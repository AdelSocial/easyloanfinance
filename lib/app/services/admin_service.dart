import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AdminService {
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

  // Admin Login
  static Future<Map<String, dynamic>> adminLogin({
    required String phoneOrEmail,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/admin/login'),
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

  // Get admin dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/dashboard'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get dashboard stats
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/dashboard-stats'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get chart data for deposit and withdraw
  static Future<Map<String, dynamic>> getDepositWithdrawChart() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/chart/deposit-withdraw'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get chart data for transactions
  static Future<Map<String, dynamic>> getTransactionChart() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/chart/transaction'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ PROFILE APIs ============

  // Get admin profile
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/profile'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Update admin profile
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/profile'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update admin password
  static Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/password'),
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

  // Get all inquiries
  static Future<Map<String, dynamic>> getInquiries() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/admininquiries'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get inquiry by ID
  static Future<Map<String, dynamic>> getInquiry(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/admininquiriesedit/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Create inquiry
  static Future<Map<String, dynamic>> createInquiry(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/adminstoreinquiries'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update inquiry
  static Future<Map<String, dynamic>> updateInquiry(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/admininquiriesupdate/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Delete inquiry
  static Future<Map<String, dynamic>> deleteInquiry(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/admininquiriesdestroy/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Assign staff to inquiry
  static Future<Map<String, dynamic>> assignStaffToInquiry(int id, int staffId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/admininquiriesassign/$id'),
      headers: await _getHeaders(),
      body: json.encode({
        'staff_id': staffId,
      }),
    );

    return _handleResponse(response);
  }

  // Update inquiry status
  static Future<Map<String, dynamic>> updateInquiryStatus(int id, int status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/admininquiriesstatus/$id'),
      headers: await _getHeaders(),
      body: json.encode({
        'status': status,
      }),
    );

    return _handleResponse(response);
  }

  // ============ LOAN CATEGORY APIs ============

  // Get all categories
  static Future<Map<String, dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/category/index'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Create or update category
  static Future<Map<String, dynamic>> saveCategory(Map<String, dynamic> data, {int? id}) async {
    final url = id != null 
        ? '$baseUrl/admin/category/store/$id'
        : '$baseUrl/admin/category/store';
    
    final response = await http.post(
      Uri.parse(url),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update category status
  static Future<Map<String, dynamic>> updateCategoryStatus(int id, int status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/category/status/$id'),
      headers: await _getHeaders(),
      body: json.encode({
        'status': status,
      }),
    );

    return _handleResponse(response);
  }

  // ============ LOAN PLANS APIs ============

  // Get all loan plans
  static Future<Map<String, dynamic>> getLoanPlans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/plans/loans/index'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get loan plan by ID
  static Future<Map<String, dynamic>> getLoanPlan(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/plans/loans/edit/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Create or update loan plan
  static Future<Map<String, dynamic>> saveLoanPlan(Map<String, dynamic> data, {int? id}) async {
    final url = id != null 
        ? '$baseUrl/admin/plans/loans/store/$id'
        : '$baseUrl/admin/plans/loans/store';
    
    final response = await http.post(
      Uri.parse(url),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update loan plan status
  static Future<Map<String, dynamic>> updateLoanPlanStatus(int id, int status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/plans/loans/status/$id'),
      headers: await _getHeaders(),
      body: json.encode({
        'status': status,
      }),
    );

    return _handleResponse(response);
  }

  // ============ LOAN APIs ============

  // Get all loans
  static Future<Map<String, dynamic>> getAllLoans({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/loan/all?user_id=$userId'
        : '$baseUrl/admin/loan/all';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get running loans
  static Future<Map<String, dynamic>> getRunningLoans({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/loan/running/$userId'
        : '$baseUrl/admin/loan/running';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get pending loans
  static Future<Map<String, dynamic>> getPendingLoans({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/loan/pending/$userId'
        : '$baseUrl/admin/loan/pending';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get rejected loans
  static Future<Map<String, dynamic>> getRejectedLoans({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/loan/rejected/$userId'
        : '$baseUrl/admin/loan/rejected';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get paid loans
  static Future<Map<String, dynamic>> getPaidLoans({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/loan/paid/$userId'
        : '$baseUrl/admin/loan/paid';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get due installments
  static Future<Map<String, dynamic>> getDueInstallments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/loan/due'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Approve loan
  static Future<Map<String, dynamic>> approveLoan(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/loan/approve/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Reject loan
  static Future<Map<String, dynamic>> rejectLoan(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/loan/reject/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get loan details
  static Future<Map<String, dynamic>> getLoanDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/loan/details/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get loan installments
  static Future<Map<String, dynamic>> getLoanInstallments(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/loan/installments/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ USER MANAGEMENT APIs ============

  // Get all users
  static Future<Map<String, dynamic>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get active users
  static Future<Map<String, dynamic>> getActiveUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/active'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get banned users
  static Future<Map<String, dynamic>> getBannedUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/banned'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get email verified users
  static Future<Map<String, dynamic>> getEmailVerifiedUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/email-verified'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get email unverified users
  static Future<Map<String, dynamic>> getEmailUnverifiedUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/email-unverified'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get mobile verified users
  static Future<Map<String, dynamic>> getMobileVerifiedUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/mobile-verified'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get mobile unverified users
  static Future<Map<String, dynamic>> getMobileUnverifiedUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/mobile-unverified'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get KYC unverified users
  static Future<Map<String, dynamic>> getKycUnverifiedUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/kyc-unverified'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get KYC pending users
  static Future<Map<String, dynamic>> getKycPendingUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/kyc-pending'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get users with balance
  static Future<Map<String, dynamic>> getUsersWithBalance() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/with-balance'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get user details
  static Future<Map<String, dynamic>> getUserDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/detail/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get KYC details
  static Future<Map<String, dynamic>> getKycDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/kyc-data/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Approve KYC
  static Future<Map<String, dynamic>> approveKyc(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/users/kyc-approve/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Reject KYC
  static Future<Map<String, dynamic>> rejectKyc(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/users/kyc-reject/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Update user
  static Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/users/update/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Add or subtract balance
  static Future<Map<String, dynamic>> addSubBalance(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/users/add-sub-balance/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Send notification to single user
  static Future<Map<String, dynamic>> sendNotificationToUser(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/users/send-notification/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Send notification to all users
  static Future<Map<String, dynamic>> sendNotificationToAll(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/users/send-notification'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update user status
  static Future<Map<String, dynamic>> updateUserStatus(int id, int status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/users/status/$id'),
      headers: await _getHeaders(),
      body: json.encode({
        'status': status,
      }),
    );

    return _handleResponse(response);
  }

  // Get user list (for dropdowns)
  static Future<Map<String, dynamic>> getUserList() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users/list'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ DEPOSIT APIs ============

  // Get all deposits
  static Future<Map<String, dynamic>> getAllDeposits({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/deposit/all/$userId'
        : '$baseUrl/admin/deposit/all';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get pending deposits
  static Future<Map<String, dynamic>> getPendingDeposits({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/deposit/pending/$userId'
        : '$baseUrl/admin/deposit/pending';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get rejected deposits
  static Future<Map<String, dynamic>> getRejectedDeposits({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/deposit/rejected/$userId'
        : '$baseUrl/admin/deposit/rejected';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get approved deposits
  static Future<Map<String, dynamic>> getApprovedDeposits({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/deposit/approved/$userId'
        : '$baseUrl/admin/deposit/approved';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get successful deposits
  static Future<Map<String, dynamic>> getSuccessfulDeposits({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/deposit/successful/$userId'
        : '$baseUrl/admin/deposit/successful';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get initiated deposits
  static Future<Map<String, dynamic>> getInitiatedDeposits({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/deposit/initiated/$userId'
        : '$baseUrl/admin/deposit/initiated';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get deposit details
  static Future<Map<String, dynamic>> getDepositDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/deposit/details/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Approve deposit
  static Future<Map<String, dynamic>> approveDeposit(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/deposit/approve/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Reject deposit
  static Future<Map<String, dynamic>> rejectDeposit(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/deposit/reject'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // ============ WITHDRAWAL APIs ============

  // Get all withdrawals
  static Future<Map<String, dynamic>> getAllWithdrawals({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/withdraw/all/$userId'
        : '$baseUrl/admin/withdraw/all';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get pending withdrawals
  static Future<Map<String, dynamic>> getPendingWithdrawals({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/withdraw/pending/$userId'
        : '$baseUrl/admin/withdraw/pending';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get approved withdrawals
  static Future<Map<String, dynamic>> getApprovedWithdrawals({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/withdraw/approved/$userId'
        : '$baseUrl/admin/withdraw/approved';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get rejected withdrawals
  static Future<Map<String, dynamic>> getRejectedWithdrawals({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/withdraw/rejected/$userId'
        : '$baseUrl/admin/withdraw/rejected';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get withdrawal details
  static Future<Map<String, dynamic>> getWithdrawalDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/withdraw/details/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Approve withdrawal
  static Future<Map<String, dynamic>> approveWithdrawal(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/withdraw/approve'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Reject withdrawal
  static Future<Map<String, dynamic>> rejectWithdrawal(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/withdraw/reject'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // ============ WITHDRAW METHOD APIs ============

  // Get all withdraw methods
  static Future<Map<String, dynamic>> getWithdrawMethods() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/withdraw/method'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Create withdraw method
  static Future<Map<String, dynamic>> createWithdrawMethod(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/withdraw/method/create'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update withdraw method
  static Future<Map<String, dynamic>> updateWithdrawMethod(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/withdraw/method/edit/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Update withdraw method status
  static Future<Map<String, dynamic>> updateWithdrawMethodStatus(int id, int status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/withdraw/method/status/$id'),
      headers: await _getHeaders(),
      body: json.encode({
        'status': status,
      }),
    );

    return _handleResponse(response);
  }

  // ============ REPORT APIs ============

  // Get transaction report
  static Future<Map<String, dynamic>> getTransactionReport({int? userId}) async {
    final url = userId != null 
        ? '$baseUrl/admin/report/transaction?user_id=$userId'
        : '$baseUrl/admin/report/transaction';
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get login history
  static Future<Map<String, dynamic>> getLoginHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/report/login/history'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get login IP history
  static Future<Map<String, dynamic>> getLoginIpHistory(String ip) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/report/login/ipHistory/$ip'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get notification history
  static Future<Map<String, dynamic>> getNotificationHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/report/notification/history'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get email details
  static Future<Map<String, dynamic>> getEmailDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/report/email/detail/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ NOTIFICATION APIs ============

  // Get all notifications
  static Future<Map<String, dynamic>> getNotifications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/notifications'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Mark notification as read
  static Future<Map<String, dynamic>> markNotificationAsRead(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/notification/read/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Mark all notifications as read
  static Future<Map<String, dynamic>> markAllNotificationsAsRead() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/notifications/read-all'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Delete all notifications
  static Future<Map<String, dynamic>> deleteAllNotifications() async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/notifications/delete-all'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Delete single notification
  static Future<Map<String, dynamic>> deleteNotification(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/notifications/delete-single/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // ============ SUPPORT TICKET APIs ============

  // Get all tickets
  static Future<Map<String, dynamic>> getTickets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/ticket'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get pending tickets
  static Future<Map<String, dynamic>> getPendingTickets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/ticket/pending'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get closed tickets
  static Future<Map<String, dynamic>> getClosedTickets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/ticket/closed'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get answered tickets
  static Future<Map<String, dynamic>> getAnsweredTickets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/ticket/answered'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get ticket details
  static Future<Map<String, dynamic>> getTicketDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/ticket/view/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Reply to ticket
  static Future<Map<String, dynamic>> replyToTicket(int id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/ticket/reply/$id'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // Close ticket
  static Future<Map<String, dynamic>> closeTicket(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/ticket/close/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Delete ticket
  static Future<Map<String, dynamic>> deleteTicket(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/ticket/delete/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Download ticket attachment
  static Future<http.Response> downloadTicketAttachment(int attachmentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/ticket/download/$attachmentId'),
      headers: await _getHeaders(),
    );

    return response;
  }

  // ============ SUBSCRIBER APIs ============

  // Get all subscribers
  static Future<Map<String, dynamic>> getSubscribers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/subscriber'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Remove subscriber
  static Future<Map<String, dynamic>> removeSubscriber(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/subscriber/remove/$id'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Send email to subscribers
  static Future<Map<String, dynamic>> sendEmailToSubscribers(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/subscriber/send-email'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );

    return _handleResponse(response);
  }

  // ============ ADMIN DASHBOARD APIs (from API routes) ============

  // Get all leads
  static Future<Map<String, dynamic>> getAllLeads() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/leads'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get all loan applications
  static Future<Map<String, dynamic>> getAllLoanApplications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/loan-applications'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }

  // Get all customers
  static Future<Map<String, dynamic>> getAllCustomers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/customers'),
      headers: await _getHeaders(),
    );

    return _handleResponse(response);
  }
}
