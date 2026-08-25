import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Avatar & Driver Name
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Kamya Edward",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text("Shuttle Driver", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),

            // Verified Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Verified ", style: TextStyle(color: Colors.red, fontSize: 12)),
                  Icon(Icons.check_circle, color: Colors.red, size: 14),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Logout & Ratings Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  child: const Text("Logout", style: TextStyle(color: Colors.white)),
                ),
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(" 4.0 (22 Reviews)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.red),
                  onPressed: () {},
                ),
              ],
            ),
            const Divider(height: 30),

            // Driver Information List
            _buildProfileItem("Phone Number", "07311452630"),
            _buildProfileItem("NIN", "CM201900000158"),
            _buildProfileItem("Gender", "Male"),
            _buildProfileItem("Date of Registration", "10-10-2023"),
            _buildProfileItem("Address", "Natete, Kampala"),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}