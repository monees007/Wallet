import 'package:flutter/material.dart';
import 'dart:math';
import 'credit_front.dart';
import 'credit_back.dart';

class FlipCardWidget extends StatefulWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  // UPDATED: Changed from String to nullable ImageProvider
  final ImageProvider<Object>? frontImageProvider;
  final ImageProvider<Object>? backImageProvider;

  const FlipCardWidget({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    // UPDATED: Now accepts ImageProvider
    this.frontImageProvider,
    this.backImageProvider,
  });

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    // This animation flips the card from 0 to 180 degrees (pi radians)
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  void _flipCard() {
    // Forward animation shows the back, reverse shows the front
    if (_controller.isCompleted || _controller.isDismissed) {
      if (_controller.isDismissed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    // It's important to dispose of the controller to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Determine if the front of the card should be shown
          final isFront = _animation.value < (pi / 2);
          return Transform(
            alignment: Alignment.center,
            // Apply a 3D rotation effect
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_animation.value),
            child: isFront
                ? CreditCardFront(
              // UPDATED: Pass the ImageProvider down
              frontImageProvider: widget.frontImageProvider,
              cardNumber: widget.cardNumber,
              cardHolder: widget.cardHolder,
              expiryDate: widget.expiryDate,
            )
                : Transform(
              // Rotate the back of the card so it's not mirrored
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: CreditCardBack(
                  cvv: widget.cvv,
                  // UPDATED: Pass the ImageProvider down
                  backImageProvider: widget.backImageProvider,
                  cardHolder: widget.cardHolder),
            ),
          );
        },
      ),
    );
  }
}
