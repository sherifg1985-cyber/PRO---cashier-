import 'package:flutter/material.dart';

class FingerprintSetupScreen extends StatefulWidget {
  const FingerprintSetupScreen({Key? key}) : super(key: key);

  @override
  State<FingerprintSetupScreen> createState() => _FingerprintSetupScreenState();
}

class _FingerprintSetupScreenState extends State<FingerprintSetupScreen> {
  bool _isScanning = false;
  int _fingerprintScans = 0;
  final int _requiredScans = 5;

  void _startFingerprintScan() {
    setState(() => _isScanning = true);
    // TODO: Implement actual fingerprint scanning
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isScanning = false;
        if (_fingerprintScans < _requiredScans) {
          _fingerprintScans++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Fingerprint'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isScanning)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (value * 0.2),
                    child: Icon(
                      Icons.fingerprint,
                      size: 100,
                      color: Colors.blue[700],
                    ),
                  );
                },
              )
            else
              Icon(
                Icons.fingerprint,
                size: 100,
                color: Colors.grey[400],
              ),
            const SizedBox(height: 32),
            Text(
              'Fingerprint Scan $_fingerprintScans/$_requiredScans',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _fingerprintScans / _requiredScans,
              minHeight: 8,
            ),
            const SizedBox(height: 32),
            if (_fingerprintScans < _requiredScans)
              ElevatedButton(
                onPressed: _isScanning ? null : _startFingerprintScan,
                child: Text(_isScanning ? 'Scanning...' : 'Place Finger'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  // TODO: Save fingerprint and navigate
                  Navigator.pop(context);
                },
                child: const Text('Setup Complete'),
              ),
          ],
        ),
      ),
    );
  }
}
