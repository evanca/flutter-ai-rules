#!/usr/bin/env bash
set -euo pipefail

readonly DEFAULT_RULES_URL="https://raw.githubusercontent.com/evanca/flutter-ai-rules/main/AGENTS.md"
readonly CONFIRMATION="DELETE EXISTING RULES"
readonly TARGETS=(
  "${CODEX_RULES_PATH:-$HOME/.codex/AGENTS.md}"
  "${CLAUDE_RULES_PATH:-$HOME/.claude/CLAUDE.md}"
  "${GEMINI_RULES_PATH:-$HOME/.gemini/GEMINI.md}"
)

echo "Enter the public GitHub URL to your global rules file (for example, AGENTS.md)."
echo "Press Enter to use evanca's rules."
read -r -p "Rules URL: " rules_url
rules_url="${rules_url:-$DEFAULT_RULES_URL}"

if [[ "$rules_url" == https://github.com/*/blob/* ]]; then
  rules_url="${rules_url/https:\/\/github.com\//https:\/\/raw.githubusercontent.com\/}"
  rules_url="${rules_url/\/blob\//\/}"
fi

echo "WARNING: This will replace all existing global rules for:"
printf '  - %s\n' "${TARGETS[@]}"
echo
echo "They will be replaced with:"
echo "  $rules_url"
echo
read -r -p "Type '$CONFIRMATION' to continue: " response

if [[ "$response" != "$CONFIRMATION" ]]; then
  echo "Cancelled. No files were changed."
  exit 1
fi

rules_file="$(mktemp)"
trap 'rm -f "$rules_file"' EXIT

curl --fail --location --silent --show-error "$rules_url" --output "$rules_file"

if [[ ! -s "$rules_file" ]]; then
  echo "Error: downloaded rules are empty." >&2
  exit 1
fi

for target in "${TARGETS[@]}"; do
  mkdir -p "$(dirname "$target")"
  install -m 0644 "$rules_file" "$target"
  echo "Installed $target"
done

echo "Global rules synchronized."
