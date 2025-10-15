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
5. Prefer lines 80 characters or fewer for readability.

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
13. Prefer specific exception handling: avoid generic `catch (e)` handlers when possible; use `on SomeException catch (e, _)` and `.onError<T>` (or specific `on` clauses) instead of broad `.catchError`/catch blocks.

### Documentation
1. Format comments like sentences.
2. Use `///` doc comments to document members and types; don't use block comments for documentation.
3. Prefer writing doc comments for public APIs.
4. Consider writing doc comments for private APIs.
5. Consider including explanations of terminology, links, and references in library-level docs.
6. Start doc comments with a single-sentence summary.
7. Separate the first sentence of a doc comment into its own paragraph.
8. Avoid redundancy with the surrounding context.
9. Prefer starting comments of a function or method with third-person verbs if its main purpose is a side effect.
10. Prefer a noun phrase or non-imperative verb phrase for a function or method if returning a value is its primary purpose.
11. Prefer starting non-boolean variable or property comments with a noun phrase.
12. Prefer starting boolean variable or property comments with "Whether" followed by a noun or gerund phrase.
13. Prefer starting library or type comments with noun phrases.
14. Use square brackets in doc comments to refer to in-scope identifiers.
15. Use prose to explain parameters, return values, and exceptions.
	- Consider using short sections such as "The [parameter]", "Returns", and "Throws" to make parameter and error documentation clearer.
16. Put doc comments before metadata annotations.
17. Document why code exists or how it should be used, not just what it does.

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

