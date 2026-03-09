---
name: flutter-errors
description: Diagnoses and fixes common Flutter errors. Use when encountering layout errors (RenderFlex overflow, unbounded constraints, RenderBox not laid out), scroll errors, or setState-during-build errors.
---

# Flutter Errors Skill

This skill provides solutions for the most common Flutter runtime and layout errors.

---

## RenderFlex Overflowed

**Error:** `A RenderFlex overflowed by X pixels on the right/bottom.`

**Cause:** A `Row` or `Column` contains children that are wider/taller than the available space.

**Fix:** Wrap the overflowing child in `Flexible` or `Expanded`, or constrain its size:

```dart
Row(
  children: [
    Expanded(child: Text('Long text that might overflow')),
    Icon(Icons.info),
  ],
)
```

---

## Vertical Viewport Given Unbounded Height

**Error:** `Vertical viewport was given unbounded height.`

**Cause:** A `ListView` (or other scrollable) is placed inside a `Column` without a bounded height.

**Fix:** Wrap the `ListView` in `Expanded` or give it a fixed height with `SizedBox`:

```dart
Column(
  children: [
    Text('Header'),
    Expanded(
      child: ListView(children: [...]),
    ),
  ],
)
```

---

## InputDecorator Cannot Have Unbounded Width

**Error:** `An InputDecorator...cannot have an unbounded width.`

**Cause:** A `TextField` or similar widget is placed in a context without width constraints.

**Fix:** Wrap it in `Expanded`, `SizedBox`, or any parent that provides width constraints:

```dart
Row(
  children: [
    Expanded(child: TextField()),
  ],
)
```

---

## setState Called During Build

**Error:** `setState() or markNeedsBuild() called during build.`

**Cause:** `setState` or `showDialog` is called directly inside the `build` method.

**Fix:** Trigger state changes in response to user actions, or defer to after the frame using `addPostFrameCallback`:

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Safe to call setState or showDialog here
  });
}
```

---

## ScrollController Attached to Multiple Scroll Views

**Error:** `The ScrollController is attached to multiple scroll views.`

**Cause:** A single `ScrollController` instance is shared across more than one scrollable widget simultaneously.

**Fix:** Ensure each scrollable widget has its own dedicated `ScrollController` instance.

---

## RenderBox Was Not Laid Out

**Error:** `RenderBox was not laid out: ...`

**Cause:** A widget is missing or has unbounded constraints — commonly `ListView` or `Column` without proper size constraints.

**Fix:** Review your widget tree for missing constraints. Common patterns:

- Wrap `ListView` in `Expanded` inside a `Column`.
- Give widgets an explicit `width` or `height` via `SizedBox` or `ConstrainedBox`.

---

## Debugging Layout Issues

- Use the **Flutter Inspector** (in DevTools) to visualize widget constraints.
- Enable **"Show guidelines"** to see layout boundaries.
- Add `debugPaintSizeEnabled = true;` temporarily in your `main()` to paint layout bounds.
- Refer to the [Flutter constraints documentation](https://docs.flutter.dev/ui/layout/constraints) for a deeper understanding of how constraints propagate.

## References

- [Flutter Website GitHub Repository](https://github.com/flutter/website)
