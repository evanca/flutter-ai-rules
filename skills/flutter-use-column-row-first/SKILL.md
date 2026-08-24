---
name: flutter-use-column-row-first
description: Use when building any Flutter screen or component to choose responsive Row, Column, Expanded, Flexible, and Spacer layouts before fixed-size or coordinate-based alternatives.
license: MIT
---

# Flutter Use Column Row First

Build responsive Flutter layouts from the constraint system outward. Prefer simple flex composition and introduce fixed dimensions or overlays only when the design requires them for a concrete purpose.

## Layout workflow

1. Identify each group as primarily vertical, horizontal, overlapping, scrolling, or wrapping.
2. Start vertical groups with `Column` and horizontal groups with `Row`.
3. Nest small, named widgets instead of building one deeply nested `build` method.
4. Use `Expanded`, `Flexible`, and `Spacer` to distribute bounded free space.
5. Add padding, alignment, aspect ratio, and constraints intentionally.
6. Test narrow and wide constraints, text scaling, keyboard appearance, and long or localized content.

## Rules

- Prefer `Column` for vertical flow and `Row` for horizontal flow.
- Control alignment with `mainAxisAlignment`, `crossAxisAlignment`, and `mainAxisSize`.
- Use `Expanded` when a child must fill its allocated share of remaining main-axis space.
- Use `Flexible` when a child may use less than its allocated share.
- Use `flex` only to express proportional allocation. A child with `flex: 2` receives twice the free-space share of a sibling with `flex: 1`.
- Use `Spacer` for flexible separation between siblings. Use `SizedBox` for deliberate, fixed gaps.
- Wrap text or other variable-width content in `Expanded` or `Flexible` inside a `Row` when it must yield space to siblings.
- Use `ListView` or another scrollable when vertical content can exceed the viewport; `Column` does not scroll.
- Use `Wrap` when horizontal children should move onto another run instead of shrinking or overflowing.
- Use `LayoutBuilder`, breakpoints, or adaptive widgets when the composition itself must change with available space.
- Use `SafeArea` when content must avoid system intrusions.

## Avoid rigid layouts

Avoid these as default layout mechanisms:

- `Stack` with hardcoded `Positioned` coordinates
- `Container`, `SizedBox`, or `ConstrainedBox` with hardcoded screen-like width or height
- offsets, transforms, or margins used to simulate normal document flow
- screen dimensions copied from a mockup

Use them when they serve a concrete purpose, such as:

- true visual overlap, badges, floating controls, or anchored decoration
- touch-target minimums, icon sizes, thumbnails, or bounded media
- intentional maximum reading width
- aspect-ratio requirements
- platform or design-system constants

State the purpose in the code structure or a brief comment when it is not obvious.

## Constraint safety

- Put `Expanded` and `Flexible` only under `Row`, `Column`, or `Flex`.
- Do not use non-zero flex along an unbounded main axis. In a vertical scrollable, remove vertical `Expanded` or `Flexible`, or establish a meaningful finite constraint.
- Fix a nested `Column` that needs the outer column's remaining height by wrapping the inner column in `Expanded`.
- Diagnose overflow by inspecting constraints and variable content before adding clipping or smaller hardcoded sizes.
- Prefer scrolling for content that legitimately exceeds available space.

## Preferred pattern

```dart
Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Header(),
      const SizedBox(height: 16),
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Flexible(flex: 2, child: PrimaryContent()),
            const SizedBox(width: 16),
            const Flexible(child: SecondaryContent()),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const Actions(),
    ],
  ),
)
```

Change this composition at a breakpoint if the horizontal content cannot remain usable on a narrow screen; do not merely squeeze it.

## Visual references

Inspect these diagrams when decomposing a mockup into nested flex layouts:

- [Pavlova Row and Column layout](assets/flutter-row-column-pavlova-layout_by_docs.flutter.dev.png) shows the overall horizontal `Row` containing a vertical content `Column` and an image.
- [Nested Row and Column diagram](assets/flutter-nested-row-column-diagram_by_docs.flutter.dev.png) shows smaller rating and icon groups decomposed into nested `Row` and `Column` widgets.

Use the diagrams as structural references, not as fixed pixel templates.

## Verification

- Confirm no RenderFlex overflow at supported viewport sizes.
- Confirm text wraps or truncates intentionally.
- Confirm flexible children receive bounded constraints.
- Confirm scrollable content remains reachable.
- Confirm fixed sizes and `Stack` or `Positioned` usages have a concrete design reason.

## Sources

- [Flutter layout guide](https://docs.flutter.dev/ui/layout#lay-out-multiple-widgets-vertically-and-horizontally)
- [Column API](https://api.flutter.dev/flutter/widgets/Column-class.html)
- [Expanded API](https://api.flutter.dev/flutter/widgets/Expanded-class.html)
- [Flexible.flex API](https://api.flutter.dev/flutter/widgets/Flexible/flex.html)
