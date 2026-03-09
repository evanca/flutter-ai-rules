---
name: effective-dart
description: Applies Effective Dart guidelines in Flutter/Dart code. Use when writing or reviewing Dart code for naming conventions, types, style, imports, file structure, usage patterns, documentation, testing, widgets, state management, or performance.
---

# Effective Dart Skill

This skill defines how to write idiomatic, high-quality Dart and Flutter code following Effective Dart guidelines.

---

## 1. Naming Conventions

| Kind | Convention | Example |
|---|---|---|
| Classes, enums, typedefs, type parameters, extensions | `UpperCamelCase` | `MyWidget`, `UserState` |
| Packages, directories, source files | `lowercase_with_underscores` | `user_profile.dart` |
| Import prefixes | `lowercase_with_underscores` | `import '...' as my_prefix;` |
| Variables, parameters, named parameters, functions | `lowerCamelCase` | `userName`, `fetchData()` |

- Capitalize acronyms and abbreviations longer than two letters like words: `HttpRequest`, not `HTTPRequest`.
- Avoid abbreviations unless the abbreviation is more common than the full term.
- Prefer putting the **most descriptive noun last** in names.
- Use terms **consistently** throughout your code.
- Follow mnemonic conventions for type parameters: `E` (element), `K`/`V` (key/value), `T`/`S`/`U` (generic types).
- Consider making code **read like a sentence** when designing APIs.
- Prefer a **noun phrase** for non-boolean properties or variables.
- Prefer a **non-imperative verb phrase** for boolean properties or variables; prefer the positive form.
- Consider omitting the verb for named boolean parameters.

---

## 2. Types and Functions

- Use **class modifiers** to control if a class can be extended or used as an interface.
- **Type annotate variables** without initializers.
- Type annotate **fields and top-level variables** if the type isn't obvious.
- **Annotate return types** on function declarations.
- **Annotate parameter types** on function declarations.
- Write **type arguments** on generic invocations that aren't inferred.
- Annotate with `dynamic` instead of letting inference fail.
- Use `Future<void>` as the return type of async members that do not produce values.
- Use **getters** for operations that conceptually access properties.
- Use **setters** for operations that conceptually change properties.
- Use a **function declaration** to bind a function to a name.
- Use **inclusive start and exclusive end** parameters to accept a range.

---

## 3. Style

```bash
dart format .
```

- Format code with `dart format` — don't manually format.
- Use **curly braces** for all flow control statements.
- Prefer `final` over `var` when variable values won't change.
- Use `const` for compile-time constants.
- Prefer lines **80 characters or fewer** for readability.

---

## 4. Imports and Files

- Don't import libraries inside the `src` directory of another package.
- Don't allow import paths to reach into or out of `lib`.
- **Prefer relative import paths** within a package.
- Don't use `/lib/` or `../` in import paths.
- Consider writing a **library-level doc comment** for library files.

---

## 5. Structure

- Keep files **focused on a single responsibility**.
- Limit file length to maintain readability.
- Group related functionality together.
- Prefer making fields and top-level variables `final`.
- Consider making constructors `const` if the class supports it.
- **Prefer making declarations private** — only expose what's necessary.

---

## 6. Usage

```dart
// Adjacent string concatenation (not +)
final greeting = 'Hello, '
    'world!';

// Collection literals
final list = [1, 2, 3];
final map = {'key': 'value'};

// Initializing formals
class Point {
  final double x, y;
  Point(this.x, this.y);
}

// Empty constructor body
class Empty {
  Empty();  // not Empty() {}
}

// rethrow
try {
  doSomething();
} catch (e) {
  log(e);
  rethrow;
}
```

- Use `whereType()` to filter a collection by type.
- Follow a **consistent rule** for `var` and `final` on local variables.
- Initialize fields at their **declaration** when possible.
- Override `hashCode` if you override `==`; ensure `==` obeys mathematical equality rules.
- **Prefer specific exception handling**: use `on SomeException catch (e)` instead of broad `catch (e)` or `.catchError` handlers.

---

## 7. Documentation

```dart
/// Returns the sum of [a] and [b].
///
/// Throws [ArgumentError] if either value is negative.
int add(int a, int b) { ... }
```

- Format comments like sentences (capitalize, end with period).
- Use `///` doc comments — not `/* */` block comments — for types and members.
- Prefer writing doc comments for **public APIs**; consider them for private APIs too.
- Start doc comments with a **single-sentence summary**, separated into its own paragraph.
- Avoid redundancy with the surrounding context.
- Start function/method comments with a **third-person verb** if the main purpose is a side effect.
- Start with a **noun or non-imperative verb phrase** if returning a value is the primary purpose.
- Start **boolean** variable/property comments with "Whether followed by a noun or gerund phrase.
- Use `[identifier]` in doc comments to refer to in-scope identifiers.
- Use **prose** to explain parameters, return values, and exceptions (e.g., "The [param]", "Returns", "Throws" sections).
- Put doc comments **before** metadata annotations.
- Document **why** code exists or how it should be used, not just what it does.
- When referring to the current object, prefer "this box" over bare "this".

---

## 8. Testing

- Write **unit tests** for business logic.
- Write **widget tests** for UI components.
- Aim for **good test coverage**.

---

## 9. Widgets

- Extract reusable widgets into **separate components**.
- Use `StatelessWidget` when possible.
- Keep **build methods simple and focused**.

---

## 10. State Management

- Choose appropriate state management based on **complexity**.
- Avoid unnecessary `StatefulWidget`s.
- Keep **state as local as possible**.

---

## 11. Performance

- Use `const` constructors when possible.
- Avoid **expensive operations** in build methods.
- Implement **pagination** for large lists.

---

## References

- [Dart Site WWW GitHub Repository](https://github.com/dart-lang/site-www)
