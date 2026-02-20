# Effective Dart Rules

### Naming Conventions
1. Use terms consistently throughout your code.
2. Follow existing mnemonic conventions when naming type parameters (e.g., `E` for element, `K`/`V` for key/value, `T`/`S`/`U` for generic types).
3. Name types using `UpperCamelCase` (classes, enums, typedefs, type parameters).
4. Name extensions using `UpperCamelCase`.
5. Name packages, directories, and source files using `lowercase_with_underscores`.
6. Name import prefixes using `lowercase_with_underscores`.
7. Name other identifiers using `lowerCamelCase` (variables, parameters, named parameters).
8. Capitalize acronyms and abbreviations longer than two letters like words.
9. Avoid abbreviations unless the abbreviation is more common than the unabbreviated term.
10. Prefer putting the most descriptive noun last in names.
11. Consider making code read like a sentence when designing APIs.
12. Prefer a noun phrase for non-boolean properties or variables.
13. Prefer a non-imperative verb phrase for boolean properties or variables.
14. Prefer the positive form for boolean property and variable names.
15. Consider omitting the verb for named boolean parameters.
16. Use camelCase for variable and function names.
17. Use PascalCase for class names.
18. Use snake_case for file names.

### Types and Functions
1. Use class modifiers to control if your class can be extended or used as an interface.
2. Type annotate variables without initializers.
3. Type annotate fields and top-level variables if the type isn't obvious.
4. Annotate return types on function declarations.
5. Annotate parameter types on function declarations.
6. Write type arguments on generic invocations that aren't inferred.
7. Annotate with `dynamic` instead of letting inference fail.
8. Use `Future<void>` as the return type of asynchronous members that do not produce values.
9. Use getters for operations that conceptually access properties.
10. Use setters for operations that conceptually change properties.
11. Use a function declaration to bind a function to a name.
12. Use inclusive start and exclusive end parameters to accept a range.

### Style
1. Format your code using `dart format`.
2. Use curly braces for all flow control statements.
3. Prefer `final` over `var` when variable values won't change.
4. Use `const` for compile-time constants.

### Imports & Files
1. Don't import libraries inside the `src` directory of another package.
2. Don't allow import paths to reach into or out of `lib`.
3. Prefer relative import paths within a package.
4. Don't use `/lib/` or `../` in import paths.
5. Consider writing a library-level doc comment for library files.

### Structure
1. Keep files focused on a single responsibility.
2. Limit file length to maintain readability.
3. Group related functionality together.
4. Prefer making fields and top-level variables `final`.
5. Consider making your constructor `const` if the class supports it.
6. Prefer making declarations private.

### Usage
1. Use strings in `part of` directives.
2. Use adjacent strings to concatenate string literals.
3. Use collection literals when possible.
4. Use `whereType()` to filter a collection by type.
5. Test for `Future<T>` when disambiguating a `FutureOr<T>` whose type argument could be `Object`.
6. Follow a consistent rule for `var` and `final` on local variables.
7. Initialize fields at their declaration when possible.
8. Use initializing formals when possible.
9. Use `;` instead of `{}` for empty constructor bodies.
10. Use `rethrow` to rethrow a caught exception.
11. Override `hashCode` if you override `==`.
12. Make your `==` operator obey the mathematical rules of equality.

### Documentation
1. Format comments like sentences.
2. Use `///` doc comments to document members and types; don't use block comments for documentation.
3. Prefer writing doc comments for public APIs.
4. Consider writing doc comments for private APIs.
5. Consider including explanations of terminology, links, and references in library-level docs.
6. Start doc comments with a single-sentence summary.
7. Separate the first sentence of a doc comment into its own paragraph.
8. Use square brackets in doc comments to refer to in-scope identifiers.
9. Use prose to explain parameters, return values, and exceptions.
10. Put doc comments before metadata annotations.
11. Document why code exists or how it should be used, not just what it does.

### Testing
1. Write unit tests for business logic.
2. Write widget tests for UI components.
3. Aim for good test coverage.

### Widgets
1. Extract reusable widgets into separate components.
2. Use `StatelessWidget` when possible.
3. Keep build methods simple and focused.

### State Management
1. Choose appropriate state management based on complexity.
2. Avoid unnecessary `StatefulWidget`s.
3. Keep state as local as possible.

### Performance
1. Use `const` constructors when possible.
2. Avoid expensive operations in build methods.
3. Implement pagination for large lists.

# Dart 3 Updates

### Branches
1. Use `if` statements for conditional branching. The condition must evaluate to a boolean.
2. `if` statements support optional `else` and `else if` clauses for multiple branches.
3. Use `if-case` statements to match and destructure a value against a single pattern. Example: `if (pair case [int x, int y]) { ... }`
4. If the pattern in an `if-case` matches, variables defined in the pattern are in scope for that branch.
5. If the pattern does not match in an `if-case`, control flows to the `else` branch if present.
6. Use `switch` statements to match a value against multiple patterns (cases). Each `case` can use any kind of pattern.
7. When a value matches a `case` pattern in a `switch` statement, the case body executes and control jumps to the end of the switch. `break` is not required.
8. You can end a non-empty `case` clause with `continue`, `throw`, or `return`.
9. Use `default` or `_` in a `switch` statement to handle unmatched values.
10. Empty `case` clauses fall through to the next case. Use `break` to prevent fallthrough.
11. Use `continue` with a label for non-sequential fallthrough between cases.
12. Use logical-or patterns (e.g., `case a || b`) to share a body or guard between cases.
13. Use `switch` expressions to produce a value based on matching cases. Syntax differs from statements: omit `case`, use `=>` for bodies, and separate cases with commas.
14. In `switch` expressions, the default case must use `_` (not `default`).
15. Dart checks for exhaustiveness in `switch` statements and expressions, reporting a compile-time error if not all possible values are handled.
16. To ensure exhaustiveness, use a default (`default` or `_`) case, or switch over enums or sealed types.
17. Use the `sealed` modifier on a class to enable exhaustiveness checking when switching over its subtypes.
18. Add a guard clause to a `case` using `when` to further constrain when a case matches. Example: `case pattern when condition:`
19. Guard clauses can be used in `if-case`, `switch` statements, and `switch` expressions. The guard is evaluated after pattern matching.
20. If a guard clause evaluates to false, execution proceeds to the next case (does not exit the switch).

### Patterns
1. Patterns are a syntactic category that represent the shape of values for matching and destructuring.
2. Pattern matching checks if a value has a certain shape, constant, equality, or type.
3. Pattern destructuring allows extracting parts of a matched value and binding them to variables.
4. Patterns can be nested, using subpatterns (outer/inner patterns) for recursive matching and destructuring.
5. Use wildcard patterns (`_`) to ignore parts of a matched value; use rest elements in list patterns to ignore remaining elements.
6. Patterns can be used in:
   - Local variable declarations and assignments
   - For and for-in loops
   - If-case and switch-case statements
   - Control flow in collection literals
7. Pattern variable declarations start with `var` or `final` and bind new variables from the matched value. Example: `var (a, [b, c]) = ('str', [1, 2]);`
8. Pattern variable assignments destructure a value and assign to existing variables. Example: `(b, a) = (a, b); // swap values`
9. Every case clause in `switch` and `if-case` contains a pattern. Any kind of pattern can be used in a case.
10. Case patterns are refutable; if the pattern doesn't match, execution continues to the next case.
11. Destructured values in a case become local variables scoped to the case body.
12. Use logical-or patterns (e.g., `case a || b`) to match multiple alternatives in a single case.
13. Use logical-or patterns with guards (`when`) to share a body or guard between cases.
14. Guard clauses (`when`) evaluate a condition after matching; if false, execution proceeds to the next case.
15. Patterns can be used in for and for-in loops to destructure collection elements (e.g., destructuring `MapEntry` in map iteration).
16. Object patterns match named object types and destructure their data using getters. Example: `var Foo(:one, :two) = myFoo;`
8. Constant patterns match if the value is equal to a constant (number, string, bool, named constant, const constructor, const collection, etc.). Use parentheses and `const` for complex expressions.
9. Variable patterns (`var name`, `final Type name`) bind new variables to matched/destructured values. Typed variable patterns only match if the value has the declared type.
10. Identifier patterns (`foo`, `_`) act as variable or constant patterns depending on context. `_` always acts as a wildcard and matches/discards any value.
11. Parenthesized patterns (`(subpattern)`) control pattern precedence and grouping, similar to expressions.
12. List patterns (`[subpattern1, subpattern2]`) match lists and destructure elements by position. The pattern length must match the list unless a rest element is used.
13. Rest elements (`...`, `...rest`) in list patterns match arbitrary-length lists or collect unmatched elements into a new list.
14. Map patterns (`{"key": subpattern}`) match maps and destructure by key. Only specified keys are matched; missing keys throw a `StateError`.
15. Record patterns (`(subpattern1, subpattern2)`, `(x: subpattern1, y: subpattern2)`) match records by shape and destructure positional/named fields. Field names can be omitted if inferred from variable or identifier patterns.
16. Object patterns (`ClassName(field1: subpattern1, field2: subpattern2)`) match objects by type and destructure using getters. Extra fields in the object are ignored.
17. Wildcard patterns (`_`, `Type _`) match any value without binding. Useful for ignoring values or type-checking without binding.
18. All pattern types can be nested and combined for expressive and precise matching and destructuring.

### Records
1. Records are anonymous, immutable, aggregate types that bundle multiple objects into a single value.
2. Records are fixed-sized, heterogeneous, and strongly typed. Each field can have a different type.
3. Records are real values: store them in variables, nest them, pass to/from functions, and use in lists, maps, and sets.
4. Record expressions use parentheses with comma-delimited positional and/or named fields, e.g. `('first', a: 2, b: true, 'last')`.
5. Record type annotations use parentheses with comma-delimited types. Named fields use curly braces: `({int a, bool b})`.
6. The names of named fields are part of the record's type (shape). Records with different named field names have different types.
7. Positional field names in type annotations are for documentation only and do not affect the record's type.
8. Record fields are accessed via built-in getters: positional fields as `$1`, `$2`, etc., and named fields by their name (e.g., `.a`).
9. Records are immutable: fields do not have setters.
10. Records are structurally typed: the set, types, and names of fields define the record's type (shape).
11. Two records are equal if they have the same shape and all corresponding field values are equal. Named field order does not affect equality.
12. Records automatically define `hashCode` and `==` based on structure and field values.
13. Use records for functions that return multiple values; destructure with pattern matching: `var (name, age) = userInfo(json);`
14. Destructure named fields with the colon syntax: `final (:name, :age) = userInfo(json);`
15. Using records for multiple returns is more concise and type-safe than using classes, lists, or maps.
16. Use lists of records for simple data tuples with the same shape.
17. Use type aliases (`typedef`) for record types to improve readability and maintainability.
18. Changing a record type alias does not guarantee all code using it is still type-safe; only classes provide full abstraction/encapsulation.
19. Extension types can wrap records but do not provide full abstraction or protection.
20. Records are best for simple, immutable data aggregation; use classes for abstraction, encapsulation, and behavior.

# Common Flutter Errors

1. If you get a "RenderFlex overflowed" error, check if a `Row` or `Column` contains unconstrained widgets. Fix by wrapping children in `Flexible`, `Expanded`, or by setting constraints.
2. If you get "Vertical viewport was given unbounded height", ensure `ListView` or similar scrollable widgets inside a `Column` have a bounded height (e.g., wrap with `Expanded` or `SizedBox`).
3. If you get "An InputDecorator...cannot have an unbounded width", constrain the width of widgets like `TextField` using `Expanded`, `SizedBox`, or by placing them in a parent with width constraints.
4. If you get a "setState called during build" error, do not call `setState` or `showDialog` directly inside the build method. Trigger dialogs or state changes in response to user actions or after the build completes (e.g., using `addPostFrameCallback`).
5. If you get "The ScrollController is attached to multiple scroll views", make sure each `ScrollController` is only attached to a single scrollable widget at a time.
6. If you get a "RenderBox was not laid out" error, check for missing or unbounded constraints in your widget tree. This is often caused by using widgets like `ListView` or `Column` without proper size constraints.
7. Use the Flutter Inspector and review widget constraints to debug layout issues. Refer to the official documentation on constraints if needed.
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


