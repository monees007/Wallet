import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallet/credit_card.dart';
import 'package:wallet/flippabe_jnu_libcard.dart';
import 'package:wallet/custom_card.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            textTheme: TextTheme(
              titleLarge: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme:
                darkDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.cyan,
                  brightness: Brightness.dark,
                ),
            textTheme: TextTheme(
              titleLarge: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          themeMode: ThemeMode.system,

          home: const MyHomePage(title: 'Wallet'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _secureStorage = const FlutterSecureStorage();
  List<Map<String, dynamic>> _cards = [];
  bool isEditing = false;
  Set<int> selectedIndices = {};

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    try {
      String? cardsJson = await _secureStorage.read(key: 'wallet_cards');
      if (cardsJson != null) {
        List<dynamic> cardsList = jsonDecode(cardsJson);
        setState(() {
          _cards = cardsList.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error exporting cards: $e')));
    }
  }

  Future<void> _exportCards() async {
    try {
      String? cardsJson = await _secureStorage.read(key: 'wallet_cards');
      if (cardsJson == null || cardsJson.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No cards to export')));
        return;
      }

      final mediaDir = Directory(
        '/storage/emulated/0/Android/media/com.monees007.wallet/WalletBackup',
      );

      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }

      final file = File('${mediaDir.path}/wallet_cards_backup.json');
      await file.writeAsString(cardsJson);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cards exported to ${file.path}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error exporting cards: $e')));
    }
  }

  Future<void> _importCards(BuildContext context) async {
    try {
      // 1️⃣ Prompt user to pick a file (.json)
      final params = OpenFileDialogParams(
        dialogType: OpenFileDialogType.document,
        fileExtensionsFilter: ['json'],
        mimeTypesFilter: ['application/json'],
      );
      final filePath = await FlutterFileDialog.pickFile(params: params);

      if (filePath == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No file selected')));
        return;
      }

      final file = File(filePath);
      final content = await file.readAsString();
      final List<dynamic> cardsList = jsonDecode(content);

      setState(() {
        _cards = cardsList.cast<Map<String, dynamic>>();
      });
      await _saveCards();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cards imported successfully')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Import failed: $e')));
      }
    }
  }

  Future<void> _saveCards() async {
    try {
      String cardsJson = jsonEncode(_cards);
      await _secureStorage.write(key: 'wallet_cards', value: cardsJson);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error exporting cards: $e')));
    }
  }

  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Credit/Debit Card'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showCreditCardForm();
                },
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Library ID Card'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showLibraryCardForm();
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_membership),
                title: const Text('Other Card'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showCustomCardForm();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showCreditCardForm() {
    final formKey = GlobalKey<FormState>();
    String cardNumber = '';
    String cardHolder = '';
    String expiryDate = '';
    String cvv = '';
    File? frontImage;
    File? backImage;
    String type = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Credit/Debit Card'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Card Number',
                        ),
                        keyboardType: TextInputType.number,
                        autofillHints: [AutofillHints.creditCardNumber],
                        validator:
                            (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => cardNumber = value ?? '',
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        autofillHints: [AutofillHints.creditCardName],
                        decoration: const InputDecoration(
                          labelText: 'Card Holder',
                        ),
                        validator:
                            (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => cardHolder = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date (MM/YY)',
                        ),
                        keyboardType: TextInputType.datetime,
                        autofillHints: [AutofillHints.creditCardExpirationDate],
                        validator:
                            (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => expiryDate = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'CVV'),
                        keyboardType: TextInputType.number,
                        autofillHints: [AutofillHints.creditCardSecurityCode],
                        validator:
                            (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => cvv = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Type'),
                        validator:
                            (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => type = value ?? '',
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    frontImage = File(pickedFile.path);
                                  });
                                }
                              },
                              icon: const Icon(Icons.image),
                              label: Text(
                                frontImage != null ? 'Front ' : 'Front Image',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    backImage = File(pickedFile.path);
                                  });
                                }
                              },
                              icon: const Icon(Icons.image),
                              label: Text(
                                backImage != null ? 'Back' : 'Back Image',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState?.save();
                      _addCreditCard(
                        cardNumber,
                        cardHolder,
                        expiryDate,
                        cvv,
                        type,
                        frontImage,
                        backImage,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLibraryCardForm() {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String idNumber = '';
    String registrationNumber = '';
    String course = '';
    String session = '';
    String school = '';
    File? profile;
    String id = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Library Card'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator:
                        (value) => value?.isEmpty ?? true ? 'Required' : null,
                    onSaved: (value) => name = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'ID'),
                    validator:
                        (value) => value?.isEmpty ?? true ? 'Required' : null,
                    onSaved: (value) => id = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'ID Number'),
                    validator:
                        (value) => value?.isEmpty ?? true ? 'Required' : null,
                    onSaved: (value) => idNumber = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Registration Number',
                    ),
                    validator:
                        (value) => value?.isEmpty ?? true ? 'Required' : null,
                    onSaved: (value) => registrationNumber = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Course'),
                    validator:
                        (value) => value?.isEmpty ?? true ? 'Required' : null,
                    onSaved: (value) => course = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Session'),
                    validator:
                        (value) => value?.isEmpty ?? true ? 'Required' : null,
                    onSaved: (value) => session = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'School'),
                    validator:
                        (value) => value?.isEmpty ?? true ? 'Required' : null,
                    onSaved: (value) => school = value ?? '',
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          profile = File(pickedFile.path);
                        });
                      }
                    },
                    icon: const Icon(Icons.image),
                    label: Text(
                      profile != null ? 'Profile ✓' : 'Profile Image',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                  _addLibraryCard(
                    name,
                    idNumber,
                    registrationNumber,
                    course,
                    session,
                    school,
                    id,
                    profile,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showCustomCardForm() {
    final formKey = GlobalKey<FormState>();
    String cardName = '';
    File? frontImage;
    File? backImage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Custom Card'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Card Name',
                        ),
                        validator:
                            (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => cardName = value ?? '',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    frontImage = File(pickedFile.path);
                                  });
                                }
                              },
                              icon: const Icon(Icons.image),
                              label: Text(
                                frontImage != null ? 'Front ✓' : 'Front Image',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    backImage = File(pickedFile.path);
                                  });
                                }
                              },
                              icon: const Icon(Icons.image),
                              label: Text(
                                backImage != null ? 'Back ✓' : 'Back Image',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState?.save();
                      _addCustomCard(cardName, frontImage, backImage);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addCreditCard(
    String cardNumber,
    String cardHolder,
    String expiryDate,
    String cvv,
    String type,
    File? frontImage,
    File? backImage,
  ) async {
    setState(() {
      _cards.add({
        'type': type,
        'cardNumber': cardNumber,
        'cardHolder': cardHolder,
        'expiryDate': expiryDate,
        'cvv': cvv,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'frontImage': frontImage?.path,
        'backImage': backImage?.path,
      });
    });
    _saveCards();
  }

  void _addLibraryCard(
    String name,
    String idNumber,
    String registrationNumber,
    String course,
    String session,
    String school,
    String id,
    File? profile,
  ) {
    setState(() {
      _cards.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': 'library',
        'name': name,
        'idNumber': idNumber,
        'registrationNumber': registrationNumber,
        'course': course,
        'session': session,
        'school': school,
        'profile': profile?.path,
      });
    });
    _saveCards();
  }

  void _addCustomCard(String cardName, File? frontImage, File? backImage) {
    setState(() {
      _cards.add({
        'type': 'custom',
        'cardName': cardName,
        'frontImagePath': frontImage?.path,
        'backImagePath': backImage?.path,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });
    _saveCards();
  }

  Widget _buildCard(Map<String, dynamic> cardData) {
    switch (cardData['type']) {
      case 'swiggy':
        return FlipCardWidget(
          cardNumber: cardData['cardNumber'],
          cardHolder: cardData['cardHolder'],
          expiryDate: cardData['expiryDate'],
          cvv: cardData['cvv'],
          frontImage: "assets/swiggy.png",
          backImage: "assets/swiggy_back.png",
        );
      case 'simply_click':
        return FlipCardWidget(
          cardNumber: cardData['cardNumber'],
          cardHolder: cardData['cardHolder'],
          expiryDate: cardData['expiryDate'],
          cvv: cardData['cvv'],
          frontImage: "assets/simply_click.png",
          backImage: "assets/simply_click_back.png",
        );
      case 'credit':
        return FlipCardWidget(
          cardNumber: cardData['cardNumber'],
          cardHolder: cardData['cardHolder'],
          expiryDate: cardData['expiryDate'],
          cvv: cardData['cvv'],
          frontImage: cardData['frontImage'] ?? '',
          backImage: cardData['backImage'] ?? '',
        );
      case 'library':
        return FlippableJnuLibraryCard(
          name: cardData['name'],
          idNumber: cardData['idNumber'],
          registrationNumber: cardData['registrationNumber'],
          course: cardData['course'],
          session: cardData['session'],
          school: cardData['school'],
          photo:
              cardData['profile'] != null
                  ? FileImage(File(cardData['profile']))
                  : AssetImage('assets/default.jpg'),
        );
      case 'custom':
        return CustomCard(
          cardName: cardData['cardName'],
          frontImagePath: cardData['frontImagePath'],
          backImagePath: cardData['backImagePath'],
        );
      default:
        return Container();
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
            onPressed: _exportCards,
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Import Cards',
            onPressed: () => _importCards(context),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                selectedIndices.clear();
              });
            },
          ),
          if (isEditing)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _cards =
                      _cards
                          .asMap()
                          .entries
                          .where((e) => !selectedIndices.contains(e.key))
                          .map((e) => e.value)
                          .toList();
                  selectedIndices.clear();
                  _saveCards();
                  isEditing = false;
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
                if (isEditing) {
                  setState(() {
                    if (isSelected) {
                      selectedIndices.remove(index);
                    } else {
                      selectedIndices.add(index);
                    }
                  });
                }
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      _buildCard(card),
                      if (isEditing)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: IconButton(
                            color: Colors.orangeAccent,
                            icon: Icon(
                              isSelected
                                  ? Icons.check
                                  : Icons.check_box_outline_blank,
                            ),
                            onPressed: () {
                              isSelected = !isSelected;
                              setState(() {
                                if (isSelected) {
                                  selectedIndices.add(index);
                                } else {
                                  selectedIndices.remove(index);
                                }
                              });
                            },
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
        onPressed: _showAddCardDialog,
        tooltip: 'Add Card',
        child: const Icon(Icons.add),
      ),
    );
  }
}
