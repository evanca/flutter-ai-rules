---
name: flutter-best-practices
description: >-
  Flutter/Dart architecture and coding standards based on the official Flutter
  architecture guide (MVVM) and LeanCode's enterprise/feature-based patterns.
  Use this skill whenever writing, reviewing, refactoring, or planning
  Flutter/Dart code — creating a new screen or feature, structuring a new
  Flutter project, choosing state management, organizing folders, setting up a
  monorepo, writing widgets, cubits/blocs, repositories or services, writing
  Flutter tests, or answering questions about Flutter architecture and code
  style. Trigger even if the user doesn't say "architecture" — e.g. "add a
  settings page", "review this widget", "how should I structure this app".
---

# Flutter Best Practices

Standards for building maintainable Flutter apps, distilled from the official
Flutter architecture guide and LeanCode's experience shipping 40+ Flutter
projects (including a 30-developer banking app). Apply these when writing new
code; when touching existing code, prefer consistency with the surrounding
codebase and raise conflicts with these standards rather than silently
rewriting.

## How to use this skill

Read the reference file that matches the task. Read more than one when tasks
overlap (e.g. a new feature touches both structure and coding style).

| Task | Read |
|---|---|
| Design layers, decide where logic lives, MVVM, repositories/services | [references/architecture-layers.md](references/architecture-layers.md) |
| Create/organize a feature, folder structure, state management wiring | [references/feature-structure.md](references/feature-structure.md) |
| Write or review Dart/Flutter code, widgets, tests, lints | [references/dart-coding-practices.md](references/dart-coding-practices.md) |
| Multi-team/multi-package apps, monorepo, navigation, localization, API contracts, E2E tests | [references/enterprise-scale.md](references/enterprise-scale.md) |

For a quick task (small widget fix, one-line review comment), the core rules
below may be enough on their own.

## Core rules (always apply)

### Architecture

1. **Separate UI from data.** Two broad layers: UI (views + view models /
   cubits) and Data (repositories + services). Dependencies point one way:
   `View → ViewModel → Repository → Service`. Lower layers never import upper
   layers. Repositories never depend on each other.
2. **Views hold no business logic.** Widgets may contain show/hide
   conditionals, animation, layout, and simple routing logic — nothing that
   transforms or decides about data. All data logic lives in the view model
   (or cubit/bloc), which has no access to `BuildContext`.
3. **Organize by feature, not by layer.** Everything a feature needs — state
   management, widgets, models — lives under one feature directory. Don't
   create top-level `blocs/`, `widgets/`, `models/` buckets that scatter a
   feature across the tree.
4. **State is immutable and explicit.** Model UI state as a sealed/union type
   (initial / inProgress / failure / ready) so every case is handled
   exhaustively. One-off effects (snackbars, navigation) are events, not
   state.
5. **Add layers only when they pay for themselves.** Start with
   view-model → API client. Introduce a repository when you need caching,
   offline, or merging sources. Introduce a use case only when logic merges
   multiple repositories, is genuinely complex, or is reused by several view
   models.

### Coding

6. **Prefer intent-revealing widgets over `Container`.** Use `Padding`,
   `SizedBox`, `ColoredBox`, `DecoratedBox`, `Center` — they are const-able
   and self-describing. `Container` is fine only when combining several
   properties at once.
7. **Use modern Dart.** Pattern matching (`if (x case final v?)`), switch
   expressions with exhaustiveness, records and destructuring, collection
   `if`/`for`/spreads instead of `.add()` loops, expression bodies for
   pass-through async functions (no redundant `async`/`await`).
8. **Prefix sliver-returning widgets with `Sliver`** so misuse in the wrong
   scroll context is caught at a glance.
9. **Tests tell a story.** Use expressive matchers (`isEmpty`, `throwsA`,
   `isA`, `completion`) and minimize dependencies — plain `Text`/`SizedBox`
   over design-system widgets in test fixtures. Test cubits/view models in
   isolation from the widget tree.
10. **Every `// ignore:` gets a reason** on the same or preceding line. Log
    errors with dedicated `error`/`stackTrace` parameters, never string
    interpolation.

## Workflow checklists

### Adding a new feature/screen

1. Read [references/feature-structure.md](references/feature-structure.md)
   and mirror the existing project's conventions for the feature directory.
2. Define the state as a union type first; then the cubit/view model; then
   the widgets. Constructor-inject dependencies; scope them to the feature's
   widget subtree.
3. Data comes in through a repository or typed API client — never fetched
   inside a widget.
4. Add unit tests for the cubit/view model logic before wiring UI details.

### Reviewing Flutter code

Check, in order of importance:

1. Logic in the right layer (rule 1–2)? Any `BuildContext` in business logic?
2. State modeled as immutable union types, all cases handled?
3. Feature self-contained, or does it reach into another feature's internals?
4. Widget choices (rule 6), modern Dart (rule 7), sliver naming (rule 8)?
5. Tests present for logic, readable, minimal dependencies?
6. Unexplained `// ignore:`, string-interpolated error logs, deprecated
   patterns still spreading?

### Starting a new project

1. Read [references/architecture-layers.md](references/architecture-layers.md)
   for the layer blueprint and
   [references/feature-structure.md](references/feature-structure.md) for the
   folder skeleton.
2. If more than ~2 teams or clearly separable domains are involved, read
   [references/enterprise-scale.md](references/enterprise-scale.md) and
   consider a Melos monorepo with one package per domain from day one.
3. Set up strict lints early (`leancode_lint` or equivalent + custom rules) —
   retrofitting is far more expensive.

## Package palette

Defaults that these standards assume (swap for project-local equivalents when
the codebase already uses something else):

- **State:** `bloc` (Cubit) + `freezed` for union-type states;
  `bloc_presentation` for one-off UI events
- **DI:** `provider` scoped to widget subtrees (accepting its lack of
  compile-time safety as the lesser evil)
- **Boilerplate reduction:** `flutter_hooks`
- **Monorepo:** `melos`
- **Localization:** `flutter_localizations` + `intl` with `.arb` files
- **Lints:** `leancode_lint`
- **E2E/UI tests:** `patrol`

The official Flutter guide is state-management-agnostic (MVVM with
ChangeNotifier works too); what matters is the layer separation, not the
package. See the reference files for rationale and trade-offs.
