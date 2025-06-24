import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:drift/drift.dart' show Value;

// Import your updated Drift database definition
import 'database.dart';

/// A generic wrapper class to represent any type of card in the UI.
/// This helps in managing different card types in a single list.
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

  // --- Export/Import Operations ---

  Future<void> exportCards() async {
    try {
      final payment = await _database.getAllPaymentCards();
      final library = await _database.getAllLibraryCards();
      final custom = await _database.getAllCustomCards();

      if (payment.isEmpty && library.isEmpty && custom.isEmpty) {
        _showSnackBar('No cards to export');
        return;
      }

      // Helper to encode Uint8List to Base64
      dynamic encodeImages(Map<String, dynamic> jsonMap) {
        jsonMap.forEach((key, value) {
          if (value is Uint8List) {
            jsonMap[key] = base64Encode(value);
          }
        });
        return jsonMap;
      }

      final backupData = {
        'paymentCards': payment.map((c) => encodeImages(c.toJson())).toList(),
        'libraryCards': library.map((c) => encodeImages(c.toJson())).toList(),
        'customCards': custom.map((c) => encodeImages(c.toJson())).toList(),
      };

      final String backupJson = jsonEncode(backupData);
      final params = SaveFileDialogParams(data: Uint8List.fromList(backupJson.codeUnits), fileName: 'wallet_full_backup.json');
      await FlutterFileDialog.saveFile(params: params);
      _showSnackBar('Cards exported successfully!');

    } catch (e) {
      _showSnackBar('Error exporting cards: $e');
    }
  }

  Future<void> importCards(BuildContext context) async {
    try {
      final params = OpenFileDialogParams(dialogType: OpenFileDialogType.document, fileExtensionsFilter: const ['json']);
      final filePath = await FlutterFileDialog.pickFile(params: params);

      if (filePath == null) {
        _showSnackBar('No file selected');
        return;
      }

      final file = File(filePath);
      final content = await file.readAsString();
      final Map<String, dynamic> backupData = jsonDecode(content);

      // Clear existing cards before importing.
      await _database.delete(_database.paymentCards).go();
      await _database.delete(_database.libraryCards).go();
      await _database.delete(_database.customCards).go();

      // Helper to decode Base64 to Uint8List
      dynamic decodeImages(Map<String, dynamic> jsonMap) {
        jsonMap.forEach((key, value) {
          if (key.toLowerCase().contains('image') && value is String) {
            jsonMap[key] = base64Decode(value);
          }
        });
        return jsonMap;
      }

      for (var cardMap in (backupData['paymentCards'] as List)) {
        await _database.addPaymentCardBulk(PaymentCard.fromJson(decodeImages(cardMap)));
      }
      for (var cardMap in (backupData['libraryCards'] as List)) {
        await _database.addLibraryCardBulk(LibraryCard.fromJson(decodeImages(cardMap)));
      }
      for (var cardMap in (backupData['customCards'] as List)) {
        await _database.addCustomCardBulk(CustomCard.fromJson(decodeImages(cardMap)));
      }

      await loadCards(); // Reload cards from DB to update the UI
      _showSnackBar('Cards imported successfully');
    } catch (e) {
      _showSnackBar('Import failed: $e');
    }
  }

  // --- Card Addition Methods ---

  Future<void> addPaymentCard(String cardNumber, String cardHolder, String expiryDate, String cvv, String type, File? frontImageFile, File? backImageFile) async {
    try {
      final Uint8List? frontBytes = await frontImageFile?.readAsBytes();
      final Uint8List? backBytes = await backImageFile?.readAsBytes();
      final companion = PaymentCardsCompanion.insert(
          cardholderName: cardHolder,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
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
      print('Error deleting cards: $e');
    }
  }
}
