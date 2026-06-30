#!/usr/bin/env bash
#
# PreToolUse hook for the code-review skill.
#
# Goal: the agent may confirm a review-bot token is configured and report its
# LENGTH, but must never reveal the token VALUE. This hook enforces that
# deterministically in the harness rather than relying on instructions alone.
#
# Allowed:  existence/length checks via ${#GITLAB_TOKEN} / ${#GITHUB_TOKEN},
#           and passing the token to curl as an auth header.
# Blocked:  echo/printf/cat/tee of the token value, environment dumps, and
#           curl -v/--verbose/--trace (which print the auth header).
#
# The hook reads the PreToolUse event JSON on stdin and, to block a call, prints
# a permissionDecision=deny object (see code.claude.com/docs/en/hooks). Any other
# Bash command falls through (exit 0) to the normal permission flow.

input="$(cat)"

# Extract the Bash command. If jq is unavailable, scan the raw event instead so
# enforcement still applies (it just may be slightly more conservative).
if command -v jq >/dev/null 2>&1; then
  cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // ""' 2>/dev/null)"
else
  cmd="$input"
fi

deny() {
  # Reasons must contain no double quotes or backslashes (kept JSON-safe inline).
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
  exit 0
}

names='GITLAB_TOKEN|GITHUB_TOKEN'

# 1) curl with verbose/trace prints the Authorization / PRIVATE-TOKEN header.
if printf '%s' "$cmd" | grep -Eq 'curl' \
   && printf '%s' "$cmd" | grep -Eq '(^|[[:space:]])(-v|--verbose|--trace[^[:space:]]*)([[:space:]]|$)'; then
  deny "curl -v/--verbose/--trace prints the auth header, which exposes the token. Re-run the request without verbose/trace flags."
fi

# 2) Environment dumps that would include the token.
if printf '%s' "$cmd" | grep -Eq "printenv[[:space:]]+($names)([[:space:]]|$)"; then
  deny "Printing the token with printenv is not allowed. Confirm it is set and how long it is with the length form instead."
fi
if printf '%s' "$cmd" | grep -Eq '(^|[|;&]|[[:space:]])(printenv|env|set|export[[:space:]]+-p|declare[[:space:]]+-p)[[:space:]]*(\||$)'; then
  deny "Dumping the whole environment can expose the token. Reference a specific variable length instead."
fi

# 3) Token VALUE passed to a printing/writing command. The length form is allowed
#    because the regex requires the value form ($NAME or ${NAME...}), and ${#NAME}
#    does not match it.
if printf '%s' "$cmd" | grep -Eq "(echo|printf|print|cat|tee)[[:space:]][^|;&]*[\$][{]?($names)"; then
  deny "Refusing to print the token value. Verify existence/length with the length form, but never echo/printf/cat the value itself."
fi

exit 0
