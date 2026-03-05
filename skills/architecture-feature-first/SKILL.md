---
name: architecture-feature-first
description: Structures Flutter apps using layered architecture (UI / Logic / Data) with feature-first file organization. Use when creating new features, designing the project structure, adding repositories/services/view models (or cubits/providers/notifiers), or wiring dependency injection. State management agnostic.
---

# Flutter Architecture — Feature-First Skill

This skill defines how to design, structure, and implement Flutter applications using the recommended **layered architecture** with **feature-first** file organization.

It is **state management agnostic**: the business logic holder in the UI layer may be named ViewModel, Controller, Cubit, Bloc, Provider, or Notifier — depending on the chosen state management approach. The architectural rules apply equally to all of them.

## When to Use

Use this skill when:

* Designing the folder/file structure of a new Flutter app or feature.
* Creating a new View, ViewModel, Repository, or Service.
* Deciding which layer owns a piece of logic.
* Wiring dependency injection between components.
* Adding a domain (logic) layer for complex business logic.

Do not use this skill for:

* Choosing a state management package (bloc, riverpod, etc.). The pattern applies regardless of state management.
* Firebase, navigation, or platform plugin specifics.

---

## 1. Layers

Separate every app into a **UI Layer** and a **Data Layer**. Add a **Logic (Domain) Layer** between them only for complex apps.

```
┌──────────────────────────────────────────────────────────────┐
│   UI Layer    │  Views + business logic holders              │
│               │  (ViewModel / Cubit / Controller / Provider) │
├──────────────────────────────────────────────────────────────┤
│  Logic Layer  │  Use Cases / Interactors  (optional)         │
├──────────────────────────────────────────────────────────────┤
│   Data Layer  │  Repositories + Services                     │
└──────────────────────────────────────────────────────────────┘
```

**Rules:**
- Only adjacent layers may communicate. The UI layer must never access a Service directly.
- The Logic layer is added **only** when business logic is too complex for the business logic holder or is reused across multiple screens.
- Data changes always happen in the Data layer (SSOT = Repository). No mutation in UI or Logic layers.
- Follow unidirectional data flow: state flows **down** (Data → UI), events flow **up** (UI → Data).

---

## 2. Feature-First File Structure

Organize code by **feature**, not by type. Group all layers belonging to one feature together in a single directory.

Each feature directory contains the files needed for that feature, named according to the chosen state management approach:

| Approach | Business logic holder file |
|---|---|
| MVVM / ChangeNotifier | `*_viewmodel.dart` / `*_controller.dart` |
| BLoC | `*_cubit.dart` / `*_bloc.dart` |
| Provider / Riverpod | `*_provider.dart` / `*_notifier.dart` |

Example: an `auth` feature would have files like `auth_viewmodel.dart` (or `auth_cubit.dart`, `auth_provider.dart` depending on approach), `login_screen.dart`, and optionally `login_usecase.dart`.

---

## 3. Component Responsibilities

### View
- Describes how to present data to the user; keep logic minimal and only UI-related.
- Passes events to the business logic holder in response to user interactions.
- Keep views focused on presentation; extract reusable widgets into separate components.
- Use `StatelessWidget` when possible; keep build methods simple.

### Business Logic Holder (ViewModel / Cubit / Controller / Provider)
- Contains logic to convert app data into UI state and maintains current state needed by the view.
- Exposes callbacks (commands) to the View and retrieves/transforms data from repositories.
- Business logic must not live in UI widgets; only interact with repositories via the business logic holder.

### Repository
- Single Source of Truth (SSOT) for a given type of model data.
- The only class allowed to mutate its data; all other classes read from it.
- Handles business logic such as caching, error handling, and refreshing data.
- Transforms raw data from services into domain models consumed by business logic holders.

### Service
- Wraps API endpoints and exposes asynchronous response objects.
- Isolates data-loading and holds no state.

---

## 4. Domain Layer (Use Cases)

Introduce use cases/interactors **only** when:
- Logic is complex or does not fit cleanly in the UI or Data layers.
- Logic is reused across multiple business logic holders or merges data from multiple repositories.

Do not add a domain layer for simple CRUD apps.

---

## 5. Dependency Injection

Use dependency injection to provide components with their dependencies, enabling testability and flexibility.

- Supply repositories to business logic holders via constructors.
- Supply services to repositories via constructors.
- Design all components with well-defined interfaces so implementations can be swapped without changing consumers.

---

## References

- [Flutter app architecture guide](https://docs.flutter.dev/app-architecture/guide)
- [Architecture case study (Compass app)](https://docs.flutter.dev/app-architecture/case-study)
- [Architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations)
