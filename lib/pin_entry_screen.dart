import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinEntryScreen extends StatefulWidget {
  final bool isSettingPin;
  const PinEntryScreen({super.key, this.isSettingPin = false});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  final _pinController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  String? _error;

  Future<void> _checkPin() async {
    String? savedPin = await _storage.read(key: 'pin');
    if (_pinController.text == savedPin) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _error = 'Incorrect PIN');
    }
  }

  Future<void> _savePin() async {
    if (_pinController.text.length == 4) {
      await _storage.write(key: 'pin', value: _pinController.text);
      Navigator.of(context).pop(true);
    } else {
      setState(() => _error = 'PIN must be 4 digits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isSettingPin ? 'Set PIN' : 'Enter PIN')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'PIN',
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.isSettingPin ? _savePin : _checkPin,
              child: Text(widget.isSettingPin ? 'Save PIN' : 'Unlock'),
            ),
          ],
        ),
      ),
    );
  }
}
