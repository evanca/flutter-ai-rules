---
name: architecture-feature-first
description: "Structure Flutter apps using layered architecture (UI / Logic / Data) with feature-first file organization. Use when creating new features, designing the project folder structure, adding repositories, services, view models (or cubits/providers/notifiers), wiring dependency injection, or deciding which layer owns a piece of logic. State management agnostic."
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
* Refactoring an existing app from type-first to feature-first organization.

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

### Sample directory structure

```
lib/
├── app.dart
├── main.dart
├── core/                          # Shared utilities, theme, DI setup
│   ├── di/
│   │   └── service_locator.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── network/
│       └── api_client.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_repository.dart
│   │   │   └── auth_api_service.dart
│   │   ├── domain/                # Optional — only for complex logic
│   │   │   └── login_usecase.dart
│   │   └── ui/
│   │       ├── auth_viewmodel.dart
│   │       ├── login_screen.dart
│   │       └── widgets/
│   │           └── login_form.dart
│   └── profile/
│       ├── data/
│       │   ├── profile_repository.dart
│       │   └── profile_api_service.dart
│       └── ui/
│           ├── profile_viewmodel.dart
│           └── profile_screen.dart
└── shared/                        # Shared widgets, models, extensions
    ├── models/
    │   └── user.dart
    └── widgets/
        └── loading_indicator.dart
```

Each feature directory contains the files needed for that feature, named according to the chosen state management approach:

| Approach | Business logic holder file |
|---|---|
| MVVM / ChangeNotifier | `*_viewmodel.dart` / `*_controller.dart` |
| BLoC | `*_cubit.dart` / `*_bloc.dart` |
| Provider / Riverpod | `*_provider.dart` / `*_notifier.dart` |

---

## 3. Component Responsibilities

### View
- Describes how to present data to the user; keep logic minimal and only UI-related.
- Passes events to the business logic holder in response to user interactions.
- Extract reusable widgets into separate components within a `widgets/` subdirectory.
- Use `StatelessWidget` when possible; keep build methods simple.

### Business Logic Holder (ViewModel / Cubit / Controller / Provider)
- Contains logic to convert app data into UI state and maintains current state needed by the view.
- Exposes callbacks (commands) to the View and retrieves/transforms data from repositories.

```dart
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  AuthViewModel(this._authRepo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authRepo.login(email, password);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### Repository
- Single Source of Truth (SSOT) for a given type of model data.
- The only class allowed to mutate its data; all other classes read from it.
- Handles caching, error handling, and data refresh logic.
- Transforms raw data from services into domain models.

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
- Define abstract interfaces so implementations can be swapped without changing consumers.

```dart
// In service_locator.dart — register dependencies at startup
void setupDependencies() {
  final apiClient = ApiClient();

  // Services
  final authService = AuthApiService(apiClient);
  final profileService = ProfileApiService(apiClient);

  // Repositories
  final authRepo = AuthRepository(authService);
  final profileRepo = ProfileRepository(profileService);

  // Register with your DI framework (get_it, provider, riverpod, etc.)
  getIt.registerSingleton<AuthRepository>(authRepo);
  getIt.registerSingleton<ProfileRepository>(profileRepo);
}
```

---

## 6. Workflow: Add a New Feature

1. **Create the `features/<name>/` directory** with `data/`, `ui/`, and optionally `domain/` subdirectories.
2. **Implement the Service** — wrap the API endpoints in `data/<name>_api_service.dart`.
3. **Implement the Repository** — inject the Service, add caching/error handling in `data/<name>_repository.dart`.
4. **Implement the ViewModel** — inject the Repository, expose UI state and commands in `ui/<name>_viewmodel.dart`.
5. **Implement the View** — bind to the ViewModel, render state, dispatch events in `ui/<name>_screen.dart`.
6. **Register in DI** — add the new Service, Repository, and ViewModel to the service locator.
7. **Verify** — confirm the View never accesses the Service directly and data flows unidirectionally.

---

## References

- [Flutter app architecture guide](https://docs.flutter.dev/app-architecture/guide)
- [Architecture case study (Compass app)](https://docs.flutter.dev/app-architecture/case-study)
- [Architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations)
