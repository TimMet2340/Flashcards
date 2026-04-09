class Flashcard {
  int id;
  String question;
  String? awnser;
  bool remembered;

  Flashcard ({
    required this.id,
    required this.question,
    this.awnser,
    this.remembered = false
  });
  //String get text => _text.toUpperCase()

  // creating flashcard with it's constructor from existing map typa source (for json)
  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard( // calling the constructorasdfasdf
      id: map['id'],
      question: map['question'],
      awnser: map['awnser'],
      remembered: map['remembered'],
    );
  }
  
  // converts obj to map (for saving in json)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'awnser': awnser,
      'remembered': remembered,
    };
  }
}