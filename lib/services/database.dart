import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// ignore: depend_on_referenced_packages
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

part 'database.g.dart';

// This converts a List<String> into a JSON string and back.
class ImageListConverter extends TypeConverter<List<String>, String> {
  const ImageListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return (json.decode(fromDb) as List).cast<String>();
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}


/// Table for storing credit/debit cards.
@DataClassName('PaymentCard')
class PaymentCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cardholderName => text().withLength(min: 1, max: 50)();
  TextColumn get cardNumber => text().withLength(min: 16, max: 19)();
  TextColumn get expiryDate => text().withLength(min: 5, max: 5)(); // MM/YY
  TextColumn get cvv => text().withLength(min: 3, max: 4)();
  TextColumn get cardType => text().nullable()(); // e.g., Visa, Mastercard
  BlobColumn get frontImage => blob().nullable()();
  BlobColumn get backImage => blob().nullable()();
}

/// NEW: Table for storing library cards.
@DataClassName('LibraryCard')
class LibraryCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get idNumber => text()();
  TextColumn get registrationNumber => text().nullable()();
  TextColumn get course => text().nullable()();
  TextColumn get session => text().nullable()();
  TextColumn get school => text().nullable()();
  // CORRECTED: Renamed 'profile' to 'profileImage' for consistency
  BlobColumn get profileImage => blob().nullable()();
}

/// NEW: Table for storing custom, image-based cards.
@DataClassName('CustomCard')
class CustomCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cardName => text()();
  BlobColumn get frontImage => blob().nullable()();
  BlobColumn get backImage => blob().nullable()();
}

/// Table for storing secure notes.
@DataClassName('Note')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1)();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // --- NEW FIELDS ---
  TextColumn get theme => text().nullable()();
  TextColumn get images => text()
      .map(const ImageListConverter())
      .withDefault(Constant('[]'))(); // Defaults to an empty JSON array '[]'
}

/// Table for storing two-step verification codes (TOTP secrets).
@DataClassName('VerificationCode')
class VerificationCodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get issuer => text().withLength(min: 1)(); // e.g., Google, GitHub
  TextColumn get accountName => text()(); // e.g., user@example.com
  TextColumn get secretKey => text()(); // This is the sensitive secret
}

// --- 2. Define the Database Class ---
// CORRECTED: Added generateFromJson: true to enable JSON serialization
@DriftDatabase(
  tables: [PaymentCards, LibraryCards, CustomCards, Notes, VerificationCodes],
  daos: [],
  // This explicitly tells Drift to generate the fromJson factory constructors.
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

  // You should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 3; // Bumped from 2 to 3

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Use a switch statement to handle specific version upgrades
      if (from == 2) {
        // This is the migration from v2 to v3
        await m.addColumn(notes, notes.theme);
        await m.addColumn(notes, notes.images);
      }
    },
  );

  factory AppDatabase() => AppDatabase._(openConnection());

  // --- Data Access Methods ---

  // PaymentCard methods
  Future<List<PaymentCard>> getAllPaymentCards() => select(paymentCards).get();
  Future<int> addPaymentCardBulk(PaymentCard entry) => into(paymentCards).insert(entry);
  Future<int> addPaymentCard(PaymentCardsCompanion entry) => into(paymentCards).insert(entry);
  Future<int> deletePaymentCard(int id) => (delete(paymentCards)..where((t) => t.id.equals(id))).go();

  // LibraryCard methods
  Future<List<LibraryCard>> getAllLibraryCards() => select(libraryCards).get();
  Future<int> addLibraryCardBulk(LibraryCard entry) => into(libraryCards).insert(entry);
  Future<int> addLibraryCard(LibraryCardsCompanion entry) => into(libraryCards).insert(entry);
  Future<int> deleteLibraryCard(int id) => (delete(libraryCards)..where((t) => t.id.equals(id))).go();

  // CustomCard methods
  Future<List<CustomCard>> getAllCustomCards() => select(customCards).get();
  Future<int> addCustomCardBulk(CustomCard entry) => into(customCards).insert(entry);
  Future<int> addCustomCard(CustomCardsCompanion entry) => into(customCards).insert(entry);
  Future<int> deleteCustomCard(int id) => (delete(customCards)..where((t) => t.id.equals(id))).go();

  // Note methods
  Stream<List<Note>> watchAllNotes() => (select(notes)..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])).watch();
  Future<List<Note>> getAllNotes() => select(notes).get();
  Future<Note> getNoteById(int nid) => (select(notes)..where((tbl) => tbl.id.equals(nid))).getSingle();  Future<int> addNote(NotesCompanion entry) => into(notes).insert(entry);
  Future<bool> updateNote(NotesCompanion entry) => update(notes).replace(entry);
  Future<int> deleteNote(int id) => (delete(notes)..where((t) => t.id.equals(id))).go();

  // Verification code methods
  Future<List<VerificationCode>> getAllVerificationCodes() => select(verificationCodes).get();
  Future<int> addVerificationCode(VerificationCodesCompanion entry) => into(verificationCodes).insert(entry);
  Future<int> deleteVerificationCode(int id) => (delete(verificationCodes)..where((t) => t.id.equals(id))).go();
}

// --- 3. Setup the Encrypted Connection ---
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'wallet.db'));

    open.overrideFor(OperatingSystem.android, openCipherOnAndroid);

    // IMPORTANT: This password should be fetched from flutter_secure_storage
    const password = 'your-very-secret-password';

    final connection = NativeDatabase(file, setup: (db) {
      db.execute("PRAGMA key = '$password';");
    });

    return connection;
  });
}