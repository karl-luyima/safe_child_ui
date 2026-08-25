// lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Standardized API Response Container
class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse.success(this.data, {this.statusCode, this.message})
      : isSuccess = true;

  ApiResponse.failure(this.message, {this.statusCode})
      : isSuccess = false,
        data = null;
}

/// Custom Exception Types
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (Code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network connection failed.']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Core API Integration Service
class ApiService {
  static String baseUrl = "https://your-backend-api.com/api";
  static const Duration _timeoutDuration = Duration(seconds: 10);

  // In-memory Auth Token
  static String? _authToken;

  /// Configure Authentication Token
  static void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Default Request Headers
  static Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  /// Verify Code or QR Scan and process Drop-Off
  static Future<ApiResponse<Map<String, dynamic>>> verifyAndDropOff({
    required String code,
    required String busId,
  }) async {
    final url = Uri.parse('$baseUrl/students/dropoff');

    try {
      final response = await http
          .post(
            url,
            headers: _getHeaders(),
            body: jsonEncode({
              'code': code,
              'busId': busId,
              'timestamp': DateTime.now().toIso8601String(),
            }),
          )
          .timeout(_timeoutDuration);

      return _handleResponse<Map<String, dynamic>>(
        response,
        parser: (data) => data as Map<String, dynamic>,
      );
    } on SocketException {
      return ApiResponse.failure('No Internet connection. Please check network.');
    } on TimeoutException {
      return ApiResponse.failure('Server response timed out. Try again.');
    } catch (e) {
      return ApiResponse.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Fetch Updated Driver Dashboard Metrics
  static Future<ApiResponse<Map<String, int>>> getDashboardStats(
      String busId) async {
    final url = Uri.parse('$baseUrl/driver/stats?busId=$busId');

    try {
      final response = await http
          .get(url, headers: _getHeaders())
          .timeout(_timeoutDuration);

      return _handleResponse<Map<String, int>>(
        response,
        parser: (data) {
          return {
            'onboard': (data['onboardCount'] as num?)?.toInt() ?? 0,
            'dropOff': (data['dropOffCount'] as num?)?.toInt() ?? 0,
            'pending': (data['pendingCount'] as num?)?.toInt() ?? 0,
          };
        },
      );
    } on SocketException {
      return ApiResponse.failure('Offline mode active.');
    } on TimeoutException {
      return ApiResponse.failure('Request timed out.');
    } catch (e) {
      return ApiResponse.failure('Failed to load dashboard metrics.');
    }
  }

  /// Generic Response Parser
  static ApiResponse<T> _handleResponse<T>(
    http.Response response, {
    required T Function(dynamic json) parser,
  }) {
    final statusCode = response.statusCode;

    try {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (statusCode >= 200 && statusCode < 300) {
        final data = parser(body['data'] ?? body);
        return ApiResponse.success(
          data,
          statusCode: statusCode,
          message: body['message'] as String?,
        );
      } else {
        final errorMessage =
            body['message'] ?? 'Request failed with status: $statusCode';
        return ApiResponse.failure(errorMessage, statusCode: statusCode);
      }
    } catch (e) {
      return ApiResponse.failure(
        'Failed to parse server response.',
        statusCode: statusCode,
      );
    }
  }
}