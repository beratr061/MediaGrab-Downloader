# Contributing to MediaGrab

Thank you for your interest in contributing to MediaGrab!

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/mediagrab.git`
3. Create a feature branch: `git checkout -b feature/amazing-feature`
4. Make your changes
5. Test your changes thoroughly
6. Commit your changes: `git commit -m 'Add amazing feature'`
7. Push to your fork: `git push origin feature/amazing-feature`
8. Open a Pull Request

## Development Setup

### Prerequisites
- Flutter SDK 3.9.0 or higher
- Dart SDK
- Git

### Setup Steps

```bash
# Install dependencies
flutter pub get

# Download binaries
# Windows
powershell -ExecutionPolicy Bypass -File scripts/download_binaries_simple.ps1

# macOS/Linux
bash scripts/download_binaries.sh

# Run the app
flutter run
```

## Code Style

- Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Write tests for new features

## Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## Pull Request Guidelines

- Keep PRs focused on a single feature or fix
- Update documentation if needed
- Add tests for new features
- Ensure all tests pass
- Follow the existing code style
- Write clear commit messages

## Reporting Issues

When reporting issues, please include:
- Operating system and version
- Flutter version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots if applicable

## Feature Requests

We welcome feature requests! Please:
- Check if the feature already exists
- Clearly describe the feature
- Explain why it would be useful
- Provide examples if possible

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Help others learn and grow

## Questions?

Feel free to open an issue for any questions or concerns.

Thank you for contributing! 🎉
