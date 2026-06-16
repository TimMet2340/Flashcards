import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/flashcard_set.dart';
import 'package:flashcards/ui/widgets/flashcard_set_widget.dart';
import 'package:flashcards/ui/widgets/flashcard_widget.dart';
import 'package:flashcards/ui/widgets/progress_bar.dart';
import 'package:flashcards/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

// value for compact view boolean depending on certain screem width
extension LayoutUtils on BuildContext {
  bool get isCompact => MediaQuery.of(this).size.width < 600;
  // alternative: MediaQuery.sizeOf(this).width < 600
}

class ViewPage extends StatefulWidget {
  // FlashcardSet instance of the logic
  final FlashcardSet currentSet;

  const ViewPage({super.key, required this.currentSet});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  // states of this widget
  bool editMode = false;
  int _currentCardIndex =
      0; // current selected card in card widget list of card set widget
  // Cache for generated FlashcardWidget list to avoid recomputing on every build
  List<FlashcardWidget>? _cachedFlashcardWidgets;
  String _cachedSourceIds = '';
  bool _cachedEditMode = false;

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // conntection between logic/backend and ui
    // =========================================================================

    // maps (singleton -> set ->) build widget list depending on mode (edit: all cards, normal: undefined only)
    List<FlashcardWidget> flashcardWidgets = cardsToWidgetList();

    // create the card set widget with the current undefined cards; use a key based on length
    final FlashcardSetWidget cardSetWidget = FlashcardSetWidget(
      key: ValueKey(flashcardWidgets.length),
      cards: flashcardWidgets,
      onCardChanged: (index) {
        setState(() {
          _currentCardIndex = index;
        });
      },
    );

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
        cardSetWidget,
      ),
      body: cardSetWidget,
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: context.isCompact
                    ? [
                        editElements(cardSetWidget),
                        const SizedBox(height: 8.0),
                        bottomNavBar(cardSetWidget),
                      ]
                    : [bottomNavBar(cardSetWidget)],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.currentSet.resetStates();
                  });
                },
                icon: Icon(Icons.replay),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // initialization method: mapps backend objects to widget and returns list for a set
  List<FlashcardWidget> cardsToWidgetList() {
    final List<dynamic> source = editMode
        ? widget.currentSet.cards
        : widget.currentSet.getUndefined();

    // build a simple id-signature to detect real source changes
    String idsSignature;
    try {
      idsSignature = source.map((c) => c.id).join(',');
    } catch (_) {
      idsSignature = source.length.toString();
    }

    // if nothing changed, return cached widgets
    if (_cachedFlashcardWidgets != null &&
        _cachedSourceIds == idsSignature &&
        _cachedEditMode == editMode) {
      return _cachedFlashcardWidgets!;
    }

    // Debug: log source sizes and ids to help trace disappearing-cards bug
    try {
      final ids = source.map((c) => c.id).toList();
      log(
        'cardsToWidgetList - editMode=$editMode, source.length=${source.length}, ids=$ids',
      );
    } catch (_) {
      // ignore logging errors
    }

    final List<FlashcardWidget> flashcardWidgets = source.map((card) {
      return FlashcardWidget(
        editable: editMode,
        id: card.id,
        question: card.question,
        awnser: card.awnser ?? "Keine Antwort hinterlegt",
        onUpdate: (bool isFront, String newText) {
          if (newText.isEmpty) return;
          setState(() {
            isFront ? card.question = newText : card.awnser = newText;
          });
        },
        onSwipe: (isRight) {
          // declare state of cards in logic here and rebuild to update UI
          setState(() {
            if (isRight) {
              card.setState(true);
            } else {
              card.setState(false);
            }
          });
        },
      );
    }).toList();

    // update cache
    _cachedFlashcardWidgets = flashcardWidgets;
    _cachedSourceIds = idsSignature;
    _cachedEditMode = editMode;

    return flashcardWidgets;
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
    FlashcardSetWidget cardSetWidget,
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
          actions: context.isCompact
              ? [themeButton()]
              : [editElements(cardSetWidget), themeButton()],
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

  ValueListenableBuilder<bool> themeButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeManager().isDarkMode,
      builder: (context, isDark, child) {
        return IconButton(
          tooltip: isDark ? 'Light Mode' : 'Dark Mode',
          onPressed: () => ThemeManager().toggleTheme(),
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        );
      },
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

  Widget editElements(FlashcardSetWidget cardSetWidget) {
    const int animationDuration = 300;
    return AnimatedContainer(
      duration: Duration(milliseconds: animationDuration),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(3.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          editButton(),
          AnimatedSize(
            duration: const Duration(milliseconds: animationDuration),
            curve: Curves.easeInOut,
            child: editMode
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      moveButton(false, cardSetWidget),
                      moveButton(true, cardSetWidget),
                      addButton(cardSetWidget),
                      deleteButton(cardSetWidget),
                    ],
                  )
                : const SizedBox.shrink(), // takes 0 px space wenn editMode = false
          ),
        ],
      ),
    );
  }

  IconButton addButton(FlashcardSetWidget cardSetWidget) {
    return IconButton(
      onPressed: () {
        addCard(cardSetWidget);
      },
      icon: Icon(Icons.add, size: 25.0),
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
      ),
      padding: EdgeInsets.all(6.0),
      alignment: Alignment.center,
    );
  }

  void addCard(FlashcardSetWidget cardSetWidget) async {
    final List<dynamic> source = widget.currentSet.cards;

    if (source.isEmpty) return;
    if (_currentCardIndex < 0 || _currentCardIndex >= source.length) return;

    // log
    int addedCardIndex = cardSetWidget.cards!.length + 1;
    int addedCardId = widget.currentSet.nextId;
    try {
      log(
        'Adding card at index=$addedCardIndex with id=$addedCardId. Source before adding length=${source.length}',
      );
    } catch (_) {}

    setState(() {
      widget.currentSet.add('Test???', 'Test!!!');
    });

    cardSetWidget.setCards(cardsToWidgetList());
  }

  IconButton deleteButton(FlashcardSetWidget cardSetWidget) {
    return IconButton(
      onPressed: () {
        removeCurrentCard(cardSetWidget);
      },
      icon: Icon(
        Icons.delete,
        size: 25.0,
        color: Theme.of(context).colorScheme.error.withOpacity(0.9),
      ),
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          Theme.of(context).colorScheme.onError.withOpacity(0.9),
        ),
      ),
      padding: EdgeInsets.all(6.0),
      alignment: Alignment.center,
    );
  }

  void removeCurrentCard(FlashcardSetWidget cardSetWidget) async {
    // Determine the model source depending on edit mode
    final List<dynamic> source = editMode
        ? widget.currentSet.cards
        : widget.currentSet.getUndefined();

    if (source.isEmpty) return;
    if (_currentCardIndex < 0 || _currentCardIndex >= source.length) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Löschen bestätigen'),
        content: const Text(
          'Willst du diese Karte wirklich löschen? Dieser Vorgang kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final modelCard = source[_currentCardIndex];
    try {
      log(
        'Removing card at index=$_currentCardIndex with id=${modelCard.id}. Source before removal length=${source.length}',
      );
    } catch (_) {}

    // Remove from model first
    setState(() {
      widget.currentSet.remove(modelCard.id);
    });

    // Rebuild widgets and update the PageView safely after the frame
    final newWidgets = cardsToWidgetList();
    final newLength = newWidgets.length;
    int newIndex = _currentCardIndex;
    if (newLength == 0) {
      newIndex = 0;
    } else if (newIndex >= newLength) {
      newIndex = newLength - 1;
    }

    cardSetWidget.setCards(newWidgets);
    _currentCardIndex = newIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        cardSetWidget.jumpToPage(newIndex);
      } catch (_) {
        // ignore
      }
    });

    log('Karte gelöscht: ${modelCard.id}');
  }

  IconButton moveButton(bool right, FlashcardSetWidget cardSetWidget) {
    return IconButton(
      onPressed: () {
        moveCurrentCard(cardSetWidget, right);
      },
      tooltip: right ? "Rechts tauschen" : "Links tauschen",
      icon: right
          ? Icon(Icons.arrow_forward, size: 20.0)
          : Icon(Icons.arrow_back, size: 20.0),
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
      ),
      padding: EdgeInsets.all(6.0),
      alignment: Alignment.center,
    );
  }

  void moveCurrentCard(FlashcardSetWidget cardSetWidget, bool right) {
    List<dynamic> source = widget.currentSet.cards;

    // check
    if (source.length <= 1) return;
    if (_currentCardIndex < 0 || _currentCardIndex >= source.length) return;
    if ((!right && _currentCardIndex == 0) ||
        (right && _currentCardIndex == source.length - 1)) {
      return;
    }

    // log change first
    final Flashcard modelCard = source[_currentCardIndex];
    final int newIndex = right ? _currentCardIndex + 1 : _currentCardIndex - 1;
    try {
      log(
        'Moving card at index=$_currentCardIndex with id=${modelCard.id} to index $newIndex',
      );
    } catch (_) {}

    // backend change: pass model id (not index like my stupid ass)
    setState(() {
      if (right) {
        widget.currentSet.moveForward(modelCard.id);
      } else {
        widget.currentSet.moveBackward(modelCard.id);
      }
    });

    // reconnect with ui: update widget list and move to the new index
    final updatedWidgets = cardsToWidgetList();
    // ensure newIndex is within bounds
    final safeIndex = (newIndex < 0)
        ? 0
        : (newIndex >= updatedWidgets.length
              ? updatedWidgets.length - 1
              : newIndex);

    cardSetWidget.setCards(updatedWidgets);
    _currentCardIndex = safeIndex;
    try {
      cardSetWidget.jumpToPage(safeIndex);
    } catch (e) {
      log('jumpToPage failed: $e');
    }
  }

  IconButton editButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          editMode = !editMode;
        });
      },
      tooltip: editMode ? "Zurück zur Standardansicht" : "Karten bearbeiten",
      icon: editMode
          ? Icon(Icons.edit_off, size: 25.0)
          : Icon(Icons.edit, size: 25.0),
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
      ),
      padding: EdgeInsets.all(6.0),
      alignment: Alignment.center,
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
          children: [
            navigationButton(false, cardSetWidget),
            const SizedBox(width: 8.0),
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
            const SizedBox(width: 8.0),
            Text('weiter'),
            const SizedBox(width: 8.0),
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
