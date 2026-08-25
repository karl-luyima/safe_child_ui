import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Children"), backgroundColor: Colors.red),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildChildCard(context, "Alex Kamya", "SC1250", "Home Pickup"),
          _buildChildCard(context, "Sarah Kamya", "SC6523", "School Check In"),
        ],
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, String name, String studentId, String status) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("ID: $studentId\nStatus: $status"),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("$name's Pickup Pass", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    QrImageView(data: studentId, size: 200.0),
                  ],
                ),
              ),
            );
          },
          child: const Text("Pass Code", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}