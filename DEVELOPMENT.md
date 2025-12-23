# Autohelm App - Development Guide

## Quick Start

This is a Flutter project. To get started with development:

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Android Studio / Xcode for platform-specific development
- Git

### Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

3. Run tests:
```bash
flutter test
```

## Project Structure

See [Flutter Setup Documentation](docs/flutter-setup.md) for detailed information about the project structure and architecture.

## Key Directories

- `lib/models` - Data models
- `lib/services` - Business logic and services
- `lib/ui/screens` - Screen widgets
- `lib/ui/widgets` - Reusable UI components
- `lib/utils` - Utility functions
- `test/` - Test files

## Testing

### Running Tests
```bash
# All tests
flutter test

# Specific test
flutter test test/widget_test.dart

# With coverage
flutter test --coverage
```

### Test Structure
Tests should mirror the `lib/` directory structure:
- Unit tests for models and services
- Widget tests for UI components
- Integration tests for full flows

## Linting

The project uses `flutter_lints` for code quality:

```bash
# Check for issues
flutter analyze

# Format code
flutter format lib/ test/
```

## Building

### Debug Builds
```bash
flutter build apk --debug          # Android
flutter build ios --debug          # iOS
```

### Release Builds
```bash
flutter build apk --release        # Android APK
flutter build appbundle --release  # Android App Bundle
flutter build ipa --release        # iOS
```

## Dependencies

Key dependencies used in this project:
- **provider**: State management
- **http**: Networking
- **shared_preferences**: Local storage

See `pubspec.yaml` for the complete list.

## Additional Documentation

- [Flutter Setup](docs/flutter-setup.md) - Detailed project setup
- [MVP Implementation Plan](docs/mvp-implementation-plan.md) - Development roadmap
- [Rationale](docs/rationale.md) - Project background
