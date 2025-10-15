# Flutter App Architecture

### Architecture
1. Separate your features into a UI Layer (presentation), a Data Layer (business data and logic), and, for complex apps, consider adding a Domain (Logic) Layer between UI and Data layers to encapsulate business logic and use-cases.
2. You can organize code by feature: The classes needed for each feature are grouped together. For example, you might have an auth directory, which would contain files like auth_viewmodel.dart (or, depending on your state management approach: auth_controller.dart, auth_provider.dart, auth_bloc.dart), login_usecase.dart, logout_usecase.dart, login_screen.dart, logout_button.dart, etc. Alternatively, you can organize by type or use a hybrid approach.
3. Only allow communication between adjacent layers; the UI layer should not access the data layer directly, and vice versa.
4. Introduce a Logic (Domain) Layer only for complex business logic that does not fit cleanly in the UI or Data layers.
5. Clearly define the responsibilities, boundaries, and interfaces of each layer and component (Views, View Models, Repositories, Services).
6. Further divide each layer into components with specific responsibilities and well-defined interfaces.
7. In the UI Layer, use Views to describe how to present data to the user; keep logic minimal and only UI-related.
8. Pass events from Views to View Models in response to user interactions.
9. In View Models, contain logic to convert app data into UI state and maintain the current state needed by the view.
10. Expose callbacks (commands) from View Models to Views and retrieve/transform data from repositories.
11. In the Data Layer, use Repositories as the single source of truth (SSOT) for model data and to handle business logic such as caching, error handling, and refreshing data.
12. Only the SSOT class (usually the repository) should be able to mutate its data; all other classes should read from it.
13. Repositories should transform raw data from services into domain models and output data consumed by View Models.
14. Use Services to wrap API endpoints and expose asynchronous response objects; services should isolate data-loading and hold no state.
15. Use dependency injection to provide components with their dependencies, enabling testability and flexibility.

### Data Flow and State
1. Follow unidirectional data flow: state flows from the data layer through the logic layer to the UI layer, and events from user interaction flow in the opposite direction.
2. Data changes should always happen in the SSOT (data layer), not in the UI or logic layers.
3. The UI should always reflect the current (immutable) state; trigger UI rebuilds only in response to state changes.
4. Views should contain as little logic as possible and be driven by state from View Models.

### Use Cases / Interactors
1. Introduce use cases/interactors in the domain layer only when logic is complex, reused, or merges data from multiple repositories.
2. Use cases depend on repositories and may be used by multiple view models.
3. Add use cases only when needed; refactor to use use-cases exclusively if logic is repeatedly shared across view models.

### Extensibility and Testability
1. All architectural components should have well-defined inputs and outputs (interfaces).
2. Favor dependency injection to allow swapping implementations without changing consumers.
3. Test view models by mocking repositories; test UI logic independently of widgets.
4. Design components to be easily replaceable and independently testable.

### Best Practices
1. Strongly recommend following separation of concerns and layered architecture.
2. Strongly recommend using dependency injection for testability and flexibility.
3. Recommend using MVVM as the default pattern, but adapt as needed for your app's complexity.
4. Use key-value storage for simple data (e.g., configuration, preferences) and SQL storage for complex relationships.
5. Use optimistic updates to improve perceived responsiveness by updating the UI before operations complete.
6. Support offline-first strategies by combining local and remote data sources in repositories and enabling synchronization as appropriate.
7. Keep views focused on presentation and extract reusable widgets into separate components.
8. Use `StatelessWidget` when possible and avoid unnecessary `StatefulWidget`s.
9. Keep build methods simple and focused on rendering.
10. Choose state management approaches appropriate to the complexity of your app.
11. Keep state as local as possible to minimize rebuilds and complexity.
12. Use `const` constructors when possible to improve performance.
13. Avoid expensive operations in build methods and implement pagination for large lists.
14. Keep files focused on a single responsibility and limit file length for readability.
15. Group related functionality together and use `final` for fields and top-level variables when possible.
16. Prefer making declarations private and consider making constructors `const` if the class supports it.
17. Follow Dart naming conventions and format code using `dart format`.
18. Use curly braces for all flow control statements to ensure clarity and prevent bugs.
19. Prefer explicit typing and generics on public APIs (for example, prefer typed command signatures such as `Command0<void>` rather than untyped/dynamic signatures) to improve clarity and type safety.
20. For small immutable domain or data models, prefer using `abstract class` with `const` constructors and `final` fields where it improves readability and enforces immutability.
21. Use descriptive constant names for resources and table identifiers (for example prefer `_todoTableName` over compact prefixes like `_kTableTodo`) to improve clarity across examples and migrations.

