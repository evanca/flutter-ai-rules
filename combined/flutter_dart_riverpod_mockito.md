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
17. Use PascalCase for class names.
18. Use snake_case for file names.

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
# Riverpod Rules

### Combining Requests
1. Use the `Ref` object to combine providers and requests; all providers have access to a `Ref`.
2. In functional providers, obtain `Ref` as a parameter; in class-based providers, access it as a property of the Notifier.
3. Prefer using `ref.watch` to combine requests, as it enables reactive and declarative logic that automatically recomputes when dependencies change.
4. When using `ref.watch` with asynchronous providers, use `.future` to await the value if you need the resolved result, otherwise you will receive an `AsyncValue`.
5. Avoid calling `ref.watch` inside imperative code (e.g., listener callbacks or Notifier methods); only use it during the build phase of the provider.
6. Use `ref.listen` as an alternative to `ref.watch` for imperative subscriptions, but prefer `ref.watch` for most cases as `ref.listen` is more error-prone.
7. It is safe to use `ref.listen` during the build phase; listeners are automatically cleaned up when the provider is recomputed.
8. Use the return value of `ref.listen` to manually remove listeners when needed.
9. Use `ref.read` only when you cannot use `ref.watch`, such as inside Notifier methods; `ref.read` does not listen to provider changes.
10. Be cautious with `ref.read`, as providers not being listened to may destroy their state if not actively watched.

### Auto Dispose & State Disposal
1. By default, with code generation, provider state is destroyed when the provider stops being listened to for a full frame.
2. Opt out of automatic disposal by setting `keepAlive: true` (codegen) or using `ref.keepAlive()` (manual).
3. When not using code generation, state is not destroyed by default; enable `.autoDispose` on providers to activate automatic disposal.
4. Always enable automatic disposal for providers that receive parameters to prevent memory leaks from unused parameter combinations.
5. State is always destroyed when a provider is recomputed, regardless of auto dispose settings.
6. Use `ref.onDispose` to register cleanup logic that runs when provider state is destroyed; do not trigger side effects or modify providers inside `onDispose`.
7. Use `ref.onCancel` to react when the last listener is removed, and `ref.onResume` when a new listener is added after cancellation.
8. Call `ref.onDispose` multiple times if needed—once per disposable object—to ensure all resources are cleaned up.
9. Use `ref.invalidate` to manually force the destruction of a provider's state; if the provider is still listened to, a new state will be created.
10. Use `ref.invalidateSelf` inside a provider to force its own destruction and immediate recreation.
11. When invalidating parameterized providers, you can invalidate a specific parameter or all parameter combinations.
12. Use `ref.keepAlive` for fine-tuned control over state disposal; revert to automatic disposal using the return value of `ref.keepAlive`.
13. To keep provider state alive for a specific duration, combine a `Timer` with `ref.keepAlive` and dispose after the timer completes.
14. Consider using `ref.onCancel` and `ref.onResume` to implement custom disposal strategies, such as delayed disposal after a provider is no longer listened to.

### Eager Initialization
1. Providers are initialized lazily by default; they are only created when first used.
2. There is no built-in way to mark a provider for eager initialization due to Dart's tree shaking.
3. To eagerly initialize a provider, explicitly read or watch it at the root of your application (e.g., in a `Consumer` placed directly under `ProviderScope`).
4. Place the eager initialization logic in a public widget (such as `MyApp`) rather than in `main()` to ensure consistent test behavior.
5. Eagerly initializing a provider in a dedicated widget will not cause your entire app to rebuild when the provider changes; only the initialization widget will rebuild.
6. Handle loading and error states for eagerly initialized providers as you would in any `Consumer`, e.g., by returning a loading indicator or error widget.
7. Use `AsyncValue.requireValue` in widgets to read the data directly and throw a clear exception if the value is not ready, instead of handling loading/error states everywhere.
8. Avoid creating multiple providers or using overrides solely to hide loading/error states; this adds unnecessary complexity and is discouraged.

### First Provider & Network Requests
1. Always wrap your app with `ProviderScope` at the root (directly in `runApp`) to enable Riverpod for the entire application.
2. Place business logic such as network requests inside providers; use `Provider`, `FutureProvider`, or `StreamProvider` depending on the return type.
3. Providers are lazy—network requests or logic inside a provider are only executed when the provider is first read.
4. Define provider variables as `final` and at the top level (global scope).
5. Use code generators like Freezed or json_serializable for models and JSON parsing to reduce boilerplate.
6. Use `Consumer` or `ConsumerWidget` in your UI to access providers via a `ref` object.
7. Handle loading and error states in the UI by using the `AsyncValue` API returned by `FutureProvider` and `StreamProvider`.
8. Multiple widgets can listen to the same provider; the provider will only execute once and cache the result.
9. Use `ConsumerWidget` or `ConsumerStatefulWidget` to reduce code indentation and improve readability over using a `Consumer` widget inside a regular widget.
10. To use both hooks and providers in the same widget, use `HookConsumerWidget` or `StatefulHookConsumerWidget` from `flutter_hooks` and `hooks_riverpod`.
11. Always install and use `riverpod_lint` to enable IDE refactoring and enforce best practices.
12. Do not put `ProviderScope` inside `MyApp`; it must be the top-level widget passed to `runApp`.
13. When handling network requests, always render loading and error states gracefully in the UI.
14. Do not re-execute network requests on widget rebuilds; Riverpod ensures the provider is only executed once unless explicitly invalidated.

### Passing Arguments to Providers
1. Use provider "families" to pass arguments to providers; add `.family` after the provider type and specify the argument type.
2. When using code generation, add parameters directly to the annotated function (excluding `ref`).
3. Always enable `autoDispose` for providers that receive parameters to avoid memory leaks.
4. When consuming a provider that takes arguments, call it as a function with the desired parameters (e.g., `ref.watch(myProvider(param))`).
5. You can listen to the same provider with different arguments simultaneously; each argument combination is cached separately.
6. The equality (`==`) of provider parameters determines caching—ensure parameters have consistent and correct equality semantics.
7. Avoid passing objects that do not override `==` (such as plain `List` or `Map`) as provider parameters; use `const` collections, custom classes with proper equality, or Dart 3 records.
8. Use the `provider_parameters` lint rule from `riverpod_lint` to catch mistakes with parameter equality.
9. For multiple parameters, prefer code generation or Dart 3 records, as records naturally override `==` and are convenient for grouping arguments.
10. If two widgets consume the same provider with the same parameters, only one computation/network request is made; with different parameters, each is cached separately.

### FAQ & Best Practices
1. Use `ref.refresh(provider)` when you want to both invalidate a provider and immediately read its new value; use `ref.invalidate(provider)` if you only want to invalidate without reading the value.
2. Always use the return value of `ref.refresh`; ignoring it will trigger a lint warning.
3. If a provider is invalidated while not being listened to, it will not update until it is listened to again.
4. Do not try to share logic between `Ref` and `WidgetRef`; move shared logic into a `Notifier` and call methods on the notifier via `ref.read(yourNotifierProvider.notifier).yourMethod()`.
5. Prefer `Ref` for business logic and avoid relying on `WidgetRef`, which ties logic to the UI layer.
6. Extend `ConsumerWidget` instead of using raw `StatelessWidget` when you need access to providers in the widget tree, due to limitations of `InheritedWidget`.
7. `InheritedWidget` cannot implement a reliable "on change" listener or track when widgets stop listening, which is required for Riverpod's advanced features.
8. Do not expect to reset all providers at once; instead, make providers that should reset depend on a "user" or "session" provider and reset that dependency.
9. `hooks_riverpod` and `flutter_hooks` are versioned independently; always add both as dependencies if using hooks.
10. Riverpod uses `identical` instead of `==` to filter updates for performance reasons, especially with code-generated models; override `updateShouldNotify` on Notifiers to change this behavior.
11. If you encounter "Cannot use `ref` after the widget was disposed", ensure you check `context.mounted` before using `ref` after an `await` in an async callback.

### Provider Observers (Logging & Error Reporting)
1. Use a `ProviderObserver` to listen to all events in the provider tree for logging, analytics, or error reporting.
2. Extend the `ProviderObserver` class and override its methods to respond to provider lifecycle events:
   - `didAddProvider`: called when a provider is added to the tree.
   - `didUpdateProvider`: called when a provider is updated.
   - `didDisposeProvider`: called when a provider is disposed.
   - `providerDidFail`: called when a synchronous provider throws an error.
3. Register your observer(s) by passing them to the `observers` parameter of `ProviderScope` (for Flutter apps) or `ProviderContainer` (for pure Dart).
4. You can register multiple observers if needed by providing a list to the `observers` parameter.
5. Use observers to integrate with remote error reporting services, log provider state changes, or trigger custom analytics.

### Performing Side Effects
1. Use Notifiers (`Notifier`, `AsyncNotifier`, etc.) to expose methods for performing side effects (e.g., POST, PUT, DELETE) and modifying provider state.
2. Always define provider variables as `final` and at the top level (global scope).
3. Choose the provider type (`NotifierProvider`, `AsyncNotifierProvider`, etc.) based on the return type of your logic.
4. Use provider modifiers like `autoDispose` and `family` as needed for cache management and parameterization.
5. Expose public methods on Notifiers for UI to trigger state changes or side effects.
6. In UI event handlers (e.g., button `onPressed`), use `ref.read` to call Notifier methods; avoid using `ref.watch` for imperative actions.
7. After performing a side effect, update the UI state by:
   - Setting the new state directly if the server returns the updated data.
   - Calling `ref.invalidateSelf()` to refresh the provider and re-fetch data.
   - Manually updating the local cache if the server does not return the new state.
8. When updating the local cache, prefer immutable state, but mutable state is possible if necessary.
9. Always handle loading and error states in the UI when performing side effects.
10. Use progress indicators and error messages to provide feedback for pending or failed operations.
11. Be aware of the pros and cons of each update approach:
    - Direct state update: most up-to-date but depends on server implementation.
    - Invalidate and refetch: always consistent with server, but may incur extra network requests.
    - Manual cache update: efficient, but risks state divergence from server.
12. Use hooks (`flutter_hooks`) or `StatefulWidget` to manage local state (e.g., pending futures) for showing spinners or error UI during side effects.
13. Do not perform side effects directly inside provider constructors or build methods; expose them via Notifier methods and invoke from the UI layer.

### Testing Providers
1. Always create a new `ProviderContainer` (unit tests) or `ProviderScope` (widget tests) for each test to avoid shared state between tests. Use a utility like `createContainer()` to set up and automatically dispose containers (see `/references/riverpod/testing/create_container.dart`).
2. In unit tests, never share `ProviderContainer` instances between tests. Example:
   ```dart
   final container = createContainer();
   expect(container.read(provider), equals('some value'));
   ```
3. In widget tests, always wrap your widget tree with `ProviderScope` when using `tester.pumpWidget`. Example:
   ```dart
   await tester.pumpWidget(
     const ProviderScope(child: YourWidgetYouWantToTest()),
   );
   ```
4. Obtain a `ProviderContainer` in widget tests using `ProviderScope.containerOf(BuildContext)`. Example:
   ```dart
   final element = tester.element(find.byType(YourWidgetYouWantToTest));
   final container = ProviderScope.containerOf(element);
   ```
5. After obtaining the container, you can read or interact with providers as needed for assertions. Example:
   ```dart
   expect(container.read(provider), 'some value');
   ```
6. For providers with `autoDispose`, prefer `container.listen` over `container.read` to prevent the provider's state from being disposed during the test.
7. Use `container.read` to read provider values and `container.listen` to listen to provider changes in tests.
8. Use the `overrides` parameter on `ProviderScope` or `ProviderContainer` to inject mocks or fakes for providers in your tests.
9. Use `container.listen` to spy on changes in a provider for assertions or to combine with mocking libraries.
10. Await asynchronous providers in tests by reading the `.future` property (for `FutureProvider`) or listening to streams.
11. Prefer mocking dependencies (such as repositories) used by Notifiers rather than mocking Notifiers directly.
12. If you must mock a Notifier, subclass the original Notifier base class instead of using `implements` or `with Mock`.
13. Place Notifier mocks in the same file as the Notifier being mocked if code generation is used, to access generated classes.
14. Use the `overrides` parameter to swap out Notifiers or providers for mocks or fakes in tests.
15. Keep all test-specific setup and teardown logic inside the test body or test utility functions. Avoid global state.
16. Ensure your test environment closely matches your production environment for reliable results.


### Mockito Rules

1. Use a `Fake` when you want a lightweight, custom implementation of a class for testing, especially when you only need to override a subset of methods or provide specific behavior for certain methods.
2. Use a `Mock` when you need to verify interactions (method calls, arguments, call counts) or when you need to stub method responses dynamically during tests.
3. Use `@GenerateMocks([YourClass])` or `@GenerateNiceMocks([MockSpec<YourClass>()])` to generate mock classes for your real classes.
4. Run `dart run build_runner build` after adding mock annotations to generate the mock files.
5. Only annotate files under `test/` for mock generation by default; use a `build.yaml` if you need to generate mocks elsewhere.
6. Create mock instances from generated classes (e.g., `var mock = MockCat();`).
7. Use `when(mock.method()).thenReturn(value)` to stub method calls, and `when(mock.method()).thenThrow(error)` to stub errors.
8. Use `thenAnswer` to calculate a response at call time: `when(mock.method()).thenAnswer((_) => value);`.
9. Use `thenReturnInOrder([v1, v2])` to return values in sequence for multiple calls.
10. Always stub methods or getters before interacting with them if you need specific return values.
11. Use `verify(mock.method())` to check if a method was called; use `verifyNever` to check it was never called.
12. Use `verify(mock.method()).called(n)` to check the exact number of invocations.
13. Use argument matchers like `any`, `argThat`, `captureAny`, and `captureThat` for flexible verification and stubbing.
14. Do not use `null` as an argument adjacent to an argument matcher.
15. For named arguments, use `any` or `argThat` as values, not as argument names (e.g., `when(mock.method(any, namedArg: any))`).
16. Use `captureAny` and `captureThat` to capture arguments passed to mocks for later assertions.
17. Use `untilCalled(mock.method())` to wait for an interaction in async tests.
18. Understand missing stub behavior: mocks generated with `@GenerateMocks` throw on missing stubs; those with `@GenerateNiceMocks` return a simple legal value.
19. To mock function types, define an abstract class with the required method signatures and generate mocks for it.
20. Prefer using real objects over mocks when possible; if not, use a tested fake implementation (`extends Fake`) over a mock.
21. Never stub out responses in a mock's constructor or within the mock class itself; always stub in your tests.
22. Never add implementation or `@override` methods to a class extending `Mock`.
23. Use `reset(mock)` to clear all stubs and interactions; use `clearInteractions(mock)` to clear only interactions.
24. Use `logInvocations([mock1, mock2])` to print all collected invocations for debugging.
25. Use `throwOnMissingStub(mock)` to throw if a mock method is called without a matching stub.
26. Data models should not be mocked if they can be constructed with stubbed data.
27. Only use mocks if your test asserts on interactions (calls to `verify`); otherwise, prefer real or fake objects.


