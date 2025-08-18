# Riverpod Rules

### Using Ref in Riverpod
1. The `Ref` object is essential for accessing the provider system, reading or watching other providers, managing lifecycles, and handling dependencies in Riverpod.
2. In functional providers, obtain `Ref` as a parameter; in class-based providers, access it as a property of the Notifier.
3. In widgets, use `WidgetRef` (a subtype of `Ref`) to interact with providers.
4. The `@riverpod` annotation is used to define providers with code generation, where the function receives `ref` as its parameter.
5. Use `ref.watch` to reactively listen to other providers; use `ref.read` for one-time access (non-reactive); use `ref.listen` for imperative subscriptions; use `ref.onDispose` to clean up resources.
6. Example: Functional provider with Ref
   ```dart
   final otherProvider = Provider<int>((ref) => 0);
   final provider = Provider<int>((ref) {
     final value = ref.watch(otherProvider);
     return value * 2;
   });
   ```
7. Example: Provider with @riverpod annotation
   ```dart
   @riverpod
   int example(ref) {
     return 0;
   }
   ```
8. Example: Using Ref for cleanup
   ```dart
   final provider = StreamProvider<int>((ref) {
     final controller = StreamController<int>();
     ref.onDispose(controller.close);
     return controller.stream;
   });
   ```
9. Example: Using WidgetRef in a widget
   ```dart
   class MyWidget extends ConsumerWidget {
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final value = ref.watch(myProvider);
       return Text('$value');
     }
   }
   ```

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
11. If you encounter "Using `ref` when a widget is about to or has been unmounted is unsafe" after the widget was disposed, ensure you check `context.mounted` before using `ref` after an `await` in an async callback.

### Provider Observers (Logging & Error Reporting)
1. Use a `ProviderObserver` to listen to all events in the provider tree for logging, analytics, or error reporting.
2. Extend the `ProviderObserver` class and override its methods to respond to provider lifecycle events:
   - `didAddProvider(ProviderObserverContext context, Object? value)`: called when a provider is added to the tree.
   - `didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue)`: called when a provider is updated.
   - `didDisposeProvider(ProviderObserverContext context)`: called when a provider is disposed.
   - `providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace)`: called when a synchronous provider throws an error.
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

