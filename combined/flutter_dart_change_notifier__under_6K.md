# Flutter with ChangeNotifier Rules

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

## ChangeNotifier State Management
1. Place shared state above the widgets that use it in the widget tree to enable proper rebuilds and avoid imperative UI updates.
2. Avoid directly mutating widgets or calling methods on them to change state; instead, rebuild widgets with new data.
3. Use a model class that extends `ChangeNotifier` to manage and notify listeners of state changes.
```dart
class CartModel extends ChangeNotifier {
  final List<Item> _items = [];
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }
}
```
4. Keep internal state private within the model and expose unmodifiable views to the UI.
5. Call `notifyListeners()` in your model whenever the state changes to trigger UI rebuilds.
6. Use `ChangeNotifierProvider` to provide your model to the widget subtree that needs access to it.
```dart
ChangeNotifierProvider(
  create: (context) => CartModel(),
  child: MyApp(),
)
```
7. Wrap widgets that depend on the model's state in a `Consumer<T>` widget to rebuild only when relevant data changes.
```dart
return Consumer<CartModel>(
  builder: (context, cart, child) => Stack(
    children: [
      ?child,
      Text('Total price: \${cart.totalPrice}'),
    ],
  ),
  child: const SomeExpensiveWidget(),
);
```
8. Always specify the generic type `<T>` for `Consumer<T>` and `Provider.of<T>` to ensure type safety and correct behavior.
9. Use the `child` parameter of `Consumer` to optimize performance by preventing unnecessary rebuilds of widgets that do not depend on the model.
10. Place `Consumer` widgets as deep in the widget tree as possible to minimize the scope of rebuilds.
```dart
return HumongousWidget(
  child: AnotherMonstrousWidget(
    child: Consumer<CartModel>(
      builder: (context, cart, child) {
        return Text('Total price: \${cart.totalPrice}');
      },
    ),
  ),
);
```
11. Do not wrap large widget subtrees in a `Consumer` if only a small part depends on the model; instead, wrap only the part that needs to rebuild.
12. Use `Provider.of<T>(context, listen: false)` when you need to access the model for actions (such as calling methods) but do not want the widget to rebuild on state changes.
```dart
Provider.of<CartModel>(context, listen: false).removeAll();
```
13. `ChangeNotifierProvider` automatically disposes of the model when it is no longer needed.
14. Use `MultiProvider` when you need to provide multiple models to the widget tree.
15. Write unit tests for your `ChangeNotifier` models to verify state changes and notifications.
16. Avoid rebuilding widgets unnecessarily; optimize rebuilds by structuring your widget tree and provider usage carefully.

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
