# GitHub Posting Reference

How to post review comments to a GitHub pull request via the REST API. Read this
only when the user has **explicitly opted in** to posting comments online (see the
Output Format section in `SKILL.md`).

Replace the placeholders below with your own values:

- `<owner>` — repository owner (user or org), e.g. `your-org`
- `<repo>` — repository name, e.g. `your-repo`
- `<pull_number>` — the pull request number (the number in the PR URL)
- Auth token comes from the `GITHUB_TOKEN` env var (a review-bot access token /
  fine-grained PAT with "Pull requests: Read and write").

All requests use these headers:

```
Authorization: Bearer $GITHUB_TOKEN
Accept: application/vnd.github+json
X-GitHub-Api-Version: 2026-03-10
```

## Comment Format

- Line comments: `[Flutter Code Review Bot]: <feedback>`
- Summary (optional): `[Flutter Code Review Bot] Summary: <overall feedback>`

## API Usage (Essentials)

GitHub distinguishes three kinds of comments:

| Goal | Endpoint |
|---|---|
| General PR comment (not tied to a line) | `POST /repos/<owner>/<repo>/issues/<pull_number>/comments` |
| Single inline comment on a diff line | `POST /repos/<owner>/<repo>/pulls/<pull_number>/comments` |
| Batch review (many inline + verdict/approval) | `POST /repos/<owner>/<repo>/pulls/<pull_number>/reviews` |

A PR is also an issue, so the **PR number is the issue number** for general comments.
Inline comments need `commit_id` (the head SHA), `path`, and `line` (the line in the
file's diff). For added lines use `side=RIGHT`; for removed lines use `side=LEFT`.
For multi-line comments add `start_line` (+ `start_side`).

## Example (General PR Comment)

[Issues / Comments API](https://docs.github.com/en/rest/issues/comments?apiVersion=2026-03-10)

```bash
curl --request POST \
  --header "Authorization: Bearer $GITHUB_TOKEN" \
  --header "Accept: application/vnd.github+json" \
  --header "X-GitHub-Api-Version: 2026-03-10" \
  --url "https://api.github.com/repos/<owner>/<repo>/issues/<pull_number>/comments" \
  --data '{"body":"[Flutter Code Review Bot]: This is a general comment on the PR."}'
```

### Inline Diff Comment (Minimal Example)

[Pulls / Review comments API](https://docs.github.com/en/rest/pulls/comments?apiVersion=2026-03-10)

```bash
curl -s -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  "https://api.github.com/repos/<owner>/<repo>/pulls/<pull_number>/comments" \
  --data '{
    "body": "[Flutter Code Review Bot]: Feedback",
    "commit_id": "<head_sha>",
    "path": "lib/.../file.dart",
    "line": 42,
    "side": "RIGHT"
  }'
```

Fetch the head SHA (useful when running locally):

```bash
curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/<owner>/<repo>/pulls/<pull_number>" \
  | grep -A 3 '"head"'
```

### Fast Checklist

1. Get the head SHA (`commit_id`) from the PR JSON.
2. Confirm the line number exists in the diff for that file and `side`.
3. POST with `commit_id`, `path`, `line`, `side`; verify the response contains an
   `"id"` and `"path"`.

Failure quick-fix: 422 Unprocessable => line not part of the diff or wrong `side`;
404 => wrong owner/repo/number or token lacks PR access; 401 => bad/expired token.

## Batch Review + Approval

Prefer a single **review** when posting many inline comments plus a verdict — it
groups them and sets approval in one call. Use `event=APPROVE` ONLY after verdict =
APPROVED and: no blocking notes, all comments resolved/visible, bot not already
approved, checks not failing. Other events: `REQUEST_CHANGES`, `COMMENT`.

```bash
curl -s -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  "https://api.github.com/repos/<owner>/<repo>/pulls/<pull_number>/reviews" \
  --data '{
    "commit_id": "<head_sha>",
    "body": "[Flutter Code Review Bot] Summary: Looks good.",
    "event": "APPROVE",
    "comments": [
      {"path": "lib/.../file.dart", "line": 42, "side": "RIGHT",
       "body": "[Flutter Code Review Bot]: Feedback"}
    ]
  }'
```
