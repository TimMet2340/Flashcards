import 'package:flutter/material.dart';

class FlashcardWidget extends StatelessWidget {
  const FlashcardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        double maxCardHeight = 500.0;
        double maxCardWidth = 700.0;
        return Center(
          child: Container(
            child: Text('Frage???', style: TextStyle(fontSize: 30.0)),
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
