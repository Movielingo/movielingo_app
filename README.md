# 🎬 Movielingo App

**Movielingo** is an innovative language learning application powered by Flutter. It leverages the power of movies to offer an immersive and interactive language learning experience.

## 🔑 Key Features

- **Authentication**: Secure sign-in and sign-up using Firebase and [Google Sign-In](https://pub.dev/packages/google_sign_in)
- **Movie Listing**: Comprehensive display of movies, dynamically fetched from Firebase. The movie images are clickable, leading to the movie details page.
- **Movie Details**: Detailed information about the movie, including the title, release year, genre, and a brief synopsis. Using Firebase storage to store image files, the app also displays the movie poster.
- **User Profile Management**: Easy retrieval and editing of user details like name, email, first language, and target language.
- **Vocabulary Box**: A dedicated space to store the user's movies and series vocabulary.
- **Vocabulary Trainer**: The user can see the words, their meanings, and the context in which they were used in the movie. The user can also test their knowledge and track their progress.
- **Security**: Robust logout functionality ensuring data privacy and security (WIP)

## 🛠️ Technology Stack

- **Frontend**: Built with Flutter, a versatile UI toolkit for building natively compiled applications.
- **Backend**: Firestore - a flexible, scalable NoSQL cloud database from Google Firebase, known for real-time data synchronization and robust offline capabilities.

## 🏛 Software Architecture

Movielingo uses a Firebase Firestore database to store user data, movie details, vocabulary, the user's movies, the user's vocabulary and the user's progress. For more information on the database, please refer to [Movielingo Database](https://github.com/Movielingo/.github/blob/main/profile/README.md#-database).

For all possible CRUD operations, please refer to [Movielingo CRUD Operations](https://github.com/Movielingo/.github/blob/main/profile/README.md#-contribution-list).

### 🕹️ Models

Movielingo uses various models to represent the data stored in the Firestore database. Some of the models include:

- **User**: Represents a user in the database with attributes like name, email, first language, target language, and the CSRFLevel of the user.

- **Movie**: Represents a movie in the database with attributes like title, genre, release year, and the vocabulary words connected to this movie.

- **UserMovie**: Represents a user's movie in the database with attributes like the movie ID, the user ID, and the progress of the user in this movie.

- **UserVocabulary**: Represents a user's vocabulary in the database with attributes like the word lemma, the word type, the word level, the user ID, the userMediaId, sentences containing the word, and the translation of the word.

### 🤝 Services

Movielingo uses various services to interact with the Firestore database. Some of the services include:

- **AuthService**: Provides methods to interact with the Authentication collection in the Firestore database, e.g., signing in, signing out, and registering a user.

- **UserService**: Provides methods to interact with the User collection in the Firestore database.

- **MediaService**: Provides methods to interact with the Movie collection in the Firestore database, e.g., fetching all movies, fetching a specific movie, and fetching the vocabulary of a specific movie.

- **UserMediaService**: Provides methods to interact with the UserMovie collection in the Firestore database, e.g., fetching all user movies, fetching a specific user movie, and updating the progress of a user movie.

- **VocabularyService**: Provides methods to interact with the UserVocabulary collection in the Firestore database, e.g., fetching all user vocabulary of a specific movie/series or adding new vocabulary to the user's vocabulary.

## 🚀 Getting Started

If you're new to Flutter, these resources will help you hit the ground running:

- [Flutter First Steps](https://docs.flutter.dev/get-started/codelab): A hands-on guide to creating your first Flutter app.
- [Flutter Cookbook](https://docs.flutter.dev/cookbook): A collection of useful Flutter techniques and examples.
- [Flutter Documentation](https://docs.flutter.dev/): Comprehensive resources including tutorials, samples, and a detailed API reference.

## ⚙️ Installation Guide

1. **Clone the Repository**:

   ```
   git clone https://github.com/yourusername/movielingo_app.git
   ```

2. **Setup Environment**:

   - Install Flutter and Dart SDKs: Instructions available [here](https://flutter.dev/docs/get-started/install).

3. **Install Dependencies**:

   ```
   flutter pub get
   ```

4. **Run the Application**:

   ```
   flutter run
   ```

## ⚙️ Tests

Run all Unit Tests:

```
flutter test
```
