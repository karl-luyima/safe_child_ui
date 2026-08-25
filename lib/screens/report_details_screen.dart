import 'package:flutter/material.dart';

class ReportDetailsScreen extends StatelessWidget {
  final String statusType;

  const ReportDetailsScreen({super.key, required this.statusType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$statusType Report"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tuesday 16 Oct", style: TextStyle(color: Colors.grey)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {},
                  child: const Text("Download", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Logs Table Header & Data
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              children: [
                _buildTableRow("Student ID", "Pickup time", "School in", "Status", isHeader: true),
                _buildTableRow("SC1250", "08:00 am", "9:00 am", "Success"),
                _buildTableRow("SC6523", "08:15 am", "9:00 am", "Success"),
                _buildTableRow("SC7854", "08:17 am", "9:15 am", "Success"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String col1, String col2, String col3, String col4, {bool isHeader = false}) {
    TextStyle style = TextStyle(
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      color: isHeader ? Colors.indigo.shade900 : Colors.grey.shade700,
    );

    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(col1, style: style)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(col2, style: style)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(col3, style: style)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(col4, style: style)),
      ],
    );
  }
}