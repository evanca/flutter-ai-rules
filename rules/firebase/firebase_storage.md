# Firebase Storage Rules

### Setup and Configuration

1. Install the Firebase Storage plugin using `flutter pub add firebase_storage`.
2. Import the plugin in your Dart code using `import 'package:firebase_storage/firebase_storage.dart';`.
3. Make sure your Firebase project is on the Blaze (pay-as-you-go) plan as Firebase Storage requires it.
4. **Important**: Starting with the announced changes in September 2024, the Blaze plan will be required to use Firebase Storage, even for default buckets.
5. Run `flutterfire configure` from your Flutter project directory to update the Firebase config file with your default Storage bucket name.
6. Access your Cloud Storage bucket by creating an instance of `FirebaseStorage`:
   ```dart
   final storage = FirebaseStorage.instance;
   
   // Alternatively, explicitly specify the bucket name URL
   // final storage = FirebaseStorage.instanceFor(bucket: "gs://BUCKET_NAME");
   ```

### Security and Access Control

**Important Security Note**: By default, a Cloud Storage bucket requires Firebase Authentication to perform any action on the bucket's data or files. You can change your Firebase Security Rules for Cloud Storage to allow unauthenticated access, but configuring public access may make newly uploaded App Engine files publicly accessible as well. Be sure to restrict access to your Cloud Storage bucket again when you set up Authentication.

1. Use Firebase Security Rules to control access to your Cloud Storage files.
2. Combine Cloud Storage rules with Firebase Authentication for user-based access control.
3. Test your security rules thoroughly before deploying to production.
4. Monitor access patterns and adjust rules as needed for your app's requirements.

### File Operations

1. Create references to files using `FirebaseStorage.instance.ref()` with the file path.
   ```dart
   final storageRef = FirebaseStorage.instance.ref();
   final fileRef = storageRef.child("uploads/file.jpg");
   ```
2. Upload files using `putFile()`, `putData()`, or `putString()` methods.
   ```dart
   final uploadTask = fileRef.putFile(file);
   final snapshot = await uploadTask;
   final downloadUrl = await snapshot.ref.getDownloadURL();
   ```
3. Download files using `getData()` for in-memory download or `getDownloadURL()` for URL-based download.
   ```dart
   final data = await fileRef.getData();
   final downloadUrl = await fileRef.getDownloadURL();
   ```
4. Delete files using the `delete()` method on the file reference.
   ```dart
   await fileRef.delete();
   ```

### Metadata Management

1. Get file metadata using `getMetadata()` to retrieve information about uploaded files.
   ```dart
   final metadata = await fileRef.getMetadata();
   print('Content type: ${metadata.contentType}');
   print('Size: ${metadata.size}');
   ```
2. Update file metadata using `updateMetadata()` to change properties like content type.
   ```dart
   final newMetadata = SettableMetadata(
     contentType: "image/jpeg",
     customMetadata: {'uploaded_by': 'user123'},
   );
   await fileRef.updateMetadata(newMetadata);
   ```
3. Use custom metadata to store additional key/value pairs with your files.

### Error Handling

1. Handle common Storage errors using try-catch blocks with `FirebaseException`.
2. Check for specific error codes to provide appropriate user feedback:
   - `storage/object-not-found`: File doesn't exist at the reference
   - `storage/bucket-not-found`: No bucket is configured for Cloud Storage
   - `storage/project-not-found`: No project is configured for Cloud Storage
   - `storage/quota-exceeded`: Storage quota has been exceeded
   - `storage/unauthenticated`: User needs to authenticate
   - `storage/unauthorized`: User doesn't have permission for the operation
   - `storage/retry-limit-exceeded`: Operation timeout exceeded
3. For quota-exceeded errors on the Spark plan, consider upgrading to the Blaze plan.
4. Implement retry logic for network-related errors and timeouts.

### Performance and Best Practices

1. Use appropriate file upload methods based on your data source (File, Uint8List, or String).
2. Monitor upload progress using upload task streams for better user experience.
   ```dart
   final uploadTask = fileRef.putFile(file);
   uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
     print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
   });
   ```
3. Cancel upload operations when needed using `cancel()` on the upload task.
4. Pause and resume uploads using `pause()` and `resume()` methods.
5. Use Firebase Storage with other Firebase services like Firestore for comprehensive data management.
6. Consider implementing offline capabilities for critical file operations.
7. Optimize file sizes before upload to reduce storage costs and improve performance.

### Testing and Development

1. Test file operations with different file types and sizes during development.
2. Verify that security rules work correctly for your app's use cases.
3. Test offline scenarios to ensure proper error handling.
4. Monitor storage usage and costs in the Firebase console.
5. Use Firebase Local Emulator Suite for local development and testing.
