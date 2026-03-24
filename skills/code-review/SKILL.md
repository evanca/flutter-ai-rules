---
name: code-review
description: "Review Flutter/Dart pull requests and merge requests against a structured checklist. Use when asked to review a PR, review a MR, review a branch, audit changed files, check code quality, or evaluate a diff. Covers correctness, security, performance, style, testing, and documentation."
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
3. **Never assume** a change is correct without investigating the implementation.
4. If a change remains unclear after investigation, **note this explicitly** in the report.

### Step 3 — Review each file

For every changed file, verify the following:

| Area | What to verify |
|---|---|
| **Location** | File is in the correct directory |
| **Naming** | File name follows project naming conventions |
| **Responsibility** | The file's responsibility is clear; reason for change is understandable |
| **Readability** | Variable, function, and class names are descriptive and consistent |
| **Logic & correctness** | No logic errors or missing edge cases |
| **Maintainability** | Code is modular; no unnecessary duplication |
| **Error handling** | Errors and exceptions are handled appropriately |
| **Security** | No input validation gaps; no secrets committed to code |
| **Performance** | No obvious inefficiencies (e.g., unnecessary rebuilds, O(n^2) loops on large lists) |
| **Documentation** | Public APIs, complex logic, and new modules are documented |
| **Test coverage** | New or changed logic has sufficient tests |
| **Style** | Code matches the project's style guide and linting rules |

For **generated files** (e.g., `*.g.dart`, `*.freezed.dart`): confirm they are up-to-date and not manually modified.

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

### Step 4 — Evaluate the overall change set

1. Verify the change set is **focused and scoped** to its stated purpose — no unrelated changes.
2. Check that the **PR/MR description** accurately reflects the changes.
3. Confirm **new or updated tests** cover changed logic.
4. Evaluate whether tests could **actually fail** against real code, or only verify mocked behavior.

### Step 5 — Verify CI and tests

1. Ensure **all tests pass** in CI.
2. Check for new analyzer warnings or lint violations.
3. Fetch **official documentation** when unsure about best practices for a package.

**Checkpoint:** If CI is red or tests are missing for new logic, flag as a blocking issue.

---

## Feedback Standards

* Be **objective and reasonable** — avoid automatic praise or flattery.
* Take a **devil's advocate approach**: give honest, thoughtful feedback.
* Provide **clear, constructive suggestions** for every issue found.
* Include **requests for clarification** for anything unclear.
* Classify each finding by severity: `suggestion`, `minor`, or `major`.

---

## Output Format

Provide the review as a structured response covering each file:

1. **Summary** — what changed and why.
2. **Issues** — each with severity (`suggestion` / `minor` / `major`) and a concrete fix suggestion.
3. **Questions** — specific clarification requests per file.
4. **Verdict** — one of: `Approved`, `Approved with suggestions`, or `Changes requested`.
