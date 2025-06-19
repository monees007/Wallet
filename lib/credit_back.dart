import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class CreditCardBack extends StatelessWidget {
  final String cvv;
  final String backImage;
  final String cardHolder;

  String toTitleCase(String input) {
    return input
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  const CreditCardBack({
    super.key,
    required this.cvv,
    required this.backImage,
    required this.cardHolder,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 85.6 / 53.98,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          image: DecorationImage(
            image:
                backImage.contains('asset')
                    ? AssetImage(backImage)
                    : FileImage(File(backImage)),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Container(height: 40, color: Colors.black87),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    alignment: Alignment.centerRight,
                    child: Text(
                      cvv,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                toTitleCase(cardHolder),
                style: GoogleFonts.meaCulpa(
                  color: Colors.white54,
                  fontSize: 30, // Looks better larger
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
