import 'package:flutter/material.dart';
import 'dart:math';
import 'credit_front.dart';
import 'credit_back.dart';

class FlipCardWidget extends StatefulWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  final String frontImage;
  final String backImage;

  const FlipCardWidget({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    required this.frontImage, required this.backImage,
  });

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
  bool _showFront = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
    super.initState();
  }

  void _flipCard() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _showFront = !_showFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isFront = _animation.value < pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_animation.value),
            child: isFront
                ? CreditCardFront(
              frontImage: widget.frontImage,
              cardNumber: widget.cardNumber,
              cardHolder: widget.cardHolder,
              expiryDate: widget.expiryDate,
            )
                : Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: CreditCardBack(cvv: widget.cvv, backImage:widget.backImage),
            ),
          );
        },
      ),
    );
  }
}
