import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:wallet/services/database.dart';
import 'card_page.dart';
import 'notes_page.dart';

void main() {
  runApp(const MyApp());
}

// MODIFIED: Converted to a StatefulWidget to manage theme state.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // State variable to hold the current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme(); // Load the saved theme on app start
  }

  // NEW: Load the saved theme preference
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('themeMode') ?? ThemeMode.system.name;
    setState(() {
      _themeMode = ThemeMode.values.firstWhere((e) => e.name == themeName);
    });
  }

  // NEW: Change the theme and save the preference
  void _changeTheme(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode.name);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Wallet',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.cyan),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            // Apply dynamic color to dark theme as well
            colorScheme: darkDynamic ?? ColorScheme.fromSeed(seedColor: Colors.cyan, brightness: Brightness.dark),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          themeMode: _themeMode, // Use the state variable here
          // Pass the change theme function to the MainPage
          home: MainPage(onThemeChanged: _changeTheme),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  // NEW: Callback function to change the theme
  final void Function(ThemeMode) onThemeChanged;
  const MainPage({super.key, required this.onThemeChanged});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late final AppDatabase _database;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _widgetOptions = <Widget>[
      NotesPage(database: _database, onThemeChanged: widget.onThemeChanged),
      MyCardPage(title: 'Wallet', database: _database),
      // CodesPage(database: _database),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // NEW: Show the theme selection dialog
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
              onChanged: (value) {
                widget.onThemeChanged(ThemeMode.light);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
              onChanged: (value) {
                widget.onThemeChanged(ThemeMode.dark);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: null, // This can be improved, but works for selection
              onChanged: (value) {
                widget.onThemeChanged(ThemeMode.system);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

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
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shield_outlined),
          //   label: 'Codes',
          // ),
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

class CodesPage extends StatelessWidget {
  final AppDatabase database;
  const CodesPage({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    // Note: The new central AppBar will appear above this page as well.
    // You can remove this Scaffold if you want the page to be part of the main scaffold.
    return const Center(
      child: Text(
        'Your 2FA codes will appear here.',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}