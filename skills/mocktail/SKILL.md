---
name: mocktail
description: Uses the Mocktail package for mocking in Flutter/Dart tests. Use when creating mocks, stubbing methods, verifying interactions, registering fallback values, or deciding between mocks, fakes, and real objects.
---

# Mocktail Skill

This skill defines how to correctly use the `mocktail` package for mocking in Dart and Flutter tests.

---

## 1. Mock vs. Fake vs. Real Object

| Use | When |
|---|---|
| **Real object** | Prefer over mocks when practical. |
| **Fake** (`extends Fake`) | Lightweight custom implementation; override only the methods you need. Prefer over mocks when you don't need interaction verification. |
| **Mock** (`extends Mock`) | Only when you need to **verify interactions** (call counts, arguments) or stub dynamic responses. |

- Never add `@override` methods or implementations to a class extending `Mock`.
- Only use mocks if your test has `verify` assertions; otherwise prefer real or fake objects.

---

## 2. Creating Mocks

```dart
class MockMyService extends Mock implements MyService {}
class FakeMyEvent extends Fake implements MyEvent {}
```

No code generation required — unlike Mockito, Mocktail uses `noSuchMethod` at runtime.

---

## 3. Registering Fallback Values

Register fallback values **before** using custom types with argument matchers. Do this in `setUpAll` or at the top of your test:

```dart
setUpAll(() {
  registerFallbackValue(FakeMyEvent());
});
```

- Required for non-nullable custom types used with `any()`, `captureAny()`, or `captureThat()`.
- Register fallback values for **any** custom type used with argument matchers.

---

## 4. Stubbing

```dart
final mock = MockMyService();

// Return a value
when(() => mock.fetchData()).thenReturn('result');

// Throw an error
when(() => mock.fetchData()).thenThrow(Exception('error'));

// Dynamic/async response
when(() => mock.fetchData()).thenAnswer((_) async => 'result');

// Future<void>
when(() => mock.doWork()).thenAnswer((_) async {});
```

- Always stub async methods (returning `Future` or `Future<void>`) with `thenAnswer`.
- Stub every method you expect to be called, even if it's not the focus of your test.

---

## 5. Named Parameters

Always include **all named parameters** in both `when` and `verify` calls. Use `any(named: 'paramName')` for those you don't care about:

```dart
when(() => mock.fetch(
  id: any(named: 'id'),
  headers: any(named: 'headers'),
)).thenReturn(response);
```

- If a method has default values for named parameters, Mocktail still expects them all to be matched.

---

## 6. Verification

```dart
verify(() => mock.fetchData());             // called at least once
verifyNever(() => mock.fetchData());        // never called
verify(() => mock.fetchData()).called(2);   // called exactly twice
```

---

## 7. Argument Matchers

```dart
// Any positional argument
when(() => mock.process(any())).thenReturn(true);

// Capture arguments for later assertions
final captured = verify(() => mock.process(captureAny())).captured;
print(captured.last);
```

- Use `any()` for positional parameters when you don't care about the exact value.
- Use `captureThat()` for conditional capturing.
- When matching string output, be aware of what `.toString()` returns for the type.

---

## References

- [Mocktail GitHub Repository](https://github.com/felangel/mocktail)
