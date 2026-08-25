// lib/screens/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTimeRange? _selectedDateRange;
  String _selectedFormat = 'PDF';
  String _activePreset = 'Custom';

  @override
  void initState() {
    super.initState();
    // Default to last 7 days
    _setPreset('Last 7 Days', 7);
  }

  void _setPreset(String presetLabel, int days) {
    setState(() {
      _activePreset = presetLabel;
      _selectedDateRange = DateTimeRange(
        start: DateTime.now().subtract(Duration(days: days)),
        end: DateTime.now(),
      );
    });
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final primaryColor = Theme.of(context).colorScheme.primary;

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: const Color(0xFF1F2937),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _activePreset = 'Custom';
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading $_selectedFormat report ($startDate - $endDate)...'),
        backgroundColor: Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Safety Reports',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            const Text(
              'Select Date Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 10),

            // Date Picker Trigger Card
            InkWell(
              onTap: () => _pickDateRange(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date Range',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selectedDateRange == null
                                ? 'Tap to select range'
                                : '${formatter.format(_selectedDateRange!.start)} - ${formatter.format(_selectedDateRange!.end)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Preset Filter Chips
            Row(
              children: [
                _buildPresetChip('Last 7 Days', () => _setPreset('Last 7 Days', 7)),
                const SizedBox(width: 8),
                _buildPresetChip('Last 30 Days', () => _setPreset('Last 30 Days', 30)),
                const SizedBox(width: 8),
                _buildPresetChip('Last 90 Days', () => _setPreset('Last 90 Days', 90)),
              ],
            ),
            const SizedBox(height: 28),

            // Export Format Selector
            const Text(
              'Export Format',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: _buildFormatCard('PDF', Icons.picture_as_pdf_rounded)),
                const SizedBox(width: 12),
                Expanded(child: _buildFormatCard('CSV', Icons.table_chart_rounded)),
              ],
            ),

            const Spacer(),

            // Download Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _downloadReport,
                icon: const Icon(Icons.download_rounded),
                label: Text(
                  'Download $_selectedFormat Report',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    final isSelected = _activePreset == label;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? primaryColor : const Color(0xFF4B5563),
        ),
      ),
      selected: isSelected,
      selectedColor: primaryColor.withOpacity(0.12),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? primaryColor : Colors.grey.shade300,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (_) => onTap(),
    );
  }

  Widget _buildFormatCard(String format, IconData icon) {
    final isSelected = _selectedFormat == format;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () => setState(() => _selectedFormat = format),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : const Color(0xFF6B7280),
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              format,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? primaryColor : const Color(0xFF1F2937),
              ),
            ),
            const Spacer(),
            Radio<String>(
              value: format,
              groupValue: _selectedFormat,
              activeColor: primaryColor,
              onChanged: (val) {
                if (val != null) setState(() => _selectedFormat = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}