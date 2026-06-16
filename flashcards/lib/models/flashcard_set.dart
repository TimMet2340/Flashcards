import 'package:flashcards/models/flashcard.dart';
import 'package:collection/collection.dart';
/* import 'dart:convert'; // convert methods for json
import 'dart:html'; // no idea */

// main interface-class for the ui
class FlashcardSet {
  String name;
  List<Flashcard> cards;
  int nextId = 0;

  // constructor flashcards
  FlashcardSet({
    required this.name,
    List<Flashcard>?
    cards, // at first asked for the unbound paramter cards - can be null
    // attention: cards array suposed to be null, when creating a set, but can be set nativly set
    // for creating a set from existing data factory method: from Map() was implemented
  }) : cards = cards ?? [Flashcard.placeholder, Flashcard.placeholder2]
  // : x = x - set x as input x; ?? - if null set the stuff behind
  // body of constructor for setting nextId if cards array given
  {
    if (this.cards.length > 1) {
      nextId = this.cards.length;
    }
  }

  // ===========================================================================
  // basic list operation
  // ===========================================================================

  //add flashcard to the Set
  // @override
  void add(String question, String awnser) {
    Flashcard card = Flashcard(id: nextId, question: question, awnser: awnser);
    cards.add(card);
    nextId++;
  }

  // remove
  void remove(int id) {
    final index = cards.indexWhere((c) => c.id == id);
    if (index >= 0) {
      cards.removeAt(index);
    }
  }

  void moveForward(int id) {
    cards.swap(getPositionById(id), getPositionById(id) + 1);
  }

  void moveBackward(int id) {
    cards.swap(getPositionById(id), getPositionById(id) - 1);
  }

  // get amount of all cards
  //int getAmount() { return cards.length; }

  // ===========================================================================
  // methods for the cards state + amount
  // ===========================================================================

  // change state -> implemented in Flashcard class
  //void setCardState(int id, bool remembered) {}

  // reset states
  void resetStates() {
    // ensure each card's state is set to undefined
    for (var c in cards) {
      c.state = CardState.undefined;
    }
  }

  // get an List of all remembered card objs
  List<Flashcard> getRemembered() {
    return cards.where((c) => (c.state == CardState.rememembered)).toList();
  }

  // get the amount of remembered card objs
  int getAmountRemebered() {
    return getRemembered().length;
  }

  // get an List of all unremembered card objs
  List<Flashcard> getUnremembered() {
    return cards.where((c) => c.state == CardState.unremembered).toList();
  }

  // get the amount of unremembered card objs
  int getAmountUnremebered() {
    return getUnremembered().length;
  }

  List<Flashcard> getUndefined() {
    return cards.where((c) => c.state == CardState.undefined).toList();
  }

  int getAmountUndefined() {
    return getUndefined().length;
  }

  // ===========================================================================

  void sortCards() {
    cards.sort((a, b) => a.id.compareTo(b.id));
  }

  Flashcard? getById(int id) {
    return cards.firstWhereOrNull((c) => c.id == id);
    // binary search not working because of a malfunction between the package and the recent flutter version :(
  }

  int getPositionById(int id) {
    return cards.indexWhere((c) => c.id == id);
  }

  List<Flashcard> getCopyOfCards() {
    final List<Flashcard> cardsCopy = cards;
    return cardsCopy;
  }

  // ===========================================================================
  // following two methods: implemented to convert map set to List and the other way arround
  // needed for saving data as json - look at FlashcardSetManager for further information of the saving process
  // ===========================================================================

  Map<String, dynamic> toMap() {
    return {'name': name, 'cards': cards.map((c) => c.toMap()).toList()};
  }

  // create a set from an Map; used to transform stored data to object
  factory FlashcardSet.fromMap(Map<String, dynamic> map) {
    // Ensure `cards` is converted from dynamic JSON structures into
    // a List<Flashcard> safely.
    final rawCards = (map['cards'] is List)
        ? List<dynamic>.from(map['cards'])
        : <dynamic>[];
    final List<Flashcard> cards = rawCards
        .map((c) => Flashcard.fromMap(Map<String, dynamic>.from(c)))
        .toList();

    return FlashcardSet(name: map['name'] ?? '', cards: cards);
  }

  @override
  String toString() {
    String x = "Set $name contains ${cards.length} card(s): ( ";
    for (var e in cards) {
      x = "$x$e ";
    }
    x = "$x)\n";
    return x;
  }
}
