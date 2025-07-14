import 'dart:io';
import 'dart:typed_data';
import 'package:drift/drift.dart' show Value;

import 'database.dart';

class DisplayableCard {
  final int id;
  final String type; // e.g., 'payment', 'library', 'custom'
  final dynamic data; // Holds the actual Drift data object (PaymentCard, LibraryCard, etc.)

  DisplayableCard({required this.id, required this.type, required this.data});
}


// This class will handle all card-related data operations using the Drift database.
class CardService {
  final AppDatabase _database;
  final Function(List<DisplayableCard>) _onCardsUpdated;
  final Function(String) _showSnackBar;

  List<DisplayableCard> _cards = [];

  CardService({
    required AppDatabase database,
    required Function(List<DisplayableCard>) onCardsUpdated,
    required Function(String) showSnackBar,
  })  : _database = database,
        _onCardsUpdated = onCardsUpdated,
        _showSnackBar = showSnackBar;

  // --- Data Loading ---

  Future<void> loadCards() async {
    try {
      // Fetch from all card tables
      final payment = await _database.getAllPaymentCards();
      final library = await _database.getAllLibraryCards();
      final custom = await _database.getAllCustomCards();

      // Map each list to the generic wrapper
      final List<DisplayableCard> allCards = [];
      allCards.addAll(payment.map((c) => DisplayableCard(id: c.id, type: 'payment', data: c)));
      allCards.addAll(library.map((c) => DisplayableCard(id: c.id, type: 'library', data: c)));
      allCards.addAll(custom.map((c) => DisplayableCard(id: c.id, type: 'custom', data: c)));

      // You might want to sort the combined list, e.g., by type or name
      _cards = allCards;
      _onCardsUpdated(_cards);
    } catch (e) {
      _showSnackBar('Error loading cards from database: $e');
    }
  }




  // --- Card Addition Methods ---

  Future<void> addPaymentCard(String cardNumber, String cardHolder, String cardName, String expiryDate, String? cvv, String type, File? frontImageFile, File? backImageFile) async {
    try {
      final Uint8List? frontBytes = await frontImageFile?.readAsBytes();
      final Uint8List? backBytes = await backImageFile?.readAsBytes();
      final companion = PaymentCardsCompanion.insert(
          cardholderName: cardHolder,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardName: Value(cardName),
          cvv: cvv ?? '***',
          cardType: Value(type),
          frontImage: Value(frontBytes),
          backImage: Value(backBytes)
      );
      await _database.addPaymentCard(companion);
      await loadCards();
      _showSnackBar('Payment Card added successfully!');
    } catch (e) {
      _showSnackBar('Failed to add card: $e');
    }
  }

  Future<void> addLibraryCard(String name, String idNumber, String? registrationNumber, String? course, String? session, String? school, File? profileImageFile) async {
    try {
      final Uint8List? imageBytes = await profileImageFile?.readAsBytes();
      final companion = LibraryCardsCompanion.insert(
        name: name,
        idNumber: idNumber,
        registrationNumber: Value(registrationNumber),
        course: Value(course),
        session: Value(session),
        school: Value(school),
        profileImage: Value(imageBytes),
      );
      await _database.addLibraryCard(companion);
      await loadCards();
      _showSnackBar('Library Card added successfully!');
    } catch (e) {
      _showSnackBar('Failed to add library card: $e');
    }
  }

  Future<void> addCustomCard(String cardName, File? frontImageFile, File? backImageFile) async {
    try {
      final Uint8List? frontBytes = await frontImageFile?.readAsBytes();
      final Uint8List? backBytes = await backImageFile?.readAsBytes();
      final companion = CustomCardsCompanion.insert(
        cardName: cardName,
        frontImage: Value(frontBytes),
        backImage: Value(backBytes),
      );
      await _database.addCustomCard(companion);
      await loadCards();
      _showSnackBar('Custom Card added successfully!');
    } catch (e) {
      _showSnackBar('Failed to add custom card: $e');
    }
  }


  // --- Card Deletion Method ---


  Future<void> deleteCards(Set<DisplayableCard> cardsToDelete) async {
    // CORRECTED: Create a copy of the set to iterate over.
    // This prevents modification of the original set while the loop is running.
    final Set<DisplayableCard> cardsToDeleteCopy = Set.from(cardsToDelete);
    if (cardsToDeleteCopy.isEmpty) return;

    try {
      // Iterate over the safe copy
      for (final card in cardsToDeleteCopy) {
        switch (card.type) {
          case 'payment':
            await _database.deletePaymentCard(card.id);
            break;
          case 'library':
            await _database.deleteLibraryCard(card.id);
            break;
          case 'custom':
            await _database.deleteCustomCard(card.id);
            break;
        }
      }
      await loadCards(); // Refresh the list from the database
      _showSnackBar('Selected cards deleted!');
    } catch (e) {
      _showSnackBar('Error deleting cards: $e');
    }
  }
}
