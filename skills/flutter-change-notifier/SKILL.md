---
name: flutter-change-notifier
description: Implements state management with ChangeNotifier and Provider in Flutter. Use when setting up ChangeNotifier models, providing them to the widget tree, consuming state with Consumer or Provider.of, or optimizing rebuilds.
---

# Flutter ChangeNotifier Skill

This skill defines how to correctly use `ChangeNotifier` with the `provider` package for state management in Flutter.

---

## 1. Model

Extend `ChangeNotifier` to manage state. Keep internal state **private** and expose **unmodifiable views**. Call `notifyListeners()` on every state change.

```dart
class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
```

- Place shared state **above** the widgets that use it in the widget tree.
- Never directly mutate widgets or call methods on them to change state — rebuild widgets with new data instead.

---

## 2. Providing the Model

```dart
ChangeNotifierProvider(
  create: (context) => CartModel(),
  child: MyApp(),
)
```

- `ChangeNotifierProvider` **automatically disposes** of the model when it is no longer needed.
- Use `MultiProvider` when you need to provide multiple models:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => CartModel()),
    ChangeNotifierProvider(create: (_) => UserModel()),
  ],
  child: MyApp(),
)
```

---

## 3. Consuming State

### Consumer

```dart
Consumer<CartModel>(
  builder: (context, cart, child) => Stack(
    children: [
      if (child != null) child,
      Text('Total price: ${cart.totalPrice}'),
    ],
  ),
  child: const SomeExpensiveWidget(), // rebuilt only once
)
```

- Always specify the generic type (`Consumer<CartModel>`, not `Consumer`).
- Use the `child` parameter to pass **widgets that don't depend on the model** — they are built once and reused.
- Place `Consumer` widgets **as deep in the widget tree as possible** to minimize the scope of rebuilds:

```dart
HumongousWidget(
  child: AnotherMonstrousWidget(
    child: Consumer<CartModel>(
      builder: (context, cart, child) {
        return Text('Total price: ${cart.totalPrice}');
      },
    ),
  ),
)
```

### Provider.of with listen: false

Use `Provider.of<T>(context, listen: false)` when you only need to **call methods** on the model, not react to state changes:

```dart
Provider.of<CartModel>(context, listen: false).removeAll();
```

---

## 4. Optimization Rules

- Do **not** wrap large widget subtrees in a `Consumer` if only a small part depends on the model.
- Avoid rebuilding widgets unnecessarily — structure your widget tree and provider usage carefully.
- Use `listen: false` in callbacks (e.g., `onPressed`) where you trigger actions but don't need rebuilds.

---

## 5. Testing

Write **unit tests** for your `ChangeNotifier` models to verify state changes and notifications:

```dart
test('adding item updates total', () {
  final cart = CartModel();
  var notified = false;
  cart.addListener(() => notified = true);

  cart.add(Item('Book'));

  expect(cart.items.length, 1);
  expect(notified, isTrue);
});
```

---

## References

- [Flutter Website GitHub Repository](https://github.com/flutter/website)
