---
name: flutter-app-architecture
description: "Implement layered Flutter app architecture with MVVM, repositories, services, and dependency injection. Use when scaffolding a new Flutter project, refactoring an existing app into layers, creating view models and repositories, configuring dependency injection, implementing unidirectional data flow, or adding a domain layer for complex business logic."
---

# Flutter App Architecture Skill

This skill defines how to structure Flutter applications using layered architecture, proper data flow, and MVVM patterns for maintainability and testability.

## When to Use

Use this skill when:

* Scaffolding a new Flutter project with layered architecture.
* Creating or refactoring View Models, Repositories, or Services.
* Wiring dependency injection between architectural components.
* Implementing unidirectional data flow across layers.
* Adding a Domain (Logic) Layer for complex business logic or shared use cases.

---

## 1. Layer Structure

Separate every app into a **UI Layer** and a **Data Layer**. Add a **Logic (Domain) Layer** only for complex apps.

```
┌──────────────────────────────────────────────────────────────┐
│   UI Layer    │  Views + ViewModels                           │
├──────────────────────────────────────────────────────────────┤
│  Logic Layer  │  Use Cases / Interactors  (optional)         │
├──────────────────────────────────────────────────────────────┤
│   Data Layer  │  Repositories + Services                     │
└──────────────────────────────────────────────────────────────┘
```

**Rules:**
- Only adjacent layers may communicate. The UI layer must never access a Service directly.
- Data changes always happen in the Data layer (SSOT = Repository). No mutation in UI or Logic layers.
- Follow unidirectional data flow: state flows **down** (Data → UI), events flow **up** (UI → Data).

---

## 2. Component Responsibilities

### View
- Describes how to present data; keep logic minimal and UI-related only.
- Passes events to the ViewModel in response to user interactions.

### ViewModel
- Converts app data into UI state and maintains the current state needed by the View.
- Exposes callbacks (commands) to the View and retrieves/transforms data from Repositories.

```dart
class BookingViewModel extends ChangeNotifier {
  final BookingRepository _repo;

  BookingViewModel(this._repo);

  List<Booking> _bookings = [];
  List<Booking> get bookings => List.unmodifiable(_bookings);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadBookings() async {
    _isLoading = true;
    notifyListeners();

    _bookings = await _repo.getBookings();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancelBooking(String id) async {
    await _repo.cancelBooking(id);
    _bookings = await _repo.getBookings();
    notifyListeners();
  }
}
```

### Repository (Single Source of Truth)
- The only class that may mutate its data; all other classes read from it.
- Handles caching, error handling, and data refresh logic.
- Transforms raw data from Services into domain models.

```dart
class BookingRepository {
  final BookingApiService _apiService;
  final BookingLocalService _localService;

  BookingRepository(this._apiService, this._localService);

  Future<List<Booking>> getBookings() async {
    try {
      final remote = await _apiService.fetchBookings();
      await _localService.cacheBookings(remote);
      return remote;
    } catch (_) {
      return _localService.getCachedBookings();
    }
  }

  Future<void> cancelBooking(String id) async {
    await _apiService.cancelBooking(id);
    await _localService.removeCachedBooking(id);
  }
}
```

### Service
- Wraps API endpoints and exposes asynchronous response objects.
- Isolates data-loading and holds no state.

```dart
class BookingApiService {
  final http.Client _client;
  BookingApiService(this._client);

  Future<List<Booking>> fetchBookings() async {
    final response = await _client.get(Uri.parse('/api/bookings'));
    if (response.statusCode != 200) {
      throw HttpException('Failed to load bookings');
    }
    final data = jsonDecode(response.body) as List;
    return data.map((json) => Booking.fromJson(json)).toList();
  }
}
```

---

## 3. Dependency Injection

Supply dependencies via constructors. Define abstract interfaces so implementations can be swapped for testing.

```dart
// Abstract interface for the repository
abstract class BookingRepository {
  Future<List<Booking>> getBookings();
  Future<void> cancelBooking(String id);
}

// Concrete implementation
class BookingRepositoryImpl implements BookingRepository {
  final BookingApiService _api;
  BookingRepositoryImpl(this._api);

  @override
  Future<List<Booking>> getBookings() => _api.fetchBookings();

  @override
  Future<void> cancelBooking(String id) => _api.cancelBooking(id);
}
```

---

## 4. Use Cases (Domain Layer)

Introduce use cases only when:
- Logic is complex or does not fit cleanly in the UI or Data layers.
- Logic is reused across multiple ViewModels or merges data from multiple Repositories.

```dart
class GetUpcomingBookingsUseCase {
  final BookingRepository _bookingRepo;
  final UserRepository _userRepo;

  GetUpcomingBookingsUseCase(this._bookingRepo, this._userRepo);

  Future<List<Booking>> call() async {
    final user = await _userRepo.getCurrentUser();
    final bookings = await _bookingRepo.getBookings();
    return bookings
        .where((b) => b.userId == user.id && b.date.isAfter(DateTime.now()))
        .toList();
  }
}
```

---

## 5. Workflow: Scaffold a New Feature

1. **Create the Service** — implement the API wrapper with typed response parsing.
2. **Create the Repository** — inject the Service, implement caching and error-handling logic.
3. **Create the ViewModel** — inject the Repository, expose UI state and commands.
4. **Create the View** — bind to the ViewModel, render state, dispatch events.
5. **Wire DI** — register all components in the dependency injection container.
6. **Verify** — confirm the View never accesses the Service directly and data flows unidirectionally.

---

## 6. Data Storage

- Use **key-value storage** (e.g., `shared_preferences`) for configuration and preferences.
- Use **SQL storage** (e.g., `drift`, `sqflite`) for complex relational data.
- Implement **optimistic updates** to improve perceived responsiveness by updating UI before server confirms.
- Support **offline-first** by combining local and remote data sources in Repositories.

---

## 7. Coding Conventions

- Use `StatelessWidget` when possible; avoid unnecessary `StatefulWidget`s.
- Keep build methods simple and focused on rendering.
- Prefer `final` for fields and top-level variables. Prefer `const` constructors when the class supports it.
- Prefer explicit typing on public APIs (e.g., `Command0<void>` over dynamic signatures).
- Use descriptive constant names (e.g., `_todoTableName` over `_kTableTodo`).

---

## References

- [Flutter app architecture guide](https://docs.flutter.dev/app-architecture/guide)
- [Flutter Website GitHub Repository](https://github.com/flutter/website)