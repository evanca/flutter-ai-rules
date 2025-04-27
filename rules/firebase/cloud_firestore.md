# Cloud Firestore Rules

### Database Selection

1. Choose Cloud Firestore for applications with rich data models requiring queryability, scalability, and high availability.
2. Use Cloud Firestore when your application needs complex, hierarchical data organization at scale using subcollections within documents.
3. Consider Cloud Firestore for applications where availability is of utmost importance (typical uptime performance of 99.999%).
4. Choose Cloud Firestore if you need to chain filters and combine filtering and sorting on a property in a single query.
5. Select Cloud Firestore when you need transactions that can atomically read and write data from any part of the database.
6. Consider Realtime Database instead for applications with simple data models requiring simple lookups and extremely low-latency synchronization (typical response times under 10ms).

### Setup and Configuration

1. Install Cloud Firestore using `flutter pub add cloud_firestore` in your Flutter project.
2. Import the package in your Dart code using `import 'package:cloud_firestore/cloud_firestore.dart';`.
3. Initialize Firestore with `final db = FirebaseFirestore.instance;` after Firebase has been initialized.
4. Select the database location closest to your users and compute resources to minimize latency.
5. Use multi-region locations for critical applications to maximize availability and durability.
6. Use regional locations for lower costs and lower write latency for latency-sensitive applications.
7. For iOS & macOS, consider using pre-compiled frameworks to improve build times by modifying your Podfile.
   ```
   pod 'FirebaseFirestore',
     :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git',
     :tag => 'IOS_SDK_VERSION'
   ```

### Document Structure

1. Avoid using document IDs `.` and `..` as they have special meaning in Firestore paths.
2. Avoid using forward slashes (`/`) in document IDs as they are used as path separators.
3. Do not use monotonically increasing document IDs (e.g., Customer1, Customer2, Customer3) as they can lead to hotspots that impact latency.
4. Use Firestore's automatic document IDs when possible to avoid hotspotting on writes.
   ```dart
   // Create a new document with a generated ID
   db.collection("users").add(user).then((DocumentReference doc) =>
       print('DocumentSnapshot added with ID: ${doc.id}'));
   ```
5. Avoid using the following characters in field names as they require extra escaping: `.` (period), `[` (left bracket), `]` (right bracket), `*` (asterisk), `` ` `` (backtick).
6. Organize complex, hierarchical data using subcollections within documents rather than deeply nested objects.

### Indexing

1. Set collection-level index exemptions to reduce write latency and lower storage costs.
2. Disable Descending & Array indexing for fields that don't need them to improve performance.
3. Exempt string fields that hold long values and aren't used for querying from indexing to reduce storage costs.
4. Exempt fields with sequential values (like timestamps) from indexing if not used in queries to avoid the 500 writes per second limit.
5. Add single-field exemptions for TTL (time-to-live) fields to improve performance at higher traffic rates.
6. Exempt large array or map fields from indexing if not used in queries to avoid approaching the 40,000 index entries per document limit.
7. Be aware that queries in Firestore are indexed by default, with performance proportional to the size of your result set, not your dataset.

### Read and Write Operations

1. Use asynchronous calls instead of synchronous calls to minimize latency impact.
   ```dart
   // Read data asynchronously
   await db.collection("users").get().then((event) {
     for (var doc in event.docs) {
       print("${doc.id} => ${doc.data()}");
     }
   });
   ```
2. Do not use offsets for pagination; use cursors instead to avoid retrieving and billing for skipped documents.
3. Implement transaction retries when accessing Firestore directly through REST or RPC APIs.
4. Be aware of the limitations on the rate at which a single document can be updated.
5. For writing a large number of documents, consider using a bulk writer instead of the atomic batch writer.
6. When performing multiple independent operations (like a document lookup and a query), execute them in parallel rather than sequentially.
7. Remember that Firestore queries are shallow and only return documents in a particular collection or collection group, not subcollection data.
8. Be aware that Firestore has limits on write rates to individual documents (around 1 write per second per document) and indexes.

### Designing for Scale

1. Avoid high read or write rates to lexicographically close documents to prevent hotspotting.
2. Avoid creating new documents with monotonically increasing fields (like timestamps) at a very high rate.
3. Avoid deleting documents in a collection at a high rate.
4. Gradually increase traffic when writing to the database at a high rate.
5. Avoid queries that skip over recently deleted data by using the `start_at` method to find the best place to start.
6. For high-traffic applications, distribute writes across different document paths to avoid contention.
7. Be aware that Firestore scales automatically to around 1 million concurrent connections and 10,000 writes/second.

### Real-time Updates

1. Limit the number of simultaneous real-time listeners in your application.
2. Detach listeners when they are no longer needed to free up resources.
   ```dart
   // Set up a listener
   final subscription = db.collection("users")
       .snapshots()
       .listen((event) {
         // Handle the data
       });
   
   // Later, when no longer needed:
   subscription.cancel();
   ```
3. Use compound queries to filter data on the server side rather than filtering in the client.
4. Consider using server-side filtering to reduce the amount of data transferred to clients.
5. For large collections, use queries to limit the data being listened to rather than listening to the entire collection.
6. For presence functionality (knowing when a client is online/offline), implement custom presence solutions as described in Firebase documentation.

### Security

1. Always use Firebase Security Rules to protect your Firestore data.
2. Validate user input before submitting it to Firestore to prevent injection attacks.
3. Use transactions for operations that require atomic updates to multiple documents.
4. Implement proper error handling for Firestore operations to handle potential failures gracefully.
5. Never store sensitive information in Firestore without proper access controls.
6. Be aware that Firestore security rules don't cascade unless you use a wildcard.
7. Remember that if a query's results might contain data the user doesn't have access to, the entire query fails.
