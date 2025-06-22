import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet/services/card_service.dart';
import 'package:wallet/widgets/card_dialogs.dart';
import 'package:wallet/widgets/card_display.dart';


class MyCardPage extends StatefulWidget {
  const MyCardPage({super.key, required this.title});

  final String title;

  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  final _secureStorage = const FlutterSecureStorage();
  List<Map<String, dynamic>> _cards = [];
  bool isEditing = false;
  Set<int> selectedIndices = {};

  // Instantiate CardService
  late final CardService _cardService;

  @override
  void initState() {
    super.initState();
    // Initialize CardService, passing the setState callback for card updates
    _cardService = CardService(
      storage: _secureStorage,
      onCardsUpdated: (newCards) {
        setState(() {
          _cards = newCards;
        });
      },
      showSnackBar: (message) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      },
    );
    _cardService.loadCards(); // Load cards initially
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
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                selectedIndices.clear(); // Clear selection when toggling edit mode
              });
            },
          ),
          if (isEditing && selectedIndices.isNotEmpty) // Only show delete if editing and cards are selected
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _cardService.deleteCards(selectedIndices);
                setState(() {
                  selectedIndices.clear();
                  isEditing = false; // Exit edit mode after deletion
                });
              },
            ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(8, 13, 8, 100),
          itemCount: _cards.length,
          itemBuilder: (context, index) {
            final card = _cards[index];
            bool isSelected = selectedIndices.contains(index);

            return GestureDetector(
              onLongPress: () {
                // If not already editing, start editing and select the current card
                if (!isEditing) {
                  setState(() {
                    isEditing = true;
                    selectedIndices.add(index);
                  });
                }
              },
              onTap: () {
                // If editing, toggle selection on tap
                if (isEditing) {
                  setState(() {
                    if (isSelected) {
                      selectedIndices.remove(index);
                    } else {
                      selectedIndices.add(index);
                    }
                  });
                }
                // Optionally, add logic for viewing card details when not editing
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      // Use the centralized card building function
                      buildCardWidget(card),
                      if (isEditing)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                            size: 30,
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
