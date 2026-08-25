import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add 'intl: ^0.19.0' to your pubspec.yaml dependencies

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTimeRange? _selectedDateRange;

  // Open the built-in Flutter calendar range picker
  Future<void> _pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023), // Oldest available date
      lastDate: DateTime.now(),   // Cannot pick future dates
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _downloadReport() {
    if (_selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date range first.')),
      );
      return;
    }

    final startDate = DateFormat('MMM dd, yyyy').format(_selectedDateRange!.start);
    final endDate = DateFormat('MMM dd, yyyy').format(_selectedDateRange!.end);

    // Trigger your PDF or CSV export logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading report from $startDate to $endDate...'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Reports'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date Range',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Calendar Selection Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_month, color: Colors.blue),
                title: Text(
                  _selectedDateRange == null
                      ? 'Tap to select start and end date'
                      : '${formatter.format(_selectedDateRange!.start)} - ${formatter.format(_selectedDateRange!.end)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: _selectedDateRange == null
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () => _pickDateRange(context),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Preset Chips (Optional convenience options)
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Last 7 Days'),
                  onPressed: () {
                    setState(() {
                      _selectedDateRange = DateTimeRange(
                        start: DateTime.now().subtract(const Duration(days: 7)),
                        end: DateTime.now(),
                      );
                    });
                  },
                ),
                ActionChip(
                  label: const Text('Last 30 Days'),
                  onPressed: () {
                    setState(() {
                      _selectedDateRange = DateTimeRange(
                        start: DateTime.now().subtract(const Duration(days: 30)),
                        end: DateTime.now(),
                      );
                    });
                  },
                ),
              ],
            ),

            const Spacer(),

            // Download Action Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _downloadReport,
                icon: const Icon(Icons.download),
                label: const Text(
                  'Download Report',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}