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

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  bool _isFront = true;
  bool _markerVisibility = false;
  late AnimationController _controller;
  //sleep(Duration(milliseconds: 250))

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // Eine Dauer zwischen 300 und 500ms fühlt sich für UI-Elemente meist am besten an
      duration: const Duration(milliseconds: 400),
      vsync:
          this, // 'this' braucht das TickerProviderStateMixin in deiner Klasse
      value: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: _markerVisibility,
          child: Container(
            child: Icon(Icons.check),
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(color: Colors.green),
          ),
        ),
        cardDrag(_controller),
      ],
    );
  }

  Widget cardDrag(AnimationController controller) {
    Offset _dragOffset = Offset.zero;
    AnimationController _controller = controller;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        _markerVisibility = !_markerVisibility;
      },
      onHorizontalDragUpdate: (details) {
        // print(details.globalPosition.toString());
        _dragOffset += Offset(details.delta.dx, 0);
      },
      onHorizontalDragEnd: (details) {
        // print(details.globalPosition.toString());
        if (_dragOffset.dx > 150) {
          print('forward');
          _controller.forward();
          _markerVisibility = !_markerVisibility;
        } else if (_dragOffset.dx < -150) {
          print('backwards');
          _controller.reverse();
          _markerVisibility = !_markerVisibility;
        } else {
          print('drag more');
          _dragOffset = Offset.zero;
        }
      },
      child: Transform.translate(
        offset: _dragOffset,
        child: cardMovingAnimation(_dragOffset, _controller),
      ),
    );
  }

  Widget cardMovingAnimation(
    Offset dragOffset,
    AnimationController _controller,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-2.0, 0),
        end: Offset(2.0, 0),
      ).animate(_controller),
      child: cardRotation(),
    );
  }

  GestureDetector cardRotation() {
    return GestureDetector(
      onTap: () => setState(() => _isFront = !_isFront),
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
            ? buildCard(widget.question, ValueKey('Front'))
            : buildCard(widget.awnser, ValueKey('Back')),
      ),
    );
  }

  LayoutBuilder buildCard(String title, ValueKey key) {
    return LayoutBuilder(
      key: key,
      builder: (BuildContext context, BoxConstraints constraint) {
        const double maxCardHeight = 500.0;
        const double maxCardWidth = 700.0;
        return Center(
          child: AnimatedContainer(
            child: Text(title, style: TextStyle(fontSize: 30.0)),
            duration: Duration(milliseconds: 300),
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
