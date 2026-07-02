# Flutter with Bloc Rules

## Core Dart Principles
1. Use class modifiers (`base`, `final`, `sealed`, `interface`) to control class extension.
2. Override `hashCode` if you override `==`.
3. Type annotate fields, variables, and parameters when the type isn't obvious.
4. Use `Future<void>` for asynchronous members without return values.
5. Use getters for property access and setters for property changes.
6. Avoid starting a function or method name with `get`; prefer removing `get` and using a getter when the API conceptually exposes a property.
7. Use collection literals when possible.
8. Use `whereType()` to filter collections by type.
9. Initialize fields at declaration when possible.
10. Use initializing formals when possible.
11. Use `rethrow` to rethrow caught exceptions.

## Flutter Best Practices
1. Separate app into UI Layer (presentation) and Data Layer (business logic).
2. Keep views focused on presentation and extract reusable widgets.
3. Use StatelessWidget when possible and avoid unnecessary StatefulWidgets.
4. Keep build methods simple and focused.
5. Keep state as local as possible.
6. Use const constructors when possible.
7. Avoid expensive operations in build methods.
8. Implement pagination for large lists.
9. Keep files focused on a single responsibility.
10. Prefer making declarations private.

## Bloc Naming Conventions
1. Events should be named in the past tense, reflecting actions that have already occurred. Use the format: `BlocSubject` + optional noun + verb (event). For initial load events, use `BlocSubjectStarted`.
2. States should be nouns. For subclasses, use `BlocSubject` + `Initial` | `Success` | `Failure` | `InProgress`. For a single class, use `BlocSubjectState` with a `Status` enum (`initial`, `success`, `failure`, `loading`).
3. Prefer sealed classes or subclasses for exclusive states.
4. State classes should extend `Equatable`, use `@immutable`, implement a `copyWith` method, and use `const` constructors where possible. Always pass all relevant properties to the `props` getter when using Equatable to ensure proper equality comparisons.
5. Use a single concrete class with a status enum for non-exclusive states or when properties are frequently shared, but be aware this can lead to bloated and less type-safe code.

## Bloc Architecture
1. Implement a custom `BlocObserver` to monitor all state changes and errors across blocs for logging, analytics, or debugging. Override `onChange` and `onError` for global or per-bloc error handling.
2. Keep business logic inside blocs/cubits, not in UI widgets.
3. Only emit new states when the data actually changes to avoid unnecessary rebuilds.
4. Override `onError` in both `Cubit` and `BlocObserver` for robust error management.
5. Use `BlocProvider` to provide blocs to widget subtrees.
6. Use `BlocBuilder` to rebuild widgets in response to state changes.
7. Use `context.select` for fine-grained rebuilds, but avoid using it at the root of a widget tree, as it will cause the entire widget to rebuild on every state change.
8. Use `context.read<T>()` for accessing a bloc instance without listening for changes (e.g., in callbacks), but avoid using it in `build` methods for reading state, as it won't trigger rebuilds.
9. Do not mutate state directly; always emit a new state.
10. Do not perform side effects inside blocs; use the UI layer or listen to state changes for side effects.
11. Separate your features into three layers: Presentation (UI), Business Logic (blocs/cubits), and Data (repositories/providers).

## Bloc Implementation
1. Use `Cubit` for simple state management without events; use `Bloc` for complex, event-driven state management.
2. Define the initial state by passing it to the superclass.
3. Only use the `emit` method inside a `Cubit` or `Bloc`.
4. UI components should listen to state changes and update only in response to new states.
5. Duplicate states are ignored; no state change will occur.
6. Use event transformers in `Bloc` for advanced event processing.
7. Prefer `Cubit` for simplicity and less boilerplate; prefer `Bloc` for traceability and advanced event handling.
8. When overriding storage in a `HydratedCubit`, pass it as a named parameter: `super(initialState, storage: storage)`.

## Flutter Bloc Integration
1. Use `BlocBuilder` to rebuild widgets in response to bloc or cubit state changes.
2. Use `BlocListener` to perform side effects in response to state changes.
3. Use `BlocConsumer` when you need both `BlocBuilder` and `BlocListener` functionality.
4. Use `BlocProvider` to provide blocs to widget subtrees via dependency injection.
5. Use `MultiBlocProvider` to provide multiple blocs and avoid deeply nested providers.

## Dart 3 Modern Features
1. Use records for grouping values: `var user = ('John', age: 30, isAdmin: true);`. Records are anonymous, immutable, aggregate types that bundle multiple objects into a single value.
2. Access record fields by position (`$1`, `$2`, ...) or by name: `user.$1`, `user.age`. Records automatically define `hashCode` and `==` based on structure and field values.
3. Use patterns to destructure records, lists, and objects. Example: `var (name, :age) = user;` or `if (response case {'user': {'name': String name}}) { print('User $name'); }`.
4. Use switch expressions and pattern matching for concise, exhaustive control flow.
5. Use sealed classes for exhaustive `switch` and type safety.
