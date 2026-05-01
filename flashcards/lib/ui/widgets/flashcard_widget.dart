import 'package:flutter/material.dart';
import 'dart:math';

class FlashcardWidget extends StatefulWidget {
  final String question;
  final String awnser;
  const FlashcardWidget({
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
  bool _rememberedState = true;
  Offset _dragOffset = Offset.zero;
  late AnimationController _controller;

  //sleep(Duration(milliseconds: 250))

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      value: 0.0,
    );
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
              color: _rememberedState ? Color(0xff137D20) : Color(0xffCE0F22),
            ),
            child: _rememberedState ? Icon(Icons.check) : Icon(Icons.close),
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

        // state for an remmebered card
        if (_dragOffset.dx > 150) {
          // print('forward');
          _controller.forward();
          // state for an unremembered card
        } else if (_dragOffset.dx < -150) {
          // print('backwards');
          _controller.reverse();
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
      position: Tween<Offset>(
        begin: Offset.zero,
        end: Offset(2.0, 0),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
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
        return Container(
          alignment: Alignment.center,
          height: constraint.maxHeight < maxCardHeight ? null : maxCardHeight,
          width: constraint.maxWidth < maxCardWidth ? null : maxCardWidth,
          // TODO sized box
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
          child: Text(title, style: TextStyle(fontSize: 30.0)),
        );
      },
    );
  }
}
