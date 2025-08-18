### Mockito Rules

1. Use a `Fake` when you want a lightweight, custom implementation of a class for testing, especially when you only need to override a subset of methods or provide specific behavior for certain methods.
2. Use a `Mock` when you need to verify interactions (method calls, arguments, call counts) or when you need to stub method responses dynamically during tests.
3. Use `@GenerateMocks([YourClass])` or `@GenerateNiceMocks([MockSpec<YourClass>()])` to generate mock classes for your real classes.
4. Run `flutter pub run build_runner build` or `dart run build_runner build` after adding mock annotations to generate the mock files.
5. Only annotate files under `test/` for mock generation by default; use a `build.yaml` if you need to generate mocks elsewhere.
6. Create mock instances from generated classes (e.g., `var mock = MockCat();`).
7. Use `when(mock.method()).thenReturn(value)` to stub method calls, and `when(mock.method()).thenThrow(error)` to stub errors.
8. Use `thenAnswer` to calculate a response at call time: `when(mock.method()).thenAnswer((_) => value);`.
9. Use `thenReturnInOrder([v1, v2])` to return values in sequence for multiple calls.
10. Always stub methods or getters before interacting with them if you need specific return values.
11. Use `verify(mock.method())` to check if a method was called; use `verifyNever` to check it was never called.
12. Use `verify(mock.method()).called(n)` to check the exact number of invocations.
13. Use argument matchers like `any`, `argThat`, `captureAny`, and `captureThat` for flexible verification and stubbing.
14. Do not use `null` as an argument adjacent to an argument matcher.
15. For named arguments, use `any` or `argThat` as values, not as argument names (e.g., `when(mock.method(any, namedArg: any))`).
16. Use `captureAny` and `captureThat` to capture arguments passed to mocks for later assertions.
17. Use `untilCalled(mock.method())` to wait for an interaction in async tests.
18. Understand missing stub behavior: mocks generated with `@GenerateMocks` throw on missing stubs; those with `@GenerateNiceMocks` return a simple legal value.
19. To mock function types, define an abstract class with the required method signatures and generate mocks for it.
20. Prefer using real objects over mocks when possible; if not, use a tested fake implementation (`extends Fake`) over a mock.
21. Never stub out responses in a mock's constructor or within the mock class itself; always stub in your tests.
22. Never add implementation or `@override` methods to a class extending `Mock`.
23. Use `reset(mock)` to clear all stubs and interactions; use `clearInteractions(mock)` to clear only interactions.
24. Use `logInvocations([mock1, mock2])` to print all collected invocations for debugging.
25. Use `throwOnMissingStub(mock)` to throw if a mock method is called without a matching stub.
26. Data models should not be mocked if they can be constructed with stubbed data.
27. Only use mocks if your test asserts on interactions (calls to `verify`); otherwise, prefer real or fake objects.

