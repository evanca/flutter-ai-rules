---
name: firebase-storage
description: Integrates Firebase Cloud Storage into Flutter apps. Use when setting up Storage, uploading or downloading files, managing metadata, handling errors, or applying security rules.
---

# Firebase Cloud Storage Skill

This skill defines how to correctly use Firebase Cloud Storage in Flutter applications.

## When to Use

Use this skill when:

* Setting up Cloud Storage in a Flutter project.
* Uploading or downloading files.
* Managing file metadata.
* Handling Storage errors and monitoring upload progress.

---

## 1. Setup and Configuration

```
flutter pub add firebase_storage
```

```dart
import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;
// Or specify a bucket explicitly:
// final storage = FirebaseStorage.instanceFor(bucket: "gs://BUCKET_NAME");
```

- Firebase Storage requires the **Blaze (pay-as-you-go) plan**.
- Run `flutterfire configure` to update your Firebase config with the default Storage bucket name.

> **Security note:** By default, a Cloud Storage bucket requires Firebase Authentication for any action. Configuring public access may also make App Engine files publicly accessible — restrict access again when you set up Authentication.

---

## 2. File Operations

**Create a reference:**

```dart
final storageRef = FirebaseStorage.instance.ref();
final fileRef = storageRef.child("uploads/file.jpg");
```

**Upload:**

```dart
final uploadTask = fileRef.putFile(file);
final snapshot = await uploadTask;
final downloadUrl = await snapshot.ref.getDownloadURL();
```

**Download (in-memory):**

```dart
final data = await fileRef.getData();
```

**Download URL:**

```dart
final downloadUrl = await fileRef.getDownloadURL();
```

**Delete:**

```dart
await fileRef.delete();
```

---

## 3. Metadata Management

**Get metadata:**

```dart
final metadata = await fileRef.getMetadata();
print('Content type: ${metadata.contentType}');
print('Size: ${metadata.size}');
```

**Update metadata:**

```dart
final newMetadata = SettableMetadata(
  contentType: "image/jpeg",
  customMetadata: {'uploaded_by': 'user123'},
);
await fileRef.updateMetadata(newMetadata);
```

Use **custom metadata** to store additional key/value pairs with your files.

---

## 4. Error Handling

Use `try-catch` with `FirebaseException`. Key error codes:

| Code | Meaning |
|---|---|
| `storage/object-not-found` | File doesn't exist at the reference |
| `storage/bucket-not-found` | No bucket configured for Cloud Storage |
| `storage/project-not-found` | No project configured for Cloud Storage |
| `storage/quota-exceeded` | Storage quota exceeded |
| `storage/unauthenticated` | User needs to authenticate |
| `storage/unauthorized` | User lacks permission |
| `storage/retry-limit-exceeded` | Operation timeout exceeded |

- For `quota-exceeded` on the Spark plan, upgrade to Blaze.
- Implement retry logic for network-related errors and timeouts.

---

## 5. Performance and Best Practices

**Monitor upload progress:**

```dart
final uploadTask = fileRef.putFile(file);
uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
});
```

- **Cancel** uploads with `uploadTask.cancel()`.
- **Pause / resume** with `uploadTask.pause()` and `uploadTask.resume()`.
- Optimize file sizes before upload to reduce costs and improve performance.
- Use Cloud Storage with Firestore for comprehensive data management.
- Use the **Firebase Local Emulator Suite** for local development and testing.

---

## 6. Security

- Use **Firebase Security Rules** to control access to files.
- Combine Storage rules with **Firebase Authentication** for user-based access control.
- Test security rules thoroughly before deploying to production.

---

## References

- [Firebase Cloud Storage Flutter documentation](https://firebase.google.com/docs/storage/flutter/start)
- [Upload files](https://firebase.google.com/docs/storage/flutter/upload-files)
- [Download files](https://firebase.google.com/docs/storage/flutter/download-files)
- [Handle errors](https://firebase.google.com/docs/storage/flutter/handle-errors)
