## Testing
- When you look at a test, ask yourself: "Can this test actually fail if the real code is broken?" Or is it just passing because it's testing fake/mocked behavior that doesn’t reflect the real logic?
- Avoid writing tests that just confirm behavior guaranteed by the language, the standard library, or obvious code that can't really fail unless the environment is broken.
- Always use group() in test files — even if there’s only one test — and name the group after the class under test.
- Name test cases using “should” to clearly describe the expected behavior. Example: test('value should start at 0', () {...}.

TOTAL CHAR COUNT:      626
