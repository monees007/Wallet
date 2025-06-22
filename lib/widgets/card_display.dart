import 'package:flutter/material.dart';
import 'dart:io'; // For File

// Import your custom card widgets
import 'package:wallet/widgets/credit_card.dart';
import 'package:wallet/widgets/jnu_lib_card.dart';
import 'package:wallet/widgets/custom_card.dart';

// This function builds and returns the appropriate card widget based on its type
Widget buildCardWidget(Map<String, dynamic> cardData) {
  switch (cardData['type']) {
    case 'swiggy': // Example of a hardcoded credit card type
      return FlipCardWidget(
        cardNumber: cardData['cardNumber'] ?? '**** **** **** ****',
        cardHolder: cardData['cardHolder'] ?? 'CARD HOLDER',
        expiryDate: cardData['expiryDate'] ?? 'MM/YY',
        cvv: cardData['cvv'] ?? '***',
        frontImage: "assets/swiggy.png",
        backImage: "assets/swiggy_back.png",
      );
    case 'simply_click': // Example of another hardcoded credit card type
      return FlipCardWidget(
        cardNumber: cardData['cardNumber'] ?? '**** **** **** ****',
        cardHolder: cardData['cardHolder'] ?? 'CARD HOLDER',
        expiryDate: cardData['expiryDate'] ?? 'MM/YY',
        cvv: cardData['cvv'] ?? '***',
        frontImage: "assets/simply_click.png",
        backImage: "assets/simply_click_back.png",
      );
    case 'Other Credit/Debit Card': // Generic credit card
      return FlipCardWidget(
        cardNumber: cardData['cardNumber'] ?? '**** **** **** ****',
        cardHolder: cardData['cardHolder'] ?? 'CARD HOLDER',
        expiryDate: cardData['expiryDate'] ?? 'MM/YY',
        cvv: cardData['cvv'] ?? '***',
        // Check if image paths exist and use FileImage, otherwise use a placeholder
        frontImage: cardData['frontImage']?? '' , // Pass null if file doesn't exist
        backImage: cardData['backImage']?? '', // Pass null if file doesn't exist
      );
    case 'library':
      return FlippableJnuLibraryCard(
        name: cardData['name'] ?? 'Name',
        idNumber: cardData['idNumber'] ?? 'ID Number',
        registrationNumber: cardData['registrationNumber'] ?? 'Reg. No.',
        course: cardData['course'] ?? 'Course',
        session: cardData['session'] ?? 'Session',
        school: cardData['school'] ?? 'School',
        photo: cardData['profile'] != null && File(cardData['profile']).existsSync()
            ? FileImage(File(cardData['profile'])) as ImageProvider<Object>
            : const AssetImage('assets/default.jpg'), // Placeholder image
      );
    case 'custom':
      return CustomCard(
        cardName: cardData['cardName'] ?? 'Custom Card',
        frontImagePath: cardData['frontImagePath'] != null && File(cardData['frontImagePath']).existsSync()
            ? cardData['frontImagePath']
            : null,
        backImagePath: cardData['backImagePath'] != null && File(cardData['backImagePath']).existsSync()
            ? cardData['backImagePath']
            : null,
      );
    default:
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text('Unknown card type: ${cardData['type']}'),
      );
  }
}
