import 'package:flashcards/logic/flashcard_set.dart';
import 'dart:convert'; // convert methods for json
import 'dart:html';

class FlashcardSetManager {
  static List<FlashcardSet> allSets = []; // not null!!!
  static String? path = window.localStorage['flashcard_app_data'];

  void addSet(){
    // code
  }

  void saveAll(){
    List<Map> data = allSets.map((set) => {
      'name': set.name,
      'cards': set.cards.map((c) => c.toMap()).toList(),
  }).toList();

  path = jsonEncode(data);
  }

  void importAll(){
    List<Map> rawSets = jsonDecode(path ?? '[]');

    allSets = rawSets.map((map) => 
      FlashcardSet.fromMap(map as Map<String, dynamic>),
    ).toList();
  }
}