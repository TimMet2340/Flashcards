import 'package:flashcards/logic/flashcard_set_manager.dart';
import 'package:flashcards/ui/pages/view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Zugriff auf das Singleton, factory prozedur flashcard set manager
  final manager = FlashcardSetManager();

  @override
  void initState() {
    super.initState();
    manager.importAll(); // Einmalig beim Start laden
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 191, 169, 243),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20.0,
          children: [
            const Icon(Icons.lightbulb, size: 40.0),
            const Text('Do You Remember?', style: TextStyle(fontSize: 30.0)),
            // TODO buttons class
            ElevatedButton(
              onPressed: () => print('Tetstestfdasf'),
              onLongPress: null,
              child: const Text('Test Stuff'),
            ),
            ElevatedButton(
              onPressed: () {
                if (manager.allSets.isEmpty) {
                  manager.addSet("Mein erstes Set");
                }

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        ViewPage(currentSet: manager.allSets[0]),
                  ),
                );
              },
              child: const Text('Lernen starten'),
            ),
          ],
        ),
      ),
    );
  }
}
