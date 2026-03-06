---
name: mockito
description: Uses the Mockito package for mocking in Flutter/Dart tests. Use when generating mocks, stubbing methods, verifying interactions, capturing arguments, or deciding between mocks, fakes, and real objects.
---

# Mockito Skill

This skill defines how to correctly use the `mockito` package for mocking in Dart and Flutter tests.

---

## 1. Mock vs. Fake vs. Real Object

| Use | When |
|---|---|
| **Real object** | Prefer over mocks when practical. |
| **Fake** (`extends Fake`) | Lightweight custom implementation; override only the methods you need. Prefer over mocks when you don't need interaction verification. |
| **Mock** (`extends Mock`) | Only when you need to **verify interactions** (call counts, arguments) or stub dynamic responses. |

- **Data models** should not be mocked if they can be constructed with stubbed data.
- Only use mocks if your test has `verify` assertions; otherwise prefer real or fake objects.

---

## 2. Generating Mocks

```dart
@GenerateMocks([MyClass])
// or for nice mocks (return simple legal values for missing stubs):
@GenerateNiceMocks([MockSpec<MyClass>()])
void main() { ... }
```

```bash
dart run build_runner build
```

- Only annotate files under `test/` for mock generation by default.
- Use a `build.yaml` if you need to generate mocks outside of `test/`.
- Never add `@override` methods or implementations to a class extending `Mock`.
- Never stub responses in a mock's constructor or inside the mock class — always stub in your tests.

---

## 3. Stubbing

```dart
final mock = MockCat();

// Return a value
when(mock.sound()).thenReturn('Meow');

// Throw an error
when(mock.sound()).thenThrow(Exception('No sound'));

// Calculate response at call time
when(mock.sound()).thenAnswer((_) => computedValue);

// Return values in sequence
when(mock.sound()).thenReturnInOrder(['Meow', 'Purr']);
```

- Always stub methods/getters **before** using them if you need specific return values.
- Missing stub behavior: `@GenerateMocks` → throws; `@GenerateNiceMocks` → returns a simple legal value.
- Use `throwOnMissingStub(mock)` to throw on any unstubbed call.

---

## 4. Verification

```dart
verify(mock.sound());                  // called at least once
verifyNever(mock.eat(any));            // never called
verify(mock.sound()).called(2);        // called exactly twice
```

**Async:**

```dart
await untilCalled(mock.sound());       // wait for the interaction
```

---

## 5. Argument Matchers

```dart
// Flexible stubbing
when(mock.eat(any)).thenReturn(true);
when(mock.eat(argThat(isNotNull))).thenReturn(true);

// Named arguments
when(mock.fetch(any, headers: any)).thenReturn(response);
```

- Do **not** use `null` as an argument adjacent to an argument matcher.
- For named arguments, use `any` or `argThat` as values, not as argument names.

---

## 6. Capturing Arguments

```dart
final captured = verify(mock.eat(captureAny)).captured;
print(captured.last); // last captured argument
```

Use `captureThat` for conditional capturing.

---

## 7. Resetting Mocks

```dart
reset(mock);                  // clear all stubs AND interactions
clearInteractions(mock);      // clear only recorded interactions
```

---

## 8. Mocking Function Types

To mock a function type (e.g., a callback), define an abstract class with the required signature and generate mocks for it:

```dart
abstract class Callback {
  void call(String value);
}

@GenerateMocks([Callback])
```

---

## 9. Debugging

```dart
logInvocations([mock1, mock2]); // print all collected invocations
```

---

## References

- [mockito package on pub.dev](https://pub.dev/packages/mockito)
- [mockito README](https://github.com/dart-lang/mockito/blob/master/README.md)
