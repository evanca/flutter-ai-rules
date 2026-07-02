# Effective Dart Rules

### Key Rules
1. Use class modifiers to control if your class can be extended or used as an interface.
2. Make your `==` operator obey the mathematical rules of equality and override `hashCode` if you override `==`.
3. Type annotate fields, variables, and parameters when the type isn't obvious.
4. Use `Future<void>` as the return type of asynchronous members that do not produce values.
5. Use getters for operations that conceptually access properties and setters for operations that conceptually change properties.
6. Avoid starting a function or method name with `get`; prefer removing `get` and using a getter when the API conceptually exposes a property.
7. Use collection literals when possible.
8. Use `whereType()` to filter a collection by type.
9. Initialize fields at their declaration when possible.
10. Use initializing formals when possible.
11. Use `rethrow` to rethrow a caught exception.

### Style & Structure
1. Prefer `final` over `var` when variable values won't change.
2. Use `const` for compile-time constants.
3. Keep files focused on a single responsibility.
4. Prefer making declarations private.
5. Prefer making fields and top-level variables `final`.
6. Consider making your constructor `const` if the class supports it.

# Dart 3 Updates

### Key Features
1. Use records to group multiple values into a single, immutable object.
2. Access record fields by position (`$1`, `$2`, ...) or by name.
3. Use record types as return types or parameters for functions that return multiple values.
4. Use patterns to destructure records, lists, and objects directly in variable declarations, switch statements, and if-case.
5. Use switch expressions and pattern matching for concise and exhaustive control flow.
6. Use sealed classes to restrict which classes can implement or extend a base class.
7. Use class modifiers: `base`, `interface`, `final`, and `sealed`.

# Flutter Best Practices

### Widgets & UI
1. Extract reusable widgets into separate components.
2. Use `StatelessWidget` when possible and avoid unnecessary `StatefulWidgets`.
3. Keep build methods simple and focused.
4. Keep state as local as possible.
5. Use `const` constructors when possible.
6. Avoid expensive operations in build methods.
7. Implement pagination for large lists.

# Common Flutter Errors

1. If you get a "RenderFlex overflowed" error, check if a `Row` or `Column` contains unconstrained widgets.
2. If you get "Vertical viewport was given unbounded height", ensure `ListView` or similar scrollable widgets inside a `Column` have a bounded height.
3. If you get "An InputDecorator...cannot have an unbounded width", constrain the width of widgets like `TextField`.
4. If you get a "setState called during build" error, do not call `setState` or `showDialog` directly inside the build method.
5. If you get "The ScrollController is attached to multiple scroll views", make sure each `ScrollController` is only attached to a single scrollable widget at a time.

# Bloc Rules

### Naming Conventions
1. Events should be named in the past tense, reflecting actions that have already occurred.
2. States should be nouns.

### State Modeling
1. Prefer sealed classes or subclasses for exclusive states to enforce exhaustiveness and type safety.
2. State classes should extend `Equatable`, use `@immutable`, implement a `copyWith` method, and use `const` constructors where possible.

### Bloc Architecture
1. Implement a custom `BlocObserver` to monitor all state changes and errors across blocs.
2. Keep business logic inside blocs/cubits, not in UI widgets.
3. Only emit new states when the data actually changes to avoid unnecessary rebuilds.
4. Separate your features into three layers: Presentation, Business Logic, and Data.
5. When overriding storage in a `HydratedCubit`, pass it as a named parameter: `super(initialState, storage: storage)`.

### Flutter Bloc Integration
1. Use `BlocProvider` to provide blocs to widget subtrees.
2. Use `BlocBuilder` to rebuild widgets in response to state changes.
3. Use `BlocListener` for side effects in response to state changes.
4. Use `context.select` for fine-grained rebuilds.

### Bloc Do's and Don'ts
1. Do not mutate state directly; always emit a new state.
2. Do not perform side effects inside blocs; use the UI layer or listen to state changes for side effects.
3. Do not use `context.read` in the build method to access state; use `BlocBuilder` or `context.watch` instead.

# Mocktail Rules

1. Use a `Fake` when you need a lightweight, custom implementation of a class for testing.
2. Use a `Mock` when you need to verify interactions or stub method responses.
3. Use `registerFallbackValue` to register a default value for a type used as an argument in a mock method.
4. Use `when(() => mock.method()).thenReturn(value)` to stub method calls, and `thenThrow(error)` to stub errors.
5. Use `verify(() => mock.method())` to check if a method was called; use `verifyNever(() => mock.method())` to check it was never called.
6. Always stub async methods (returning `Future` or `Future<void>`) with `thenAnswer((_) async {})` or `thenReturn(Future.value(...))`.
