import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Student QR Code"), 
        backgroundColor: Colors.red
      ),
      body: Stack(
        children: [
          // Render scanner only on mobile devices, show placeholder on Web
          kIsWeb 
            ? Container(
                color: Colors.black12,
                child: const Center(
                  child: Text("Camera Scanner disabled on Web Test Mode"),
                ),
              )
            : MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      Navigator.pop(context, barcode.rawValue);
                      break;
                    }
                  }
                },
              ),

          // Simulation button for quick testing
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pop(context, "STU-99482-WEB-TEST");
              },
              child: const Text(
                "Simulate QR Scan (Web Test)",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}