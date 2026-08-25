// lib/screens/report_details_screen.dart
import 'package:flutter/material.dart';

class ReportDetailsScreen extends StatelessWidget {
  final String statusType;

  const ReportDetailsScreen({super.key, required this.statusType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "$statusType Report",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Action Bar: Date Selector & Export Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF6B7280)),
                      SizedBox(width: 8),
                      Text(
                        "Tuesday 16 Oct",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text(
                    "Export",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Report Summary Data Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2.2),
                    1: FlexColumnWidth(2.0),
                    2: FlexColumnWidth(2.0),
                    3: FlexColumnWidth(2.2),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    _buildTableHeaderRow(),
                    _buildDataRow("SC1250", "08:00 am", "09:00 am", "Success"),
                    _buildDataRow("SC6523", "08:15 am", "09:00 am", "Success"),
                    _buildDataRow("SC7854", "08:17 am", "09:15 am", "Success", isLast: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeaderRow() {
    const headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Color(0xFF6B7280),
    );

    return const TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
      ),
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text("Student ID", style: headerStyle)),
        Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text("Pickup", style: headerStyle)),
        Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text("School In", style: headerStyle)),
        Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text("Status", style: headerStyle)),
      ],
    );
  }

  TableRow _buildDataRow(
    String studentId,
    String pickupTime,
    String schoolIn,
    String status, {
    bool isLast = false,
  }) {
    const bodyStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1F2937),
    );

    return TableRow(
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(studentId, style: bodyStyle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(pickupTime, style: bodyStyle.copyWith(color: const Color(0xFF4B5563))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(schoolIn, style: bodyStyle.copyWith(color: const Color(0xFF4B5563))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.teal.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}