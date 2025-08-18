### Mocktail Rules

1. Use a `Fake` when you need a lightweight, custom implementation of a class for testing, especially if you only need to override a subset of methods or provide specific behavior.
2. Use a `Mock` when you need to verify interactions (method calls, arguments, call counts) or need to stub method responses dynamically during tests.
3. Use `registerFallbackValue` to register a default value for a type that is used as an argument in a mock method, especially when the type is not nullable and is required for argument matching (e.g., `registerFallbackValue(MyCustomEvent())`).
4. Extend `Mock` to create a mock class for the class or interface you want to mock.
5. Use `when(() => mock.method()).thenReturn(value)` to stub method calls, and `thenThrow(error)` to stub errors.
6. Use `when(() => mock.method()).thenAnswer((invocation) => value)` for dynamic responses.
7. Use `verify(() => mock.method())` to check if a method was called; use `verifyNever(() => mock.method())` to check it was never called.
8. Use `verify(() => mock.method()).called(n)` to check the exact number of invocations.
9. Use argument matchers like `any()`, `captureAny()`, and `captureThat()` for flexible verification and stubbing.
10. Always register fallback values for custom types used with argument matchers before using them in stubs or verifications.
11. Prefer using real objects over mocks when possible; if not, use a tested fake implementation (`extends Fake`) over a mock.
12. Never add implementation or `@override` methods to a class extending `Mock`.
13. Only use mocks if your test asserts on interactions (calls to `verify`); otherwise, prefer real or fake objects.
14. Always stub async methods (returning `Future` or `Future<void>`) with `thenAnswer((_) async {})` or `thenReturn(Future.value(...))`.
15. Always include all named parameters in both `when` and `verify` calls, even if you only care about one. Use `any(named: 'paramName')` for those you don't care about.
16. If a method has default values for named parameters, Mocktail still expects all of them to be matched in both stubs and verifies.
17. Use `any()` for positional parameters in `when`/`verify` if you don't care about the exact instance.
18. Register fallback values for any custom types that are used with argument matchers before using them in your tests.
19. Stub every method you expect to be called, even if it's not the focus of your test, to prevent runtime errors.
20. When matching string outputs, make sure you understand what `.toString()` returns for the type you are using.

