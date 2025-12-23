# Flutter Project Setup

This document describes the Flutter project structure setup for the Autohelm app.

## Overview

The Autohelm app is built using Flutter, a cross-platform mobile development framework. This setup follows Flutter best practices and organizes the codebase for maintainability and scalability.

## Project Structure

```
autohelm_app/
├── android/                    # Android-specific files
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── kotlin/        # Kotlin source files
│   │   │   └── res/           # Android resources
│   │   └── build.gradle       # Android app build configuration
│   └── settings.gradle        # Android project settings
├── ios/                       # iOS-specific files
│   └── Runner/
│       ├── AppDelegate.swift  # iOS app delegate
│       └── Info.plist         # iOS app configuration
├── lib/                       # Dart source code
│   ├── models/               # Data models
│   ├── services/             # Business logic and services
│   ├── ui/                   # User interface components
│   │   ├── screens/         # Full-screen views
│   │   └── widgets/         # Reusable UI components
│   ├── utils/               # Utility functions
│   └── main.dart            # App entry point
├── test/                     # Test files
│   ├── models/
│   ├── services/
│   └── ui/
├── analysis_options.yaml     # Dart analyzer configuration
├── pubspec.yaml             # Dependencies and project metadata
└── .gitignore               # Git ignore rules
```

## Dependencies

The project includes the following dependencies as specified in `pubspec.yaml`:

### Production Dependencies
- **flutter**: The Flutter SDK
- **provider** (^6.0.0): State management solution
- **http** (^1.1.0): HTTP networking library
- **shared_preferences** (^2.2.0): Local storage for settings

### Development Dependencies
- **flutter_test**: Testing framework
- **flutter_lints** (^2.0.0): Linting rules for Flutter
- **mockito** (^5.4.0): Mocking library for tests
- **build_runner** (^2.4.0): Code generation tool

## Directory Structure Details

### `/lib/models`
Contains data model classes that represent the core data structures:
- COG (Course Over Ground) data
- Connection status
- NMEA message structures
- App settings

### `/lib/services`
Houses service classes for business logic:
- WiFi connection management
- NMEA0183 protocol handling
- Settings persistence
- Network communication

### `/lib/ui`
User interface components:
- **screens/**: Complete page/screen widgets
- **widgets/**: Reusable UI components

### `/lib/utils`
Utility functions and helpers:
- Formatters
- Validators
- Constants
- Helper functions

### `/test`
Mirror structure of `/lib` for organized testing:
- Unit tests for models and services
- Widget tests for UI components
- Integration tests

## Platform Configuration

### Android
- **Namespace**: com.autohelm.app
- **Min SDK**: Set by Flutter (typically API 21)
- **Target SDK**: Latest available
- **Permissions**: INTERNET (for WiFi communication)

### iOS
- **Bundle ID**: com.autohelm.app
- **Deployment Target**: Set by Flutter (typically iOS 12+)
- **Supported Orientations**: Portrait, Landscape Left, Landscape Right

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (included with Flutter)
- Android Studio or Xcode (for mobile development)

### Setup Instructions

1. **Install Flutter**
   ```bash
   # Follow instructions at https://flutter.dev/docs/get-started/install
   ```

2. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd autohelm_app
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Verify installation**
   ```bash
   flutter doctor
   ```

5. **Run the app**
   ```bash
   # For Android
   flutter run

   # For iOS (macOS only)
   flutter run -d ios
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Code Analysis

```bash
# Run static analysis
flutter analyze

# Format code
flutter format lib/ test/
```

## Development Workflow

1. **Code Organization**: Keep code organized according to the directory structure
2. **State Management**: Use Provider for state management
3. **Testing**: Write tests for new features and bug fixes
4. **Linting**: Follow Flutter linting rules (see `analysis_options.yaml`)
5. **Code Review**: Ensure code passes analysis before committing

## Build Configuration

### Debug Build
```bash
# Android
flutter build apk --debug

# iOS
flutter build ios --debug
```

### Release Build
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ipa --release
```

## Next Steps

With the project structure in place, the next tasks are:
1. Create architecture documentation (Issue #2)
2. Document NMEA0183 protocol requirements (Issue #3)
3. Implement data models (Issue #6)
4. Build the WiFi connection manager (Issue #4)

## References

- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
