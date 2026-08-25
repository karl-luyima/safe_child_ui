import 'package:flutter/material.dart';
import '../services/mock_data.dart';
import 'enter_code_modal.dart';
import 'qr_scanner_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  void _processCode(String code) {
    bool success = MockDataRepository.verifyAndDropOff(code);

    if (context.mounted) {
      if (success) {
        setState(() {}); // Refresh UI state to reflect updated counts
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Success! Student marked as dropped off. Code: $code"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid Code: '$code'. Try SC1250 or 123456"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Curve
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                  child: const Center(
                    child: Text(
                      "NC International School",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.school, size: 40, color: Colors.indigo),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Shuttle Driver", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),

            // Driver Detail Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Column(
                children: [
                  Text("Edward Kamya", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("0732555125", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            // Statistics Row (Connected dynamically to MockDataRepository)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Students Onboard", 
                      MockDataRepository.onboardCount.toString(), 
                      Icons.directions_bus
                    )
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Total Drop Off", 
                      MockDataRepository.dropOffCount.toString(), 
                      Icons.face
                    )
                  ),
                ],
              ),
            ),

            // Bulk Drop Off Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // Bulk drop off logic
                  _processCode("123456");
                },
                child: const Text("Bulk Drop Off", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () async {
                        final scannedCode = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const QrScannerScreen()),
                        );
                        if (scannedCode != null) {
                          _processCode(scannedCode);
                        }
                      },
                      child: const Text("Scan QR Code", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => EnterCodeModal(
                            onCodeSubmitted: (code) {
                              _processCode(code);
                            },
                          ),
                        );
                      },
                      child: const Text("Enter Code", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: Colors.amber.shade700),
          Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}