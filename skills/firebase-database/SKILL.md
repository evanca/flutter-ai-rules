---
name: firebase-database
description: Integrates Firebase Realtime Database into Flutter apps. Use when setting up Realtime Database, structuring JSON data, querying, performing read/write operations, implementing offline capabilities, or applying security rules.
---

# Firebase Realtime Database Skill

This skill defines how to correctly use Firebase Realtime Database in Flutter applications.

## When to Use

Use this skill when working with Firebase Realtime Database for **simple data models**, **low-latency sync**, or **presence functionality**. For rich data models requiring complex queries and high scalability, use Cloud Firestore instead.

---

## 1. Database Selection

Choose **Realtime Database** when your app needs:
- Simple data models with simple lookups.
- Extremely low-latency synchronization (typical response times under 10ms).
- Deep queries that return an entire subtree by default.
- Access to data at any granularity, down to individual leaf-node values.
- Frequent state-syncing with built-in presence functionality.

Choose **Cloud Firestore** instead for rich data models requiring queryability, scalability, and high availability.

---

## 2. Setup and Configuration

```
flutter pub add firebase_database
```

```dart
import 'package:firebase_database/firebase_database.dart';

// After Firebase.initializeApp():
final DatabaseReference ref = FirebaseDatabase.instance.ref();
```

- Select the database location closest to your users.
- Enable persistence for offline capabilities:

```dart
FirebaseDatabase.instance.setPersistenceEnabled(true);
FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000); // 10MB
```

---

## 3. Data Structure

- Structure data as a **flattened JSON tree** — avoid deep nesting.
- Maximum nesting depth is **32 levels**.
- Design your data structure to support your most common queries.
- Use **push IDs** for unique identifiers in list-type data:

```dart
final newPostKey = FirebaseDatabase.instance.ref().child('posts').push().key;
```

- **Denormalize** data when necessary — Realtime Database doesn't support joins.
- Custom keys must be UTF-8 encoded, max 768 bytes, and cannot contain `.` `$` `#` `[` `]` `/` or ASCII control characters 0–31 or 127.

---

## 4. Indexing and Querying

- Queries can sort **or** filter on a property, but not both in the same query.
- Use `.indexOn` in security rules to index frequently queried fields:

```json
{
  "rules": {
    "dinosaurs": {
      ".indexOn": ["height", "length"]
    }
  }
}
```

- Queries are **deep** by default and return the entire subtree.
- Sort with `orderByChild()`, `orderByKey()`, or `orderByValue()`:

```dart
final query = FirebaseDatabase.instance.ref("dinosaurs").orderByChild("height");
```

- Limit results with `limitToFirst()` or `limitToLast()`:

```dart
final query = ref.orderByChild("height").limitToFirst(10);
```

---

## 5. Read and Write Operations

**Read once:**

```dart
final snapshot = await FirebaseDatabase.instance.ref('users/123').get();
if (snapshot.exists) {
  print(snapshot.value);
}
```

**Real-time listener:**

```dart
FirebaseDatabase.instance.ref('users/123').onValue.listen((event) {
  final data = event.snapshot.value;
  print(data);
});
```

A `DatabaseEvent` fires every time data changes at the reference, including changes to children.

**Write (replace):**

```dart
await ref.set({
  "name": "John",
  "age": 18,
});
```

**Update (partial):**

```dart
await ref.update({"age": 19});
```

**Atomic transaction:**

```dart
FirebaseDatabase.instance.ref('posts/123/likes').runTransaction((currentValue) {
  return (currentValue as int? ?? 0) + 1;
});
```

**Multi-path atomic update:**

```dart
final updates = <String, dynamic>{
  'posts/$postId': postData,
  'user-posts/$uid/$postId': postData,
};
FirebaseDatabase.instance.ref().update(updates);
```

- Keep individual write operations under **256KB**.
- Use listeners for real-time updates rather than polling.

---

## 6. Designing for Scale

- Realtime Database scales to ~200,000 concurrent connections and 1,000 writes/second per database. For higher scale, **shard** data across multiple database instances.
- Avoid storing large blobs — use **Firebase Storage** for files.
- Use **server timestamps** for consistent time tracking:

```dart
FirebaseDatabase.instance.ref('posts/123/timestamp').set(ServerValue.timestamp);
```

- Implement **fan-out patterns** for data accessed from multiple paths.
- Avoid deep nesting — it leads to performance issues when retrieving data.

---

## 7. Offline Capabilities

```dart
FirebaseDatabase.instance.setPersistenceEnabled(true);

// Keep critical paths synced when offline
FirebaseDatabase.instance.ref('important-data').keepSynced(true);

// Detect connection state
FirebaseDatabase.instance.ref('.info/connected').onValue.listen((event) {
  final connected = event.snapshot.value as bool? ?? false;
  print('Connected: $connected');
});
```

- Use value events (`onValue`) to read data and get notified of updates — optimized for online/offline transitions.
- Use `get()` only when you need data once; it probes local cache if the server is unavailable.

---

## 8. Security

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

- Use `.read`, `.write`, `.validate`, and `.indexOn` to control access and validate data.
- Read and write rules **cascade** in Realtime Database.
- Use the `auth` variable to authenticate users in security rules.
- Test rules thoroughly using the Firebase console's rules simulator.
- Use the **Firebase Emulator Suite** for local testing.

---

## References

- [Firebase Realtime Database Flutter documentation](https://firebase.google.com/docs/database/flutter/start)
- [Structure data](https://firebase.google.com/docs/database/flutter/structure-data)
- [Read and write data](https://firebase.google.com/docs/database/flutter/read-and-write)
