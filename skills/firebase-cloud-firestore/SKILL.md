---
name: firebase-cloud-firestore
description: "Integrates Cloud Firestore into Flutter apps. Use when implementing Firestore setup, designing document and collection schemas, performing CRUD operations, creating real-time listeners, building paginated queries, configuring indexes, implementing offline persistence, writing security rules, or optimizing for scale."
---

# Firebase Cloud Firestore Skill

This skill defines how to correctly implement Cloud Firestore in Flutter applications, covering data modeling, queries, real-time updates, security rules, and scale optimization.

## When to Use

Use this skill when:

* Setting up and configuring Cloud Firestore in a Flutter project.
* Designing document and collection structure or planning subcollections.
* Performing read, write, batch, or transaction operations.
* Implementing real-time listeners or paginated queries.
* Optimizing for scale and avoiding write hotspots.
* Writing or debugging Firestore security rules.

---

## 1. Database Selection

Choose **Cloud Firestore** when the app needs:
- Rich, hierarchical data models with subcollections.
- Complex queries: chaining filters, combining filtering and sorting on a property.
- Transactions that atomically read and write data from any part of the database.
- High availability (typical uptime 99.999%) or critical-level reliability.
- Automatic scaling to millions of concurrent users.

Use **Realtime Database** instead for simple data models requiring simple lookups and extremely low-latency synchronization (typical response times under 10ms).

---

## 2. Setup and Configuration

```
flutter pub add cloud_firestore
```

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance; // after Firebase.initializeApp()
```

**Location:**
- Select the database location closest to users and compute resources.
- Use **multi-region** locations for critical apps (maximum availability and durability).
- Use **regional** locations for lower costs and lower write latency.

**iOS/macOS:** Consider pre-compiled frameworks to improve build times:
```ruby
pod 'FirebaseFirestore',
  :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git',
  :tag => 'IOS_SDK_VERSION'
```

**Offline persistence** is enabled by default on mobile. Configure cache size:
```dart
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

---

## 3. Document Structure

- Avoid document IDs `.` and `..` (special meaning in Firestore paths).
- Avoid forward slashes (`/`) in document IDs (path separators).
- **Do not** use monotonically increasing document IDs (e.g., `Customer1`, `Customer2`) — causes write hotspots.
- Use Firestore's **automatic document IDs** when possible:

```dart
final docRef = await db.collection("users").add({
  'name': 'Ada Lovelace',
  'email': 'ada@example.com',
  'created_at': FieldValue.serverTimestamp(),
});
print('Created document with ID: ${docRef.id}');
```

- Avoid these characters in field names (require extra escaping): `.` `[` `]` `*` `` ` ``
- Use **subcollections** within documents to organize complex, hierarchical data rather than deeply nested objects.

---

## 4. Indexing

- Firestore queries are indexed by default; query performance is proportional to the result set size, not the dataset size.
- Set **collection-level index exemptions** to reduce write latency and storage costs.
- Disable Descending and Array indexing for fields that do not need them.
- Exempt string fields with long values that are not used for querying.
- Exempt fields with sequential values (e.g., timestamps) from indexing if not used in queries — avoids the 500 writes/second index limit.
- Add single-field exemptions for TTL fields.
- Exempt large array or map fields not used in queries — avoids the 40,000 index entries per document limit.

---

## 5. Read and Write Operations

### Read All Documents in a Collection

```dart
final querySnapshot = await db.collection("users").get();
for (var doc in querySnapshot.docs) {
  print("${doc.id} => ${doc.data()}");
}
```

### Query with Filters

```dart
final query = db.collection("users")
    .where("age", isGreaterThanOrEqualTo: 18)
    .orderBy("age")
    .limit(20);

final results = await query.get();
```

### Cursor-Based Pagination

```dart
// First page
final first = db.collection("cities").orderBy("name").limit(25);
final firstSnapshot = await first.get();

// Next page using last document as cursor
final lastDoc = firstSnapshot.docs.last;
final next = db.collection("cities")
    .orderBy("name")
    .startAfterDocument(lastDoc)
    .limit(25);
```

- **Do not use offsets for pagination** — use cursors to avoid retrieving and being billed for skipped documents.

### Write with Server Timestamp

```dart
await db.collection("users").doc("user_1").set({
  'name': 'Grace Hopper',
  'updated_at': FieldValue.serverTimestamp(),
});
```

### Batch Write (Atomic, Up to 500 Operations)

```dart
final batch = db.batch();
batch.set(db.collection("cities").doc("LA"), {'name': 'Los Angeles'});
batch.update(db.collection("cities").doc("SF"), {'population': 860000});
batch.delete(db.collection("cities").doc("OLD"));
await batch.commit();
```

### Transaction

```dart
await db.runTransaction((transaction) async {
  final snapshot = await transaction.get(db.collection("counters").doc("visits"));
  final currentCount = snapshot.get("count") as int;
  transaction.update(snapshot.reference, {"count": currentCount + 1});
});
```

- Execute independent operations (e.g., a document lookup and a query) **in parallel**, not sequentially.
- Be aware of write rate limits: ~1 write per second per document.
- For writing a large number of documents, use a **bulk writer** instead of the atomic batch writer.

---

## 6. Designing for Scale

- Avoid high read or write rates to **lexicographically close documents** (hotspotting).
- Avoid creating new documents with **monotonically increasing fields** (like timestamps) at a very high rate.
- Avoid **deleting documents** in a collection at a high rate.
- **Gradually increase traffic** when writing to the database at a high rate — ramp up over 5 minutes.
- Avoid queries that skip over recently deleted data — use `start_at` to find the correct start point.
- Distribute writes across different document paths to avoid contention.
- Firestore scales automatically to ~1 million concurrent connections and 10,000 writes/second.

---

## 7. Real-time Updates

```dart
final subscription = db.collection("messages")
    .where("room", isEqualTo: "general")
    .orderBy("timestamp", descending: true)
    .limit(50)
    .snapshots()
    .listen((querySnapshot) {
      for (var change in querySnapshot.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            print("New message: ${change.doc.data()}");
            break;
          case DocumentChangeType.modified:
            print("Modified: ${change.doc.data()}");
            break;
          case DocumentChangeType.removed:
            print("Removed: ${change.doc.id}");
            break;
        }
      }
    });

// Detach when no longer needed:
subscription.cancel();
```

- **Limit** the number of simultaneous real-time listeners.
- **Detach listeners** when they are no longer needed to avoid memory leaks and unnecessary reads.
- Use **compound queries** to filter data server-side rather than filtering on the client.
- For large collections, use queries to limit the data being listened to — never listen to an entire large collection.

---

## 8. Security

- Always use **Firebase Security Rules** to protect Firestore data.
- Security rules **do not cascade** unless a wildcard is used.
- If a query's results might contain data the user does not have access to, **the entire query fails**.

Example rules for user-owned documents:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, update, delete: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null;
    }
  }
}
```

- **Validate user input** before submitting to Firestore to prevent injection attacks.
- Use **transactions** for operations that require atomic updates to multiple documents.
- Implement proper **error handling** for all Firestore operations.
- Never store sensitive information in Firestore without proper access controls.

---

## References

- [Cloud Firestore Flutter documentation](https://firebase.google.com/docs/firestore/quickstart?hl=en&authuser=0&platform=flutter)
- [Cloud Firestore best practices](https://firebase.google.com/docs/firestore/best-practices)
- [Cloud Firestore security rules](https://firebase.google.com/docs/firestore/security/get-started)
