import 'package:flutter/material.dart';
import 'dart:math';
import 'jnu_lib_card.dart';

class FlippableJnuLibraryCard extends StatefulWidget {
  final String name;
  final String idNumber;
  final String registrationNumber;
  final String course;
  final String session;
  final String school;
  final ImageProvider photo;

  const FlippableJnuLibraryCard({
    super.key,
    required this.name,
    required this.idNumber,
    required this.registrationNumber,
    required this.course,
    required this.session,
    required this.school,
    required this.photo,
  });

  @override
  State<FlippableJnuLibraryCard> createState() =>
      _FlippableJnuLibraryCardState();
}

class _FlippableJnuLibraryCardState extends State<FlippableJnuLibraryCard>
    with SingleTickerProviderStateMixin {
  bool _isFront = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isBack = _animation.value >= 0.5;

          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
            child:
                isBack
                    ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: _buildBack(),
                    )
                    : _buildFront(),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return JnuLibraryCard(
      name: widget.name,
      idNumber: widget.idNumber,
      registrationNumber: widget.registrationNumber,
      course: widget.course,
      session: widget.session,
      school: widget.school,
      photo: widget.photo,
    );
  }

  Widget _buildBack() {
    return AspectRatio(
      aspectRatio: 85.6 / 53.98,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black87, width: 0.4),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'INSTRUCTIONS',
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
              ),
            ),
            SizedBox(height: 2),
            Text('1. Membership card is not transferable.\n2. Loss of card must be reported to issuing Authority immediately.\n3. A duplicate card will be issued on payment.\n4. This card is the property of the University.\n5. User must carry this card while visiting Central Library, JNU.',
            style: TextStyle(fontSize: 12, color: Colors.black, ),),
            SizedBox(height: 13,),
            Text('If found, please return to:\nDr BR AMBEDKAR CENTRAL LIBRARY, JNU New Delhi-110067\nTelephone: 91-011-26704551\nhttp://lib.jnu.ac.in/\nhttp://www.jnu.ac.in',
            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold, color: Colors.black,),)
                 ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
