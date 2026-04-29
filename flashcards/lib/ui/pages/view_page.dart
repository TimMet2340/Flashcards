import 'package:flashcards/ui/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  const ViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 120.0),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  PreferredSize appBar(BuildContext context, double height) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBar(
          title: Text(
            'Title der absolut lang ist um auszutesten ob alles funktioniert',
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 235, 235, 235),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
          ),
          leading: backButton(context),
          actions: [editButton()],
          bottom: PreferredSize(
            preferredSize: const Size.fromWidth(1.0),
            child: ProgressBar(total: 5, current: 2),
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
          color: Color.fromARGB(227, 172, 172, 172),
        ),
        padding: EdgeInsets.all(6.0),
        margin: EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child: const Icon(Icons.edit, size: 25.0, color: Colors.black),
      ),
    );
  }

  Widget bottomNavBar() {
    return Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 8.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(76, 96, 125, 139),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => print('vorherige Karte'),
            icon: Icon(Icons.arrow_left),
          ),
          IconButton(
            onPressed: () => print('vorherige Karte'),
            icon: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}
