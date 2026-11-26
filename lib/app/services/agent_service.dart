import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AgentService {
  // Base URL from ApiService
  static const String baseUrl = ApiService.baseUrl;

  // Get auth token from shared preferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Save auth token to shared preferences
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get headers with auth token
  static Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Handle API response
  static dynamic _handleResponse(http.Response response) {
    try {
      final data = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'An error occurred',
          'errors': data['errors'],
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      if (e is FormatException) {
        return {
          'success': false,
          'message': 'Failed to parse response: ${response.body}',
          'errors': null,
          'statusCode': response.statusCode,
        };
      }
      return {
        'success': false,
        'message': 'An error occurred: $e',
        'errors': null,
        'statusCode': response.statusCode,
      };
    }
  }

  // ============ AUTHENTICATION APIs ============

  // Agent Login
  static Future<Map<String, dynamic>> agentLogin({
    required String phoneOrEmail,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/agent/login'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({
        'phone_or_email': phoneOrEmail,
        'password': password,
      }),
    );

    final data = _handleResponse(response);
    
    // Handle token from different response structures
    String? token;
    if (data['data'] != null && data['data']['token'] != null) {
      token = data['data']['token'];
    } else if (data['token'] != null) {
      token = data['token'];
    }
    
    if (token != null) {
      await _saveToken(token);
    }
    
    return data;
  }

  // ============ DASHBOARD APIs ============

  // Get agent dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/dashboard'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ PROFILE APIs ============

  // Get agent profile
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/profile'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Update agent profile
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agent/profile'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update agent password
  static Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agent/password'),
      headers: await _getHeaders(),
      body: json.encode({
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': newPasswordConfirmation,
      }),
    );

    return _handleResponse(response);
  }

  // ============ INQUIRIES APIs ============

  // Get all inquiries (agent's inquiries)
  static Future<Map<String, dynamic>> getInquiries() async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/agentindex'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get my inquiries
  static Future<Map<String, dynamic>> getMyInquiries() async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/inquiries/my-inquiries'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get inquiry by ID
  static Future<Map<String, dynamic>> getInquiry(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/inquiries/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get inquiry for editing
  static Future<Map<String, dynamic>> getInquiryForEdit(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/agentinquiriesedit/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Create inquiry
  static Future<Map<String, dynamic>> createInquiry(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agent/agentstoredata'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update inquiry
  static Future<Map<String, dynamic>> updateInquiry(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agent/agentinquiriesupdate/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Delete inquiry
  static Future<Map<String, dynamic>> deleteInquiry(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/agent/agentinquiriesdestroy/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Update inquiry status
  static Future<Map<String, dynamic>> updateInquiryStatus(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agent/inquiries/$id/update-status'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // ============ CUSTOMER APIs ============

  // Get all customers
  static Future<Map<String, dynamic>> getCustomers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/customers'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get referred customers
  static Future<Map<String, dynamic>> getReferredCustomers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/customers/referred'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get customer details
  static Future<Map<String, dynamic>> getCustomerDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/customers/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ LOAN APIs ============

  // Get all loans
  static Future<Map<String, dynamic>> getLoans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/loans'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get loan details
  static Future<Map<String, dynamic>> getLoanDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/agent/loans/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ INQUIRIES APIs (using API routes) ============

  // Get inquiries by agent ID
  static Future<Map<String, dynamic>> getInquiriesByAgent(int agentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/agent/$agentId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get agent inquiries count
  static Future<Map<String, dynamic>> getAgentInquiriesCount(int agentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/agent-count/$agentId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get agent inquiries stats
  static Future<Map<String, dynamic>> getAgentInquiriesStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/stats/agent'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get average response time for agent
  static Future<Map<String, dynamic>> getAverageResponseTime(int agentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/stats/response-time/agent/$agentId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }
}
