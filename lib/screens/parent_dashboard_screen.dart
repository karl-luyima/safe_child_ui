import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Portal"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Info Banner
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.person, size: 36, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sarah Kamya", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Grade 4B • Bus Route #04", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text("Status: Onboard Shuttle", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Pickup QR Code Section
            const Text("Pickup QR Code", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Center(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      QrImageView(
                        data: "SC1250",
                        version: QrVersions.auto,
                        size: 180.0,
                        foregroundColor: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Code: SC1250",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Present this QR code or security pin to the shuttle driver during drop-off.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Transport History / Notifications
            const Text("Recent Transport Activity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildActivityItem(
              icon: Icons.directions_bus,
              title: "Boarded School Bus #04",
              subtitle: "Picked up at Home station",
              time: "07:15 AM",
            ),
            _buildActivityItem(
              icon: Icons.check_circle,
              title: "Dropped Off at School",
              subtitle: "Checked in by Shuttle Driver",
              time: "07:45 AM",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade50,
          child: Icon(icon, color: Colors.red),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ),
    );
  }
}