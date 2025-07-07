import 'package:flutter/material.dart';
import 'package:wallet/services/card_service.dart';
import 'package:wallet/services/database.dart';
import 'package:wallet/widgets/card_dialogs.dart';
import 'package:wallet/widgets/card_display.dart';

class MyCardPage extends StatefulWidget {
  // 1. Add database to the constructor
  final AppDatabase database;
  final String title;

  const MyCardPage({
    super.key,
    required this.title,
    required this.database,
  });

  @override
  State<MyCardPage> createState() => _MyCardPageState();
}



class _MyCardPageState extends State<MyCardPage> {
  // The service that handles all database logic
  late final CardService _cardService;

  // --- State Variables ---
  List<DisplayableCard> _cards = [];
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "${_selectedCards.length} Selected" :widget.title),
        actions: [
          if(_isEditing)
            IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEditMode,
          ),
          if (_isEditing && _selectedCards.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
            ),
          if(!_isEditing)
            PopupMenuButton<String>(
            tooltip: 'More options',
            // The onSelected callback is triggered when a menu item is tapped
            onSelected: (String value) {
              switch (value) {
                case 'backup':
                  _cardService.exportCards();
                  break;
                case 'restore':
                  _cardService.importCards(context);
                  break;
                case 'delete':
                  _handleDelete();
                  break;
              }
            },
            // The itemBuilder builds the menu items conditionally
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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

        ],
      ),
      body: Center(
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
                            isSelected
                                ? Icons.check_circle
                                : null,
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
                              ).colorScheme.primary.withOpacity(_selectedCards.contains(displayableCard)? 0.5: 0),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CardDialogs.showAddCardDialog(context, _cardService),
        label: const Text('Add Card'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
