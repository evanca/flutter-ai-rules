# Feature-Based Structure

Based on LeanCode's feature-based Flutter architecture
(https://leancode.co/blog/feature-based-flutter-architecture), proven across
40+ projects from small apps to enterprise scale.

## The principle

Group code by **what it does for the user**, not by what kind of class it is.
A developer implements a user story ("let users see their loan documents"),
which cuts through every technical layer — UI, state, data. So everything
related to one feature lives under one directory:

```
lib/
└── features/
    └── comment_section/
        ├── bloc/
        │   └── comment_section_cubit.dart
        ├── comment_section.dart        # feature entrypoint widget
        └── widgets/
            └── upvote_button.dart
```

Not this (layer-first — avoid):

```
lib/
├── blocs/          # every feature's cubits mixed together
├── widgets/        # every feature's widgets mixed together
└── models/
```

Why feature-first wins:

- developers work in parallel on different features without collisions
- all code for a feature is findable in one place, not scattered
- **feature-level innovation**: one feature's internal architecture can be
  rewritten without touching any other feature
- scales from small projects to enterprise (at large scale, features graduate
  into packages — see `enterprise-scale.md`)

## Anatomy of a feature

### 1. Entrypoint widget

The feature's public face: a `StatelessWidget` that takes all required
context via constructor and sets up the feature's dependencies (providers,
cubit creation) for its subtree.

```dart
class CommentSection extends StatelessWidget {
  const CommentSection({super.key, required this.postId});

  final Guid postId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentSectionCubit(
        client: context.read<ApiClient>(),
        postId: postId,
      )..fetch(),
      child: const _CommentSectionView(),
    );
  }
}
```

Other features interact with this widget only — never with the feature's
internals.

### 2. State as a union type

Express the cubit's state as a sealed/union type so the UI must handle every
case. With `freezed`:

```dart
@freezed
class CommentSectionState with _$CommentSectionState {
  const factory CommentSectionState.initial() = CommentSectionStateInitial;
  const factory CommentSectionState.inProgress() = CommentSectionStateInProgress;
  const factory CommentSectionState.failure({
    required CommentSectionFailureReason reason,
  }) = CommentSectionStateFailure;
  const factory CommentSectionState.ready({
    required List<Comment> comments,
  }) = CommentSectionStateReady;
}
```

(Plain Dart 3 `sealed class` hierarchies work too; freezed adds
value-equality and copyWith for free.)

### 3. Cubit (state management)

The Cubit owns the data and every function that alters it. It guides UI
behavior purely through emitted states.

- **No `BuildContext` in a Cubit.** Ever. This keeps it detached from the
  rendering pipeline and unit-testable in isolation.
- Dependencies (API client, repositories) come in through the constructor.
- Emit the union-type states; the widget maps state → UI.

```dart
class CommentSectionCubit extends Cubit<CommentSectionState> {
  CommentSectionCubit({required this.client, required this.postId})
      : super(const CommentSectionState.initial());

  final ApiClient client;
  final Guid postId;

  Future<void> fetch() async {
    emit(const CommentSectionState.inProgress());
    try {
      final response = await client.get(GetCommentSection(postId: postId));
      emit(CommentSectionState.ready(comments: response.comments));
    } catch (e, st) {
      emit(const CommentSectionState.failure(
        reason: CommentSectionFailureReason.network,
      ));
    }
  }
}
```

### 4. Presentation events (one-off effects)

Snackbars, dialogs, and navigation triggers are **not state** — they happen
once and shouldn't persist or replay on rebuild. Use
`package:bloc_presentation` to emit them as a separate event stream, and
listen in the widget (with `flutter_hooks` to avoid `StatefulWidget`
boilerplate for subscriptions).

Rule of thumb: if re-emitting the value on a rebuild would be wrong (showing
the snackbar twice), it's a presentation event, not state.

### 5. UI rendering

Map the state union exhaustively:

```dart
switch (state) {
  CommentSectionStateInitial() ||
  CommentSectionStateInProgress() => const _Loading(),
  CommentSectionStateFailure(:final reason) => _Error(reason: reason),
  CommentSectionStateReady(:final comments) => _CommentList(comments: comments),
}
```

## Dependency injection

Use `package:provider`, scoped to widget subtrees:

- a dependency's lifetime is tied to the widget tree — injected when the tree
  mounts, disposed when it unmounts
- **global** dependencies (ApiClient, auth session) are provided at the app
  root
- **feature-scoped** dependencies are provided in the feature entrypoint and
  constructor-injected into the Cubit

Provider was chosen with eyes open: it lacks compile-time safety when
consuming dependencies, but the alternatives (e.g. riverpod) were judged to
introduce larger issues. Known limit: on very large apps, deeply nested trees
of global Providers can hit StackOverflowError (Flutter issue #85026) —
another reason to keep global providers few and push the rest into features.

## Data access

- Prefer a **backend-for-frontend** style: a dedicated, typed endpoint per
  screen (`GetCommentSection(postId: ...)`) over generic REST endpoints that
  over-fetch.
- It is fine for a Cubit to call the typed API client **directly**. Introduce
  a repository as a *feature-level decision* when the feature actually needs
  caching, offline mode, or merging sources — see `architecture-layers.md`
  for what a repository owes you once you add it.

## Shared code between features

Shared components (design-system widgets, common utilities, shared domain
models) live outside `features/` — in `lib/common/` or dedicated packages —
and features depend on them, never on each other's internals. If feature A
needs something from feature B, either promote it to shared code or
communicate through events (see `enterprise-scale.md` for cross-domain
communication patterns).

## What this file deliberately doesn't decide

Feature structure is one slice of a real app. Navigation/deeplinks,
flavoring, monitoring, CI/CD, localization, design systems, golden/E2E tests,
and analytics all need their own decisions — several are covered in
`enterprise-scale.md`; the rest follow project conventions.
