---
name: firebase-data-connect
description: "Integrate Firebase Data Connect into Flutter apps with schema design, typed queries, mutations, and real-time listeners. Use when setting up Data Connect, implementing GraphQL-based queries and mutations, configuring generated SDKs, handling offline scenarios, or applying security rules and performance optimizations."
---

# Firebase Data Connect Skill

This skill defines how to correctly use Firebase Data Connect in Flutter applications.

## When to Use

Use this skill when:

* Setting up and configuring Firebase Data Connect in a Flutter project.
* Designing schemas, queries, and mutations for Data Connect.
* Implementing generated SDK calls for typed queries and mutations.
* Handling network failures, data inconsistencies, and offline scenarios.
* Applying security and performance best practices.

---

## 1. Setup and Configuration

### Step 1: Install the package

```
flutter pub add firebase_data_connect
```

### Step 2: Import and initialize

```dart
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Step 3: Define a schema in `dataconnect/schema/schema.gql`

```graphql
type Movie @table {
  id: UUID! @default(expr: "uuidV4()")
  title: String!
  releaseYear: Int
  genre: String
  rating: Float
  description: String
}
```

### Step 4: Define queries and mutations in `dataconnect/connector/queries.gql`

```graphql
query ListMovies @auth(level: PUBLIC) {
  movies {
    id
    title
    releaseYear
    genre
    rating
  }
}

mutation CreateMovie($title: String!, $releaseYear: Int, $genre: String) @auth(level: USER) {
  movie_insert(data: {
    title: $title
    releaseYear: $releaseYear
    genre: $genre
  })
}

mutation DeleteMovie($id: UUID!) @auth(level: USER) {
  movie_delete(id: $id)
}
```

### Step 5: Generate the typed Flutter SDK

```
flutterfire generate
```

This produces typed Dart classes for each query and mutation.

**Platform support:**

| Platform | Support |
|---|---|
| iOS | Full |
| Android | Full |
| Web | Full |
| Other platforms | Not supported |

---

## 2. Executing Queries and Mutations

Use the generated SDK to execute typed queries and mutations:

```dart
// Execute a query
final result = await ListMoviesQuery().execute();
final movies = result.data.movies;

// Execute a mutation
await CreateMovieMutation(title: 'Inception', releaseYear: 2010, genre: 'Sci-Fi')
    .execute();

// Delete by ID
await DeleteMovieMutation(id: movieId).execute();
```

### Real-Time Listeners

Subscribe to query changes for live updates:

```dart
final subscription = ListMoviesQuery().subscribe();
subscription.listen((result) {
  final movies = result.data.movies;
  // Update UI with latest movie list
});
```

---

## 3. Performance and Caching

- Design efficient queries requesting only the fields needed to minimize data transfer.
- Implement **pagination** for large datasets:
  ```graphql
  query ListMoviesPaginated($limit: Int!, $offset: Int!) @auth(level: PUBLIC) {
    movies(limit: $limit, offset: $offset) {
      id
      title
      releaseYear
    }
  }
  ```
- Use real-time listeners judiciously to avoid unnecessary network usage.
- Consider **offline capabilities** for critical app functionality by caching query results locally.

---

## 4. Error Handling

Wrap Data Connect calls in try/catch to handle network and validation errors:

```dart
try {
  final result = await ListMoviesQuery().execute();
  return result.data.movies;
} on FirebaseException catch (e) {
  if (e.code == 'unavailable') {
    // Handle offline — return cached data
    return _localCache.getMovies();
  }
  rethrow;
}
```

- Implement **retry logic** with exponential backoff for transient connection errors.
- Provide meaningful error messages for data validation failures.
- Monitor error rates and investigate recurring issues.

---

## 5. Security

- Use `@auth` directives in schema to control access levels (`PUBLIC`, `USER`, `NO_ACCESS`).
- Integrate **Firebase Authentication** for user-based access control.
- Validate data on both client and server sides.
- Follow data privacy best practices when handling user information.

---

## References

- [Firebase Data Connect documentation](https://firebase.google.com/docs/data-connect)
- [Data Connect Flutter SDK reference](https://firebase.google.com/docs/data-connect/flutter-sdk)
