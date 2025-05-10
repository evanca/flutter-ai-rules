# Code Review Ruleset for LLMs

1. Check that the current branch is a feature, bugfix, or PR/MR branch and not a main or develop branch.
2. Verify the branch is up-to-date with the target branch.
3. Identify the target branch for the merge and list all files that have changed, been added, or deleted.
4. For each changed file, check that the file is in the correct directory.
5. For each changed file, check that the file name follows naming conventions.
6. For each changed file, verify the file’s responsibility is clear and that the reason for its change or addition is understandable.
7. For each changed file, review the code for readability and ensure variable, function, and class names are descriptive and consistent.
8. For each changed file, check the logic and correctness of the code, ensuring there are no logic errors or missing edge cases.
9. For each changed file, check that the code is modular and does not contain unnecessary duplication (maintainability).
10. For each changed file, ensure errors and exceptions are handled appropriately.
11. For each changed file, check for potential security concerns such as input validation and secrets in code.
12. For each changed file, check for obvious performance issues or inefficiencies.
13. For each changed file, verify that public APIs, complex logic, and new modules are documented.
14. For each changed file, ensure there is sufficient test coverage for new or changed logic.
15. For each changed file, ensure the code matches the project’s style guide and coding patterns.
16. For generated files, confirm they are up-to-date and not manually edited.
17. Check that the overall change set is focused and scoped to the stated purpose and does not include unrelated or unnecessary changes.
18. Verify that the PR/MR description accurately reflects the changes made.
19. Ensure there are new or updated tests covering new or changed logic.
20. Ensure all tests pass in the continuous integration system.
21. Provide clear, constructive feedback for any issues found, including suggestions for improvement and requests for clarification if anything is unclear.
22. The expected output is an answer in the chat, mentioning conclusions and recommendations per file.