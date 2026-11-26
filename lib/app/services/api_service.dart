import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  // Base URL - Update this with your Laravel backend URL
  // static const String baseUrl = 'https://astro.adelsocial.com/api';
  static const String baseUrl = 'https://easyloanfinance.online/api';
  // For Android emulator use: 'http://10.0.2.2:8000/api'
  // For iOS simulator use: 'http://localhost:8000/api'
  // For physical device use your computer's IP: 'http://192.168.x.x:8000/api'

  // Converts any backend "message" value (String, Map of lists, List) into
  // readable text, so error handling never crashes on a non-String message.
  static String msg(dynamic message, [String fallback = 'Something went wrong']) {
    if (message == null) return fallback;
    if (message is String) return message.isEmpty ? fallback : message;
    if (message is List) {
      final parts = message.map((e) => msg(e, '')).where((e) => e.isNotEmpty);
      return parts.isEmpty ? fallback : parts.join('\n');
    }
    if (message is Map) {
      final parts = message.values.map((e) => msg(e, '')).where((e) => e.isNotEmpty);
      return parts.isEmpty ? fallback : parts.join('\n');
    }
    return message.toString();
  }

  // Get auth token from shared preferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Public method to check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // Public method to get token (for splash screen)
  static Future<String?> getToken() async {
    return await _getToken();
  }

  // Save auth token to shared preferences
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear auth token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
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
      
      // Backend uses format: { "status": "success/error", "remark": "...", "message": {...}, "data": {...} }
      // Convert to consistent format for the app
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Check if backend returned success status
        if (data['status'] == 'success') {
          return data; // Return as-is, will be converted in login method
        }
        // If it's an error response from backend
        if (data['status'] == 'error') {
          return {
            'status': 'error',
            'remark': data['remark'],
            'message': data['message'],
            'data': data['data'],
            'statusCode': response.statusCode,
          };
        }
        // If response has success field (standard format)
        if (data['success'] != null) {
          return data;
        }
        // Default: treat as success if status code is 2xx
        return data;
      } else {
        // Return error response with full details
        return {
          'success': false,
          'status': data['status'] ?? 'error',
          'remark': data['remark'],
          'message': data['message'] ?? 'An error occurred',
          'errors': data['errors'],
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      if (e is FormatException) {
        // If response is not JSON, return error
        return {
          'status': 'error',
          'remark': 'parse_error',
          'message': {'error': ['Failed to parse response: ${response.body}']},
          'errors': null,
          'statusCode': response.statusCode,
        };
      }
      return {
        'status': 'error',
        'remark': 'exception',
        'message': {'error': ['An error occurred: $e']},
        'errors': null,
        'statusCode': response.statusCode,
      };
    }
  }

  // ============ AUTHENTICATION APIs ============

  // Register user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? referralCode,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password,
        'referral_code': referralCode,
      }),
    );

    final data = _handleResponse(response);
    if (data['data'] != null && data['data']['token'] != null) {
      await _saveToken(data['data']['token']);
    } else if (data['token'] != null) {
      await _saveToken(data['token']);
    }
    return data;
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String phoneOrEmail,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({
        'username': phoneOrEmail, // Backend expects 'username' field
        'password': password,
      }),
    );

    final data = _handleResponse(response);
    
    // Debug: Print response to help diagnose token issues
    print('Login API Response: $data');
    
    // Handle token from different response structures
    // Backend returns: { "status": "success", "data": { "access_token": "...", "token_type": "Bearer" } }
    String? token;
    
    // Check for access_token in data (backend format)
    if (data['data'] != null && data['data']['access_token'] != null) {
      token = data['data']['access_token'];
    }
    // Check for token in data (alternative format)
    else if (data['data'] != null && data['data']['token'] != null) {
      token = data['data']['token'];
    }
    // Check for token at root level
    else if (data['token'] != null) {
      token = data['token'];
    }
    
    if (token != null) {
      await _saveToken(token);
      print('Token saved successfully');
    } else {
      print('Warning: No token found in login response');
      print('Response structure: ${data.keys}');
      if (data['data'] != null) {
        print('Data keys: ${(data['data'] as Map).keys}');
      }
    }
    
    // Convert backend response format to consistent format
    // Backend returns: { "status": "success/error", "remark": "...", "message": {...}, "data": {...} }
    // Convert to: { "success": true/false, "message": "...", "data": {...} }
    final isSuccess = data['status'] == 'success' || data['success'] == true;
    final extractedMessage = _extractMessage(data);
    
    final convertedResponse = {
      'success': isSuccess,
      'message': extractedMessage,
      'data': data['data'],
      'errors': data['errors'] ?? (isSuccess ? null : {'error': [extractedMessage]}),
      'statusCode': data['statusCode'] ?? (isSuccess ? 200 : 401),
      'remark': data['remark'], // Keep original remark for debugging
      'status': data['status'], // Keep original status for debugging
    };
    
    return convertedResponse;
  }

  // Helper method to extract message from backend response
  static String _extractMessage(Map<String, dynamic> data) {
    // Backend format: { "message": { "success": [...] or "error": [...] } }
    if (data['message'] != null) {
      final message = data['message'];
      if (message is Map) {
        // Check for success array
        if (message['success'] != null) {
          if (message['success'] is List && (message['success'] as List).isNotEmpty) {
            return (message['success'] as List).first.toString();
          } else if (message['success'] is String) {
            return message['success'];
          }
        }
        // Check for error array
        if (message['error'] != null) {
          if (message['error'] is List && (message['error'] as List).isNotEmpty) {
            return (message['error'] as List).first.toString();
          } else if (message['error'] is String) {
            return message['error'];
          }
        }
      } else if (message is String) {
        return message;
      }
    }
    // Fallback based on status
    if (data['status'] == 'error') {
      return data['remark']?.toString() ?? 'Login failed';
    }
    return 'Login successful';
  }

  // User Login (Regular user - role-based)
  static Future<Map<String, dynamic>> userLogin({
    required String phoneOrEmail,
    required String password,
  }) async {
    try {
      // Debug: Print request details
      print('User Login Request:');
      print('URL: $baseUrl/auth/user/login');
      print('Email/Phone: $phoneOrEmail');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/user/login'),
        headers: await _getHeaders(includeAuth: false),
        body: json.encode({
          'phone_or_email': phoneOrEmail.trim(),
          'password': password,
        }),
      );

      // Debug: Print raw response
      print('User Login Raw Response Status: ${response.statusCode}');
      print('User Login Raw Response Body: ${response.body}');

      // Parse JSON response directly (backend returns: {"success": true/false, "message": "...", "data": {...}})
      Map<String, dynamic> data;
      try {
        data = json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('JSON Parse Error: $e');
        return {
          'success': false,
          'message': 'Invalid response from server',
          'data': null,
          'errors': null,
          'statusCode': response.statusCode,
        };
      }
      
      // Debug: Print parsed response
      print('User Login Parsed Response: $data');
      
      // Backend returns: { "success": true/false, "message": "...", "data": {...} }
      final isSuccess = data['success'] == true && response.statusCode == 200;
      
      // Handle token extraction only if login is successful
      String? token;
      if (isSuccess && data['data'] != null) {
        final responseData = data['data'];
        if (responseData is Map) {
          // Check for token in data (backend format)
          if (responseData['token'] != null) {
            token = responseData['token'].toString();
          }
          // Check for access_token in data (alternative format)
          else if (responseData['access_token'] != null) {
            token = responseData['access_token'].toString();
          }
        }
        // Check for token at root level
        if (token == null && data['token'] != null) {
          token = data['token'].toString();
        }
      }
      
      if (token != null) {
        await _saveToken(token);
        print('User token saved successfully');
      } else if (isSuccess) {
        print('Warning: No token found in user login response');
        print('Response structure: ${data.keys}');
        if (data['data'] != null && data['data'] is Map) {
          print('Data keys: ${(data['data'] as Map).keys}');
        }
      }
      
      // Return consistent response format
      return {
        'success': isSuccess,
        'message': data['message']?.toString() ?? (isSuccess ? 'Login successful' : 'Login failed'),
        'data': data['data'],
        'errors': data['errors'],
        'statusCode': response.statusCode,
      };
    } catch (e) {
      print('User Login Exception: $e');
      return {
        'success': false,
        'message': 'Login failed: ${e.toString()}',
        'data': null,
        'errors': null,
        'statusCode': 500,
      };
    }
  }

  // Send OTP for mobile verification
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-otp'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({'phone': phone}),
    );

    return _handleResponse(response);
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({
        'phone': phone,
        'otp': otp,
      }),
    );

    final data = _handleResponse(response);
    if (data['token'] != null) {
      await _saveToken(data['token']);
    }
    return data;
  }

  // Logout
  static Future<void> logout() async {
    await clearToken();
  }

  // Forgot Password - Send OTP to email
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({
        'email': email,
      }),
    );

    return _handleResponse(response);
  }

  // Verify Reset OTP
  static Future<Map<String, dynamic>> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-reset-otp'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({
        'email': email,
        'otp': otp,
      }),
    );

    return _handleResponse(response);
  }

  // Reset Password
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    return _handleResponse(response);
  }

  // ============ PROFILE APIs ============

  // Get user profile
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Upload profile picture
  static Future<Map<String, dynamic>> uploadProfileImage(String filePath) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/profile/upload-image'),
      );

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          filePath,
        ),
      );

      print('Uploading profile image: $filePath');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Profile image upload response status: ${response.statusCode}');
      print('Profile image upload response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('Error uploading profile image: $e');
      return {
        'success': false,
        'message': 'Failed to upload image: ${e.toString()}',
      };
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    // Ensure gender and employment_type are strings (remove null values)
    if (data['gender'] != null && data['gender'].toString().isEmpty) {
      data.remove('gender');
    }
    if (data['employment_type'] != null && data['employment_type'].toString().isEmpty) {
      data.remove('employment_type');
    }
    
    // Convert to strings if they exist
    if (data['gender'] != null) {
      data['gender'] = data['gender'].toString();
    }
    if (data['employment_type'] != null) {
      data['employment_type'] = data['employment_type'].toString();
    }
    
    print('API Request Data: $data');
    
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // ============ DASHBOARD APIs ============

  // Get user dashboard data
  static Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ CIBIL APIs ============

  // Get CIBIL score
  static Future<Map<String, dynamic>> getCibilScore({
    required String pan,
    required String mobile,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cibil/score'),
      headers: await _getHeaders(),
      body: json.encode({
        'pan': pan,
        'mobile': mobile,
      }),
    );

    return _handleResponse(response);
  }

  // ============ PERSONAL LOAN APIs ============

  // Submit personal loan application
  static Future<Map<String, dynamic>> submitPersonalLoan(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/personal'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Get personal loan applications
  static Future<Map<String, dynamic>> getPersonalLoans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/loans/personal'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ BUSINESS LOAN APIs ============

  // Submit business loan application
  static Future<Map<String, dynamic>> submitBusinessLoan(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/business'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Get business loan applications
  static Future<Map<String, dynamic>> getBusinessLoans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/loans/business'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Update business loan application
  static Future<Map<String, dynamic>> updateBusinessLoan(int loanId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/loans/business/$loanId'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // ============ HOME LOAN APIs ============

  // Submit home loan application
  static Future<Map<String, dynamic>> submitHomeLoan(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/home'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Get home loan applications
  static Future<Map<String, dynamic>> getHomeLoans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/loans/home'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Update home loan application
  static Future<Map<String, dynamic>> updateHomeLoan(int loanId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/loans/home/$loanId'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // ============ CAR LOAN APIs ============

  // Submit new car loan application
  static Future<Map<String, dynamic>> submitNewCarLoan(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/car/new'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Submit old car loan application
  static Future<Map<String, dynamic>> submitOldCarLoan(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/car/old'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Get car loan applications
  static Future<Map<String, dynamic>> getCarLoans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/loans/car'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ INSTANT LOAN APIs ============

  // Submit instant loan application
  static Future<Map<String, dynamic>> submitInstantLoan(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/instant'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Get instant loan applications
  static Future<Map<String, dynamic>> getInstantLoans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/loans/instant'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Update instant loan application
  static Future<Map<String, dynamic>> updateInstantLoan(int loanId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/loans/instant/$loanId'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // ============ DOCUMENT UPLOAD APIs ============

  // Upload document
  static Future<Map<String, dynamic>> uploadDocument({
    required String loanType,
    required String loanId,
    required String documentType,
    required String filePath,
  }) async {
    final token = await _getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/loans/$loanType/$loanId/documents'),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields['document_type'] = documentType;
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  // ============ SUPPORT APIs ============

  // Google Sign In - Authenticate with backend using Firebase token
  static Future<Map<String, dynamic>> googleSignIn({
    required String firebaseToken,
    required String email,
    String? name,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/google-signin'),
      headers: await _getHeaders(includeAuth: false),
      body: json.encode({
        'firebase_token': firebaseToken,
        'email': email,
        'name': name,
      }),
    );

    final data = _handleResponse(response);
    if (data['token'] != null) {
      await _saveToken(data['token']);
    } else if (data['data'] != null && data['data']['token'] != null) {
      await _saveToken(data['data']['token']);
    }
    return data;
  }

  // Submit support inquiry
  static Future<Map<String, dynamic>> submitSupport(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/support'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // ============ CATEGORIES APIs ============

  // Get loan categories
  static Future<Map<String, dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: await _getHeaders(includeAuth: false), // Public endpoint
    );

    return _handleResponse(response);
  }
}


