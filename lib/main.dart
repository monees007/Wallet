import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:wallet/services/database.dart';
import 'card_page.dart';

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
            colorScheme: darkDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.cyan,
                  brightness: Brightness.dark,
                ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          themeMode: ThemeMode.system,
          home: const MainPage(),
        );
      },
    );
  }
}

// This widget now manages the single database instance for the entire app.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // 1. Create the single database instance here.
  late final AppDatabase _database;

  // 2. The list of pages is no longer static. It will be initialized with the database instance.
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Initialize the database when this widget is first created.
    _database = AppDatabase();

    // 3. Pass the single database instance to each page.
    _widgetOptions = <Widget>[
      MyCardPage(title: 'Wallet', database: _database), // Pass instance
      NotesPage(database: _database), // Pass instance
      CodesPage(database: _database), // Pass instance
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 4. IMPORTANT: Dispose the database when the app is closed.
  @override
  void dispose() {
    _database.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
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
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}

// UPDATED: This widget now accepts the database instance.
class NotesPage extends StatelessWidget {
  final AppDatabase database;
  const NotesPage({super.key, required this.database});

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

// UPDATED: This widget now accepts the database instance.
class CodesPage extends StatelessWidget {
  final AppDatabase database;
  const CodesPage({super.key, required this.database});

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

