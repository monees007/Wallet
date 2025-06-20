import 'package:flutter/material.dart';
import 'dart:math';
import 'package:barcode_widget/barcode_widget.dart'; // Import for BarcodeWidget

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


class JnuLibraryCard extends StatelessWidget {
  final String name;
  final String idNumber;
  final String registrationNumber;
  final String course;
  final String session;
  final String school;
  final ImageProvider photo;

  const JnuLibraryCard({
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
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 85.6 / 53.98,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black87, width: 0.4),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 2),
            _buildSubHeader(),
            const SizedBox(height: 7),
            _buildInfoSection(),
            const SizedBox(height: 4),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Center(
      child: Text(
        'JAWAHARLAL NEHRU UNIVERSITY',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSubHeader() {
    return Row(
      children: <Widget>[
        Image.asset(
          'assets/jnu_logo.png',
          width: 50, // Adjust width as needed
          height: 50, // Adjust height as needed
        ),
        Container(
          color: Colors.blue.shade900,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
          child: const Column(
            children: [
              Text(
                'Dr B R AMBEDKAR CENTRAL LIBRARY',
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'MEMBERSHIP CARD',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildInfoSection() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo
          Container(
            width: 75,
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              image: DecorationImage(image: photo, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          // Info
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 11, color: Colors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Registraion #", registrationNumber, bold: true),
                  _infoRow("NAME", name, bold: true),
                  _infoRow("ID NO.", idNumber, bold: true),
                  _infoRow("Course", course, bold: true),
                  _infoRow("Session", session, bold: true),
                  _infoRow("School/Center", school, bold: true),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text('$label :')),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: bold ? FontWeight.w600 : FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Barcode mock
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BarcodeWidget(
                barcode: Barcode.code128(),
                data: idNumber,
                width: 130,
                height: 25,
                drawText: false,
              ),
              const SizedBox(width: 9),
              Text(
                idNumber,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}