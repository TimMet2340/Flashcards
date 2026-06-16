enum CardState { rememembered, unremembered, undefined }

class Flashcard {
  int id;
  String question;
  String? awnser;
  CardState state;

  Flashcard({
    required this.id,
    required this.question,
    this.awnser,
    this.state = CardState.undefined,
  });
  //String get text => _text.toUpperCase()

  // placeholder card quickly add them - will be used in case of not null/ for null safety
  static Flashcard placeholder = Flashcard(
    id: 0,
    question: 'Ist das Leben ein rekursiver Prozess?',
    awnser:
        'Ja, zum einem, da Menschen sich aufs unbestimmte reproduieren. Zum anderen da Sie wiederholt ihren Tagesablauf ausführen solange die Bedingung: "Leben" erfüllt ist und mit dem beenden eines Tages stets einen neuen Einleiten',
  );
  static Flashcard placeholder2 = Flashcard(
    id: 1,
    question: 'Frage???',
    awnser: 'Antwort!!!',
  );

  void setState(bool remembered) {
    if (remembered) {
      state = CardState.rememembered;
    } else {
      state = CardState.unremembered;
    }
  }

  // creating flashcard with it's constructor from existing map typa source (for json)
  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      // calling the constructorasdfasdf
      id: map['id'],
      question: map['question'],
      awnser: map['awnser'],
      state: CardState.values[map['state']],
    );
  }

  // converts obj to map (for saving in json)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'awnser': awnser,
      'state': state.index,
    };
  }

  @override
  String toString() {
    String awnser = this.awnser ?? "empty";
    return "[ $question, $awnser ]";
  }
}
