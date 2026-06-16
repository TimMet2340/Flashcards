# Flashcards

A primitive App for the Creation of Learn Cards so called **Flashcards** divided in different Groups regar. In the following Doc. I will explain some of the main interactions wich should be possible for potential user of this Application.

## Get started

What's important when working on the project or reviewing it.

> [!NOTE]
> **Where is the code written?**
> All the written dart files which are the base of the project are located in the `/lib` folder.
> Every other folder exists for plattform specific konfiguration and else.

**Installing the projects packages**
To not encounter errors when running der project in debug mode it's nessesary to install the packages used in the project, which are located in the `pubspec.yaml`.
Run following before debugging in the terminal to fetch all packages: `flutter pub get`

### Further Material for Flutter

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Important Flutter Commands

## Run in development mode

**In Visual Studio**
1. choose plattform at the bottom right
2. press F5 to start debug mode (with autorefresh, after changes)

**From the terminal**
1. flutter run -d [f.e. chrome or other plattforms]

## Testing and analysation

`flutter analyze`: efficient way to find errors in the code directly from the terminal

`flutter test`: ...

### Creating the App (building process for deployment)

`flutter build web`: build single page website which can be runned with a webserver
    -> will be created in the build directory
    -> the web directory can be pulled from the gtihub directly onto a webserver
`flutter build apk`: build runable package file for android installation

`flutter flutter clean`: clean build directory

### Manage Packages

`flutter pub add <package_name>`: Installs a package and automatically updates pubspec.yaml

`flutter pub add -d <package_name>`: Adds a package specifically as a development dependency

`flutter pub get`: Fetches all packages declared in your pubspec.yaml file

`flutter pub remove <package_name>`: Uninstalls a package and strips it from pubspec.yaml

`flutter pub upgrade`: Updates all project dependencies to their latest compatible versions

`flutter pub outdated`: Analyzes dependencies to discover outdated versions and updates

// Ensure card IDs are unique and positive. If incoming cards contain
    // invalid (<=0) or duplicate IDs (e.g. both placeholders with id 0),
    // reassign sequential IDs starting at 1. Otherwise set nextId to maxId+1.
    if (this.cards.isNotEmpty) {
      final ids = this.cards.map((c) => c.id).toList();
      final hasInvalid = ids.any((id) => id <= 0) || ids.toSet().length != ids.length;
      if (hasInvalid) {
        int idCounter = 1;
        for (var c in this.cards) {
          c.id = idCounter++;
        }
        nextId = idCounter;
      } else {
        final maxId = ids.reduce((a, b) => a > b ? a : b);
        nextId = maxId + 1;
      }
    } else {
      nextId = 1;
    }