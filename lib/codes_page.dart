import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp/otp.dart';
// import 'package:cached_network_image/cached_network_image.dart';

import 'services/database.dart';
import 'services/totp_service.dart';

class TOTPScreen extends StatefulWidget {
  final AppDatabase database;
  const TOTPScreen({super.key, required this.database});
  @override
  State<TOTPScreen> createState() => _TOTPScreenState();
}

class _TOTPScreenState extends State<TOTPScreen> {
  late Stream<List<VerificationCode>> _accountsStream;
  late Timer _timer;
  // final Map<int, String> _totpCodes = {};

  @override
  void initState() {
    super.initState();
    _accountsStream = widget.database.watchAllVerificationCodes();
    _startTimer();
  }

  void _startTimer() {
    // Update state every second to refresh UI (progress bar and codes)
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      // The codes will be generated on-the-fly in the build method.
      if (mounted) {
        setState(() {});
      }
    });
  }

  String _generateCodeForAccount(VerificationCode account) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final normalizedSecret = account.secretKey.replaceAll(' ', '').toUpperCase();
    try {
      return OTP.generateTOTPCodeString(
        normalizedSecret,
        now,
        interval: 30,
        length: 6,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
    } catch (e) {
      return 'Invalid Secret';
    }
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _deleteAccount(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text('Are you sure you want to delete this TOTP account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.database.deleteVerificationCode(id);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int get _secondsRemaining => 30 - (DateTime.now().second % 30);
  double get _progress => _secondsRemaining / 30.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(

      body: StreamBuilder<List<VerificationCode>>(
        stream: _accountsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final accounts = snapshot.data ?? [];
          if (accounts.isEmpty) {
            return const Center(
              child: Text(
                'No accounts yet.\nTap the + button to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              final code = _generateCodeForAccount(account);

              return Card(
                elevation: 0,
                color: theme.colorScheme.onSecondaryFixedVariant,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ListTile(
                      onTap: () => _copyToClipboard(code),
                      // leading: CircleAvatar(
                      //   backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      //   foregroundImage: (account.logoUrl != null && account.logoUrl!.isNotEmpty)
                      //       ? CachedNetworkImageProvider(account.logoUrl!)
                      //       : null,
                      //   child: Text(account.issuer.isNotEmpty ? account.issuer[0].toUpperCase() : '?',style: TextStyle(color: theme.colorScheme.primary,fontSize: 30),),
                      // ),
                      title: Text(account.issuer, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                      subtitle: Text(account.accountName),
                      trailing: SizedBox(
                        width: 140, // Adjust width as needed
                        child: Text(
                          code,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onLongPress: () => _deleteAccount(account.id), // Or use an icon button
                    ),
                    const SizedBox(height: 0),
                    LinearProgressIndicator(
                      value: _progress,
                      // backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _secondsRemaining < 6 ? Colors.red : theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTOTPScreen(database: widget.database)),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Account'),
      ),
    );
  }
}