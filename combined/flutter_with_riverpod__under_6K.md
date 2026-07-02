# Flutter with Riverpod Rules

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

## Riverpod Fundamentals
1. Always wrap your app with `ProviderScope` at the root (directly in `runApp`).
2. Define provider variables as `final` and at the top level (global scope).
3. Use `Consumer` or `ConsumerWidget` in your UI to access providers via a `ref` object.
4. Use `Provider` for synchronous values that don't change.
5. Use `StateProvider` for simple state that can be modified from the UI.
6. Use `FutureProvider` for asynchronous operations like API calls.
7. Use `StreamProvider` for real-time data streams.
8. Use `NotifierProvider` for complex state logic with methods.
9. Use `AsyncNotifierProvider` for complex async state logic with methods.
10. Always install and use `riverpod_lint` to enable IDE refactoring and enforce best practices.
11. Providers are lazy—network requests or logic inside a provider are only executed when the provider is first read.
12. Multiple widgets can listen to the same provider; the provider will only execute once and cache the result.
13. Obtain the `Ref` object as a parameter in provider functions (or `WidgetRef` in widgets) to access other providers and manage lifecycles.

**Example: Using @riverpod annotation**
```dart
@riverpod
int example(ref) {
  return 0;
}
```

**Example: Using WidgetRef in a widget**
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(myProvider);
    return Text('$value');
  }
}
```

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
5. Avoid passing objects that do not override `==` (such as plain `List` or `Map`) as provider parameters.

## Testing Providers
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
   expect(container.read(provider), 'some value');
   ```
5. Prefer mocking dependencies (such as repositories) used by Notifiers rather than mocking Notifiers directly.

## Dart 3 Modern Features
1. Use records for grouping values: `var user = ('John', age: 30, isAdmin: true);`.
2. Access record fields by position (`$1`, `$2`, ...) or by name: `user.$1`, `user.age`.
3. Use patterns to destructure records, lists, and objects: `var (name, :age) = user;`.
4. Use switch expressions and pattern matching for concise, exhaustive control flow.
5. Use sealed classes for exhaustive `switch` and type safety.
