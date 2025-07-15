import 'package:flutter/material.dart';
import 'package:wallet/services/backup_service.dart';
import 'package:wallet/services/card_service.dart';
import 'package:wallet/services/database.dart';
import 'package:wallet/widgets/card_dialogs.dart';
import 'package:wallet/widgets/card_display.dart';

class MyCardPage extends StatefulWidget {
  final AppDatabase database;
  final String title;
  final void Function(ThemeMode) onThemeChanged;


  const MyCardPage({super.key, required this.title, required this.database, required this.onThemeChanged});

  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  // The service that handles all database logic
  late final CardService _cardService;



  // --- State Variables ---
  List<DisplayableCard> _cards = [];
  bool _isLoading = false;
  bool _isEditing = false;
  final Set<DisplayableCard> _selectedCards = {};

  @override
  void initState() {
    super.initState();
    // 2. Initialize CardService using the database instance passed from the parent widget
    _cardService = CardService(
      database: widget.database, // Use the instance from the widget
      onCardsUpdated: (newCards) {
        if (mounted) {
          setState(() {
            _cards = newCards;
          });
        }
      },
      showSnackBar: (message) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
    );

    // 3. Load cards initially
    _cardService.loadCards();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      _selectedCards.clear();
    });
  }
  // --- ADD THESE NEW METHODS ---

  void _handleBackup() async {
    final backupService = BackupService(widget.database);
    String? password;

    // Show a dialog to get a password.
    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Set a Backup Password'),
          content: TextField(controller: controller, obscureText: true),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                password = controller.text;
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    // If a password was provided, create the backup.
    if (password != null && password!.isNotEmpty) {
      setState(() { _isLoading = true; }); // Show loading indicator
      try {
        await backupService.makeCompleteBackup(password!);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Backup created successfully!')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Backup failed: $e')),
        );
      } finally {
        setState(() { _isLoading = false; }); // Hide loading indicator
      }
    }
  }

  void _handleRestore() async {
    final backupService = BackupService(widget.database);
    String? password;

    // Show a dialog to get the password.
    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Backup Password'),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                password = controller.text;
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    // If a password was provided, restore from backup.
    if (password != null && password!.isNotEmpty) {
      setState(() { _isLoading = true; }); // Show loading indicator
      try {
        await backupService.restoreCompleteBackup(password!);
        await _cardService.loadCards();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Restore successful!')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Restore failed: Incorrect password or corrupt file.'),
          ),
        );
      } finally {
        setState(() { _isLoading = false; }); // Hide loading indicator
      }
    }
  }
  void _handleCardTap(DisplayableCard card) {
    if (_isEditing) {
      setState(() {
        if (_selectedCards.contains(card)) {
          _selectedCards.remove(card);
          if (_selectedCards.isEmpty) {
            _toggleEditMode();
          }
        } else {
          _selectedCards.add(card);
        }
      });
    }
  }

  void _handleDelete() async {
    // Await the deletion to complete before updating the UI
    await _cardService.deleteCards(_selectedCards);
    if (mounted) {
      _toggleEditMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? "${_selectedCards.length} Selected" : widget.title,
        ),
        actions: [

          if (_isEditing)
            IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: _toggleEditMode,
            ),
          if (_isEditing && _selectedCards.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
            ),
          if (!_isEditing)
            PopupMenuButton<String>(
              tooltip: 'More options',
              // The onSelected callback is triggered when a menu item is tapped
              onSelected: (String value) {
                switch (value) {
                  case 'backup':
                    _handleBackup();
                    break;
                  case 'restore':
                    _handleRestore();
                    break;
                  case 'delete':
                    _handleDelete();
                    break;
                }
              },
              // The itemBuilder builds the menu items conditionally
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'backup',
                      child: ListTile(
                        leading: Icon(Icons.file_upload),
                        title: Text('Backup'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'restore',
                      child: ListTile(
                        leading: Icon(Icons.file_download),
                        title: Text('Restore'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                      ),
                    ),
                  ],
            ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              // Call the callback to change the theme globally
              final newTheme = isDarkMode ? ThemeMode.light : ThemeMode.dark;
              widget.onThemeChanged(newTheme);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 13, 8, 100),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final displayableCard = _cards[index];
                final bool isSelected = _selectedCards.contains(displayableCard);
                final cardDataMap = (displayableCard.data as dynamic).toJson();

                return GestureDetector(
                  onLongPress: () {
                    if (!_isEditing) {
                      setState(() {
                        _isEditing = true;
                        _selectedCards.add(displayableCard);
                      });
                    }
                  },
                  onTap: () => {_handleCardTap(displayableCard)},
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          buildCardWidget(cardDataMap),
                          if (_isEditing)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                isSelected ? Icons.check_circle : null,
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.withAlpha(80),
                                size: 30,
                                shadows: const [
                                  Shadow(color: Colors.black45, blurRadius: 4),
                                ],
                              ),
                            ),
                          if (_isEditing)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(
                                    _selectedCards.contains(displayableCard)
                                        ? 0.5
                                        : 0,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 17),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Processing...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CardDialogs.showAddCardDialog(context, _cardService),
        label: const Text('Add Card'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
