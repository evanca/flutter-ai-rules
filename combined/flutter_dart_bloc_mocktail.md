# Effective Dart Rules

### Naming Conventions
1. Use terms consistently throughout your code.
2. Follow existing mnemonic conventions when naming type parameters (e.g., `E` for element, `K`/`V` for key/value, `T`/`S`/`U` for generic types).
3. Name types using `UpperCamelCase` (classes, enums, typedefs, type parameters).
4. Name extensions using `UpperCamelCase`.
5. Name packages, directories, and source files using `lowercase_with_underscores`.
6. Name import prefixes using `lowercase_with_underscores`.
7. Name other identifiers using `lowerCamelCase` (variables, parameters, named parameters).
8. Capitalize acronyms and abbreviations longer than two letters like words.
9. Avoid abbreviations unless the abbreviation is more common than the unabbreviated term.
10. Prefer putting the most descriptive noun last in names.
11. Consider making code read like a sentence when designing APIs.
12. Prefer a noun phrase for non-boolean properties or variables.
13. Prefer a non-imperative verb phrase for boolean properties or variables.
14. Prefer the positive form for boolean property and variable names.
15. Consider omitting the verb for named boolean parameters.
16. Use camelCase for variable and function names.
17. Avoid starting a function or method name with `get`; prefer removing `get` and using a getter when the API conceptually exposes a property.
18. Use PascalCase for class names.
19. Use snake_case for file names.

### Types and Functions
1. Use class modifiers to control if your class can be extended or used as an interface.
2. Type annotate variables without initializers.
3. Type annotate fields and top-level variables if the type isn't obvious.
4. Annotate return types on function declarations.
5. Annotate parameter types on function declarations.
6. Write type arguments on generic invocations that aren't inferred.
7. Annotate with `dynamic` instead of letting inference fail.
8. Use `Future<void>` as the return type of asynchronous members that do not produce values.
9. Use getters for operations that conceptually access properties.
10. Use setters for operations that conceptually change properties.
11. Use a function declaration to bind a function to a name.
12. Use inclusive start and exclusive end parameters to accept a range.

### Style
1. Format your code using `dart format`.
2. Use curly braces for all flow control statements.
3. Prefer `final` over `var` when variable values won't change.
4. Use `const` for compile-time constants.

### Imports & Files
1. Don't import libraries inside the `src` directory of another package.
2. Don't allow import paths to reach into or out of `lib`.
3. Prefer relative import paths within a package.
4. Don't use `/lib/` or `../` in import paths.
5. Consider writing a library-level doc comment for library files.

### Structure
1. Keep files focused on a single responsibility.
2. Limit file length to maintain readability.
3. Group related functionality together.
4. Prefer making fields and top-level variables `final`.
5. Consider making your constructor `const` if the class supports it.
6. Prefer making declarations private.

### Usage
1. Use strings in `part of` directives.
2. Use adjacent strings to concatenate string literals.
3. Use collection literals when possible.
4. Use `whereType()` to filter a collection by type.
5. Test for `Future<T>` when disambiguating a `FutureOr<T>` whose type argument could be `Object`.
6. Follow a consistent rule for `var` and `final` on local variables.
7. Initialize fields at their declaration when possible.
8. Use initializing formals when possible.
9. Use `;` instead of `{}` for empty constructor bodies.
10. Use `rethrow` to rethrow a caught exception.
11. Override `hashCode` if you override `==`.
12. Make your `==` operator obey the mathematical rules of equality.

### Documentation
1. Format comments like sentences.
2. Use `///` doc comments to document members and types; don't use block comments for documentation.
3. Prefer writing doc comments for public APIs.
4. Consider writing doc comments for private APIs.
5. Consider including explanations of terminology, links, and references in library-level docs.
6. Start doc comments with a single-sentence summary.
7. Separate the first sentence of a doc comment into its own paragraph.
8. Use square brackets in doc comments to refer to in-scope identifiers.
9. Use prose to explain parameters, return values, and exceptions.
10. Put doc comments before metadata annotations.
11. Document why code exists or how it should be used, not just what it does.

### Testing
1. Write unit tests for business logic.
2. Write widget tests for UI components.
3. Aim for good test coverage.

### Widgets
1. Extract reusable widgets into separate components.
2. Use `StatelessWidget` when possible.
3. Keep build methods simple and focused.

### State Management
1. Choose appropriate state management based on complexity.
2. Avoid unnecessary `StatefulWidget`s.
3. Keep state as local as possible.

### Performance
1. Use `const` constructors when possible.
2. Avoid expensive operations in build methods.
3. Implement pagination for large lists.

# Dart 3 Updates

### Branches
1. Use `if` statements for conditional branching. The condition must evaluate to a boolean.
2. `if` statements support optional `else` and `else if` clauses for multiple branches.
3. Use `if-case` statements to match and destructure a value against a single pattern. Example: `if (pair case [int x, int y]) { ... }`
4. If the pattern in an `if-case` matches, variables defined in the pattern are in scope for that branch.
5. If the pattern does not match in an `if-case`, control flows to the `else` branch if present.
6. Use `switch` statements to match a value against multiple patterns (cases). Each `case` can use any kind of pattern.
7. When a value matches a `case` pattern in a `switch` statement, the case body executes and control jumps to the end of the switch. `break` is not required.
8. You can end a non-empty `case` clause with `continue`, `throw`, or `return`.
9. Use `default` or `_` in a `switch` statement to handle unmatched values.
10. Empty `case` clauses fall through to the next case. Use `break` to prevent fallthrough.
11. Use `continue` with a label for non-sequential fallthrough between cases.
12. Use logical-or patterns (e.g., `case a || b`) to share a body or guard between cases.
13. Use `switch` expressions to produce a value based on matching cases. Syntax differs from statements: omit `case`, use `=>` for bodies, and separate cases with commas.
14. In `switch` expressions, the default case must use `_` (not `default`).
15. Dart checks for exhaustiveness in `switch` statements and expressions, reporting a compile-time error if not all possible values are handled.
16. To ensure exhaustiveness, use a default (`default` or `_`) case, or switch over enums or sealed types.
17. Use the `sealed` modifier on a class to enable exhaustiveness checking when switching over its subtypes.
18. Add a guard clause to a `case` using `when` to further constrain when a case matches. Example: `case pattern when condition:`
19. Guard clauses can be used in `if-case`, `switch` statements, and `switch` expressions. The guard is evaluated after pattern matching.
20. If a guard clause evaluates to false, execution proceeds to the next case (does not exit the switch).

### Patterns
1. Patterns are a syntactic category that represent the shape of values for matching and destructuring.
2. Pattern matching checks if a value has a certain shape, constant, equality, or type.
3. Pattern destructuring allows extracting parts of a matched value and binding them to variables.
4. Patterns can be nested, using subpatterns (outer/inner patterns) for recursive matching and destructuring.
5. Use wildcard patterns (`_`) to ignore parts of a matched value; use rest elements in list patterns to ignore remaining elements.
6. Patterns can be used in:
   - Local variable declarations and assignments
   - For and for-in loops
   - If-case and switch-case statements
   - Control flow in collection literals
7. Pattern variable declarations start with `var` or `final` and bind new variables from the matched value. Example: `var (a, [b, c]) = ('str', [1, 2]);`
8. Pattern variable assignments destructure a value and assign to existing variables. Example: `(b, a) = (a, b); // swap values`
9. Every case clause in `switch` and `if-case` contains a pattern. Any kind of pattern can be used in a case.
10. Case patterns are refutable; if the pattern doesn't match, execution continues to the next case.
11. Destructured values in a case become local variables scoped to the case body.
12. Use logical-or patterns (e.g., `case a || b`) to match multiple alternatives in a single case.
13. Use logical-or patterns with guards (`when`) to share a body or guard between cases.
14. Guard clauses (`when`) evaluate a condition after matching; if false, execution proceeds to the next case.
15. Patterns can be used in for and for-in loops to destructure collection elements (e.g., destructuring `MapEntry` in map iteration).
16. Object patterns match named object types and destructure their data using getters. Example: `var Foo(:one, :two) = myFoo;`
8. Constant patterns match if the value is equal to a constant (number, string, bool, named constant, const constructor, const collection, etc.). Use parentheses and `const` for complex expressions.
9. Variable patterns (`var name`, `final Type name`) bind new variables to matched/destructured values. Typed variable patterns only match if the value has the declared type.
10. Identifier patterns (`foo`, `_`) act as variable or constant patterns depending on context. `_` always acts as a wildcard and matches/discards any value.
11. Parenthesized patterns (`(subpattern)`) control pattern precedence and grouping, similar to expressions.
12. List patterns (`[subpattern1, subpattern2]`) match lists and destructure elements by position. The pattern length must match the list unless a rest element is used.
13. Rest elements (`...`, `...rest`) in list patterns match arbitrary-length lists or collect unmatched elements into a new list.
14. Map patterns (`{"key": subpattern}`) match maps and destructure by key. Only specified keys are matched; missing keys throw a `StateError`.
15. Record patterns (`(subpattern1, subpattern2)`, `(x: subpattern1, y: subpattern2)`) match records by shape and destructure positional/named fields. Field names can be omitted if inferred from variable or identifier patterns.
16. Object patterns (`ClassName(field1: subpattern1, field2: subpattern2)`) match objects by type and destructure using getters. Extra fields in the object are ignored.
17. Wildcard patterns (`_`, `Type _`) match any value without binding. Useful for ignoring values or type-checking without binding.
18. All pattern types can be nested and combined for expressive and precise matching and destructuring.

### Records
1. Records are anonymous, immutable, aggregate types that bundle multiple objects into a single value.
2. Records are fixed-sized, heterogeneous, and strongly typed. Each field can have a different type.
3. Records are real values: store them in variables, nest them, pass to/from functions, and use in lists, maps, and sets.
4. Record expressions use parentheses with comma-delimited positional and/or named fields, e.g. `('first', a: 2, b: true, 'last')`.
5. Record type annotations use parentheses with comma-delimited types. Named fields use curly braces: `({int a, bool b})`.
6. The names of named fields are part of the record's type (shape). Records with different named field names have different types.
7. Positional field names in type annotations are for documentation only and do not affect the record's type.
8. Record fields are accessed via built-in getters: positional fields as `$1`, `$2`, etc., and named fields by their name (e.g., `.a`).
9. Records are immutable: fields do not have setters.
10. Records are structurally typed: the set, types, and names of fields define the record's type (shape).
11. Two records are equal if they have the same shape and all corresponding field values are equal. Named field order does not affect equality.
12. Records automatically define `hashCode` and `==` based on structure and field values.
13. Use records for functions that return multiple values; destructure with pattern matching: `var (name, age) = userInfo(json);`
14. Destructure named fields with the colon syntax: `final (:name, :age) = userInfo(json);`
15. Using records for multiple returns is more concise and type-safe than using classes, lists, or maps.
16. Use lists of records for simple data tuples with the same shape.
17. Use type aliases (`typedef`) for record types to improve readability and maintainability.
18. Changing a record type alias does not guarantee all code using it is still type-safe; only classes provide full abstraction/encapsulation.
19. Extension types can wrap records but do not provide full abstraction or protection.
20. Records are best for simple, immutable data aggregation; use classes for abstraction, encapsulation, and behavior.

# Common Flutter Errors

1. If you get a "RenderFlex overflowed" error, check if a `Row` or `Column` contains unconstrained widgets. Fix by wrapping children in `Flexible`, `Expanded`, or by setting constraints.
2. If you get "Vertical viewport was given unbounded height", ensure `ListView` or similar scrollable widgets inside a `Column` have a bounded height (e.g., wrap with `Expanded` or `SizedBox`).
3. If you get "An InputDecorator...cannot have an unbounded width", constrain the width of widgets like `TextField` using `Expanded`, `SizedBox`, or by placing them in a parent with width constraints.
4. If you get a "setState called during build" error, do not call `setState` or `showDialog` directly inside the build method. Trigger dialogs or state changes in response to user actions or after the build completes (e.g., using `addPostFrameCallback`).
5. If you get "The ScrollController is attached to multiple scroll views", make sure each `ScrollController` is only attached to a single scrollable widget at a time.
6. If you get a "RenderBox was not laid out" error, check for missing or unbounded constraints in your widget tree. This is often caused by using widgets like `ListView` or `Column` without proper size constraints.
7. Use the Flutter Inspector and review widget constraints to debug layout issues. Refer to the official documentation on constraints if needed.
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
18. When exposing public methods on a cubit, only use them to trigger state changes and return `void` or `Future<void>`.
19. For blocs, avoid exposing custom public methods; trigger state changes by adding events.
20. When overriding storage in a `HydratedCubit`, pass it as a named parameter (for example, `super(0, storage: storage)`), not as a positional argument.
21. When using `BlocProvider.of(context)`, call it within a child `BuildContext`, not the same context where the bloc was provided.

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


### Mocktail Rules

1. Use a `Fake` when you need a lightweight, custom implementation of a class for testing, especially if you only need to override a subset of methods or provide specific behavior.
2. Use a `Mock` when you need to verify interactions (method calls, arguments, call counts) or need to stub method responses dynamically during tests.
3. Use `registerFallbackValue` to register a default value for a type that is used as an argument in a mock method, especially when the type is not nullable and is required for argument matching (e.g., `registerFallbackValue(MyCustomEvent())`).
4. Extend `Mock` to create a mock class for the class or interface you want to mock.
5. Use `when(() => mock.method()).thenReturn(value)` to stub method calls, and `thenThrow(error)` to stub errors.
6. Use `when(() => mock.method()).thenAnswer((invocation) => value)` for dynamic responses.
7. Use `verify(() => mock.method())` to check if a method was called; use `verifyNever(() => mock.method())` to check it was never called.
8. Use `verify(() => mock.method()).called(n)` to check the exact number of invocations.
9. Use argument matchers like `any()`, `captureAny()`, and `captureThat()` for flexible verification and stubbing.
10. Always register fallback values for custom types used with argument matchers before using them in stubs or verifications.
11. Prefer using real objects over mocks when possible; if not, use a tested fake implementation (`extends Fake`) over a mock.
12. Never add implementation or `@override` methods to a class extending `Mock`.
13. Only use mocks if your test asserts on interactions (calls to `verify`); otherwise, prefer real or fake objects.
14. Always stub async methods (returning `Future` or `Future<void>`) with `thenAnswer((_) async {})` or `thenReturn(Future.value(...))`.
15. Always include all named parameters in both `when` and `verify` calls, even if you only care about one. Use `any(named: 'paramName')` for those you don't care about.
16. If a method has default values for named parameters, Mocktail still expects all of them to be matched in both stubs and verifies.
17. Use `any()` for positional parameters in `when`/`verify` if you don't care about the exact instance.
18. Register fallback values for any custom types that are used with argument matchers before using them in your tests.
19. Stub every method you expect to be called, even if it's not the focus of your test, to prevent runtime errors.
20. When matching string outputs, make sure you understand what `.toString()` returns for the type you are using.