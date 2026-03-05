# Flutter Flavors Configuration

This project uses Flutter flavors to manage different environments: **Development**, **Staging**, and **Production**.

## Available Flavors

| Flavor        | Environment  | App Name     | Application ID Suffix | Entry Point                 |
| :------------ | :----------- | :----------- | :-------------------- | :-------------------------- |
| `development` | Local / Dev  | Kora Dev     | `.dev`                | `lib/main_development.dart` |
| `staging`     | Staging / QA | Kora Staging | `.staging`            | `lib/main_staging.dart`     |
| `production`  | Production   | Kora Chat    | (none)                | `lib/main_production.dart`  |

## How to Run

### Command Line

#### Development (default)

```bash
# Using main.dart (defaults to dev)
flutter run

# Explicitly using flavor
flutter run --flavor development -t lib/main_development.dart
```

#### Staging

```bash
flutter run --flavor staging -t lib/main_staging.dart
```

#### Production

```bash
flutter run --flavor production -t lib/main_production.dart
```

### Build

To build an APK for staging:

```bash
flutter build apk --flavor staging -t lib/main_staging.dart
```

## Adding new Environment Variables

To add a new environment-specific setting:

1. Open `lib/config/app_environment.dart` and add the field to the `AppEnvironment` class.
2. Update the constructors in `lib/main_*.dart` files.
3. Access the setting via `AppConfig` or `AppEnvironment.instance`.
