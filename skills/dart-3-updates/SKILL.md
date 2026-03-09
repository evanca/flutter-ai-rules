---
name: dart-3-updates
description: Applies Dart 3 language features in Flutter/Dart code. Use when writing if-else or switch statements, creating new classes, or deciding between a data class and a record.
---

# Dart 3 Updates Skill

This skill defines how to correctly use Dart 3 language features: branches, patterns, pattern types, and records.

---

## 1. Branches

### if / if-case

```dart
// Standard if
if (score >= 90) {
  grade = 'A';
} else if (score >= 80) {
  grade = 'B';
} else {
  grade = 'C';
}

// if-case: match and destructure against a single pattern
if (pair case [int x, int y]) {
  print('$x, $y');
}
```

- `if` conditions must evaluate to a `bool`.
- In `if-case`, variables declared in the pattern are scoped to the matching branch.
- If the pattern does not match, control flows to the `else` branch (if present).

### switch statements

```dart
switch (command) {
  case 'quit':
    quit();
  case 'start' || 'begin': // logical-or pattern
    startGame();
  default:
    print('Unknown command');
}
```

- Each matched `case` body executes and jumps to the end — `break` is **not required**.
- Non-empty cases can end with `continue`, `throw`, or `return`.
- Use `default` or `_` to handle unmatched values.
- Empty cases fall through; use `break` to prevent fallthrough in an empty case.
- Use `continue` with a label for non-sequential fallthrough.
- Use logical-or patterns (`case a || b`) to share a body between cases.

### switch expressions

```dart
final color = switch (shape) {
  Circle() => 'red',
  Square() => 'blue',
  _ => 'unknown',
};
```

- Omit `case`; use `=>` for bodies; separate cases with commas.
- Default must use `_` (not `default`).
- Produces a value.

### Exhaustiveness

- Dart checks exhaustiveness in `switch` statements and expressions at compile time.
- Use `default`/`_`, enums, or `sealed` types to satisfy exhaustiveness.

```dart
sealed class Shape {}
class Circle extends Shape {}
class Square extends Shape {}

// Dart knows all subtypes — no default needed:
String describe(Shape s) => switch (s) {
  Circle() => 'circle',
  Square() => 'square',
};
```

### Guard clauses

```dart
switch (point) {
  case (int x, int y) when x == y:
    print('Diagonal: $x');
  case (int x, int y):
    print('$x, $y');
}
```

- Add `when condition` after a pattern to further constrain matching.
- Usable in `if-case`, `switch` statements, and `switch` expressions.
- If the guard is `false`, execution proceeds to the next case.

---

## 2. Patterns

Patterns represent the **shape** of a value for matching and destructuring.

### Uses

```dart
// Variable declaration
var (a, [b, c]) = ('str', [1, 2]);

// Variable assignment (swap)
(b, a) = (a, b);

// for-in loop destructuring
for (final MapEntry(:key, :value) in map.entries) { ... }

// switch / if-case (see Branches section)
```

- Wildcard `_` ignores parts of a matched value.
- Rest elements (`...`) in list patterns ignore remaining elements.
- Case patterns are **refutable**: if no match, execution continues to the next case.
- Destructured values in a case become local variables scoped to that case body.

### Object patterns

```dart
var Foo(:one, :two) = myFoo;
```

### JSON / nested data validation

```dart
if (data case {'user': [String name, int age]}) {
  print('$name, $age');
}
```

---

## 3. Pattern Types

| Pattern | Syntax | Description |
|---|---|---|
| Logical-or | `p1 \|\| p2` | Matches if any branch matches. All branches must bind the same variables. |
| Logical-and | `p1 && p2` | Matches if both match. Variable names must not overlap. |
| Relational | `== c`, `< c`, `>= c` | Compares value to a constant. Combine with `&&` for ranges. |
| Cast | `subpattern as Type` | Asserts type, then matches inner pattern. Throws if type mismatch. |
| Null-check | `subpattern?` | Matches non-null; binds non-nullable type. |
| Null-assert | `subpattern!` | Matches non-null or throws. Use in declarations to eliminate nulls. |
| Constant | `42`, `'str'`, `const Foo()` | Matches if value equals the constant. |
| Variable | `var name`, `final Type name` | Binds matched value to a new variable. Typed form only matches the declared type. |
| Wildcard | `_`, `Type _` | Matches any value without binding. |
| Parenthesized | `(subpattern)` | Controls precedence. |
| List | `[p1, p2]` | Matches lists by position. Length must match unless a rest element is used. |
| Rest element | `...`, `...rest` | Matches arbitrary-length tails or collects remaining elements. |
| Map | `{'key': subpattern}` | Matches maps by key. Missing keys throw `StateError`. |
| Record | `(p1, p2)`, `(x: p1, y: p2)` | Matches records by shape; field names can be omitted if inferred. |
| Object | `ClassName(field: p)` | Matches by type and destructures via getters. Extra fields ignored. |

- Use parentheses to group lower-precedence patterns.
- All pattern types can be **nested and combined**.

---

## 4. Records

```dart
// Create
var record = ('first', a: 2, b: true, 'last');

// Type annotation
({int a, bool b}) namedRecord;

// Access
print(record.$1);   // positional: 'first'
print(record.a);    // named: 2
```

- Records are **anonymous, immutable, fixed-size** aggregates.
- Each field can have a different type (heterogeneous).
- Fields are accessed via built-in getters (`$1`, `$2`, `.name`); no setters.
- Two records are equal if they have the same shape and equal field values.
- `hashCode` and `==` are automatically defined.

### Multiple return values

```dart
(String name, int age) userInfo(Map<String, dynamic> json) {
  return (json['name'] as String, json['age'] as int);
}

var (name, age) = userInfo(json);
// Named fields:
final (:name, :age) = userInfo(json);
```

### Records vs. data classes

Use a **record** when:
- Returning multiple values from a single function (small, one-time use).
- Grouping a few values locally with no reuse across the codebase.
- You need structural equality with no additional behavior.

Use a **class** when:
- The type is reused across multiple files or features.
- You need methods, encapsulation, inheritance, or `copyWith`.
- The type is part of a public API or long-lived data model.
- Changing the shape must be caught by the type system across the codebase.

### Other best practices

- Use `typedef` for record types to improve readability and maintainability.
- Changing a record type alias does not guarantee type safety across the codebase — only classes provide full abstraction.

---
