import 'package:flashcards/models/flashcard.dart';
import 'package:collection/collection.dart';
/* import 'dart:convert'; // convert methods for json
import 'dart:html'; // no idea */


// main interface-class for the ui 
class FlashcardSet {
  String name;
  List<Flashcard> cards;

  FlashcardSet ({
    required this.name,
    List<Flashcard>? cards, // at first asked for the unbound paramter cards - can be null
  }) : this.cards = cards ?? [Flashcard.placeholder]; // : x = x - set x as input x; ?? - if null set the stuff behind

  //add flashcard to the Set
  // @override
  void add(String question, String awnser) {
    Flashcard card = Flashcard(id: cards.length, question: question, awnser: awnser);
    cards.add(card);
  }
  /* void add(Flashcard card) {
    cards.add(card);
  }*/

  // get amount of all added cards
  //int getAmount() { return cards.length; }

  // get an List of all remembered card objs
  List<Flashcard> getRemembered() { return cards.where((c) => (c.remembered)).toList(); }

  // get the amount of remembered card objs
  int getAmountRemebered() { return getRemembered().length; }

  // get an List of all unremembered card objs
  List<Flashcard> getUnremembered() { return cards.where((c) => !(c.remembered)).toList(); }

  // get the amount of unremembered card objs
  int getAmountUnremebered() { return getUnremembered().length; }
  
  void sortCards() { cards.sort((a, b) => a.id.compareTo(b.id)); }

  Flashcard? getById(int id) {
    return cards.firstWhereOrNull((c) => c.id == id);
    // binary search not working because of a malfunction between the package and the recent flutter version :(
  }

  List<Flashcard> getCopyOfCards() {
    final List<Flashcard> cardsCopy = cards;
    return cardsCopy;
  }

  void setCardState(int id, bool remembered) {
    
  }

  /* void saveToDisk() {
    List<Map> mappedCards = cards.map((c) => c.toMap()).toList();
    String jsonString = jsonEncode(mappedCards);
    window.localStorage['flashcards_data'] = jsonString;
  } */

 // following two methods: implemented to convert map set to List and the other way arround
 // needed for saving data as json - look at FlashcardSetManager for further information of the saving process
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cards': cards.map((c) => c.toMap()).toList(),
    };
  }

  factory FlashcardSet.fromMap(Map<String, dynamic> map) {
    return FlashcardSet( // calling the constructorasdfasdf
      name: 'name',
      cards: List<Flashcard>.from(
        map['cards'].map((c) => Flashcard.fromMap(map))
      ),
      // cards.map((c) => c.toMap()).toList(),
    );
  }

  // TODO editor mode can be activated inside die flashcardset view
}