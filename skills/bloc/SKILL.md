---
name: bloc
description: Implements Flutter state management using the bloc library (Bloc and Cubit). Use when creating new features, screens, or state management logic with bloc/cubit, modeling state, wiring Flutter widgets to blocs, or writing bloc/cubit unit tests.
---

# Bloc Skill

This skill defines how to design, implement, and test state management using the [bloc](https://pub.dev/packages/bloc) and [flutter_bloc](https://pub.dev/packages/flutter_bloc) libraries.

## When to Use

Use this skill when:

* Creating a new Cubit or Bloc for a feature.
* Modeling state (choosing between sealed classes vs a single state class).
* Wiring `BlocBuilder`, `BlocListener`, `BlocConsumer`, or `BlocProvider` in the widget tree.
* Writing unit tests for a Cubit or Bloc.
* Deciding between Cubit and Bloc.

---

## 1. Cubit vs Bloc

| Situation | Use |
|---|---|
| Simple state, no events needed | `Cubit` |
| Complex flows, event traceability needed | `Bloc` |
| Advanced event processing (debounce, throttle) | `Bloc` with event transformers |

**Default to `Cubit`. Refactor to `Bloc` only when requirements grow.**

---

## 2. Naming Conventions

### Events (Bloc only)
- Named in **past tense**: `LoginButtonPressed`, `UserProfileLoaded`.
- Format: `BlocSubject` + optional noun + verb.
- Initial load event: `BlocSubjectStarted` (e.g., `AuthenticationStarted`).
- Base event class: `BlocSubjectEvent`.

### States
- Named as **nouns** (states are snapshots in time).
- Base state class: `BlocSubjectState`.
- Sealed subclasses: `BlocSubject` + `Initial` | `InProgress` | `Success` | `Failure`.
  - Example: `LoginInitial`, `LoginInProgress`, `LoginSuccess`, `LoginFailure`.
- Single-class approach: `BlocSubjectState` + `BlocSubjectStatus` enum (`initial`, `loading`, `success`, `failure`).

---

## 3. Modeling State

### When to use a sealed class with subclasses
- States are **well-defined and mutually exclusive**.
- Type-safe exhaustive `switch` is desired.
- Subclass-specific properties exist.

```dart
@immutable
sealed class LoginState extends Equatable {
  const LoginState();
}

final class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

final class LoginInProgress extends LoginState {
  @override
  List<Object?> get props => [];
}

final class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);
  final User user;
  @override
  List<Object?> get props => [user];
}

final class LoginFailure extends LoginState {
  const LoginFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
```

Handle all states exhaustively in the UI:
```dart
switch (state) {
  case LoginInitial():  ...
  case LoginInProgress(): ...
  case LoginSuccess(:final user): ...
  case LoginFailure(:final message): ...
}
```

### When to use a single class with a status enum
- Many shared properties across states.
- Simpler, more flexible; previous data must be retained after failure.

```dart
enum LoginStatus { initial, loading, success, failure }

@immutable
class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.errorMessage,
  });

  final LoginStatus status;
  final User? user;
  final String? errorMessage;

  LoginState copyWith({
    LoginStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
```

### State rules (both approaches)
- Extend `Equatable` and pass all relevant fields to `props`.
- Copy `List`/`Map` properties with `List.of`/`Map.of` inside `props`.
- Annotate with `@immutable`.
- Always emit a **new instance**; never reuse the same state object.
- Duplicate states are ignored by bloc — ensure meaningful state changes.

---

## 4. Cubit Implementation

```dart
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final user = await _authRepository.login(email, password);
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }
}
```

Rules:
- Only call `emit` inside the Cubit/Bloc.
- Public methods return `void` or `Future<void>` only.
- Keep business logic out of UI.

---

## 5. Bloc Implementation

```dart
sealed class LoginEvent {}
final class LoginSubmitted extends LoginEvent {
  LoginSubmitted({required this.email, required this.password});
  final String email;
  final String password;
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final AuthRepository _authRepository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginInProgress());
    try {
      final user = await _authRepository.login(event.email, event.password);
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
```

Rules:
- Trigger state changes via `bloc.add(Event())`, not custom public methods.
- Keep event handler methods private (`_onEventName`).
- Internal/repository events must be private and may use custom transformers.

---

## 6. Architecture

Three layers — each must stay in its own boundary:

```
Presentation  →  Business Logic (Cubit/Bloc)  →  Data (Repository → DataProvider)
```

- **Data Layer**: Repositories wrap data providers. Providers perform raw CRUD (HTTP, DB). Repositories expose clean domain objects.
- **Business Logic Layer**: Cubits/Blocs receive repository data and emit states. Inject repositories via constructor.
- **Presentation Layer**: Renders UI based on state. Handles user input by calling cubit methods or adding bloc events.

Rules:
- Blocs must not access data providers directly — only via repositories.
- No direct bloc-to-bloc communication. Use `BlocListener` in the UI to bridge blocs.
- For shared data, inject the same repository into multiple blocs.
- Initialize `BlocObserver` in `main.dart`.

---

## 7. Flutter Bloc Widgets

| Widget | Use |
|---|---|
| `BlocProvider` | Provide a bloc to a subtree |
| `MultiBlocProvider` | Provide multiple blocs without nesting |
| `BlocBuilder` | Rebuild UI on state change |
| `BlocListener` | Side effects only (navigation, dialogs, snackbars) |
| `MultiBlocListener` | Listen to multiple blocs without nesting |
| `BlocConsumer` | Rebuild UI + side effects together |
| `BlocSelector` | Rebuild only when a selected slice of state changes |
| `RepositoryProvider` | Provide a repository to the widget tree |
| `MultiRepositoryProvider` | Provide multiple repositories without nesting |

```dart
BlocProvider(
  create: (context) => LoginCubit(context.read<AuthRepository>()),
  child: LoginView(),
);

BlocBuilder<LoginCubit, LoginState>(
  builder: (context, state) {
    return switch (state.status) {
      LoginStatus.loading => const CircularProgressIndicator(),
      LoginStatus.success => const HomeView(),
      LoginStatus.failure => Text(state.errorMessage ?? 'Error'),
      LoginStatus.initial => const LoginForm(),
    };
  },
);

BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state.status == LoginStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
      );
    }
  },
  child: LoginForm(),
);
```

Rules:
- Use `context.read<T>()` in callbacks (not in `build`).
- Use `context.watch<T>()` in `build` only when necessary; prefer `BlocBuilder`.
- Never call `context.watch` or `context.select` at the root of `build` — scope with `Builder`.
- Handle **all** possible states in the UI (initial, loading, success, failure).

---

## 8. Testing

Use `bloc_test` package. Mock repositories with `mocktail`.

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginCubit', () {
    late AuthRepository authRepository;
    late LoginCubit loginCubit;

    setUp(() {
      authRepository = MockAuthRepository();
      loginCubit = LoginCubit(authRepository);
    });

    tearDown(() => loginCubit.close());

    test('initial state should be LoginState with status initial', () {
      expect(loginCubit.state, const LoginState());
    });

    blocTest<LoginCubit, LoginState>(
      'should emit [loading, success] when login succeeds',
      build: () {
        when(() => authRepository.login(any(), any()))
            .thenAnswer((_) async => fakeUser);
        return loginCubit;
      },
      act: (cubit) => cubit.login('email@test.com', 'password'),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        LoginState(status: LoginStatus.success, user: fakeUser),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'should emit [loading, failure] when login throws',
      build: () {
        when(() => authRepository.login(any(), any()))
            .thenThrow(Exception('error'));
        return loginCubit;
      },
      act: (cubit) => cubit.login('email@test.com', 'wrong'),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        isA<LoginState>().having((s) => s.status, 'status', LoginStatus.failure),
      ],
    );
  });
}
```

Rules:
- Always call `tearDown(() => cubit.close())`.
- Use `blocTest` for state emission assertions.
- Use `group()` named after the class under test.
- Name test cases with "should" to describe expected behavior.
- Register fallback values for custom types: `registerFallbackValue(MyEvent())`.

---

## References

- [bloc library documentation](https://bloclibrary.dev)
- [flutter_bloc package](https://pub.dev/packages/flutter_bloc)
- [bloc_test package](https://pub.dev/packages/bloc_test)
