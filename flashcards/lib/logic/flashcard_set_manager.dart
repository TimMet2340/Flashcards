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
        final dynamic decodedRaw = jsonDecode(rawData);
        final List<dynamic> decoded = decodedRaw is List ? decodedRaw : [];
        allSets = decoded
            .map((map) => FlashcardSet.fromMap(Map<String, dynamic>.from(map)))
            .toList();
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

  void init() {
    // Erstelle zwei Standard-Sets mit den Platzhalter-Flashcards aus dem Model
    allSets = [FlashcardSet(name: 'set1'), FlashcardSet(name: 'set2')];

    // Direkt speichern
    saveAll();
  }

  @override
  String toString() {
    String x = "";
    for (var e in allSets) {
      x = x + e.toString();
    }
    return x;
  }
}

// Simple top-level main for quick testing with `dart run`.
void main() {
  final manager = FlashcardSetManager();
  manager.init();

  final manager2 = FlashcardSetManager();
  manager2.importAll();

  print(manager2.toString());
}
