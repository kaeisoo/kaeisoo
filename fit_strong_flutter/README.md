# Fit & Strong — Flutter Android App

A dark fitness tracker with neon-lime accents, inspired by the reference design.

## Screens
- **Home:** daily challenge, progress gauge, calories, heart rate, and workout duration.
- **Workouts:** category filters, featured plan, workout library, and a start/complete session flow.
- **Progress:** day/week/month activity, step goals, metrics, and recent workouts.
- **Profile:** member summary, activity stats, and preference rows.

## Requirements
- Flutter stable with Dart 3.6 or newer.
- Android Studio and Android SDK, or an Android phone with USB debugging enabled.

## Run on Android

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Create a release APK:

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`.

## Automated build
The repository workflow `.github/workflows/android-build.yml` generates Android runner files when missing, runs `flutter analyze`, runs the widget tests, and builds a release APK. It publishes the APK and a source archive as GitHub Actions artifacts.

## Current scope
This is a functional front-end prototype. Navigation, category filters, workout start/completion, and period switching are interactive. Metrics are demonstration values. Account authentication, cloud sync, device step sensors, GPS tracking, and persistent workout history are not connected yet.
