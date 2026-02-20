# Flutter with Riverpod and Mockito Rules

## Core Dart Principles
1. Use class modifiers (`base`, `final`, `sealed`, `interface`) to control class extension.
2. Override `hashCode` if you override `==`.
3. Type annotate fields, variables, and parameters when the type isn't obvious.
4. Use `Future<void>` for asynchronous members without return values.
5. Use getters for property access and setters for property changes.

## Riverpod Fundamentals
1. Always wrap your app with `ProviderScope` at the root (directly in `runApp`).
2. Define provider variables as `final` and at the top level (global scope).
3. Use `Provider` for synchronous values that don't change.
4. Use `StateProvider` for simple state that can be modified from the UI.
5. Use `FutureProvider` for asynchronous operations like API calls.
6. Use `StreamProvider` for real-time data streams.
7. Use `NotifierProvider` for complex state logic with methods.
8. Use `AsyncNotifierProvider` for complex async state logic with methods.
9. Providers are lazy—network requests or logic inside a provider are only executed when the provider is first read.

## Ref Object Usage
1. Use `ref.watch` to reactively depend on other providers; the provider will rebuild when dependencies change.
2. When using `ref.watch` with asynchronous providers, use `.future` to await the value if you need the resolved result.
3. Use `ref.listen` to perform side effects when a provider changes.
4. Use `ref.read` only when you cannot use `ref.watch`, such as inside Notifier methods or event handlers.
5. Be cautious with `ref.read`, as providers not being listened to may destroy their state if not actively watched.

## State Management with Notifiers
1. Use Notifiers to expose methods for performing side effects and modifying provider state.
2. Expose public methods on Notifiers for UI to trigger state changes or side effects.
3. In UI event handlers (e.g., button `onPressed`), use `ref.read` to call Notifier methods.
4. After performing a side effect, update the UI state by:
   - Setting the new state directly if the server returns the updated data.
   - Calling `ref.invalidateSelf()` to refresh the provider and re-fetch data.
   - Manually updating the local cache if the server does not return the new state.
5. Always handle loading and error states in the UI when performing side effects.
6. Do not perform side effects directly inside provider constructors or build methods.

## Auto Dispose & State Disposal
1. By default, with code generation, provider state is destroyed when the provider stops being listened to.
2. Opt out of automatic disposal by setting `keepAlive: true` (codegen) or using `ref.keepAlive()` (manual).
3. When not using code generation, enable `.autoDispose` on providers to activate automatic disposal.
4. Always enable automatic disposal for providers that receive parameters to prevent memory leaks.
5. Use `ref.onDispose` to register cleanup logic that runs when provider state is destroyed.

## Passing Arguments to Providers
1. Use provider "families" to pass arguments to providers; add `.family` after the provider type.
2. When using code generation, add parameters directly to the annotated function (excluding `ref`).
3. Always enable `autoDispose` for providers that receive parameters to avoid memory leaks.
4. The equality (`==`) of provider parameters determines caching—ensure parameters have consistent equality.

## Testing with Riverpod
1. Always create a new `ProviderContainer` (unit tests) or `ProviderScope` (widget tests) for each test.
2. In unit tests, never share `ProviderContainer` instances between tests:
   ```dart
   final container = createContainer();
   expect(container.read(provider), equals('some value'));
   ```
3. In widget tests, always wrap your widget tree with `ProviderScope`:
   ```dart
   await tester.pumpWidget(
     const ProviderScope(child: YourWidgetYouWantToTest()),
   );
   ```
4. Obtain a `ProviderContainer` in widget tests using `ProviderScope.containerOf(BuildContext)`:
   ```dart
   final element = tester.element(find.byType(YourWidgetYouWantToTest));
   final container = ProviderScope.containerOf(element);
   ```
5. After obtaining the container, you can read or interact with providers as needed for assertions:
   ```dart
   expect(container.read(provider), 'some value');
   ```
6. Use the `overrides` parameter to inject mocks or fakes for providers in your tests.
7. Use `container.listen` to spy on changes in a provider for assertions.

## Mockito Best Practices
1. Use a `Fake` when you want a lightweight, custom implementation of a class for testing.
2. Use a `Mock` when you need to verify interactions (method calls, arguments, call counts).
3. Use `@GenerateMocks([YourClass])` or `@GenerateNiceMocks([MockSpec<YourClass>()])` to generate mock classes.
4. Run `dart run build_runner build` after adding mock annotations to generate the mock files.
5. Create mock instances from generated classes (e.g., `var mock = MockCat();`).
6. Use `when(mock.method()).thenReturn(value)` to stub method calls, and `when(mock.method()).thenThrow(error)` to stub errors.
7. Use `thenAnswer` to calculate a response at call time: `when(mock.method()).thenAnswer((_) => value);`.

## Dart 3 Modern Features
1. Use records for grouping values: `var user = ('John', age: 30, isAdmin: true);`.
2. Access record fields by position (`$1`, `$2`, ...) or by name: `user.$1`, `user.age`.
3. Use patterns to destructure records, lists, and objects: `var (name, :age) = user;`.

## Riverpod and Mockito Integration
1. When testing Riverpod providers, use Mockito to mock dependencies.
