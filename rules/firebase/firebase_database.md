# Firebase Realtime Database Rules

### Database Selection

1. Choose Realtime Database for applications with simple data models requiring simple lookups and extremely low-latency synchronization (typical response times under 10ms).
2. Use Realtime Database for applications that need deep queries by default, which return the entire subtree.
3. Consider Realtime Database when you need to access data at any granularity, down to individual leaf-node values in the JSON tree.
4. Select Realtime Database for applications that require extremely low latency for frequent state-syncing.
5. Choose Realtime Database when your application needs to track client connection status with built-in presence functionality.
6. Consider Cloud Firestore instead for applications with rich data models requiring queryability, scalability, and high availability.

### Setup and Configuration

1. Install Firebase Realtime Database using `flutter pub add firebase_database` in your Flutter project.
2. Import the package in your Dart code using `import 'package:firebase_database/firebase_database.dart';`.
3. Initialize Realtime Database with `final DatabaseReference ref = FirebaseDatabase.instance.ref();` after Firebase has been initialized.
4. Select the database location closest to your users to minimize latency.
5. Consider enabling persistence for offline capabilities.
   ```dart
   FirebaseDatabase.instance.setPersistenceEnabled(true);
   ```
6. Set a cache size limit if needed for performance optimization.
   ```dart
   FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000); // 10MB
   ```

### Data Structure

1. Structure your data as a JSON tree with a flattened hierarchy to avoid deep nesting.
2. Avoid nesting data more than 32 levels deep, as this is the maximum depth allowed.
3. Design your data structure to support your most common queries, as the structure directly impacts how you can retrieve data.
4. Use push IDs when you need to create unique identifiers for list-type data.
   ```dart
   // Generate a unique key
   final newPostKey = FirebaseDatabase.instance.ref().child('posts').push().key;
   ```
5. Denormalize data when necessary to avoid complex joins, as Realtime Database doesn't support joins natively.
6. Keep your data structure shallow to improve read and write performance.
7. When creating your own keys, they must be UTF-8 encoded, can be a maximum of 768 bytes, and cannot contain `.`, `$`, `#`, `[`, `]`, `/`, or ASCII control characters 0-31 or 127.
8. Do not use ASCII control characters in the values themselves.

### Indexing and Querying

1. Queries can sort or filter on a property, but not both in the same query.
2. Index your data structure for frequently accessed paths to improve read performance.
3. Use the `.indexOn` rule in your security rules to specify which child keys should be indexed.
   ```json
   {
     "rules": {
       "dinosaurs": {
         ".indexOn": ["height", "length"]
       }
     }
   }
   ```
4. Be aware that queries are deep by default and always return the entire subtree.
5. Use the `orderByChild()`, `orderByKey()`, or `orderByValue()` methods to specify how data should be sorted.
   ```dart
   // Order results by child value
   final ref = FirebaseDatabase.instance.ref("dinosaurs");
   final query = ref.orderByChild("height");
   ```
6. Limit query results using `limitToFirst()` or `limitToLast()` to improve performance and reduce data transfer.
   ```dart
   // Get first 10 dinosaurs ordered by height
   final query = ref.orderByChild("height").limitToFirst(10);
   ```

### Read and Write Operations

1. Use asynchronous calls instead of synchronous calls to minimize latency impact.
   ```dart
   // Read data once
   final snapshot = await FirebaseDatabase.instance.ref('users/123').get();
   if (snapshot.exists) {
     print(snapshot.value);
   }
   ```
2. Use listeners for real-time updates rather than repeatedly polling for data.
   ```dart
   // Set up a listener
   FirebaseDatabase.instance.ref('users/123').onValue.listen((event) {
     final data = event.snapshot.value;
     print(data);
   });
   ```
3. Use `set()` to write or replace data at a specific reference.
   ```dart
   await ref.set({
     "name": "John",
     "age": 18,
     "address": {
       "line1": "100 Mountain View"
     }
   });
   ```
4. Use `update()` to update specific fields without overwriting the entire object.
   ```dart
   await ref.update({
     "age": 19,
   });
   ```
5. Use transactions for operations that require atomic updates.
   ```dart
   FirebaseDatabase.instance.ref('posts/123/likes').runTransaction((currentValue) {
     return (currentValue as int? ?? 0) + 1;
   });
   ```
6. Use multi-path updates to update multiple locations atomically.
   ```dart
   final updates = <String, dynamic>{
     'posts/$postId': postData,
     'user-posts/$uid/$postId': postData,
   };
   FirebaseDatabase.instance.ref().update(updates);
   ```
7. Keep individual write operations under 256KB to comply with size limits.
8. Be aware that a `DatabaseEvent` is fired every time data is changed at the specified reference, including changes to children.

### Designing for Scale

1. Be aware that Realtime Database scales to around 200,000 concurrent connections and 1,000 writes/second in a single database.
2. For applications requiring higher scale, shard your data across multiple database instances.
3. Avoid storing large blobs of data; use Firebase Storage instead for files.
4. Use server timestamps for consistent time tracking across clients.
   ```dart
   final serverTimestamp = ServerValue.timestamp;
   FirebaseDatabase.instance.ref('posts/123/timestamp').set(serverTimestamp);
   ```
5. Implement fan-out patterns for data that needs to be accessed from multiple paths.
6. Monitor your database usage and performance using Firebase console.
7. Flatten data structures to avoid deep nesting, which can lead to performance issues when retrieving data.

### Offline Capabilities

1. Enable disk persistence to allow your app to work offline.
   ```dart
   FirebaseDatabase.instance.setPersistenceEnabled(true);
   ```
2. Use `keepSynced(true)` for critical paths that should be kept in sync even when offline.
   ```dart
   FirebaseDatabase.instance.ref('important-data').keepSynced(true);
   ```
3. Handle connection state changes to provide feedback to users.
   ```dart
   FirebaseDatabase.instance.ref('.info/connected').onValue.listen((event) {
     final connected = event.snapshot.value as bool? ?? false;
     print('Connected: $connected');
   });
   ```
4. Implement proper error handling for operations that may fail due to connectivity issues.
5. Be aware of the cache size limitations when enabling persistence.
6. Generally, use value events to read data and get notified of updates from the backend, which reduces usage and billing and is optimized for online/offline transitions.
7. Use `get()` only when you need the data once, as it will probe the local storage cache if the server value is unavailable.

### Security

1. Always use Firebase Realtime Database Security Rules to protect your data.
2. Structure security rules to match your data structure for efficient validation.
3. Use the `auth` variable to authenticate users in security rules.
4. Validate data structure and content using the `validate` rule.
5. Be aware that read and write rules cascade in Realtime Database.
6. Use the `.read`, `.write`, `.validate`, and `.indexOn` rules to control access and validate data.
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
7. Test your security rules thoroughly using the Firebase console's rules simulator.
8. For testing purposes, you can use the Firebase Emulator Suite to prototype and test Realtime Database functionality locally.
