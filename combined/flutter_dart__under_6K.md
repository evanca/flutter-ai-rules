# Effective Dart Rules

### Naming Conventions
1. Use terms consistently throughout your code.
2. Name types using `UpperCamelCase` (classes, enums, typedefs, type parameters).
3. Name extensions using `UpperCamelCase`.
4. Name packages, directories, and source files using `lowercase_with_underscores`.
5. Name import prefixes using `lowercase_with_underscores`.
6. Name other identifiers using `lowerCamelCase` (variables, parameters, named parameters).
7. Capitalize acronyms and abbreviations longer than two letters like words.
8. Avoid abbreviations unless the abbreviation is more common than the unabbreviated term.
9. Prefer putting the most descriptive noun last in names.
10. Prefer a noun phrase for non-boolean properties or variables.
11. Avoid starting a function or method name with `get`; prefer removing `get` and using a getter when the API conceptually exposes a property.

### Types and Functions
1. Use class modifiers to control if your class can be extended or used as an interface.
2. Type annotate fields and top-level variables if the type isn't obvious.
3. Annotate return types on function declarations.
4. Annotate parameter types on function declarations.
5. Use `Future<void>` as the return type of asynchronous members that do not produce values.
6. Use getters for operations that conceptually access properties.
7. Use setters for operations that conceptually change properties.
8. Use inclusive start and exclusive end parameters to accept a range.

### Style and Structure
1. Prefer `final` over `var` when variable values won't change.
2. Use `const` for compile-time constants.
3. Keep files focused on a single responsibility.
4. Limit file length to maintain readability.
5. Group related functionality together.
6. Prefer making declarations private.

### Imports & Files
1. Don't import libraries inside the `src` directory of another package.
2. Prefer relative import paths within a package.
3. Don't use `/lib/` or `../` in import paths.
4. Consider writing a library-level doc comment for library files.

### Usage
1. Use strings in `part of` directives.
2. Use adjacent strings to concatenate string literals.
3. Use collection literals when possible.
4. Use `whereType()` to filter a collection by type.
5. Test for `Future<T>` when disambiguating a `FutureOr<T>` whose type argument could be `Object`.
6. Initialize fields at their declaration when possible.
7. Use initializing formals when possible.
8. Use `;` instead of `{}` for empty constructor bodies.
9. Use `rethrow` to rethrow a caught exception.
10. Override `hashCode` if you override `==`.
11. Make your `==` operator obey the mathematical rules of equality.

### Documentation
1. Use `///` doc comments to document members and types; don't use block comments for documentation.
2. Prefer writing doc comments for public APIs.
3. Start doc comments with a single-sentence summary.
4. Use square brackets in doc comments to refer to in-scope identifiers.

### Flutter Best Practices
1. Extract reusable widgets into separate components.
2. Use `StatelessWidget` when possible.
3. Keep build methods simple and focused.
4. Avoid unnecessary `StatefulWidget`s.
5. Keep state as local as possible.
6. Use `const` constructors when possible.
7. Avoid expensive operations in build methods.
8. Implement pagination for large lists.

### Dart 3: Records
1. Records are anonymous, immutable, aggregate types that bundle multiple objects into a single value.
2. Records are fixed-sized, heterogeneous, and strongly typed. Each field can have a different type.
3. Record expressions use parentheses with comma-delimited positional and/or named fields, e.g. `('first', a: 2, b: true, 'last')`.
4. Record fields are accessed via built-in getters: positional fields as `$1`, `$2`, etc., and named fields by their name (e.g., `.a`).
5. Records are immutable: fields do not have setters.
6. Use records for functions that return multiple values; destructure with pattern matching: `var (name, age) = userInfo(json);`
7. Use type aliases (`typedef`) for record types to improve readability and maintainability.
8. Records are best for simple, immutable data aggregation; use classes for abstraction, encapsulation, and behavior.

### Dart 3: Patterns
1. Patterns represent the shape of values for matching and destructuring.
2. Pattern matching checks if a value has a certain shape, constant, equality, or type.
3. Pattern destructuring allows extracting parts of a matched value and binding them to variables.
4. Use wildcard patterns (`_`) to ignore parts of a matched value.
5. Use rest elements (`...`, `...rest`) in list patterns to match arbitrary-length lists.
6. Use logical-or patterns (e.g., `case a || b`) to match multiple alternatives in a single case.
7. Add guard clauses (`when`) to further constrain when a case matches.
8. Use the `sealed` modifier on a class to enable exhaustiveness checking when switching over its subtypes.

### Common Flutter Errors
1. If you get a "RenderFlex overflowed" error, check if a `Row` or `Column` contains unconstrained widgets. Fix by wrapping children in `Flexible`, `Expanded`, or by setting constraints.
2. If you get "Vertical viewport was given unbounded height", ensure `ListView` or similar scrollable widgets inside a `Column` have a bounded height.
3. If you get "An InputDecorator...cannot have an unbounded width", constrain the width of widgets like `TextField`.
4. If you get a "setState called during build" error, do not call `setState` or `showDialog` directly inside the build method.
5. If you get "The ScrollController is attached to multiple scroll views", make sure each `ScrollController` is only attached to a single scrollable widget.
6. If you get a "RenderBox was not laid out" error, check for missing or unbounded constraints in your widget tree.
7. Use the Flutter Inspector and review widget constraints to debug layout issues.

### Testing
1. Write unit tests for business logic.
2. Write widget tests for UI components.