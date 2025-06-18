import 'package:flutter/material.dart';

class CreditCardBack extends StatelessWidget {
  final String cvv;
  final String backImage;

  const CreditCardBack({super.key, required this.cvv, required this.backImage});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 85.6 / 53.98,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          image: backImage!='' ? DecorationImage(
            image: AssetImage(backImage),
            fit: BoxFit.cover,
          ) : null,
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
            Container(
              height: 40,
              color: Colors.black87,
            ),
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
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Swipe Signature',
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
