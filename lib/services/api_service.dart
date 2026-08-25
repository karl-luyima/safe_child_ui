import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace with your actual backend URL or local server IP
  static const String baseUrl = "https://your-backend-api.com/api";

  // Verify code or scanned QR with backend server
  static Future<bool> verifyAndDropOff(String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/students/dropoff'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      // Return false on connection/network errors
      return false;
    }
  }

  // Fetch updated dashboard counts from server
  static Future<Map<String, int>> getDashboardStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/driver/stats'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'onboard': data['onboardCount'] ?? 0,
          'dropOff': data['dropOffCount'] ?? 0,
        };
      }
    } catch (_) {}
    return {'onboard': 0, 'dropOff': 0};
  }
}