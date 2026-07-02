# Dart & Flutter Coding Practices

Based on LeanCode's Flutter coding best practices
(https://leancode.co/blog/flutter-coding-best-practices). These are
line-level habits: how to write the code once the architecture has decided
where it goes.

## Contents

1. [Null safety & pattern matching](#null-safety--pattern-matching)
2. [Collections](#collections)
3. [Control flow](#control-flow)
4. [Async](#async)
5. [Widgets](#widgets)
6. [Testing](#testing)
7. [Documentation & logging](#documentation--logging)
8. [Linting](#linting)

## Null safety & pattern matching

**Check-and-bind in one step.** Prefer `case` patterns over null checks
followed by `!`:

```dart
// Avoid — the ! silently breaks if the check above is refactored away
if (userData != null) {
  greet(userData!.name);
}

// Prefer — compiler-verified: user is non-null and bound in one step
if (userData case final user?) {
  greet(user.name);
}
```

**Destructure instead of repeated field access:**

```dart
final Point(:x, :y) = point;      // objects
final (lat, lng) = coordinates;   // records
final [first, second, ...] = items; // lists (rest pattern)
```

## Collections

**Build lists declaratively — the same way you build widget trees.** Use
collection `if`, collection `for`, spreads, and null-aware elements instead
of imperative `.add()`/`.addAll()`:

```dart
// Avoid
final messages = <Widget>[];
messages.add(welcomeMessage);
if (showPromo) messages.addAll(promoBanners);

// Prefer
final messages = [
  welcomeMessage,
  ?optionalMessage,           // null-aware element
  if (showPromo) ...promoBanners,
  for (final item in news) NewsTile(item),
];
```

## Control flow

**Switch expressions over if/else chains.** Pattern matching does the type
checking and destructuring, and the compiler enforces exhaustiveness — add a
new subtype and every unhandled switch becomes a compile error:

```dart
final label = switch (state) {
  Loading() => 'Loading…',
  Failure(:final reason) => 'Failed: $reason',
  Ready(:final items) => '${items.length} items',
};
```

**Dot shorthands (Dart 3.10+).** When the context type is known, drop the
redundant type name: `padding: .all(16)`, `case .dark`. Especially effective
with well-known enum/const-heavy types like `EdgeInsets` and `Brightness`.

## Async

**No redundant async/await on pass-through functions.** If a function only
forwards a future, use an expression body:

```dart
// Avoid — needless state machine
Future<User> getUser() async => await repository.getUserDetails();

// Prefer
Future<User> getUser() => repository.getUserDetails();
```

Use `async`/`await` only when you actually manipulate the awaited result (or
need try/catch around it).

## Widgets

**Replace `Container` with the dedicated widget for the job:**

| Need | Use |
|---|---|
| spacing around a child | `Padding` |
| a fixed size | `SizedBox` |
| a background color | `ColoredBox` |
| a decoration (border, gradient, radius) | `DecoratedBox` |
| centering | `Center` |

Why: dedicated widgets have `const` constructors (`Container` doesn't) and
state intent instantly. `Container` is appropriate when genuinely combining
several properties (e.g. padding + color together). Watch one subtlety:
`Container` insets its child *inside* the border; a manual
`DecoratedBox` + `Padding` composition does not, so verify visuals when
converting.

**Prefix sliver-returning widgets with `Sliver`** — e.g.
`SliverDashboardAppBar`, not `DashboardAppBar`. Slivers used as box widgets
(or vice versa) fail at runtime, not compile time; the name is the guard. The
`leancode_lint` rule `prefix_widgets_returning_slivers` automates this.

## Testing

**Tests should tell a story, not read like cryptic puzzles.** Use expressive
matchers:

```dart
expect(list, isEmpty);                       // not expect(list, [])
expect(name, startsWith('Dr.'));
expect(future, completion(equals(42)));
expect(() => parse(bad), throwsA(isA<FormatException>()));
```

**Minimize test dependencies.** Every dependency pulled into a test is
another potential point of failure — a fragile test can pass while real
functionality is broken, or fail for reasons unrelated to what it tests. In
widget-test fixtures, prefer Flutter built-ins (`Text`, `SizedBox`) over
custom design-system widgets unless the design system is what's under test.

**Test business logic off the widget tree.** Cubits/view models have no
`BuildContext`, so test them as plain Dart: construct, call, assert on
emitted states. Reserve widget tests for actual widget behavior.

## Documentation & logging

**Every `// ignore:` carries a justification:**

```dart
// Solid black required by brand guidelines — intentionally not theme-dependent
// ignore: avoid_hardcoded_colors
const color = Color(0xFF000000);
```

Without the reason, future maintainers can't tell an intentional exemption
from a forgotten hack.

**Log errors as structured parameters, never interpolation:**

```dart
// Avoid — error tracking tools see one opaque string
logger.warning('Failed to sync $error $stackTrace');

// Prefer — formatters and error trackers get structured data
logger.warning('Failed to sync', error, stackTrace);
```

## Linting

- Adopt a strict shared lint config — `package:leancode_lint` bundles rules
  like `use_padding`, `use_colored_box`, and
  `prefix_widgets_returning_slivers` that automate the widget guidance above.
- Custom analyzer plugin rules can encode project-specific patterns; prefer
  a lint over a code-review comment for anything that recurs.
- Set lints up at project start — retrofitting a strict config onto a mature
  codebase is drastically more expensive.
