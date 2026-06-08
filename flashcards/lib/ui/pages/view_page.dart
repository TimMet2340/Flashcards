import 'package:flashcards/models/flashcard_set.dart';
import 'package:flashcards/ui/widgets/flashcard_set_widget.dart';
import 'package:flashcards/ui/widgets/flashcard_widget.dart';
import 'package:flashcards/ui/widgets/progress_bar.dart';
import 'package:flashcards/theme/theme_manager.dart';
import 'package:flutter/material.dart';

class ViewPage extends StatefulWidget {
  /* final FlashcardSetWidget cardsTemplate = FlashcardSetWidget(
    cards: [
      FlashcardWidget(),
      FlashcardWidget(question: 'Was?', awnser: 'das!'),
    ],
  ); */

  // FlashcardSet instance of the logic
  final FlashcardSet currentSet;

  const ViewPage({super.key, required this.currentSet});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // conntection between logic/backend and ui
    // =========================================================================

    // empty widget to connect Flashcards with scroll method for flashcard
    final FlashcardSetWidget cardSetWidget = FlashcardSetWidget(cards: []);

    // maps (singleton -> set ->) cards with a widget that displays its content and warps them into a list
    final List<FlashcardWidget> flashcardWidgets = widget.currentSet.cards.map((
      card,
    ) {
      return FlashcardWidget(
        question: card.question,
        awnser: card.awnser ?? "Keine Antwort hinterlegt",
        onSwipe: (isRight) {
          // deklaring state of cards in logic here
          isRight ? card.setState(true) : card.setState(false);
          cardSetWidget.nextCard();
        },
      );
    }).toList();

    // give cards to widget
    cardSetWidget.setCards(flashcardWidgets);

    // =========================================================================
    // every element which you can see on the screen
    // =========================================================================
    return Scaffold(
      appBar: appBar(
        context,
        120.0,
        widget.currentSet.name,
        widget.currentSet.cards.length,
        (widget.currentSet.getAmountRemebered() +
            widget.currentSet.getAmountUnremebered()),
        widget.currentSet.getAmountRemebered(),
        widget.currentSet.getAmountUnremebered(),
      ),
      body: cardSetWidget,
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(bottom: true, child: bottomNavBar(cardSetWidget)),
          IconButton(
            onPressed: () {
              widget.currentSet.resetStates();
              print('reset performed');
            },
            icon: Icon(Icons.replay),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  PreferredSize appBar(
    BuildContext context,
    double height,
    String title,
    int totalProgress,
    int currentProgress,
    int rememberedAmount,
    int unrememberedAmount,
  ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBar(
          title: Text(title),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
          ),
          leading: backButton(context),
          actions: [
            editButton(),
            ValueListenableBuilder<bool>(
              valueListenable: ThemeManager().isDarkMode,
              builder: (context, isDark, child) {
                return IconButton(
                  tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                  onPressed: () => ThemeManager().toggleTheme(),
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromWidth(1.0),
            child: ProgressBar(
              total: totalProgress,
              current: currentProgress,
              rememberedAmount: rememberedAmount,
              unrememberedAmount: unrememberedAmount,
            ),
          ),
        ),
      ),
    );
  }

  IconButton backButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      tooltip: 'Zurück zum Menü', // Dein Wunsch-Icon
      onPressed: () {
        Navigator.pop(context); // Manuelles Zurückgehen
      },
    );
  }

  InkWell editButton() {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () => print("Edit mode"),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
        padding: EdgeInsets.all(6.0),
        margin: EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child: const Icon(Icons.edit, size: 25.0, color: Colors.black),
      ),
    );
  }

  // methods defining the bottom navigation bar and it's child elements
  Widget bottomNavBar(FlashcardSetWidget cardSetWidget) {
    return UnconstrainedBox(
      child: Container(
        margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5.0,
          children: [
            navigationButton(false, cardSetWidget),
            Text('zurück'),
            Container(
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              width: 5.0,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(69, 0, 0, 0),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            Text('weiter'),
            navigationButton(true, cardSetWidget),
          ],
        ),
      ),
    );
  }

  IconButton navigationButton(bool next, FlashcardSetWidget cardSetWidget) {
    return IconButton(
      tooltip: next ? 'Zur nächsten Karte' : 'Zur vorherigen Karte',
      style: ButtonStyle(
        shape: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(20.0),
            );
          }
          return CircleBorder();
        }),
        backgroundColor: WidgetStateColor.resolveWith((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.9);
          }
          return Theme.of(context).colorScheme.primary;
        }),
      ),
      onPressed: () =>
          next ? cardSetWidget.nextCard() : cardSetWidget.previousCard(),
      icon: next ? Icon(Icons.arrow_right) : Icon(Icons.arrow_left),
      color: Theme.of(context).colorScheme.onPrimary,
      iconSize: 40.0,
    );
  }
}
