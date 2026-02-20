### Flutter ChangeNotifier State Management Rules

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
7. Wrap widgets that depend on the model’s state in a `Consumer<T>` widget to rebuild only when relevant data changes.
```dart
return Consumer<CartModel>(
  builder: (context, cart, child) => Stack(
    children: [
      ?child,
      Text('Total price: ${cart.totalPrice}'),
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

