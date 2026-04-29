import 'package:flashcards/models/flashcard_set.dart';
import 'dart:convert'; // convert methods for json
import 'dart:html';

class FlashcardSetManager {
  static List<FlashcardSet> allSets = []; // not null!!!
  static String? path = window.localStorage['flashcard_app_data'];

  // senseless functionjh
  void addSet() {
    // code
  }

  void saveAll() {
    List<Map<String, dynamic>> data = allSets
        .map((set) => set.toMap())
        .toList();

    path = jsonEncode(data);
  }

  /*'name': set.name,
  'cards': set.cards.map((c) => c.toMap()).toList(),*/

  void importAll() {
    List<Map> rawSets = jsonDecode(path ?? '[]');

    allSets = rawSets
        .map((map) => FlashcardSet.fromMap(map as Map<String, dynamic>))
        .toList();
  }
}
