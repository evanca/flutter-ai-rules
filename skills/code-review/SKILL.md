---
name: code-review
description: "Review Flutter/Dart pull requests and merge requests against a structured checklist. Use when asked to review a PR, review a MR, review a branch, audit changed files, check code quality, or evaluate a diff. Covers correctness, code smells, security, performance, style, testing, and documentation."
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/protect-token.sh"
---

# Code Review Skill

Perform structured, objective code reviews for Flutter/Dart projects following a repeatable checklist.

## When to Use

Use this skill when:

* Asked to review a pull request, merge request, or branch.
* Evaluating changed, added, or deleted files for correctness and quality.
* Auditing a diff before merging.
* Checking whether new code meets project standards.

---

## Review Workflow

### Step 1 — Validate branch and merge target

1. Confirm the current branch is a **feature, bugfix, or PR/MR branch** — not the project's primary branch (e.g. `main`, `master`, `develop`).
2. Verify the branch is **up-to-date** with the target branch (no unresolved conflicts).
3. Identify the **target branch** for the merge.

**Checkpoint:** If the branch is behind the target, flag it before proceeding.

### Step 2 — Discover changes

1. List all **changed, added, and deleted files**.
2. For each change, look up the **commit title** and review how connected components are implemented.
3. **Analyze the change**: is it clear *why* the change was made? If not, dig into the connected methods and files until it is. When you report, name **which connected files/methods you analyzed and why** — this shows the change was understood, not assumed.
4. **Never assume** a change is correct without investigating the implementation.
5. If a change remains unclear after investigation, **note this explicitly** in the report.

### Step 3 — Review each file

Iterate through each changed file. For every file, verify the following:

| Area | What to verify |
|---|---|
| **Understand the change** | Why was it made? Review connected methods/files; note which ones you analyzed and why |
| **Location** | File is in the correct directory |
| **Naming** | File name follows project naming conventions |
| **Responsibility** | The file's responsibility is clear; reason for change is understandable |
| **Readability** | Variable, function, and class names are descriptive and consistent |
| **Logic & correctness** | No logic errors or missing edge cases |
| **Code smells** | Scan for the smells in [Code Smells Reference](#code-smells-reference) below |
| **Maintainability** | Code is modular; no unnecessary duplication |
| **Error handling** | Errors and exceptions are handled appropriately |
| **Security** | No input validation gaps; no secrets committed to code |
| **Performance** | No obvious inefficiencies (e.g., unnecessary rebuilds, O(n^2) loops on large lists) |
| **SOLID principles** | Adherence assessed without forcing unnecessary boilerplate or over-abstraction |
| **Flutter/Dart/Riverpod patterns** | Match against the project's loaded guidelines and conventions |
| **Documentation** | Public APIs, complex logic, and new modules are documented |
| **Test coverage** | New or changed logic has sufficient tests (see Step 4) |
| **Style** | Code matches the project's style guide and linting rules |
| **Existing code** | If the new changes look fine, also review surrounding **existing (unchanged) code** for smells and suggest refactors where relevant |

For **generated files** (e.g., `*.g.dart`, `*.freezed.dart`): confirm they are up-to-date and not manually modified.

> **Scope discipline:** Your job is **not** to comment on every change — it's to find errors and concrete improvement areas and comment on those. Don't manufacture comments where the code is fine.

#### Flutter-specific checks

```dart
// BAD — rebuilds entire tree on every state change
BlocBuilder<MyCubit, MyState>(
  builder: (context, state) => EntireScreen(state: state),
);

// GOOD — scope rebuilds to the widget that actually changes
BlocSelector<MyCubit, MyState, String>(
  selector: (state) => state.title,
  builder: (context, title) => Text(title),
);
```

* Verify `Key` usage on dynamically generated widgets.
* Check that `dispose()` is called for controllers, streams, and animation controllers.
* Confirm `const` constructors are used where possible.

#### Code Smells Reference

For each file, check for common code smells. Use [refactoring.guru/refactoring/smells](https://refactoring.guru/refactoring/smells) for definitions and suggested refactorings.

| Category | Smells |
|---|---|
| **Bloaters** | Long Method, Large Class, Primitive Obsession, Long Parameter List, Data Clumps |
| **Object-Orientation Abusers** | Alternative Classes with Different Interfaces, Refused Bequest, Temporary Field, Switch Statements |
| **Change Preventers** | Divergent Change, Parallel Inheritance Hierarchies, Shotgun Surgery |
| **Dispensables** | Comments (redundant), Duplicate Code, Data Class, Dead Code, Lazy Class, Speculative Generality |
| **Couplers** | Feature Envy, Inappropriate Intimacy, Incomplete Library Class, Message Chains, Middle Man |

### Step 4 — Evaluate the overall change set

1. Verify the change set is **focused and scoped** to its stated purpose — no unrelated changes.
2. Check that the **PR/MR description** accurately reflects the changes.

#### Test coverage

Verify test coverage **explicitly** — this is easy to skip and easy to fake, so be deliberate:

- For any new logic or significant change, **search for the corresponding test file(s)** and confirm tests actually exist.
- Check that tests cover the changed functionality **including edge cases**, not just the happy path.
- Evaluate whether tests could **actually fail** against real code, or only verify mocked behavior (a test that asserts a mock returns what the mock was told to return proves nothing).
- If tests are **missing or insufficient**, comment on the lack of coverage — don't let it pass silently.

### Step 5 — Verify CI and tests

1. Ensure **all tests pass** in CI.
2. Check for new analyzer warnings or lint violations.
3. Fetch **official documentation** when unsure about best practices for a package.

**Checkpoint:** If CI is red or tests are missing for new logic, flag as a blocking issue.

---

## Wrap-Up

After the per-file pass, decide the outcome:

- **If everything looks good and no changes are needed:** post an **overall conclusion comment** summarizing what the MR is about (what was done) plus any observations, and approve the MR.
- **If the new changes are clean but you spotted smells in existing code:** include those as optional refactor suggestions rather than blockers.
- **If issues were found:** summarize the **key concerns** clearly so the author knows what to address first.

---

## Feedback Standards

* Be **objective and reasonable** — avoid automatic praise or flattery.
* Take a **devil's advocate approach**: give honest, thoughtful feedback.
* Provide **clear, constructive suggestions** for every issue found.
* Include **requests for clarification** for anything unclear.
* Classify each finding by severity: `suggestion`, `minor`, or `major`.

---

## Output Format

**By default, provide the review as a chat response** — a structured response covering each file:

1. **Summary** — what changed and why.
2. **Issues** — each with severity (`suggestion` / `minor` / `major`) and a concrete fix suggestion.
3. **Questions** — specific clarification requests per file.
4. **Verdict** — one of: `Approved`, `Approved with suggestions`, or `Changes requested`.

> **Posting comments online (opt-in only).** After presenting the chat review, **ask the user whether they'd prefer you to also post these comments online** on the PR/MR — so the team can see them, review them, and reply. **Only post online if the user explicitly says yes.** Never post to the platform on your own initiative.
>
> When the user does opt in, post issues as **inline comments** anchored to the right file and line (use proper position fields), with the conclusion/key-concerns as a top-level review comment and an approval when warranted. This requires a **review-bot access token** for the platform (GitHub/GitLab); if one isn't configured, let the user know and ask them to set it up before posting.
>
> **Token safety.** The token is a secret. You may check whether it **exists** and report its **length** to confirm it's configured, but **never read, echo, log, print, or otherwise reveal the token value** — not in chat, not in a file, not in a commit. Pass it to `curl` only by referencing the env var (e.g. `$GITLAB_TOKEN`), never by inlining the literal value, and avoid `curl -v`/`--verbose` (it prints the auth header). This is enforced by a `PreToolUse` hook (`scripts/protect-token.sh`) that blocks any Bash command which would expose the value. See the "Handling the token safely" section in each reference file for the safe existence/length check.
>
> The hook fires in both the Claude Code CLI and the Agent SDK. (SDK apps that set `settingSources`/`setting_sources` explicitly must include `"project"` for skill hooks to load; it's included by default.)
>
> For platform-specific API details, curl formats, and approval steps, follow:
> - GitLab → [references/gitlab-posting.md](references/gitlab-posting.md) (uses the `GITLAB_TOKEN` env var)
> - GitHub → [references/github-posting.md](references/github-posting.md) (uses the `GITHUB_TOKEN` env var)
