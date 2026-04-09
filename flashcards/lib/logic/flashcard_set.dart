import 'package:flashcards/models/flashcard.dart';
import 'package:collection/collection.dart';
import 'dart:convert'; // convert methods for json
import 'dart:html'; // no idea


// main interface-class for the ui 

class FlashcardSet {
  String name;
  List<Flashcard> cards = [Flashcard(
    id: 0,
    question: 'Ist das Leben ein rekursiver Prozess?', 
    awnser: 'Ja, zum einem, da Menschen sich aufs unbestimmte reproduieren. Zum anderen da Sie wiederholt ihren Tagesablauf ausführen solange die Bedingung: "Leben" erfüllt ist und mit dem beenden eines Tages stets einen neuen Einleiten'
  )];

  FlashcardSet ({
    required this.name
  });

  //add flashcard to the Set
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

  // TODO editor mode can be activated inside die flashcardset view
}