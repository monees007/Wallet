import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
// import 'package:url_launcher/url_launcher.dart';

import 'database.dart';

class AddEditTOTPScreen extends StatefulWidget {
  final VerificationCode? existingAccount;
  final AppDatabase database;


  const AddEditTOTPScreen({
    super.key,
    this.existingAccount,
    required this.database,
  });

  @override
  State<AddEditTOTPScreen> createState() => _AddEditTOTPScreenState();
}

class _AddEditTOTPScreenState extends State<AddEditTOTPScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _issuerController;
  late final TextEditingController _accountNameController;
  late final TextEditingController _secretController;
  late final TextEditingController _logoUrlController;

  @override
  void initState() {
    super.initState();
    _issuerController = TextEditingController(text: widget.existingAccount?.issuer ?? '');
    _accountNameController = TextEditingController(text: widget.existingAccount?.accountName ?? '');
    _secretController = TextEditingController(text: widget.existingAccount?.secretKey ?? '');
    _logoUrlController = TextEditingController(text: widget.existingAccount?.logoUrl ?? '');
  }

  @override
  void dispose() {
    _issuerController.dispose();
    _accountNameController.dispose();
    _secretController.dispose();
    _logoUrlController.dispose();
    super.dispose();
  }

  // Future<void> _findLogo() async {
  //   if (_issuerController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please enter an issuer name first.')),
  //     );
  //     return;
  //   }
  //   final query = Uri.encodeComponent('${_issuerController.text} logo');
  //   final url = Uri.parse('https://www.google.com/search?tbm=isch&q=$query');
  //
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Could not open browser to search for: $url')),
  //     );
  //   }
  // }

  void _saveAccount() async {
    if (_formKey.currentState!.validate()) {
      final companion = VerificationCodesCompanion(
        issuer: drift.Value(_issuerController.text),
        accountName: drift.Value(_accountNameController.text),
        secretKey: drift.Value(_secretController.text),
        logoUrl: drift.Value(_logoUrlController.text),
      );

      // This example only handles adding a new one
      await widget.database.addVerificationCode(companion);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account saved successfully!')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingAccount == null ? 'Add Account' : 'Edit Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAccount,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _issuerController,
                decoration: const InputDecoration(
                  labelText: 'Issuer',
                  hintText: 'e.g., Google, GitHub',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter an issuer' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountNameController,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  hintText: 'e.g., user@example.com',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter an account name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _secretController,
                decoration: const InputDecoration(
                  labelText: 'Secret Key',
                  hintText: 'Your base32 secret key',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter the secret key' : null,
              ),
              // const SizedBox(height: 24),
              // TextFormField(
              //   controller: _logoUrlController,
              //   decoration: InputDecoration(
              //     labelText: 'Logo URL (Optional)',
              //     hintText: 'Paste the URL of an image',
              //     border: const OutlineInputBorder(),
              //     suffixIcon: IconButton(
              //       icon: const Icon(Icons.search),
              //       onPressed: _findLogo,
              //       tooltip: 'Search for logo on Google Images',
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 8),
              // const Text(
              //   'Tip: Tap the search icon to find a logo. Then, long-press the image in your browser and copy its URL to paste here.',
              //   style: TextStyle(color: Colors.grey, fontSize: 12),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}