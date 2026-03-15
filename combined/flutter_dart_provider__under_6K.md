# Flutter with Provider Rules

## Core Dart Principles
1. Use class modifiers to control if your class can be extended or used as an interface.
2. Make your `==` operator obey the mathematical rules of equality and override `hashCode` if you override `==`.
3. Type annotate fields, variables, and parameters when the type isn't obvious.
4. Use `Future<void>` as the return type of asynchronous members that do not produce values.
5. Use getters for operations that conceptually access properties and setters for operations that conceptually change properties.
6. Use collection literals when possible.
7. Use `whereType()` to filter a collection by type.
8. Initialize fields at their declaration when possible.
9. Use initializing formals when possible.
10. Use `rethrow` to rethrow a caught exception.

## Flutter Best Practices
1. Extract reusable widgets into separate components.
2. Use `StatelessWidget` when possible.
3. Keep build methods simple and focused.
4. Avoid unnecessary `StatefulWidget`s.
5. Keep state as local as possible.
6. Use `const` constructors when possible.
7. Avoid expensive operations in build methods.
8. Implement pagination for large lists.

## Provider State Management
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
6. Use `context.watch<T>()` to listen to changes and rebuild the widget when `T` changes. `context.watch<T>()` can only be called inside `StatelessWidget.build`/`State.build` or a Provider's `update` method.
7. Use `context.read<T>()` to access a provider without listening for changes (e.g., in callbacks). Avoid calling `context.read<T>()` inside `StatelessWidget.build`/`State.build`; use `context.watch<T>()` there instead.
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
11. Do not create your provider's object from variables that can change over time; otherwise, the object will not update when the value changes.
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

## Dart 3 Modern Features
1. Use records for grouping values: `var user = ('John', age: 30)`.
2. Access record fields by position (`$1`) or name (`.age`).
3. Use patterns to destructure records, lists, and objects: `var (name, age) = user;`
4. Use switch expressions and pattern matching for concise, exhaustive control flow.
5. Use sealed classes for exhaustive `switch` and type safety.

## Common Flutter Errors
1. If you get a "RenderFlex overflowed" error, check if a `Row` or `Column` contains unconstrained widgets. Fix by wrapping children in `Flexible`, `Expanded`, or by setting constraints.
2. If you get "Vertical viewport was given unbounded height", ensure `ListView` or similar scrollable widgets inside a `Column` have a bounded height (e.g., wrap with `Expanded` or `SizedBox`).
3. If you get "An InputDecorator...cannot have an unbounded width", constrain the width of widgets like `TextField` using `Expanded`, `SizedBox`, or by placing them in a parent with width constraints.
4. If you get a "setState called during build" error, do not call `setState` or `showDialog` directly inside the build method. Trigger dialogs or state changes in response to user actions or after the build completes (e.g., using `addPostFrameCallback`).
5. If you get "The ScrollController is attached to multiple scroll views", make sure each `ScrollController` is only attached to a single scrollable widget at a time.
6. If you get a "RenderBox was not laid out" error, check for missing or unbounded constraints in your widget tree. This is often caused by using widgets like `ListView` or `Column` without proper size constraints.
