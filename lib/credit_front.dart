import 'dart:io';

import 'package:flutter/material.dart';

class CreditCardFront extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String frontImage;


  const CreditCardFront({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate, required this.frontImage,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 85.6 / 53.98,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          image: DecorationImage(
            image:  frontImage.contains('asset')?  AssetImage(frontImage): FileImage(File(frontImage)),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black, 
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            Text(
              cardNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontFamily: 'Courier',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _labelValue('Card Holder', cardHolder),
                _labelValue('Expires', expiryDate),
                const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}
