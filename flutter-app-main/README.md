# new_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Flutter Project Setup

Follow these steps to run the project on your local machine.

## 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-name>
```

## 2. Verify Flutter Installation

```bash
flutter doctor
```

Resolve any issues reported by `flutter doctor` before proceeding.

## 3. Install Dependencies

```bash
flutter pub get
```

## 4. Run the Application

### List available devices

```bash
flutter devices
```

### Run the app

```bash
flutter run
```

Or specify a device:

```bash
flutter run -d <device-id>
```

## 5. If You Encounter Build Issues

Clean the project and reinstall dependencies:

```bash
flutter clean
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── core/
├── features/
├── shared/
└── main.dart
```

## Requirements

- Flutter SDK (latest stable version recommended)
- Dart SDK (included with Flutter)
- Android Studio or VS Code
- Android SDK (for Android development)
- Git

## Useful Commands

```bash
# Check Flutter installation
flutter doctor

# Get dependencies
flutter pub get

# Run the app
flutter run

# Clean build files
flutter clean

# Update dependencies
flutter pub upgrade

# Build release APK
flutter build apk
```
