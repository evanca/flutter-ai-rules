# Architecture Layers (MVVM)

Based on the official Flutter app architecture guide
(https://docs.flutter.dev/app-architecture/guide). This is the layer
blueprint: what each component is responsible for, what it must not do, and
how components relate. Folder placement of these pieces is covered in
`feature-structure.md`.

## The two mandatory layers

Separation of concerns is the foundational principle. Every app splits into:

1. **UI layer** — interaction with the user (views + view models)
2. **Data layer** — business data and logic (repositories + services)

A third **domain layer** (use cases) is optional — see below.

## Dependency flow

```
View → ViewModel → [Use Case (optional)] → Repository → Service
```

- Flow is strictly unidirectional. Lower layers never depend on upper layers.
- A service never imports a repository; a repository never imports a view
  model; nothing in the data layer knows Flutter widgets exist.
- **Repositories never depend on each other.** If two repositories need
  coordination, that logic belongs in a use case or view model above them.

| Relationship | Cardinality |
|---|---|
| View ↔ ViewModel | one-to-one (per feature) |
| ViewModel ↔ Repository | many-to-many |
| Repository ↔ Service | many-to-many |
| Repository ↔ Repository | none — never |

## UI layer

### Views

Widget classes that render UI. They display data given to them by the view
model and forward user gestures to view-model commands.

Allowed logic in a view — and *only* this:

- simple `if` statements to show/hide widgets based on flags
- animation logic
- layout logic (screen size, orientation, responsive breakpoints)
- simple routing logic

Anything that filters, sorts, aggregates, validates, or otherwise *decides
about data* is business logic and belongs in the view model. If you find
yourself writing a `.where(...)` or a date-formatting branch inside `build`,
move it.

### View models

Expose exactly the data a view needs, in presentation-ready form.

Responsibilities:

1. **Retrieve and transform** — pull domain models from repositories; filter,
   sort, aggregate into UI state.
2. **Maintain UI state** — selection flags, carousel position, form validity,
   loading/error status. State survives configuration changes because it
   lives here, not in the widget.
3. **Expose commands** — member functions (named after the Command pattern)
   that views call from gesture handlers. The view never talks to a
   repository directly.

View models are plain Dart: no `BuildContext`, no widget imports. That is
what makes them unit-testable without the rendering pipeline. (A Cubit, as
used in `feature-structure.md`, is a view model in this sense.)

Granularity tip from the official guide: a view/view-model pair doesn't have
to be a full screen. A `LoginView` + `LoginViewModel` is a screen; a
`LogoutButton` + `LogoutViewModel` is a reusable component that can appear in
many places. Give any sufficiently complex, reusable component its own pair.

## Data layer

### Repositories

The **single source of truth** for a type of model data.

Responsibilities:

- poll raw data from one or more services
- transform raw responses into **domain models** consumable by view models
- own the business logic around data: caching, error handling, retry logic,
  refresh logic

Repositories also manage app-wide session state that multiple features share:
the active user session, in-memory caches, transient settings. Multiple view
models depend on the same repository instance (via DI) and observe changes
reactively through exposed streams or methods.

### Services

The lowest layer. A service wraps one external data source and exposes async
objects — nothing more.

- **Stateless.** A service holds no state, ever. State belongs in
  repositories.
- One service class per data source: a REST API, a platform channel
  (iOS/Android API), local files, a database.
- If a "service" starts caching or retrying, it has become a repository —
  rename it or move that logic up.

## Optional domain layer: use cases / interactors

A use case sits between view models and repositories and abstracts complex
interaction logic.

Add a use case only when the logic meets **at least one** of:

1. it merges data from multiple repositories
2. it is exceedingly complex
3. it will be reused by several different view models

Trade-offs to weigh:

- Pros: removes duplication from view models, isolates complex logic for
  testing, keeps view models readable.
- Cons: more architectural complexity, more mocks in tests, more boilerplate.

**Add use cases incrementally** — when you notice duplication or complexity,
not preemptively for every data access. Most features never need one. When
present: use cases depend on repositories (many-to-many), and view models may
depend on both use cases and repositories directly.

## Why this pays off

- View-model logic is testable without widgets; services and repositories are
  testable in isolation.
- UI state survives configuration changes (rotation) because it lives outside
  the widget.
- Swapping a data source touches one service; swapping caching strategy
  touches one repository; the UI layer doesn't notice.

## Interaction with feature-based structure

LeanCode's feature-based approach (see `feature-structure.md`) starts leaner:
a Cubit may call a typed API client directly, and a repository is introduced
per-feature only when caching/offline demands it. That is compatible with
this guide — it's the "add layers when they pay for themselves" principle.
The invariants that must hold from day one are: no business logic in widgets,
no `BuildContext` in business logic, unidirectional dependencies.
