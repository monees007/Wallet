import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/services/database.dart';
import 'card_page.dart';
import 'notes_page.dart';

// MODIFIED: main is now async to allow for initialization before running the app.
void main() {
  // Required to ensure that async calls can be made before runApp()
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('themeMode') ?? ThemeMode.system.name;
    if (mounted) {
      setState(() {
        _themeMode = ThemeMode.values.firstWhere((e) => e.name == themeName);
      });
    }
  }

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
                    seedColor: Colors.cyan, brightness: Brightness.dark),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          themeMode: _themeMode,
          // MODIFIED: Home is now MainPage, which handles its own state.
          home: MainPage(onThemeChanged: _changeTheme),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;
  const MainPage({super.key, required this.onThemeChanged});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  // MODIFIED: This is now a Future that will be resolved.
  late final Future<AppDatabase> _dbFuture;

  @override
  void initState() {
    super.initState();
    // MODIFIED: Start the async database initialization.
    _dbFuture = _initializeDatabase();
  }

  // NEW: This async method handles the database creation and authentication.
  Future<AppDatabase> _initializeDatabase() async {
    return AppDatabase();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // // NOTE: This dialog logic remains the same.
  // void _showThemeDialog(ThemeMode currentTheme) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Choose Theme'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           RadioListTile<ThemeMode>(
  //             title: const Text('Light'),
  //             value: ThemeMode.light,
  //             groupValue: currentTheme,
  //             onChanged: (value) {
  //               widget.onThemeChanged(ThemeMode.light);
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           RadioListTile<ThemeMode>(
  //             title: const Text('Dark'),
  //             value: ThemeMode.dark,
  //             groupValue: currentTheme,
  //             onChanged: (value) {
  //               widget.onThemeChanged(ThemeMode.dark);
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           RadioListTile<ThemeMode>(
  //             title: const Text('System Default'),
  //             value: ThemeMode.system,
  //             groupValue: currentTheme,
  //             onChanged: (value) {
  //               widget.onThemeChanged(ThemeMode.system);
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // MODIFIED: Use a FutureBuilder to handle the async database connection.
    return FutureBuilder<AppDatabase>(
      future: _dbFuture,
      builder: (context, snapshot) {
        // State 1: Still connecting/authenticating
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Authenticating..."),
                ],
              ),
            ),
          );
        }

        // State 2: Error occurred (e.g., auth failed)
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    "Authentication Failed",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text("Could not open the secure wallet."),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Allow the user to retry
                      setState(() {
                        _dbFuture = _initializeDatabase();
                      });
                    },
                    child: const Text("Retry"),
                  )
                ],
              ),
            ),
          );
        }

        // State 3: Successfully connected
        if (snapshot.hasData) {
          final database = snapshot.data!;
          final widgetOptions = <Widget>[
            NotesPage(database: database, onThemeChanged: widget.onThemeChanged),
            MyCardPage(title: 'Wallet', database: database),
          ];

          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: widgetOptions,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notes'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.credit_card), label: 'Cards'),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
            ),
          );
        }

        // Should not happen, but a fallback
        return const Scaffold(body: Center(child: Text("An unknown error occurred.")));
      },
    );
  }
}

// NOTE: CodesPage is unchanged.
class CodesPage extends StatelessWidget {
  final AppDatabase database;
  const CodesPage({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Your 2FA codes will appear here.',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}