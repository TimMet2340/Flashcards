import 'package:flutter/material.dart';
import 'dart:math';

class FlashcardWidget extends StatefulWidget {
  final String question;
  final String awnser;
  FlashcardWidget({
    super.key,
    this.question = 'Frage???',
    this.awnser = 'Antwort!!!',
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  bool _isFront = true;
  //sleep(Duration(milliseconds: 250))

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isFront = !_isFront),
      child: cardRotation(),
    );
  }

  AnimatedSwitcher cardRotation() {
    return AnimatedSwitcher(
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
          ? buildCard(widget.question, ValueKey('Front'))
          : buildCard(widget.awnser, ValueKey('Back')),
    );
  }

  LayoutBuilder buildCard(String title, ValueKey key) {
    return LayoutBuilder(
      key: key,
      builder: (BuildContext context, BoxConstraints constraint) {
        const double maxCardHeight = 500.0;
        const double maxCardWidth = 700.0;
        return Center(
          child: Container(
            child: Text(title, style: TextStyle(fontSize: 30.0)),
            alignment: Alignment.center,
            height: constraint.maxHeight < maxCardHeight ? null : maxCardHeight,
            width: constraint.maxWidth < maxCardWidth ? null : maxCardWidth,
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              // boxShadow: List.filled(length, fill),
              border: Border.all(color: const Color.fromARGB(101, 0, 0, 0)),
              gradient: LinearGradient(
                colors: [Colors.white, Color.fromARGB(125, 87, 83, 83)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(60.0),
            ),
          ),
        );
      },
    );
  }
}
