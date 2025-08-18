# Bloc Rules

### Naming Conventions
1. Name events in the past tense, as they represent actions that have already occurred from the bloc's perspective.
2. Use the format: `BlocSubject` + optional noun + verb (event). Example: `LoginButtonPressed`, `UserProfileLoaded`
3. For initial load events, use: `BlocSubjectStarted`. Example: `AuthenticationStarted`
4. The base event class should be named: `BlocSubjectEvent`.
5. Name states as nouns, since a state is a snapshot at a particular point in time.
6. When using subclasses for states, use the format: `BlocSubject` + `Initial` | `Success` | `Failure` | `InProgress`. Example: `LoginInitial`, `LoginSuccess`, `LoginFailure`, `LoginInProgress`
7. For single-class states, use: `BlocSubjectState` with a `BlocSubjectStatus` enum (`initial`, `success`, `failure`, `loading`). Example: `LoginState` with `LoginStatus.initial`
8. The base state class should always be named: `BlocSubjectState`.

### Modeling State
1. Extend `Equatable` for all state classes to enable value equality.
2. Annotate state classes with `@immutable` to enforce immutability.
3. Implement a `copyWith` method in state classes for easy state updates.
4. Use `const` constructors for state classes when possible.
5. Use a single concrete class with a status enum for simple, non-exclusive states or when many properties are shared.
6. In the single-class approach, make properties nullable and handle them based on the current status.
7. Use a sealed class with subclasses for well-defined, exclusive states.
8. Store shared properties in the sealed base class; keep state-specific properties in subclasses.
9. Use exhaustive `switch` statements to handle all possible state subclasses.
10. Prefer the sealed class approach for type safety and exhaustiveness; prefer the single-class approach for conciseness and flexibility.
11. Always pass all relevant properties to the `props` getter when using Equatable in state classes.
12. When using Equatable, copy List or Map properties with `List.of` or `Map.of` to ensure value equality.
13. To retain previous data after an error, use a single state class with nullable data and error fields.
14. Emit a new instance of the state each time you want the UI to update; do not reuse the same instance.

### Bloc Concepts
1. Use `Cubit` for simple state management without events; use `Bloc` for more complex, event-driven state management.
2. Define the initial state by passing it to the superclass in both `Cubit` and `Bloc`.
3. Only use the `emit` method inside a `Cubit` or `Bloc`; do not call it externally.
4. UI components should listen to state changes and update only in response to new states.
5. Duplicate states (`state == nextState`) are ignored; no state change will occur.
6. Override `onChange` in `Cubit` or `Bloc` to observe all state changes.
7. Use a custom `BlocObserver` to observe all state changes and errors globally.
8. Override `onError` in both `Cubit`/`Bloc` and `BlocObserver` for error handling.
9. Add events to a `Bloc` in response to user actions or lifecycle events.
10. Use `onTransition` in `Bloc` to observe the full transition (event, current state, next state).
11. Use event transformers (e.g., debounce, throttle) in `Bloc` for advanced event processing.
12. Prefer `Cubit` for simplicity and less boilerplate; prefer `Bloc` for traceability and advanced event handling.
13. If unsure, start with `Cubit` and refactor to `Bloc` if needed as requirements grow.
14. Initialize `BlocObserver` in `main.dart` for debugging and logging.
15. Always keep business logic out of UI widgets; only interact with cubits/blocs via events or public methods.
16. Internal events in a bloc should be private and only used for real-time updates from repositories.
17. Use custom event transformers for internal events if needed.
17. When exposing public methods on a cubit, only use them to trigger state changes and return `void` or `Future<void>`.
18. For blocs, avoid exposing custom public methods; trigger state changes by adding events via the `add` method.
19. When using `BlocProvider.of(context)`, call it within a child `BuildContext`, not the same context where the bloc was provided.

### Architecture
1. Separate your features into three layers: Presentation, Business Logic, and Data.
2. The Data Layer is responsible for retrieving and manipulating data from sources such as databases or network requests.
3. Structure the Data Layer into repositories (wrappers around data providers) and data providers (perform CRUD operations).
4. The Business Logic Layer responds to input from the presentation layer and communicates with repositories to build new states.
5. The Presentation Layer renders UI based on bloc states and handles user input and lifecycle events.
6. Inject repositories into blocs via constructors; blocs should not directly access data providers.
7. Avoid direct bloc-to-bloc communication to prevent tight coupling.
8. To coordinate between blocs, use BlocListener in the presentation layer to listen to one bloc and add events to another.
9. For shared data, inject the same repository into multiple blocs; let each bloc listen to repository streams independently.
10. Always strive for loose coupling between architectural layers and components.
11. Structure your project consistently and intentionally; there is no single right way.

### Flutter Bloc Concepts
1. Use `BlocBuilder` to rebuild widgets in response to bloc or cubit state changes; the builder function must be pure.
2. Use `BlocListener` to perform side effects (e.g., navigation, dialogs) in response to state changes.
3. Use `BlocConsumer` when you need both `BlocBuilder` and `BlocListener` functionality in a single widget.
4. Use `BlocProvider` to provide blocs to widget subtrees via dependency injection.
5. Use `MultiBlocProvider` to provide multiple blocs and avoid deeply nested providers.
6. Use `BlocSelector` to rebuild widgets only when a selected part of the state changes.
7. Use `MultiBlocListener` to listen for state changes and trigger side effects; avoid nesting listeners by using `MultiBlocListener`.
8. Use `RepositoryProvider` to provide repositories or services to the widget tree.
9. Use `MultiRepositoryProvider` to provide multiple repositories and avoid nesting.
10. Use `context.read<T>()` to access a bloc or repository without listening for changes (e.g., in callbacks).
11. Use `context.watch<T>()` inside the build method to listen for changes and trigger rebuilds.
12. Use `context.select<T, R>()` to listen for changes in a specific part of a bloc’s state.
13. Avoid using `context.watch` or `context.select` at the root of the build method to prevent unnecessary rebuilds.
14. Prefer `BlocBuilder` and `BlocSelector` over `context.watch` and `context.select` for explicit rebuild scoping.
15. Scope rebuilds using `Builder` when using `context.watch` or `context.select` for multiple blocs.
16. Handle all possible cubit/bloc states explicitly in the UI (e.g., empty, loading, error, populated).

### Code Quality & Linting
1. Use the `bloc_lint` package to enforce Bloc best practices and catch common mistakes.
2. Use `bloc_tools` command-line utilities for project scaffolding and development workflow.
3. Configure `bloc_lint` in your `analysis_options.yaml` with recommended rules for static analysis.
4. Avoid importing Flutter dependencies in your business logic components (blocs, cubits, repositories).
5. Avoid exposing public fields on Bloc and Cubit instances; all state should be accessed through the `state` getter.
6. Avoid exposing public methods on Bloc instances; use the `add` method to communicate with blocs via events.
7. Use `bloc lint` command from `bloc_tools` to run linting from the command line.
8. Install `bloc_tools` globally for command-line access: `dart pub global activate bloc_tools`.
9. Use the recommended `analysis_options.yaml` configuration with all recommended bloc linting rules enabled.
10. Available lint rules include: `avoid_flutter_imports`, `avoid_public_fields`, `avoid_public_bloc_methods`, `prefer_bloc`, `prefer_cubit`, and `prefer_void_public_cubit_methods`.

### Developer Tools & Integrations
1. Create custom templates using Mason bricks for consistent code generation across projects.
2. Use the official Bloc developer tools for debugging and state inspection.

### Testing
1. Add the `test` and `bloc_test` packages to your dev dependencies for bloc testing.
2. Organize tests into groups to share setup and teardown logic.
3. Create a dedicated test file (e.g., `counter_bloc_test.dart`) for each bloc.
4. Import the `test` and `bloc_test` packages in your test files.
5. Use `setUp` to initialize bloc instances before each test and `tearDown` to clean up after tests.
6. Test the bloc’s initial state before testing transitions.
7. Use the `blocTest` function to test bloc state transitions in response to events.
8. Assert the expected sequence of emitted states for each bloc event.
9. Keep tests concise, focused, and easy to maintain to ensure confidence in refactoring.
10. Mock cubits/blocs in widget tests to verify UI behavior for all possible states.
11. Consider using `bloc_lint` in your CI/CD pipeline to enforce code quality standards.

### Ecosystem & Packages
1. The Bloc ecosystem consists of multiple packages: `bloc` (core), `flutter_bloc` (Flutter widgets), `bloc_test` (testing), `bloc_lint` (linting), `bloc_tools` (CLI), `bloc_concurrency` (event transformers), `hydrated_bloc` (persistence), `replay_bloc` (undo/redo), and `angular_bloc` (AngularDart).
2. Use `bloc_concurrency` package for advanced event transformers like `sequential`, `concurrent`, `droppable`, and `restartable`.
3. Use `hydrated_bloc` for automatic state persistence and restoration across app sessions.
4. Use `replay_bloc` to add undo and redo functionality to your blocs.
5. Install packages based on your needs: start with `bloc` and `flutter_bloc` for basic functionality.

