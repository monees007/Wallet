import 'package:flutter/material.dart';

String formatCardNumber(String text) {
  // Remove any existing spaces or non-digit characters first
  String digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

  var buffer = StringBuffer();
  for (int i = 0; i < digitsOnly.length; i++) {
    buffer.write(digitsOnly[i]);
    var nonZeroIndex = i + 1;
    // Add a space after every 4th digit, but not at the very end
    if (nonZeroIndex % 4 == 0 && nonZeroIndex != digitsOnly.length) {
      buffer.write(' ');
    }
  }
  return buffer.toString();
}

class CreditCardFront extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final ImageProvider<Object>? frontImageProvider;

  const CreditCardFront({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.frontImageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 85.6 / 53.98,
      child: Container(
        decoration: BoxDecoration(
          // Use the image provider if it exists, otherwise use a solid color.
          image: frontImageProvider != null
              ? DecorationImage(
            image: frontImageProvider!,
            fit: BoxFit.cover,
          )
              : null,
          color: frontImageProvider == null ? Colors.blueGrey[900] : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
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
            // Spacer to push content down, you can add a chip or logo here
            const Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 40,
                width: 60,
                // // Placeholder for a chip
                // child: DecoratedBox(
                //   decoration: BoxDecoration(
                //       color: Color(0xFFC0C0C0),
                //       borderRadius: BorderRadius.all(Radius.circular(6))
                //   ),
                // ),
              ),
            ),
            SizedBox(height: 15,),

            Text(
              formatCardNumber(cardNumber),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontFamily: 'Courier',
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black87,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _labelValue('Card Holder', cardHolder),
                _labelValue('Expires', expiryDate),
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
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
            shadows: const [
              Shadow(
                blurRadius: 1.0,
                color: Colors.black54,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black87,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
