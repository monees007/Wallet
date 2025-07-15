import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'backup_utils.dart';
import 'database.dart';

class BackupService {
  final AppDatabase _db;

  BackupService(this._db);
  /// **Creates a complete, encrypted backup of all database content.**
  ///
  /// This function fetches all data, serializes it to JSON, encrypts it with the
  /// provided [password], and prompts the user to save the resulting file.

  Future<void> makeCompleteBackup(String password) async {
    final backupData = await _fetchAllData();
    final serializedData = json.encode(backupData);

    // Run encryption in the background
    final encryptedData = await compute(
      encryptDataForBackup,
      EncryptionPayload(serializedData, password),
    );

    await FilePicker.platform.saveFile(
      dialogTitle: 'Save Encrypted Backup',
      fileName: 'wallet_backup_${DateTime.now().toIso8601String()}.enc',
      bytes: encryptedData,
    );
  }

  Future<void> restoreCompleteBackup(String password) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final encryptedData = result.files.single.bytes!;

      try {
        // Run decryption in the background
        final decryptedData = await compute(
          decryptDataForRestore,
          DecryptionPayload(encryptedData, password),
        );

        final backupData = json.decode(decryptedData) as Map<String, dynamic>;
        await _clearAllTables();
        await _restoreData(backupData);
      } catch (e) {
        throw Exception('Failed to restore backup. Check password or file integrity.');
      }
    }
  }


  /// Fetches all records from all tables and converts them to a serializable map.
  Future<Map<String, List<Map<String, dynamic>>>> _fetchAllData() async {
    final allData = <String, List<Map<String, dynamic>>>{};
    allData['payment_cards'] = (await _db.getAllPaymentCards()).map((e) => e.toJson()).toList();
    allData['library_cards'] = (await _db.getAllLibraryCards()).map((e) => e.toJson()).toList();
    allData['custom_cards'] = (await _db.getAllCustomCards()).map((e) => e.toJson()).toList();
    allData['notes'] = (await _db.getAllNotes()).map((e) => e.toJson()).toList();
    allData['verification_codes'] = (await _db.getAllVerificationCodes()).map((e) => e.toJson()).toList();
    return allData;
  }

  /// Deletes all records from all tables.
  Future<void> _clearAllTables() async {
    await _db.customStatement('DELETE FROM payment_cards');
    await _db.customStatement('DELETE FROM library_cards');
    await _db.customStatement('DELETE FROM custom_cards');
    await _db.customStatement('DELETE FROM notes');
    await _db.customStatement('DELETE FROM verification_codes');
  }

  /// Restores data from a map into the respective tables using batch operations.
// In backup_service.dart

// In backup_service.dart

  Future<void> _restoreData(Map<String, dynamic> data) async {
    // Helper function to safely parse entries
    T? _safeFromJson<T>(
        dynamic item,
        T Function(Map<String, dynamic>) fromJson,
        ) {
      if (item is Map<String, dynamic>) {
        try {
          return fromJson(item);
        } catch (e) {
          print('Skipping corrupt item during restore: $e');
          return null;
        }
      }
      return null;
    }

    // --- HELPER TO FIX BLOB (IMAGE) FIELDS ---
    void _fixBlobFields(List<dynamic> tableData, List<String> blobFieldNames) {
      for (final itemMap in tableData) {
        if (itemMap is Map<String, dynamic>) {
          for (final fieldName in blobFieldNames) {
            if (itemMap[fieldName] is List) {
              // Convert List<dynamic> from JSON back to Uint8List for images
              itemMap[fieldName] = Uint8List.fromList((itemMap[fieldName] as List).cast<int>());
            }
          }
        }
      }
    }

    await _db.batch((batch) {
      if (data['payment_cards'] is List) {
        final list = data['payment_cards'] as List;
        _fixBlobFields(list, ['frontImage', 'backImage']); // Fix image fields
        final items = list
            .map((e) => _safeFromJson(e, PaymentCard.fromJson))
            .whereType<PaymentCard>()
            .toList();
        if (items.isNotEmpty) batch.insertAll(_db.paymentCards, items);
      }

      if (data['library_cards'] is List) {
        final list = data['library_cards'] as List;
        _fixBlobFields(list, ['profileImage']); // Fix image field
        final items = list
            .map((e) => _safeFromJson(e, LibraryCard.fromJson))
            .whereType<LibraryCard>()
            .toList();
        if (items.isNotEmpty) batch.insertAll(_db.libraryCards, items);
      }

      if (data['custom_cards'] is List) {
        final list = data['custom_cards'] as List;
        _fixBlobFields(list, ['frontImage', 'backImage']); // Fix image fields
        final items = list
            .map((e) => _safeFromJson(e, CustomCard.fromJson))
            .whereType<CustomCard>()
            .toList();
        if (items.isNotEmpty) batch.insertAll(_db.customCards, items);
      }

      if (data['notes'] is List) {
        final List<dynamic> notesList = data['notes'];
        for (final noteMap in notesList) {
          if (noteMap is Map<String, dynamic> && noteMap['images'] is List) {
            // Fix the List<String> field for note images
            noteMap['images'] = (noteMap['images'] as List).map((i) => i.toString()).toList();
          }
        }
        final items = notesList
            .map((e) => _safeFromJson(e, Note.fromJson))
            .whereType<Note>()
            .toList();
        if (items.isNotEmpty) batch.insertAll(_db.notes, items);
      }

      if (data['verification_codes'] is List) {
        final items = (data['verification_codes'] as List)
            .map((e) => _safeFromJson(e, VerificationCode.fromJson))
            .whereType<VerificationCode>()
            .toList();
        if (items.isNotEmpty) batch.insertAll(_db.verificationCodes, items);
      }
    });
  }

}