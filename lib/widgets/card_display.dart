import 'package:flutter/material.dart';
import 'dart:typed_data'; // For Uint8List

// Import your custom card widgets
import 'package:wallet/widgets/credit_card.dart';
import 'package:wallet/widgets/jnu_lib_card.dart';
import 'package:wallet/widgets/custom_card.dart';

// This function builds and returns the appropriate card widget based on its data
Widget buildCardWidget(Map<String, dynamic> cardData) {

  // --- Payment Card Logic ---
  // We infer it's a payment card if it has a 'card_number' key.
  if (cardData.containsKey('cardNumber')) {
    final cardType = cardData['cardType'];

    // Handle specific, branded cards with built-in assets
    if (cardType == 'Swiggy') {
      return FlipCardWidget(
        cardNumber: cardData['cardNumber'] ?? '**** **** **** ****',
        cardHolder: cardData['cardholderName'] ?? 'CARD HOLDER',
        cardName: cardData['cardName'] ?? 'CREDIT CARD',
        expiryDate: cardData['expiryDate'] ?? 'MM/YY',
        cvv: cardData['cvv'] ?? '***',
        frontImageProvider: const AssetImage("assets/swiggy.png"),
        backImageProvider: const AssetImage("assets/swiggy_back.png"),
      );
    }

    if (cardType == 'SBI SimplyClick') {
      return FlipCardWidget(
        cardNumber: cardData['cardNumber'] ?? '**** **** **** ****',
        cardName: cardData['cardName']?? 'CREDIT CARD',
        cardHolder: cardData['cardholderName'] ?? 'CARD HOLDER',
        expiryDate: cardData['expiryDate'] ?? 'MM/YY',
        cvv: cardData['cvv'] ?? '***',
        frontImageProvider: const AssetImage("assets/simply_click.png"),
        backImageProvider: const AssetImage("assets/simply_click_back.png"),
      );
    }

    // Handle generic "Other" cards with images from the database
    ImageProvider? frontProvider;
    if (cardData['frontImage'] != null) {
      frontProvider = MemoryImage(cardData['frontImage'] as Uint8List);
    }

    ImageProvider? backProvider;
    if (cardData['backImage'] != null) {
      backProvider = MemoryImage(cardData['backImage'] as Uint8List);
    }

    return FlipCardWidget(
      cardNumber: cardData['cardNumber'] ?? '**** **** **** ****',
      cardHolder: cardData['cardholderName'] ?? 'CARD HOLDER',
      cardName: cardData['cardName'] ?? 'CREDIT CARD',
      expiryDate: cardData['expiryDate'] ?? 'MM/YY',
      cvv: cardData['cvv'] ?? '***',
      frontImageProvider: frontProvider, // Pass the MemoryImage or null
      backImageProvider: backProvider,   // Pass the MemoryImage or null
    );
  }

  // --- Library Card Logic ---
  // We infer it's a library card if it has an 'id_number' key.
  if (cardData.containsKey('idNumber')) {
    return FlippableJnuLibraryCard(
      name: cardData['name'] ?? 'Name',
      idNumber: cardData['idNumber'] ?? 'ID Number',
      registrationNumber: cardData['registrationNumber'] ?? 'Reg. No.',
      course: cardData['course'] ?? 'Course',
      session: cardData['session'] ?? 'Session',
      school: cardData['school'] ?? 'School',
      // Load profile image from database bytes, or use a default asset
      photo: cardData['profileImage'] != null
          ? MemoryImage(cardData['profileImage'] as Uint8List)
          : const AssetImage('assets/default.jpg'),
    );
  }

  // --- Custom Card Logic ---
  // We infer it's a custom card if it has a 'card_name' key.
  if (cardData.containsKey('cardName')) {
    ImageProvider? frontProvider;
    if (cardData['frontImage'] != null) {
      frontProvider = MemoryImage(cardData['frontImage'] as Uint8List);
    }

    ImageProvider? backProvider;
    if (cardData['backImage'] != null) {
      backProvider = MemoryImage(cardData['backImage'] as Uint8List);
    }

    return CustomCard(
      cardName: cardData['card_name'] ?? 'Custom Card',
      frontImageProvider: frontProvider,
      backImageProvider: backProvider,
    );
  }

  // Fallback for any unknown card data structure
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Text('Unknown card Type'),
    // child: Text(cardData.toString()),

  );
}
