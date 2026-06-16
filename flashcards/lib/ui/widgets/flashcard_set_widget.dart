import 'package:flashcards/ui/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';

class FlashcardSetWidget extends StatefulWidget {
  List<FlashcardWidget>? cards;
  final PageController _controller = PageController();

  final ValueChanged<int>? onCardChanged;

  FlashcardSetWidget({super.key, this.cards, this.onCardChanged});

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
    // If the controller is positioned beyond the new list, jump back to a valid page.
    try {
      if (_controller.hasClients) {
        final currentPage =
            _controller.page?.round() ?? _controller.initialPage;
        if (cards.isEmpty) {
          _controller.jumpToPage(0);
        } else if (currentPage >= cards.length) {
          _controller.jumpToPage(0);
        }
      }
    } catch (_) {
      // ignore any errors if controller isn't ready yet
    }
  }

  void jumpToPage(int index) {
    _controller.jumpToPage(index);
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
      onPageChanged: (index) {
        if (widget.onCardChanged != null) {
          widget.onCardChanged!(index);
        }
      },
    );
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}
