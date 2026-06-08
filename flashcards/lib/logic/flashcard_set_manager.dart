// flashcard_set_manager.dart
import 'dart:convert';
import 'package:flashcards/models/flashcard_set.dart';

// Use conditional import so non-web platforms (tests, Android, iOS, desktop)
// don't try to import dart:html which isn't available there.
import 'storage_io.dart' if (dart.library.html) 'storage_web.dart';

class FlashcardSetManager {
  static final FlashcardSetManager _instance = FlashcardSetManager._internal();

  factory FlashcardSetManager() {
    return _instance;
  }

  FlashcardSetManager._internal();

  // Datenliste
  List<FlashcardSet> allSets = [];
  final String _storageKey = 'flashcard_app_data';

  // Daten vom LocalStorage laden
  void importAll() {
    final String? rawData = localStorage[_storageKey];
    if (rawData != null && rawData.isNotEmpty) {
      try {
        List<dynamic> decoded = jsonDecode(rawData);
        allSets = decoded.map((map) => FlashcardSet.fromMap(map)).toList();
      } catch (e) {
        print("Fehler beim Import: $e");
        allSets = [];
      }
    }
  }

  // Alles sicher auf die Platte schreiben
  void saveAll() {
    List<Map<String, dynamic>> data = allSets
        .map((set) => set.toMap())
        .toList();
    localStorage[_storageKey] = jsonEncode(data);
  }

  // Set hinzufügen
  void addSet(String name) {
    allSets.add(FlashcardSet(name: name));
    saveAll();
  }
}
