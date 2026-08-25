import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedStatus = "Home Pickup";

  final List<String> statuses = [
    "Home Pickup",
    "School Check In",
    "School Check Out",
    "Home Drop off",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports"), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Student Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...statuses.map((status) => RadioListTile(
              title: Text(status),
              value: status,
              groupValue: selectedStatus,
              activeColor: Colors.red,
              onChanged: (val) {
                setState(() { selectedStatus = val.toString(); });
              },
            )),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {},
              child: const Text("Generate Report", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}