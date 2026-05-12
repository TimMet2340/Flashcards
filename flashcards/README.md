# Flashcards

A primitive App for the Creation of Learn Cards so called **Flashcards** divided in different Groups regar. In the following Doc. I will explain some of the main interactions wich should be possible for potential user of this Application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Important Flutter Commands

### Creating the App

flutter build web: build single page website which can be runned with a webserver
    -> will be created in the build directory
    -> the web directory can be pulled from the gtihub directly onto a webserver
flutter build apk -> build runable package file for android installation

flutter flutter clean -> clean build directory

### Edit Packages

flutter pub add <package_name>: Installs a package and automatically updates pubspec.yaml

flutter pub add -d <package_name>: Adds a package specifically as a development dependency

flutter pub get: Fetches all packages declared in your pubspec.yaml file

flutter pub remove <package_name>: Uninstalls a package and strips it from pubspec.yaml

flutter pub upgrade: Updates all project dependencies to their latest compatible versions

flutter pub outdated: Analyzes dependencies to discover outdated versions and updates

