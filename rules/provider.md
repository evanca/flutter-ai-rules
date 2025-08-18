### Provider Rules

1. Use `Provider`, `ChangeNotifierProvider`, `FutureProvider`, and `StreamProvider` to expose values and manage state in the widget tree.
2. Always specify the generic type when using `Provider`, `Consumer`, `context.watch`, `context.read`, or `context.select` for type safety.
```dart
final value = context.watch<int>();
```
3. Use `ChangeNotifierProvider` to automatically dispose of the model when it is no longer needed.
```dart
ChangeNotifierProvider(
  create: (_) => MyNotifier(),
  child: MyApp(),
)
```
4. For objects that depend on other providers or values that may change, use `ProxyProvider` or `ChangeNotifierProxyProvider` instead of creating the object from variables that can change over time.
```dart
ProxyProvider0(
  update: (_, __) => MyModel(count),
  child: ...
)
```
5. Use `MultiProvider` to group multiple providers and avoid deeply nested provider trees.
```dart
MultiProvider(
  providers: [
    Provider<Something>(create: (_) => Something()),
    Provider<SomethingElse>(create: (_) => SomethingElse()),
  ],
  child: someWidget,
)
```
6. Use `context.watch<T>()` to listen to changes and rebuild the widget when `T` changes.
7. Use `context.read<T>()` to access a provider without listening for changes (e.g., in callbacks).
8. Use `context.select<T, R>(R selector(T value))` to listen to only a small part of `T` and optimize rebuilds.
```dart
final selected = context.select<MyModel, int>((model) => model.count);
```
9. Use `Consumer<T>` or `Selector<T, R>` widgets for fine-grained rebuilds when you cannot access a descendant `BuildContext`.
```dart
Consumer<MyModel>(
  builder: (context, value, child) => Text('$value'),
)
```
10. To migrate from `ValueListenableProvider`, use `Provider` with `ValueListenableBuilder`.
```dart
ValueListenableBuilder<int>(
  valueListenable: myValueListenable,
  builder: (context, value, _) {
    return Provider<int>.value(
      value: value,
      child: MyApp(),
    );
  }
)
```
11. Do not create your provider’s object from variables that can change over time; otherwise, the object will not update when the value changes.
12. For debugging, implement `toString` or use `DiagnosticableTreeMixin` to improve how your objects appear in Flutter DevTools.
```dart
class MyClass with DiagnosticableTreeMixin {
  // ...
  @override
  String toString() => '$runtimeType(a: $a, b: $b)';
}
```
13. Do not attempt to obtain providers inside `initState` or `constructor`; use them in `build`, callbacks, or lifecycle methods where the widget is fully mounted.
14. You can use any object as state, not just `ChangeNotifier`; use `Provider.value()` with a `StatefulWidget` if needed.
15. If you have a very large number of providers (e.g., 150+), consider mounting them over time (e.g., during splash screen animation) or avoid `MultiProvider` to prevent StackOverflowError.

