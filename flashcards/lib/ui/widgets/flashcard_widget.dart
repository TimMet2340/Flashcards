import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FlashcardWidget extends StatefulWidget {
  final bool editable;
  final int id;
  final String question;
  final String awnser;
  //final Flashcard? card;
  final Function(bool, String)? onUpdate;
  final Function(bool)? onSwipe;
  const FlashcardWidget({
    super.key,
    this.id = -1,
    this.question = 'Frage???',
    this.awnser = 'Antwort!!!',
    this.onUpdate,
    this.onSwipe,
    //this.card,
    this.editable = false,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  bool _isFront = true;
  bool _markerVisibility = false;
  bool _rememberedState = true;
  Offset _dragOffset = Offset.zero;
  late AnimationController _animationController;
  late TextEditingController _textController;

  // NNNNEEINNN
  //sleep(Duration(milliseconds: 250))

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      value: 0.0,
    );
    _textController = TextEditingController(
      text: _isFront ? widget.question : widget.awnser,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question ||
        oldWidget.awnser != widget.awnser) {
      _textController.text = _isFront ? widget.question : widget.awnser;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Visibility(
          visible: _markerVisibility,
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: _rememberedState
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.error,
            ),
            child: _rememberedState
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onSecondary,
                  )
                : Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onError,
                  ),
          ),
        ),
        cardDrag(),
      ],
    );
  }

  Widget cardDrag() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // print(details.globalPosition.toString());
        setState(() {
          _dragOffset += Offset(details.delta.dx, 0);

          if (_dragOffset.dx.abs() > 20.0) {
            _markerVisibility = true;
            _rememberedState = _dragOffset.dx > 0;
          }
        });
      },
      onHorizontalDragEnd: (details) {
        // print(details.globalPosition.toString());

        // state for an remmebered card / right swipe
        if (_dragOffset.dx > 150) {
          // print('forward');
          _animationController.forward();
          widget.onSwipe != null
              ? widget.onSwipe!(true)
              : null; // true - right swipe
          // state for an unremembered card
        } else if (_dragOffset.dx < -150) {
          // print('backwards');
          _animationController.reverse();
          widget.onSwipe != null
              ? widget.onSwipe!(false)
              : null; // false - left swipe
        } else {
          // print('drag more');
          setState(() {
            _dragOffset = Offset.zero;
            _markerVisibility = false;
          });
        }
      },
      child: Transform.translate(
        offset: _dragOffset,
        child: cardMovingAnimation(),
      ),
    );
  }

  Widget cardMovingAnimation() {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: Offset(2.0, 0)).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: cardRotation(),
    );
  }

  GestureDetector cardRotation() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFront = !_isFront;
          _textController.text = _isFront ? widget.question : widget.awnser;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.rotationY(
                  rotate.value,
                ), // Drehung um die Y-Achse
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: _isFront
            ? buildCard(ValueKey('Front'))
            : buildCard(ValueKey('Back')),
      ),
    );
  }

  LayoutBuilder buildCard(ValueKey key) {
    return LayoutBuilder(
      key: key,
      builder: (BuildContext context, BoxConstraints constraint) {
        const double maxCardHeight = 500.0;
        const double maxCardWidth = 700.0;
        return Container(
          alignment: Alignment.center,
          height: constraint.maxHeight < maxCardHeight ? null : maxCardHeight,
          width: constraint.maxWidth < maxCardWidth ? null : maxCardWidth,
          // TODO sized box
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
            ),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).colorScheme.shadow.withOpacity(0.25),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(60.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: AutoSizeTextField(
                controller: _textController,
                enabled: widget.editable,
                style: TextStyle(fontSize: 30.0),
                maxLines: 5,
                fullwidth: true,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                minFontSize: 20,
                onChanged: (String newText) {
                  if (widget.onUpdate != null) {
                    widget.onUpdate!(_isFront, newText);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
