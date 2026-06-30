# GitLab Posting Reference

How to post review comments to a GitLab merge request via the API. Read this only
when the user has **explicitly opted in** to posting comments online (see the
Output Format section in `SKILL.md`).

Replace the placeholders below with your own values:

- `<your-gitlab-host>` — your GitLab host, e.g. `git.example.com`
- `<project_id>` — your project's numeric ID
- `<iid>` — the merge request's internal ID (the number in the MR URL)
- Auth token comes from the `GITLAB_TOKEN` env var (a review-bot access token).

## Handling the token safely

`GITLAB_TOKEN` is a secret that can act on the user's behalf. Treat it as
write-only from your perspective: you may confirm it's present and report its
length, but its value must never leave the process. This is enforced by the
skill's `PreToolUse` hook (`scripts/protect-token.sh`), which blocks any Bash
command that would expose the value.

**Allowed** — confirm it's configured without revealing it. This uses only the
length form `${#GITLAB_TOKEN}`, so presence is derived from length and the value
is never expanded:

```bash
if [ "${#GITLAB_TOKEN}" -gt 0 ]; then
  echo "GITLAB_TOKEN is set (length: ${#GITLAB_TOKEN})"
else
  echo "GITLAB_TOKEN is not set"
fi
```

**Never do any of these** (the hook will deny them):

- `echo "$GITLAB_TOKEN"`, `printf` it, or `cat` a file/heredoc containing it.
- Print it to chat, write it to a file, or include it in a commit.
- `printenv GITLAB_TOKEN`, or dump the environment (`env`, `set`, `export -p`).
- Inline the literal token in a command (it lands in shell history/logs) — always
  reference `$GITLAB_TOKEN`.
- Use `curl -v` / `--verbose` / `--trace*`, which echo the `PRIVATE-TOKEN` header.

When sharing command output for debugging, redact the `PRIVATE-TOKEN:` header line.

## Comment Format

- Line comments: `[Flutter Code Review Bot]: <feedback>`
- Summary (optional): `[Flutter Code Review Bot] Summary: <overall feedback>`

## API Usage (Essentials)

GitLab Discussions API: `POST /projects/:id/merge_requests/:iid/discussions`.
Required `position[...]` fields for inline notes (added lines):
`position_type=text`, `base_sha`, `start_sha`, `head_sha`, `new_path`, `new_line`.
Removed lines: use `old_path` + `old_line` instead of new.
Missing `position_type` => GitLab error and no comment.
Auth: `PRIVATE-TOKEN` from the `GITLAB_TOKEN` env var.

## Example (General MR Comment)

```bash
curl --request POST \
  --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  --url "https://<your-gitlab-host>/api/v4/projects/<project_id>/merge_requests/<iid>/discussions" \
  --form "body=[Flutter Code Review Bot]: This is a general comment on the MR."
```

**Important Note:** Use the exact curl format shown above
(`--request POST --header ... --url ... --form ...`) for posting comments to avoid
401 Unauthorized errors. Alternative formats like `-X POST -H ...` may not
authenticate properly with the API.

### Inline Diff Comment (Minimal Example)

```bash
curl -s -X POST \
  -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "https://<your-gitlab-host>/api/v4/projects/<project_id>/merge_requests/<iid>/discussions" \
  --form "body=[Flutter Code Review Bot]: Feedback" \
  --form "position[position_type]=text" \
  --form "position[base_sha]=<base>" \
  --form "position[start_sha]=<start>" \
  --form "position[head_sha]=<head>" \
  --form "position[new_path]=lib/.../file.dart" \
  --form "position[new_line]=42"
```

Fetch `diff_refs` (useful when running locally):

```bash
curl -s -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "https://<your-gitlab-host>/api/v4/projects/<project_id>/merge_requests/<iid>" \
  | grep -A 6 '"diff_refs"'
```

### Fast Checklist

1. Get `diff_refs` (base/start/head) from MR JSON.
2. Confirm absolute line number in current file (`nl -ba file | grep context`).
3. POST with all required fields; verify response contains `"type":"DiffNote"`.

Failure quick-fix: missing note => check `position_type`; invisible => wrong line;
400/error => refresh SHAs.

## Automated Approval

Use ONLY after verdict = APPROVED and: no blocking notes, all inline comments
visible, bot not already approved, pipeline not failing.

Approve:

```bash
curl -s -X POST -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "https://<your-gitlab-host>/api/v4/projects/<project_id>/merge_requests/<iid>/approve"
```
