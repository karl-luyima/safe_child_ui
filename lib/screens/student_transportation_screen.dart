// lib/screens/student_transportation_screen.dart
import 'package:flutter/material.dart';
import 'package:safe_child_ui/theme/app_colors.dart';
enum TransportationStatus { onboard, droppedOff, pending }

class StudentRoster {
  final String id;
  final String name;
  final String grade;
  final String busNo;
  final TransportationStatus status;
  final String timestamp;

  const StudentRoster({
    required this.id,
    required this.name,
    required this.grade,
    required this.busNo,
    required this.status,
    required this.timestamp,
  });

  String get statusText {
    switch (status) {
      case TransportationStatus.onboard:
        return 'Onboard';
      case TransportationStatus.droppedOff:
        return 'Dropped Off';
      case TransportationStatus.pending:
        return 'Pending Pickup';
    }
  }

  Color get statusColor {
    switch (status) {
      case TransportationStatus.onboard:
        return Colors.amber.shade800;
      case TransportationStatus.droppedOff:
        return AppColors.emerald700;
      case TransportationStatus.pending:
        return AppColors.rose700;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case TransportationStatus.onboard:
        return Icons.directions_bus_rounded;
      case TransportationStatus.droppedOff:
        return Icons.check_circle_rounded;
      case TransportationStatus.pending:
        return Icons.access_time_filled_rounded;
    }
  }
}

class StudentTransportationScreen extends StatefulWidget {
  const StudentTransportationScreen({super.key});

  @override
  State<StudentTransportationScreen> createState() =>
      _StudentTransportationScreenState();
}

class _StudentTransportationScreenState
    extends State<StudentTransportationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedBus = 'All';
  String _searchQuery = '';

  final List<StudentRoster> _allStudents = const [
    StudentRoster(
      id: '1',
      name: 'Sarah Kamya',
      grade: 'Grade 4B',
      busNo: 'Bus #04',
      status: TransportationStatus.onboard,
      timestamp: '07:15 AM',
    ),
    StudentRoster(
      id: '2',
      name: 'Alex Mukasa',
      grade: 'Grade 2A',
      busNo: 'Bus #04',
      status: TransportationStatus.droppedOff,
      timestamp: '07:40 AM',
    ),
    StudentRoster(
      id: '3',
      name: 'David Okello',
      grade: 'Grade 5C',
      busNo: 'Bus #02',
      status: TransportationStatus.pending,
      timestamp: 'Pending',
    ),
    StudentRoster(
      id: '4',
      name: 'Grace Kato',
      grade: 'Grade 1B',
      busNo: 'Bus #04',
      status: TransportationStatus.droppedOff,
      timestamp: '07:32 AM',
    ),
    StudentRoster(
      id: '5',
      name: 'Brian Omondi',
      grade: 'Grade 3A',
      busNo: 'Bus #02',
      status: TransportationStatus.onboard,
      timestamp: '07:22 AM',
    ),
  ];

  List<StudentRoster> get _filteredStudents {
    return _allStudents.where((student) {
      final matchesBus =
          _selectedBus == 'All' || student.busNo == _selectedBus;
      final matchesSearch = student.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          student.grade.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesBus && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final onboardCount = _filteredStudents
        .where((s) => s.status == TransportationStatus.onboard)
        .length;
    final droppedCount = _filteredStudents
        .where((s) => s.status == TransportationStatus.droppedOff)
        .length;
    final pendingCount = _filteredStudents
        .where((s) => s.status == TransportationStatus.pending)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Student Transportation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter & Search Controls Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Field & Bus Selector Row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Search student or grade...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12),
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedBus,
                          icon: const Icon(Icons.filter_list_rounded),
                          items: ['All', 'Bus #02', 'Bus #04']
                              .map((bus) => DropdownMenuItem(
                                    value: bus,
                                    child: Text(
                                      bus,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedBus = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Real-time Status Metric Badges
                Row(
                  children: [
                    _buildMetricCard(
                      'Onboard',
                      onboardCount,
                      Colors.amber.shade800,
                      Colors.amber.shade50,
                    ),
                    const SizedBox(width: 8),
                    _buildMetricCard(
                      'Dropped',
                      droppedCount,
                      AppColors.emerald700,
                      AppColors.emerald50,
                    ),
                    const SizedBox(width: 8),
                    _buildMetricCard(
                      'Pending',
                      pendingCount,
                      AppColors.rose700,
                      AppColors.rose50,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Student List Section
          Expanded(
            child: _filteredStudents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_accounts_rounded,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'No students match your filter',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              // Avatar Circle
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: primaryColor.withOpacity(0.1),
                                child: Text(
                                  student.name[0],
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Name & Grade Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          student.grade,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text('•',
                                            style: TextStyle(
                                                color: Color(0xFF9CA3AF))),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F4F6),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            student.busNo,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF374151),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Status Pill & Time Tag
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          student.statusColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          student.statusIcon,
                                          size: 13,
                                          color: student.statusColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          student.statusText,
                                          style: TextStyle(
                                            color: student.statusColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    student.timestamp,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String label, int value, Color textColor, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}