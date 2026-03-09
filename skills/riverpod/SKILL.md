---
name: riverpod
description: Uses Riverpod for state management in Flutter/Dart. Use when setting up providers, combining requests, managing state disposal, passing arguments, performing side effects, testing providers, or applying Riverpod best practices.
---

# Riverpod Skill

This skill defines how to correctly use Riverpod for state management in Flutter and Dart applications.

---

## 1. Setup

```dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
```

- Wrap your app with `ProviderScope` directly in `runApp` — never inside `MyApp`.
- Install and use `riverpod_lint` to enable IDE refactoring and enforce best practices.

---

## 2. Defining Providers

```dart
// Functional provider (codegen)
@riverpod
int example(Ref ref) => 0;

// FutureProvider (codegen)
@riverpod
Future<List<Todo>> todos(Ref ref) async {
  return ref.watch(repositoryProvider).fetchTodos();
}

// Notifier (codegen)
@riverpod
class TodosNotifier extends _$TodosNotifier {
  @override
  Future<List<Todo>> build() async {
    return ref.watch(repositoryProvider).fetchTodos();
  }

  Future<void> addTodo(Todo todo) async { ... }
}
```

- Define all providers as **`final` top-level variables**.
- Use `Provider`, `FutureProvider`, or `StreamProvider` based on the return type.
- Use `ConsumerWidget` or `ConsumerStatefulWidget` instead of `StatelessWidget`/`StatefulWidget` when accessing providers.

---

## 3. Using Ref

| Method | Use for |
|---|---|
| `ref.watch` | Reactively listen — rebuilds when value changes. Use during build phase only. |
| `ref.read` | One-time access — use in callbacks/Notifier methods, not in build. |
| `ref.listen` | Imperative subscription — prefer `ref.watch` where possible. |
| `ref.onDispose` | Cleanup when provider state is destroyed. |

```dart
// In a widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(myProvider);
    return Text('$value');
  }
}

// Cleanup in a provider
final provider = StreamProvider<int>((ref) {
  final controller = StreamController<int>();
  ref.onDispose(controller.close);
  return controller.stream;
});
```

- **Never** call `ref.watch` inside callbacks, listeners, or Notifier methods.
- Use `ref.read(yourNotifierProvider.notifier).method()` to call Notifier methods from the UI.
- Check `context.mounted` before using `ref` after an `await` in async callbacks.

---

## 4. Combining Providers

```dart
@riverpod
Future<String> userGreeting(Ref ref) async {
  final user = await ref.watch(userProvider.future);
  return 'Hello, ${user.name}!';
}
```

- Use `ref.watch(asyncProvider.future)` to await an async provider's resolved value.
- Providers only execute once and cache the result — multiple widgets listening to the same provider share one computation.

---

## 5. Passing Arguments (Families)

```dart
@riverpod
Future<Todo> todo(Ref ref, String id) async {
  return ref.watch(repositoryProvider).fetchTodo(id);
}

// Usage
final todo = ref.watch(todoProvider('some-id'));
```

- Always enable `autoDispose` for parameterized providers to prevent memory leaks.
- Use `Dart 3 records` or code generation for multiple parameters — they naturally override `==`.
- Avoid passing plain `List` or `Map` as parameters (no `==` override); use `const` collections, records, or classes with proper equality.
- Use the `provider_parameters` lint rule from `riverpod_lint` to catch equality mistakes.

---

## 6. Auto Dispose & State Lifecycle

- With codegen: state is **destroyed by default** when no longer listened to. Opt out with `keepAlive: true`.
- Without codegen: state is **kept alive by default**. Use `.autoDispose` to enable disposal.
- State is always destroyed when a provider is recomputed.

```dart
// keepAlive with timer
ref.onCancel(() {
  final link = ref.keepAlive();
  Timer(const Duration(minutes: 5), link.close);
});
```

- Use `ref.onDispose` for cleanup; do not trigger side effects or modify providers inside it.
- Use `ref.invalidate(provider)` to force destruction; use `ref.invalidateSelf()` from within the provider.
- Use `ref.refresh(provider)` to invalidate and immediately read the new value — always use the return value.

---

## 7. Eager Initialization

Providers are **lazy** by default. To eagerly initialize:

```dart
// In MyApp or a dedicated widget under ProviderScope:
Consumer(
  builder: (context, ref, _) {
    ref.watch(myEagerProvider); // forces initialization
    return const MyApp();
  },
)
```

- Place eager initialization in a public widget (not `main()`) for consistent test behavior.
- Use `AsyncValue.requireValue` to read data directly and throw clearly if not ready.

---

## 8. Performing Side Effects

```dart
@riverpod
class TodosNotifier extends _$TodosNotifier {
  Future<void> addTodo(Todo todo) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(repositoryProvider).addTodo(todo);
      return [...?state.value, todo];
    });
  }
}

// In UI:
ElevatedButton(
  onPressed: () => ref.read(todosNotifierProvider.notifier).addTodo(todo),
  child: const Text('Add'),
)
```

- Use `ref.read` (not `ref.watch`) in event handlers.
- After a side effect, update state by: setting it directly, calling `ref.invalidateSelf()`, or manually updating the cache.
- Always handle loading and error states in the UI.
- Do not perform side effects in provider constructors or build methods.

---

## 9. Provider Observers

```dart
class MyObserver extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue) {
    print('[${context.provider}] updated: $previousValue → $newValue');
  }

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    // Report to error service
  }
}

runApp(ProviderScope(observers: [MyObserver()], child: MyApp()));
```

---

## 10. Testing

```dart
// Unit test
final container = ProviderContainer(
  overrides: [repositoryProvider.overrideWith((_) => FakeRepository())],
);
addTearDown(container.dispose);

expect(await container.read(todosProvider.future), isNotEmpty);

// Widget test
await tester.pumpWidget(
  ProviderScope(
    overrides: [repositoryProvider.overrideWith((_) => FakeRepository())],
    child: const MyApp(),
  ),
);
```

- Create a **new** `ProviderContainer` or `ProviderScope` for each test — never share state between tests.
- Use `container.listen` over `container.read` for `autoDispose` providers to keep state alive during the test.
- Use `overrides` to inject mocks or fakes.
- Prefer mocking **dependencies** (repositories) rather than Notifiers directly.
- If you must mock a Notifier, **subclass** the original — don't use `implements` or `with Mock`.
- Place Notifier mocks in the same file as the Notifier if using code generation.
- Obtain the container in widget tests with `ProviderScope.containerOf(tester.element(...))`.

---

## References

- [Riverpod documentation](https://riverpod.dev/docs/introduction/getting_started)
- [riverpod package on pub.dev](https://pub.dev/packages/flutter_riverpod)
- [riverpod_lint](https://pub.dev/packages/riverpod_lint)
