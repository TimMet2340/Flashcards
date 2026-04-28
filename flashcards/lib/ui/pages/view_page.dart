import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  const ViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(context));
  }

  PreferredSize appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBar(
          title: Text('Title'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 235, 235, 235),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            tooltip: 'Zurück zum Menü', // Dein Wunsch-Icon
            onPressed: () {
              Navigator.pop(context); // Manuelles Zurückgehen
            },
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(227, 172, 172, 172),
              ),
              padding: EdgeInsets.all(6.0),
              margin: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              child: const Icon(Icons.edit, size: 25.0, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
