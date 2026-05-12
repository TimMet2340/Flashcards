import 'package:flashcards/ui/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';

class FlashcardSetWidget extends StatefulWidget {
  List<FlashcardWidget>? cards;
  final PageController _controller = PageController();
  FlashcardSetWidget({super.key, this.cards});

  void nextCard() {
    _controller.nextPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.bounceOut,
    );
  }

  void previousCard() {
    _controller.previousPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.bounceOut,
    );
  }

  void setCards(List<FlashcardWidget> cards) {
    this.cards = cards;
  }

  @override
  State<FlashcardSetWidget> createState() => _FlashcardSetWidgetState();
}

class _FlashcardSetWidgetState extends State<FlashcardSetWidget> {
  //final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: widget._controller,
      physics: NeverScrollableScrollPhysics(),
      children: widget.cards ?? [],
    );
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }

  // TODO Dispose animation controller
}
