import 'package:flashcards/logic/flashcard_set_manager.dart';
import 'package:flashcards/main.dart';
import 'package:flashcards/models/flashcard_set.dart';
import 'package:flashcards/ui/pages/view_page.dart';
import 'package:flashcards/ui/widgets/theme_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension LayoutUtils on BuildContext {
  bool get isWide => MediaQuery.of(this).size.width >= 900;
  // alternative: MediaQuery.sizeOf(this).width < 600
}

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
    const SizedBox seperator = SizedBox(height: 20.0);
    const double drawerBorderRadius = 30;

    Widget mainBody = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            seperator,
            const Icon(Icons.lightbulb, size: 40.0),
            Text(
              'Do You Remember?',
              style: GoogleFonts.archivoBlack(fontSize: 30.0),
            ),
            seperator,
            // TODO buttons class
            ElevatedButton(
              onPressed: () {
                manager.init();
                //manager.saveAll();
              },
              onLongPress: null,
              child: const Text('Initialisiere Dummy Flashkarten'),
            ),
            seperator,
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: listAllSets(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [ThemeButton()],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        backgroundColor: Theme.of(
          context,
        ).appBarTheme.backgroundColor?.withValues(alpha: 0.9),
      ),
      drawer: context.isWide
          ? null
          : Drawer(child: buildDrawerContent(context, drawerBorderRadius)),
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor.withOpacity(0.9),
      body: context.isWide
          ? Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(drawerBorderRadius),
                      ),
                    ),
                    child: buildDrawerContent(context, drawerBorderRadius),
                  ),
                ),
                //const VerticalDivider(width: 1),
                Expanded(child: mainBody),
              ],
            )
          : mainBody,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          manager.addSet('Neues Set');
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget listAllSets(BuildContext context) {
    final sets = manager.allSets;
    if (sets.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'Keine Sets vorhanden',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8.0),
      itemBuilder: (ctx, index) {
        final s = sets[index];
        return SetMenuWidget(
          context: context,
          onPressed: () => Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => ViewPage(currentSet: s)),
          ),
          set: s,
        );
      },
    );
  }

  Widget buildDrawerContent(BuildContext context, double drawerBorderRadius) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text('Flashcards'),
          accountEmail: Text(''),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            child: Icon(
              Icons.lightbulb,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: context.isWide
                ? BorderRadius.only(
                    topRight: Radius.circular(drawerBorderRadius),
                  )
                : null,
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          subtitle: Text('Zur Startseite'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text('Alle Sets'),
          subtitle: Text('${manager.allSets.length} Sets'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Neues Set'),
          onTap: () {
            manager.addSet('Neues Set');
            Navigator.pop(context);
            setState(() {});
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Einstellungen'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('Über'),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Flashcards App v1.0')));
          },
        ),
      ],
    );
  }

  Widget SetMenuWidget({
    required BuildContext context,
    VoidCallback? onPressed,
    FlashcardSet? set,
  }) {
    onPressed ??= () {};
    set ??= FlashcardSet(name: "no input");

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Theme.of(context).cardColor,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              title: Text(
                set.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Anzahl: ${set.cards.length}',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.menu_book,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                    ),
                    onPressed: onPressed,
                    child: Text(
                      "Lernen",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  deleteButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconButton deleteButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.delete,
        size: 25.0,
        color: Theme.of(context).colorScheme.error.withOpacity(0.9),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.onError.withOpacity(0.9),
        ),
      ),
      padding: EdgeInsets.all(6.0),
      alignment: Alignment.center,
    );
  }
}
