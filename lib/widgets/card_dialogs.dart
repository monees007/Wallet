import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File

import 'package:wallet/services/card_service.dart';

// This file contains functions to show different card addition dialogs
class CardDialogs {
  // Main dialog to choose card type
  static void showAddCardDialog(BuildContext context, CardService cardService) {
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
                  Navigator.of(context).pop(); // Close current dialog
                  _showCreditCardForm(context, cardService);
                },
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Library ID Card'),
                onTap: () {
                  Navigator.of(context).pop(); // Close current dialog
                  _showLibraryCardForm(context, cardService);
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_membership),
                title: const Text('Other Card'),
                onTap: () {
                  Navigator.of(context).pop(); // Close current dialog
                  _showCustomCardForm(context, cardService);
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

  // Dialog for Credit/Debit Card Form
  static void _showCreditCardForm(BuildContext context, CardService cardService) {
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
                        autofillHints: const [AutofillHints.creditCardNumber],
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => cardNumber = value ?? '',
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        autofillHints: const [AutofillHints.creditCardName],
                        decoration: const InputDecoration(
                          labelText: 'Card Holder',
                        ),
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => cardHolder = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date (MM/YY)',
                        ),
                        keyboardType: TextInputType.datetime,
                        autofillHints: const [AutofillHints.creditCardExpirationDate],
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => expiryDate = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'CVV'),
                        keyboardType: TextInputType.number,
                        autofillHints: const [AutofillHints.creditCardSecurityCode],
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => cvv = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Type (e.g., Visa, Mastercard)'),
                        validator: (value) =>
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
                      cardService.addCreditCard(
                        cardNumber,
                        cardHolder,
                        expiryDate,
                        cvv,
                        type,
                        frontImage,
                        backImage,
                      );
                      Navigator.of(context).pop(); // Close form dialog
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

  // Dialog for Library Card Form
  static void _showLibraryCardForm(BuildContext context, CardService cardService) {
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
        return StatefulBuilder(
          builder: (context, setState) {
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
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => name = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'ID'),
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => id = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'ID Number'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => idNumber = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Registration Number',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => registrationNumber = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Course'),
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => course = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Session'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => session = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'School'),
                        validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => school = value ?? '',
                      ),
                      const SizedBox(height: 10),
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
                      cardService.addLibraryCard(
                        name,
                        idNumber,
                        registrationNumber,
                        course,
                        session,
                        school,
                        id,
                        profile,
                      );
                      Navigator.of(context).pop(); // Close form dialog
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

  // Dialog for Custom Card Form
  static void _showCustomCardForm(BuildContext context, CardService cardService) {
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
                        validator: (value) =>
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
                      cardService.addCustomCard(
                        cardName,
                        frontImage,
                        backImage,
                      );
                      Navigator.of(context).pop(); // Close form dialog
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
}
