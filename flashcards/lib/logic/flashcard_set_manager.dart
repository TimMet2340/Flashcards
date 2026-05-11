// flashcard_set_manager.dart
import 'dart:convert';
import 'dart:html'; // Nur für Web!
import 'package:flashcards/models/flashcard_set.dart';

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
    final String? rawData = window.localStorage[_storageKey];
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
    window.localStorage[_storageKey] = jsonEncode(data);
  }

  // Set hinzufügen
  void addSet(String name) {
    allSets.add(FlashcardSet(name: name));
    saveAll();
  }
}
