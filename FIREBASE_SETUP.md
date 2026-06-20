# Firebase setup

The app contains production authentication and Firestore integrations, but no
project-specific Firebase keys are committed. Until configuration is supplied,
HomeFit starts in demo mode so the UI remains usable.

## 1. Create and connect a Firebase project

Install the Firebase and FlutterFire CLIs, sign in, then run:

```shell
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

Select Android, iOS, and web. This creates `lib/firebase_options.dart` and the
platform configuration files. Update `FirebaseService.initialize()` to pass:

```dart
options: DefaultFirebaseOptions.currentPlatform
```

and import the generated options file.

## 2. Enable authentication providers

In Firebase Console > Authentication > Sign-in method:

- Enable Email/Password
- Enable Google

For Android Google login, add the debug and release SHA-1/SHA-256 fingerprints
to the Firebase app and download the refreshed `google-services.json`.

For iOS, follow the generated `GoogleService-Info.plist` URL-scheme setup.

## 3. Create Firestore

Create a Firestore database, then deploy the included user-scoped rules:

```shell
firebase deploy --only firestore
```

Collections created by the app:

```text
users/{uid}
users/{uid}/weights/{entryId}
users/{uid}/workoutHistory/{workoutId}
```

The user document stores profile data, current weight, daily streak, and the
last workout date.
