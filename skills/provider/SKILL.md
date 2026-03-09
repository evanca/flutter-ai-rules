---
name: provider
description: Uses the Provider package for dependency injection and state management in Flutter. Use when setting up providers, consuming state, optimizing rebuilds, using ProxyProvider, or migrating from deprecated providers.
---

# Provider Skill

This skill defines how to correctly use the `provider` package in Flutter applications.

---

## 1. Provider Types

| Provider | Use for |
|---|---|
| `Provider` | Exposing any immutable value |
| `ChangeNotifierProvider` | Mutable state with `ChangeNotifier` |
| `FutureProvider` | Exposing a `Future` result |
| `StreamProvider` | Exposing a `Stream` |
| `ProxyProvider` / `ChangeNotifierProxyProvider` | Objects that depend on other providers |

---

## 2. Setup

```dart
MultiProvider(
  providers: [
    Provider<Something>(create: (_) => Something()),
    ChangeNotifierProvider(create: (_) => MyNotifier()),
    FutureProvider<String>(create: (_) => fetchData(), initialData: ''),
  ],
  child: MyApp(),
)
```

- Use `MultiProvider` to group multiple providers and avoid deeply nested trees.
- `ChangeNotifierProvider` **automatically disposes** the model when it is no longer needed.
- **Never** create a provider's object from variables that can change over time — the object won't update when the variable changes. Use `ProxyProvider` instead.
- If you have 150+ providers, consider mounting them over time (e.g., during a splash screen) rather than all at once to avoid `StackOverflowError`.

---

## 3. Consuming State

Always specify the **generic type** for type safety:

```dart
// Listen and rebuild on change
final count = context.watch<MyModel>().count;

// Access without listening (use in callbacks)
context.read<MyModel>().increment();

// Listen to only part of the state
final count = context.select<MyModel, int>((m) => m.count);
```

Use `Consumer<T>` or `Selector<T, R>` widgets when you need fine-grained rebuilds and cannot access a descendant `BuildContext`:

```dart
Consumer<MyModel>(
  builder: (context, model, child) => Text('${model.count}'),
  child: const ExpensiveWidget(), // rebuilt only once
)

Selector<MyModel, int>(
  selector: (_, model) => model.count,
  builder: (_, count, __) => Text('$count'),
)
```

---

## 4. ProxyProvider

Use `ProxyProvider` or `ChangeNotifierProxyProvider` for objects that depend on other providers or values that can change:

```dart
MultiProvider(
  providers: [
    Provider<Auth>(create: (_) => Auth()),
    ProxyProvider<Auth, Api>(
      update: (_, auth, __) => Api(auth.token),
    ),
  ],
)
```

---

## 5. Rules

- Do **not** access providers inside `initState` or constructors — use them in `build`, callbacks, or lifecycle methods where the widget is fully mounted.
- You can use **any object** as state, not just `ChangeNotifier`; use `Provider.value()` with a `StatefulWidget` if needed.

---

## 6. Debugging

Implement `toString` or `DiagnosticableTreeMixin` to improve how your objects appear in Flutter DevTools:

```dart
class MyModel with DiagnosticableTreeMixin {
  final int count;
  MyModel(this.count);

  @override
  String toString() => 'MyModel(count: $count)';
}
```

---

## 7. Migration: ValueListenableProvider

`ValueListenableProvider` is deprecated. Use `Provider` with `ValueListenableBuilder` instead:

```dart
ValueListenableBuilder<int>(
  valueListenable: myValueListenable,
  builder: (context, value, _) {
    return Provider<int>.value(
      value: value,
      child: MyApp(),
    );
  },
)
```

---

## References

- [Provider GitHub Repository](https://github.com/rrousselGit/provider)
