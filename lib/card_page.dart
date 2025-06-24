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
    required this.database, // This is now required
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
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            tooltip: 'Export Cards',
            onPressed: () => _cardService.exportCards(),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Import Cards',
            onPressed: () => _cardService.importCards(context),
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEditMode,
          ),
          if (_isEditing && _selectedCards.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
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
              onTap: () => _handleCardTap(displayableCard),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      buildCardWidget(cardDataMap),
                      if (_isEditing)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.withOpacity(0.8),
                            size: 30,
                            shadows: const [
                              Shadow(color: Colors.black45, blurRadius: 4)
                            ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => CardDialogs.showAddCardDialog(context, _cardService),
        tooltip: 'Add Card',
        child: const Icon(Icons.add),
      ),
    );
  }
}
