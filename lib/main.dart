import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'card_page.dart'; // Your existing page for cards

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Wallet',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.cyan),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme:
                darkDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.cyan,
                  brightness: Brightness.dark,
                ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          themeMode: ThemeMode.system,
          // The home screen is now MainPage, which handles the navigation
          home: const MainPage(),
        );
      },
    );
  }
}

// This new widget manages the state of the bottom navigation bar
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // List of the pages that the navigation bar will switch between.
  // Each page is a separate widget.
  static final List<Widget> _widgetOptions = <Widget>[
    const MyCardPage(title: 'Wallet'), // Your existing card page
    const NotesPage(), // The new page for notes
    const CodesPage(), // The new page for 2-step verification codes
  ];

  // This function is called when a navigation bar item is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the widget from the list based on the selected index.
      // It's assumed that each page (e.g., MyCardPage) has its own AppBar.
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            label: 'Codes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // The handler for tap events
        // A few style tweaks for a modern look
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}

// A placeholder widget for the "Notes" page.
// You can build this out into a full feature.
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: const Center(
        child: Text(
          'Your notes will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// A placeholder widget for the "Two-Step Verification" page.
// You can build this out into a full feature.
class CodesPage extends StatelessWidget {
  const CodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Two-Step Verification')),
      body: const Center(
        child: Text(
          'Your 2FA codes will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
