import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

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
    return Center(
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
          child: Column(
            children: [const Text(
              'Dr B R AMBEDKAR CENTRAL LIBRARY',
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 1.5,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),const Text(
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

  // Widget _buildRegistration(String regNo) {
  //   return Center(
  //     child: Text.rich(
  //       TextSpan(
  //         text: 'Registration No. : ',
  //         style: const TextStyle(fontSize: 12),
  //         children: [
  //           TextSpan(
  //             text: regNo,
  //             style: const TextStyle(fontWeight: FontWeight.w600),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
        // Signature
        // SizedBox(width: 15),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   children: const [
        //     Text(
        //       "Librarian",
        //       style: TextStyle(fontSize: 15,),
        //     ),
        //
        //   ],
        // )
      ],
    );
  }
}
