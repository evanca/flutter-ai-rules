# GitLab Posting Reference

How to post review comments to a GitLab merge request via the API. Read this only
when the user has **explicitly opted in** to posting comments online (see the
Output Format section in `SKILL.md`).

Replace the placeholders below with your own values:

- `<your-gitlab-host>` — your GitLab host, e.g. `git.example.com`
- `<project_id>` — your project's numeric ID
- `<iid>` — the merge request's internal ID (the number in the MR URL)
- Auth token comes from the `GITLAB_TOKEN` env var (a review-bot access token).

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
