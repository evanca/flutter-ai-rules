---
name: firebase-data-connect
description: Integrates Firebase Data Connect into Flutter apps. Use when setting up Data Connect, designing queries, handling errors, or applying security and performance best practices.
---

# Firebase Data Connect Skill

This skill defines how to correctly use Firebase Data Connect in Flutter applications.

## When to Use

Use this skill when:

* Setting up and configuring Firebase Data Connect in a Flutter project.
* Designing schemas, queries, and mutations for Data Connect.
* Handling network failures, data inconsistencies, and offline scenarios.
* Applying security and performance best practices.

---

## 1. Setup and Configuration

```
flutter pub add firebase_data_connect
```

```dart
import 'package:firebase_data_connect/firebase_data_connect.dart';
```

- Ensure your Firebase project is properly configured for Data Connect services.
- Initialize Firebase before using any Data Connect features.

**Platform support:**

| Platform | Support |
|---|---|
| iOS | Full |
| Android | Full |
| Web | Full |
| Other platforms | Not supported |

---

## 2. Best Practices

- Follow Firebase Data Connect documentation for proper **schema design** and **query optimization**.
- Design efficient queries to minimize data transfer and processing time.
- Implement **pagination** for large datasets to improve app responsiveness.
- Use real-time listeners judiciously to avoid unnecessary network usage.
- Consider **offline capabilities** for critical app functionality.
- Use **caching strategies** to improve performance and reduce costs.

---

## 3. Error Handling

- Handle **connection errors** gracefully with appropriate retry mechanisms.
- Implement proper error messages for data validation failures.
- Handle **offline scenarios** and implement appropriate fallback behavior.
- Monitor error rates and investigate recurring issues.

---

## 4. Security

- Configure **Firebase Security Rules** for Data Connect to control data access.
- Use **Firebase Authentication** integration for user-based access control.
- Implement proper **data validation** on both client and server sides.
- Follow data privacy best practices when handling user information.

---

## References

- [Firebase Data Connect documentation](https://firebase.google.com/docs/data-connect)
