import 'package:flashcards/ui/pages/view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                Navigator.push(
                  context,
                  CupertinoPageRoute<void>(
                    builder: (context) => const ViewPage(),
                  ),
                );
              },
              child: const Text('view page'),
            ),
          ],
        ),
      ),
    );
  }
}
