import 'package:flutter/material.dart';
import 'dart:io';

class CustomCard extends StatefulWidget {
  final String cardName;
  final String? frontImagePath;
  final String? backImagePath;

  const CustomCard({
    super.key,
    required this.cardName,
    this.frontImagePath,
    this.backImagePath,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isShowingFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isShowingFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isShowingFront = !_isShowingFront;
    });
  }

  Widget _buildCardSide({
    required String? imagePath,
    required bool isFront,
  }) {
    return AspectRatio(
      aspectRatio: 85.6 / 53.98,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black87, width: 0.4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Background image or color
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child:
                imagePath != null
                        ? Image.file(
                          File(imagePath),
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.purple.shade400,
                                    Colors.blue.shade600,
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                        : null,
              ),
              // Card content
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isShowingFront = _animation.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_animation.value * 3.14159),
            child:
                isShowingFront
                    ? _buildCardSide(
                      imagePath: widget.frontImagePath,
                      isFront: true,
                    )
                    : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.14159),
                      child: _buildCardSide(
                        imagePath: widget.backImagePath,
                        isFront: false,
                      ),
                    ),
          );
        },
      ),
    );
  }
}
