import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class StaffService {
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

  // Staff Login
  static Future<Map<String, dynamic>> staffLogin({
    required String phoneOrEmail,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/staff/login'),
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

  // Get staff dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/dashboard'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ PROFILE APIs ============

  // Get staff profile
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/profile'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Update staff profile
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/staff/profile'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update staff password
  static Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/staff/password'),
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

  // Get all inquiries (staff's inquiries)
  static Future<Map<String, dynamic>> getInquiries() async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/staffinquiries'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get assigned inquiries
  static Future<Map<String, dynamic>> getAssignedInquiries() async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/inquiries/assigned'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get inquiry by ID
  static Future<Map<String, dynamic>> getInquiry(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/inquiries/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get inquiry for editing
  static Future<Map<String, dynamic>> getInquiryForEdit(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/staffinquiries/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Create inquiry
  static Future<Map<String, dynamic>> createInquiry(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/staff/staffstoreinquiries'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update inquiry
  static Future<Map<String, dynamic>> updateInquiry(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/staff/staffinquiries/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Delete inquiry
  static Future<Map<String, dynamic>> deleteInquiry(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/staff/staffinquiries/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Update inquiry status
  static Future<Map<String, dynamic>> updateInquiryStatus(int id, int status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/staff/staffinquiries/status/$id'),
      headers: await _getHeaders(),
      body: json.encode({
        'status': status,
      }),
    );

    return _handleResponse(response);
  }

  // Update inquiry status (via inquiries route)
  static Future<Map<String, dynamic>> updateInquiryStatusViaRoute(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/staff/inquiries/$id/update-status'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // ============ CUSTOMER APIs ============

  // Get all customers
  static Future<Map<String, dynamic>> getCustomers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/customers'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get referred customers
  static Future<Map<String, dynamic>> getReferredCustomers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/customers/referred'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get customer details
  static Future<Map<String, dynamic>> getCustomerDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/customers/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ LOAN APIs ============

  // Get all loans
  static Future<Map<String, dynamic>> getLoans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/loans'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get loan details
  static Future<Map<String, dynamic>> getLoanDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/loans/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ INQUIRIES APIs (using API routes) ============

  // Get inquiries by staff ID
  static Future<Map<String, dynamic>> getInquiriesByStaff(int staffId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/staff/$staffId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get assigned inquiries count
  static Future<Map<String, dynamic>> getAssignedInquiriesCount(int staffId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/assigned-count/$staffId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get staff inquiries count
  static Future<Map<String, dynamic>> getStaffInquiriesCount(int staffId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/staff-count/$staffId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get staff inquiries stats
  static Future<Map<String, dynamic>> getStaffInquiriesStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/stats/staff'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get average response time for staff
  static Future<Map<String, dynamic>> getAverageResponseTime(int staffId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/stats/response-time/staff/$staffId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get follow-up count for staff
  static Future<Map<String, dynamic>> getFollowUpCount(int staffId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/stats/followup-count/$staffId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get notes count for staff
  static Future<Map<String, dynamic>> getNotesCount(int staffId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/stats/notes-count/$staffId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ INQUIRY NOTES APIs ============

  // Add note to inquiry
  static Future<Map<String, dynamic>> addNoteToInquiry(int inquiryId, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/inquiries/$inquiryId/add-note'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Get notes for inquiry
  static Future<Map<String, dynamic>> getInquiryNotes(int inquiryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/$inquiryId/notes'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Delete note from inquiry
  static Future<Map<String, dynamic>> deleteNote(int inquiryId, int noteId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/inquiries/$inquiryId/notes/$noteId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ INQUIRY FOLLOW-UP APIs ============

  // Add follow-up to inquiry
  static Future<Map<String, dynamic>> addFollowUpToInquiry(int inquiryId, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/inquiries/$inquiryId/add-followup'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Get follow-ups for inquiry
  static Future<Map<String, dynamic>> getInquiryFollowUps(int inquiryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inquiries/$inquiryId/followups'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Delete follow-up from inquiry
  static Future<Map<String, dynamic>> deleteFollowUp(int inquiryId, int followUpId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/inquiries/$inquiryId/followups/$followUpId'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }
}
