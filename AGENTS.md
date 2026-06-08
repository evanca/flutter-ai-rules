# Global Agent Rules

These rules apply to any agentic IDE or AI coding assistant working on this project.

## 1. Modular Code Base / Avoid Bloated Files
Our rule of thumb in software development is to avoid bloated files. If a file becomes large, that’s usually a good reason to refactor it into smaller, modular pieces. Think in terms of breaking things down into independent, reusable parts — for example, small building blocks that can be combined in different ways to make larger features — rather than keeping everything in one big file.

## 2. Notification Sound
After you are done with a task, play a sound via running:
```bash
afplay /System/Library/Sounds/Glass.aiff
```

## 3. Commit Title Conventions
After every step, suggest a commit title for the work completed. Use the "short capitalised action" format (e.g., `Implement dashboard`) for features and the `Fix: Problem` format (e.g., `Fix: Stripe webhook not firing`) for issues. Do not use other prefixes and do not write long commit messages.

## 4. Flutter Web Live Reload
If we deploy Flutter on Chrome, always enter `r` into the terminal so the user can see the updated page. Note that if `pubspec.yaml` or assets are altered, you must restart the web application entirely.
