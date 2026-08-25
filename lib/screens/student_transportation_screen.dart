import 'package:flutter/material.dart';

class StudentTransportationScreen extends StatefulWidget {
  const StudentTransportationScreen({super.key});

  @override
  State<StudentTransportationScreen> createState() => _StudentTransportationScreenState();
}

class _StudentTransportationScreenState extends State<StudentTransportationScreen> {
  final List<Map<String, dynamic>> students = [
    {
      "name": "Sarah Kamya",
      "grade": "Grade 4B",
      "busNo": "Bus #04",
      "status": "Onboard",
      "statusColor": Colors.orange,
      "time": "07:15 AM",
    },
    {
      "name": "Alex Mukasa",
      "grade": "Grade 2A",
      "busNo": "Bus #04",
      "status": "Dropped Off",
      "statusColor": Colors.green,
      "time": "07:40 AM",
    },
    {
      "name": "David Okello",
      "grade": "Grade 5C",
      "busNo": "Bus #02",
      "status": "Pending Pickup",
      "statusColor": Colors.red,
      "time": "Pending",
    },
    {
      "name": "Grace Kato",
      "grade": "Grade 1B",
      "busNo": "Bus #04",
      "status": "Dropped Off",
      "statusColor": Colors.green,
      "time": "07:32 AM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Transportation"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Students: ${students.length}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: const Text("Bus #04", style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ),
          // Student Transportation Roster List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade100,
                    child: Text(
                      student["name"][0],
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(student["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${student["grade"]} • ${student["busNo"]}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (student["statusColor"] as Color).withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          student["status"],
                          style: TextStyle(
                            color: student["statusColor"],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student["time"],
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}