// lib/screens/qr_scanner_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Scan Student QR Code",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (!kIsWeb)
            ValueListenableBuilder(
              valueListenable: _scannerController,
              builder: (context, state, child) {
                return IconButton(
                  icon: Icon(
                    state.torchState == TorchState.on
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    color: Colors.amber,
                  ),
                  onPressed: () => _scannerController.toggleTorch(),
                );
              },
            ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Render scanner on mobile, show interactive web placeholder on Web
          kIsWeb
              ? _buildWebPlaceholder(context, primaryColor)
              : MobileScanner(
                  controller: _scannerController,
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

          // Camera Frame Target Overlay (Mobile View)
          if (!kIsWeb)
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 3),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 2,
                      width: 210,
                      color: primaryColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

          // Simulation Panel at the bottom
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                if (!kIsWeb)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Position the QR code inside the frame",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "SC1250");
                  },
                  icon: const Icon(Icons.bug_report_rounded),
                  label: const Text(
                    "Simulate Scan (SC1250)",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Web Placeholder Layout
  Widget _buildWebPlaceholder(BuildContext context, Color primaryColor) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF111827),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.qr_code_scanner_rounded,
              size: 64,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Camera Scanner Disabled",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Web Emulation Mode active. Select a test passcode below to simulate scanning:",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Quick Test Code Preset Chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _buildTestChip(context, "SC1250", primaryColor),
              _buildTestChip(context, "SC6523", primaryColor),
              _buildTestChip(context, "123456", primaryColor),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildTestChip(BuildContext context, String code, Color primaryColor) {
    return ActionChip(
      backgroundColor: Colors.white.withOpacity(0.1),
      side: BorderSide(color: primaryColor.withOpacity(0.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      label: Text(
        code,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context, code);
      },
    );
  }
}