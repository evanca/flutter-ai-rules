---
name: firebase-cloud-firestore
description: Integrates Cloud Firestore into Flutter apps. Use when setting up Firestore, designing document/collection structure, reading and writing data, working with real-time listeners, designing for scale, or applying security rules.
---

# Firebase Cloud Firestore Skill

This skill defines how to correctly use Cloud Firestore in Flutter applications.

## When to Use

Use this skill when:

* Setting up and configuring Cloud Firestore in a Flutter project.
* Designing document and collection structure.
* Performing read, write, or real-time listener operations.
* Optimizing for scale and avoiding hotspots.
* Applying Firestore security rules.

Do not use this skill for:

* Firebase Realtime Database (a separate product).
* Firebase Auth, Storage, or other Firebase services.

---

## 1. Database Selection

Choose **Cloud Firestore** when your app needs:
- Rich, hierarchical data models with subcollections.
- Complex queries: chaining filters, combining filtering and sorting on a property.
- Transactions that atomically read and write data from any part of the database.
- High availability (typical uptime 99.999%) or critical-level reliability.
- Scalability.

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
- Select the database location closest to your users and compute resources.
- Use **multi-region** locations for critical apps (maximum availability and durability).
- Use **regional** locations for lower costs and lower write latency for latency-sensitive apps.

**iOS/macOS:** Consider pre-compiled frameworks to improve build times:
```ruby
pod 'FirebaseFirestore',
  :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git',
  :tag => 'IOS_SDK_VERSION'
```

---

## 3. Document Structure

- Avoid document IDs `.` and `..` (special meaning in Firestore paths).
- Avoid forward slashes (`/`) in document IDs (path separators).
- **Do not** use monotonically increasing document IDs (e.g., `Customer1`, `Customer2`) — causes write hotspots.
- Use Firestore's **automatic document IDs** when possible:

```dart
db.collection("users").add(user).then((DocumentReference doc) =>
    print('DocumentSnapshot added with ID: ${doc.id}'));
```

- Avoid these characters in field names (require extra escaping): `.` `[` `]` `*` `` ` ``
- Use **subcollections** within documents to organize complex, hierarchical data rather than deeply nested objects.

---

## 4. Indexing

- Set **collection-level index exemptions** to reduce write latency and storage costs.
- Disable Descending & Array indexing for fields that don't need them.
- Exempt string fields with long values that aren't used for querying.
- Exempt fields with sequential values (e.g., timestamps) from indexing if not used in queries — avoids the 500 writes/second index limit.
- Add single-field exemptions for TTL fields.
- Exempt large array or map fields not used in queries — avoids the 40,000 index entries per document limit.
- Firestore queries are indexed by default; query performance is proportional to the result set size, not the dataset size.

---

## 5. Read and Write Operations

- **Always use asynchronous calls** to minimize latency impact:

```dart
await db.collection("users").get().then((event) {
  for (var doc in event.docs) {
    print("${doc.id} => ${doc.data()}");
  }
});
```

- **Do not use offsets for pagination** — use cursors instead to avoid retrieving and being billed for skipped documents.
- Implement **transaction retries** when accessing Firestore directly through REST or RPC APIs.
- For writing a large number of documents, use a **bulk writer** instead of the atomic batch writer.
- Execute independent operations (e.g., a document lookup and a query) **in parallel**, not sequentially.
- Firestore queries are **shallow**: they only return documents in a specific collection or collection group, not subcollection data.
- Be aware of write rate limits: ~1 write per second per document.

---

## 6. Designing for Scale

- Avoid high read or write rates to **lexicographically close documents** (hotspotting).
- Avoid creating new documents with **monotonically increasing fields** (like timestamps) at a very high rate.
- Avoid **deleting documents** in a collection at a high rate.
- **Gradually increase traffic** when writing to the database at a high rate.
- Avoid queries that skip over recently deleted data — use `start_at` to find the correct start point.
- Distribute writes across different document paths to avoid contention.
- Firestore scales automatically to ~1 million concurrent connections and 10,000 writes/second.

---

## 7. Real-time Updates

- **Limit** the number of simultaneous real-time listeners.
- **Detach listeners** when they are no longer needed:

```dart
final subscription = db.collection("users")
    .snapshots()
    .listen((event) {
      // Handle the data
    });

// When no longer needed:
subscription.cancel();
```

- Use **compound queries** to filter data server-side rather than filtering on the client.
- For large collections, use queries to limit the data being listened to — never listen to an entire large collection.
- For presence functionality (online/offline status), implement custom presence solutions as described in Firebase documentation.

---

## 8. Security

- Always use **Firebase Security Rules** to protect Firestore data.
- **Validate user input** before submitting to Firestore to prevent injection attacks.
- Use **transactions** for operations that require atomic updates to multiple documents.
- Implement proper **error handling** for all Firestore operations.
- Never store sensitive information in Firestore without proper access controls.
- Security rules **do not cascade** unless you use a wildcard.
- If a query's results might contain data the user doesn't have access to, **the entire query fails**.

---

## References

- [Cloud Firestore Flutter documentation](https://firebase.google.com/docs/firestore/quickstart?hl=en&authuser=0&platform=flutter)
- [Cloud Firestore best practices](https://firebase.google.com/docs/firestore/best-practices)
- [Cloud Firestore security rules](https://firebase.google.com/docs/firestore/security/get-started)
