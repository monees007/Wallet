import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

// This class will handle all card-related data operations
class CardService {
  final FlutterSecureStorage _secureStorage;
  final Function(List<Map<String, dynamic>>) _onCardsUpdated;
  final Function(String) _showSnackBar;

  List<Map<String, dynamic>> _cards = [];

  CardService({
    required FlutterSecureStorage storage,
    required Function(List<Map<String, dynamic>>) onCardsUpdated,
    required Function(String) showSnackBar,
  }) : _secureStorage = storage,
        _onCardsUpdated = onCardsUpdated,
        _showSnackBar = showSnackBar;

  // --- Data Loading and Saving ---

  Future<void> loadCards() async {
    try {
      String? cardsJson = await _secureStorage.read(key: 'wallet_cards');
      if (cardsJson != null) {
        List<dynamic> cardsList = jsonDecode(cardsJson);
        _cards = cardsList.cast<Map<String, dynamic>>();
        _onCardsUpdated(_cards); // Notify listener
      }
    } catch (e) {
      _showSnackBar('Error loading cards: $e');
    }
  }

  Future<void> _saveCards() async {
    try {
      String cardsJson = jsonEncode(_cards);
      await _secureStorage.write(key: 'wallet_cards', value: cardsJson);
      _onCardsUpdated(_cards); // Notify listener after saving
    } catch (e) {
      _showSnackBar('Error saving cards: $e');
    }
  }

  // --- Export/Import Operations ---

  Future<void> exportCards() async {
    try {
      String? cardsJson = await _secureStorage.read(key: 'wallet_cards');
      if (cardsJson == null || cardsJson.isEmpty) {
        _showSnackBar('No cards to export');
        return;
      }

      // Define a more general and accessible directory for backup
      // This path is for Android 10+ and might require MANAGE_EXTERNAL_STORAGE permission
      // For more robust solutions, consider path_provider or similar packages for platform-agnostic paths.
      final String externalStoragePath = '/storage/emulated/0/';
      final Directory backupDir = Directory('${externalStoragePath}Download/WalletBackup');

      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      final file = File('${backupDir.path}/wallet_cards_backup.json');
      await file.writeAsString(cardsJson);

      _showSnackBar('Cards exported to ${file.path}');
    } catch (e) {
      _showSnackBar('Error exporting cards: $e');
    }
  }

  Future<void> importCards(BuildContext context) async {
    try {
      final params = OpenFileDialogParams(
        dialogType: OpenFileDialogType.document,
        fileExtensionsFilter: const ['json'],
        mimeTypesFilter: const ['application/json'],
      );
      final filePath = await FlutterFileDialog.pickFile(params: params);

      if (filePath == null) {
        _showSnackBar('No file selected');
        return;
      }

      final file = File(filePath);
      final content = await file.readAsString();
      final List<dynamic> cardsList = jsonDecode(content);

      _cards = cardsList.cast<Map<String, dynamic>>();
      await _saveCards(); // Save imported cards

      _showSnackBar('Cards imported successfully');
    } catch (e) {
      _showSnackBar('Import failed: $e');
    }
  }

  // --- Card Addition Methods ---

  Future<void> addCreditCard(
      String cardNumber,
      String cardHolder,
      String expiryDate,
      String cvv,
      String type,
      File? frontImage,
      File? backImage,
      ) async {
    _cards.add({
      'type': type,
      'cardNumber': cardNumber,
      'cardHolder': cardHolder,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'frontImage': frontImage?.path, // Store image path
      'backImage': backImage?.path,   // Store image path
    });
    await _saveCards();
    _showSnackBar('Credit Card added successfully!');
  }

  Future<void> addLibraryCard(
      String name,
      String idNumber,
      String registrationNumber,
      String course,
      String session,
      String school,
      String id,
      File? profile,
      ) async {
    _cards.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'library',
      'name': name,
      'idNumber': idNumber,
      'registrationNumber': registrationNumber,
      'course': course,
      'session': session,
      'school': school,
      'profile': profile?.path, // Store image path
    });
    await _saveCards();
    _showSnackBar('Library Card added successfully!');
  }

  Future<void> addCustomCard(String cardName, File? frontImage, File? backImage) async {
    _cards.add({
      'type': 'custom',
      'cardName': cardName,
      'frontImagePath': frontImage?.path, // Store image path
      'backImagePath': backImage?.path,   // Store image path
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    await _saveCards();
    _showSnackBar('Custom Card added successfully!');
  }

  // --- Card Deletion Method ---

  Future<void> deleteCards(Set<int> indicesToDelete) async {
    // Create a new list excluding the cards at the selected indices
    final List<Map<String, dynamic>> updatedCards = [];
    for (int i = 0; i < _cards.length; i++) {
      if (!indicesToDelete.contains(i)) {
        updatedCards.add(_cards[i]);
      }
    }
    _cards = updatedCards;
    await _saveCards();
    _showSnackBar('Selected cards deleted!');
  }
}
