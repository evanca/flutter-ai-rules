---
name: testing
description: Writes and reviews Flutter/Dart tests. Use when writing unit tests, widget tests, or reviewing existing tests for correctness, structure, and naming conventions.
---

# Testing Skill

This skill defines how to write effective, meaningful Flutter and Dart tests.

---

## 1. Test Validity

Before writing or accepting a test, ask:

> **"Can this test actually fail if the real code is broken?"**

- Avoid tests that only confirm mocked/fake behavior that doesn't reflect real logic.
- Avoid tests that confirm behavior guaranteed by the language, the standard library, or trivially obvious code that cannot fail unless the environment is broken.
- Every test should be capable of catching a real regression.

---

## 2. Structure

Always use `group()` in test files — even when there is only one test. Name the group after the **class under test**:

```dart
group('Counter', () {
  test('value should start at 0', () {
    final counter = Counter();
    expect(counter.value, 0);
  });
});
```

---

## 3. Naming

Name test cases using **"should"** to clearly describe the expected behavior:

```dart
test('should emit updated list when item is added', () { ... });
test('should throw ArgumentError when input is negative', () { ... });
```
