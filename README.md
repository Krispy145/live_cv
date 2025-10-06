# CV App

A Flutter application showcasing David Kisbey-Green's CV with GitHub repository integration.

## Features

- **Personal CV Display**: Interactive landing page with experience, education, skills, and portfolio
- **GitHub Projects**: Dynamic loading and display of GitHub repositories with filtering and search
- **Responsive Design**: Works on web and mobile platforms
- **Theme Support**: Light and dark theme modes
- **Caching**: Intelligent caching for GitHub data with stale-while-revalidate pattern

## GitHub Integration

The app includes a Projects page that fetches and displays your GitHub repositories with the following features:

- **Repository Cards**: Display repository information including stars, forks, language, and topics
- **Search**: Real-time search through repository names
- **Topic Filtering**: Filter repositories by topics with multi-select chips
- **Sorting**: Sort by last updated, star count, or name
- **Roadmap Support**: Special handling for the `ai-cyber-security-roadmap` repository
- **Caching**: 15-minute cache with background refresh

## Configuration

### Required Environment Variables

The app requires a GitHub username to fetch repositories. Set this via `--dart-define`:

```bash
flutter run --dart-define=GITHUB_USERNAME=your-github-username
```

### Optional Environment Variables

For increased GitHub API rate limits, you can provide a Personal Access Token:

```bash
flutter run --dart-define=GITHUB_USERNAME=your-github-username --dart-define=GITHUB_TOKEN=your-pat-token
```

### Building for Production

When building for production, include the environment variables:

```bash
# Web
flutter build web --dart-define=GITHUB_USERNAME=your-github-username --dart-define=GITHUB_TOKEN=your-pat-token

# Android
flutter build apk --dart-define=GITHUB_USERNAME=your-github-username --dart-define=GITHUB_TOKEN=your-pat-token

# iOS
flutter build ios --dart-define=GITHUB_USERNAME=your-github-username --dart-define=GITHUB_TOKEN=your-pat-token
```

## Development

### Prerequisites

- Flutter SDK (>=3.0.3)
- Dart SDK
- Firebase CLI (for deployment)

### Running the App

1. Install dependencies:

   ```bash
   flutter packages get
   ```

2. Generate required files:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. Run the app:
   ```bash
   flutter run --dart-define=GITHUB_USERNAME=your-github-username
   ```

### Testing

Run the test suite:

```bash
flutter test
```

## Architecture

The app follows a clean architecture pattern with:

- **Data Layer**: API clients, DTOs, and repositories with caching
- **Domain Layer**: Business logic and entities
- **Presentation Layer**: UI components and state management
- **State Management**: Riverpod for reactive state management

## Dependencies

- **Flutter**: UI framework
- **Riverpod**: State management
- **Dio**: HTTP client for GitHub API
- **SharedPreferences**: Local caching
- **Auto Route**: Navigation
- **MobX**: State management for existing features
- **Firebase**: Analytics and crashlytics

## License

This project is private and proprietary.
