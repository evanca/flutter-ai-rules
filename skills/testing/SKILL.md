---
name: testing
description: "Write, review, and improve Flutter and Dart tests including unit tests, widget tests, and golden tests. Use when writing new tests, reviewing test quality, fixing flaky tests, adding test coverage, structuring test files, or choosing between unit and widget tests."
---

# Testing Skill

Write effective, meaningful Flutter and Dart tests that catch real regressions.

## When to Use

Use this skill when:

* Writing unit tests for business logic, repositories, or utility classes.
* Writing widget tests for UI components.
* Reviewing existing tests for correctness and coverage.
* Fixing flaky or false-positive tests.
* Deciding between unit tests, widget tests, and integration tests.

---

## 1. Test Validity

Before writing or accepting a test, ask:

> **"Can this test actually fail if the real code is broken?"**

- Avoid tests that only confirm mocked/fake behavior without exercising real logic.
- Avoid tests that confirm behavior guaranteed by the language or standard library.
- Every test must be capable of catching a real regression.

```dart
// BAD — tests the mock, not real logic
test('should return user', () {
  when(() => repo.getUser()).thenReturn(fakeUser);
  expect(repo.getUser(), fakeUser); // Only proves the mock works
});

// GOOD — tests the cubit's state transitions driven by the mock
blocTest<UserCubit, UserState>(
  'should emit loaded state when getUser succeeds',
  build: () {
    when(() => repo.getUser()).thenAnswer((_) async => fakeUser);
    return UserCubit(repo);
  },
  act: (cubit) => cubit.fetchUser(),
  expect: () => [
    const UserState(status: UserStatus.loading),
    UserState(status: UserStatus.loaded, user: fakeUser),
  ],
);
```

---

## 2. Structure

Always use `group()` in test files. Name the group after the **class under test**:

```dart
group('Counter', () {
  late Counter counter;

  setUp(() {
    counter = Counter();
  });

  test('value should start at 0', () {
    expect(counter.value, 0);
  });

  test('should increment value by 1', () {
    counter.increment();
    expect(counter.value, 1);
  });
});
```

Rules:
- Use `setUp` for shared object creation; use `tearDown` for cleanup (closing streams, controllers).
- Keep each test focused on one behavior.
- Nest `group()` blocks for sub-features when a class has many methods.

---

## 3. Naming

Name test cases using **"should"** to describe expected behavior:

```dart
test('should emit updated list when item is added', () { ... });
test('should throw ArgumentError when input is negative', () { ... });
```

---

## 4. Unit Tests vs Widget Tests

| Type | Target | Tools |
|---|---|---|
| **Unit test** | Pure Dart logic, repositories, cubits/blocs | `test`, `bloc_test`, `mocktail` |
| **Widget test** | Individual widgets, UI behavior, navigation | `flutter_test`, `WidgetTester` |

Default to **unit tests** for business logic. Use **widget tests** when verifying UI rendering, gesture handling, or widget interaction.

---

## 5. Widget Test Patterns

```dart
testWidgets('should display error message on failure', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<LoginCubit>.value(
        value: mockLoginCubit,
        child: const LoginView(),
      ),
    ),
  );

  // Simulate failure state
  whenListen(
    mockLoginCubit,
    Stream.fromIterable([const LoginState(status: LoginStatus.failure, errorMessage: 'Invalid')]),
    initialState: const LoginState(),
  );
  await tester.pump();

  expect(find.text('Invalid'), findsOneWidget);
});
```

Rules:
- Wrap widgets in `MaterialApp` (or the app's root widget) to provide `MediaQuery`, `Directionality`, etc.
- Use `pump()` for a single frame or `pumpAndSettle()` when animations must complete.
- Prefer `find.byKey` over `find.text` for widgets that may have localized or dynamic text.

---

## 6. Mocking Best Practices

- Use `mocktail` for mocks (no code generation required).
- Call `registerFallbackValue()` in `setUpAll` for custom types passed to `any()`.
- Mock at the repository boundary, not at the HTTP/database layer.

```dart
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginRequest());
  });

  // ... tests
}
```

---

## 7. Test File Organization

```
test/
  feature_a/
    cubit/
      feature_a_cubit_test.dart
    view/
      feature_a_view_test.dart
    model/
      feature_a_model_test.dart
```

- Mirror the `lib/` folder structure under `test/`.
- One test file per source file.
- Name test files `<source_file>_test.dart`.
