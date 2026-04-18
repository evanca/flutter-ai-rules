---
name: firebase-database
description: "Integrates Firebase Realtime Database into Flutter apps. Use when implementing real-time data sync, structuring flattened JSON trees, performing read and write operations, creating real-time listeners, implementing offline persistence, managing presence detection, sharding across database instances, or writing security and validation rules."
---

# Firebase Realtime Database Skill

This skill defines how to correctly implement Firebase Realtime Database in Flutter applications, covering data modeling, queries, real-time sync, offline support, and security rules.

## When to Use

Use this skill when working with Firebase Realtime Database for **simple data models**, **low-latency sync**, or **presence functionality**. For rich data models requiring complex queries and high scalability, use Cloud Firestore instead.

---

## 1. Database Selection

Choose **Realtime Database** when the app needs:
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

- Select the database location closest to users.
- Enable persistence for offline capabilities:

```dart
FirebaseDatabase.instance.setPersistenceEnabled(true);
FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000); // 10MB
```

### Setup Checklist

1. Confirm `Firebase.initializeApp()` completes before accessing `FirebaseDatabase.instance`.
2. Set persistence **before** any read/write operations.
3. Verify connectivity by writing a test value and reading it back.

---

## 3. Data Structure

- Structure data as a **flattened JSON tree** — avoid deep nesting.
- Maximum nesting depth is **32 levels**.
- Design the data structure to support the most common queries.
- Use **push IDs** for unique identifiers in list-type data:

```dart
final newPostKey = FirebaseDatabase.instance.ref().child('posts').push().key;
```

- **Denormalize** data when necessary — Realtime Database does not support joins.
- Custom keys must be UTF-8 encoded, max 768 bytes, and cannot contain `.` `$` `#` `[` `]` `/` or ASCII control characters 0-31 or 127.

### Flattened Structure Example

```dart
// Instead of nesting chat messages inside rooms:
// rooms/roomId/messages/messageId/...

// Flatten into separate top-level paths:
// rooms/roomId: { name: "General", createdBy: "uid1" }
// room-members/roomId: { uid1: true, uid2: true }
// room-messages/roomId/messageId: { text: "Hello", sender: "uid1", timestamp: ... }
```

This pattern allows reading room metadata without downloading all messages.

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

- Range queries using `startAt()`, `endAt()`, and `equalTo()`:

```dart
// Find users whose name starts with "A"
final query = ref.child("users")
    .orderByChild("name")
    .startAt("A")
    .endAt("A\uf8ff");
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
final subscription = FirebaseDatabase.instance
    .ref('users/123')
    .onValue
    .listen((event) {
      final data = event.snapshot.value;
      print(data);
    });

// Cancel when no longer needed:
subscription.cancel();
```

A `DatabaseEvent` fires every time data changes at the reference, including changes to children.

**Write (replace):**

```dart
await ref.set({
  "name": "John",
  "age": 18,
  "created_at": ServerValue.timestamp,
});
```

**Update (partial):**

```dart
await ref.update({"age": 19});
```

**Atomic transaction:**

```dart
final result = await FirebaseDatabase.instance
    .ref('posts/123/likes')
    .runTransaction((currentValue) {
      return Transaction.success((currentValue as int? ?? 0) + 1);
    });
print('Likes: ${result.snapshot.value}');
```

**Multi-path atomic update:**

```dart
final updates = <String, dynamic>{
  'posts/$postId': postData,
  'user-posts/$uid/$postId': postData,
};
await FirebaseDatabase.instance.ref().update(updates);
```

- Keep individual write operations under **256KB**.
- Use listeners for real-time updates rather than polling.

---

## 6. Designing for Scale

- Realtime Database scales to ~200,000 concurrent connections and 1,000 writes/second per database. For higher scale, **shard** data across multiple database instances.
- Avoid storing large blobs — use **Firebase Storage** for files.
- Use **server timestamps** for consistent time tracking:

```dart
await FirebaseDatabase.instance.ref('posts/123/timestamp').set(ServerValue.timestamp);
```

- Implement **fan-out patterns** for data accessed from multiple paths.
- Avoid deep nesting — it leads to performance issues when retrieving data.

---

## 7. Offline Capabilities and Presence

```dart
FirebaseDatabase.instance.setPersistenceEnabled(true);

// Keep critical paths synced when offline
FirebaseDatabase.instance.ref('important-data').keepSynced(true);
```

### Connection State and Presence

```dart
// Detect connection state
FirebaseDatabase.instance.ref('.info/connected').onValue.listen((event) {
  final connected = event.snapshot.value as bool? ?? false;
  if (connected) {
    // Set online status and configure onDisconnect cleanup
    final presenceRef = FirebaseDatabase.instance.ref('status/${uid}');
    presenceRef.set({'online': true, 'last_seen': ServerValue.timestamp});
    presenceRef.onDisconnect().set({
      'online': false,
      'last_seen': ServerValue.timestamp,
    });
  }
});
```

- Use value events (`onValue`) to read data and get notified of updates — optimized for online/offline transitions.
- Use `get()` only when data is needed once; it probes local cache if the server is unavailable.
- `onDisconnect()` operations are executed server-side, ensuring cleanup even if the app crashes.

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
- Read and write rules **cascade** in Realtime Database — a parent rule granting access cannot be revoked by a child rule.
- Use the `auth` variable to authenticate users in security rules.

### Data Validation Example

```json
{
  "rules": {
    "messages": {
      "$messageId": {
        ".validate": "newData.hasChildren(['text', 'sender', 'timestamp'])",
        "text": {
          ".validate": "newData.isString() && newData.val().length <= 500"
        }
      }
    }
  }
}
```

- Test rules thoroughly using the Firebase console's rules simulator.
- Use the **Firebase Emulator Suite** for local testing.

---

## References

- [Firebase Realtime Database Flutter documentation](https://firebase.google.com/docs/database/flutter/start)
- [Structure data](https://firebase.google.com/docs/database/flutter/structure-data)
- [Read and write data](https://firebase.google.com/docs/database/flutter/read-and-write)
