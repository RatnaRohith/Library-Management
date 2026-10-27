# BookNest — Flutter Library Book App

A beginner-friendly Flutter project demonstrating:
- Login form validation and local JSON authentication
- Logout button with confirmation dialog
- Credentials persisted in an app-private `credentials.json` file; passwords stored as SHA-256 hashes
- Four screens/flows: Login, Explore/Catalogue, Book Details, My Library
- Responsive book grid
- `setState()` for local UI state and Provider for shared library state
- Reusable custom theme, button, and book card
- AnimatedSwitcher, AnimatedOpacity, and Hero transitions
- REST API integration with Open Library
- Unit and widget tests

## Run the app

1. Install Flutter and configure an Android emulator, desktop target, or device.
2. Open this folder in VS Code.
3. Run:

```bash
flutter pub get
flutter run
```

## Demo login

- Email: `student@library.com`
- Password: `Library123`

On first launch, these demo credentials are written to the app-private `credentials.json` file. The file is stored in the platform application documents directory, not in the read-only Flutter assets folder. Passwords are stored as SHA-256 hashes rather than plain text. This local-only demonstration is not production-grade authentication.

## Run tests and analysis

```bash
flutter test
flutter analyze
```

## Local credentials

The app creates `credentials.json` in the platform-specific application documents directory on first login. The file contains a `users` array with email addresses and password hashes. Use **New here? Create a local account** on the login page to save additional credentials. Logging out returns to the login screen and does not delete saved credentials. Logging out returns to the login screen and does not delete saved credentials.

## API

The catalogue uses Open Library Search API. An internet connection is required. Results and cover images may occasionally be missing.

## Notes

- Borrowing and favourites are stored in memory using Provider and reset when the app restarts. Login credentials persist in the local JSON file.
- The app does not reserve physical library copies; borrowing is a local demonstration.
- On Android, make sure `android.permission.INTERNET` is present in `android/app/src/main/AndroidManifest.xml`.
- To create platform folders if needed, run `flutter create .` from this directory.
