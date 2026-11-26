import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_loan_finance/app/services/api_service.dart';
import 'package:easy_loan_finance/app/routes/app_pages.dart';

class HomeController extends GetxController {

  var selectedIndex = 0.obs;
  var isLoading = false.obs;

  // User data
  var userName = ''.obs;
  var walletBalance = 0.0.obs;
  var loanEligibility = 0.0.obs;
  var creditScore = 0.obs;
  var activeEMI = 0.0.obs;
  var todayDeposit = 0.0.obs;

  // Recent Transactions
  final recentTransactions = <Map<String, dynamic>>[].obs;

  // Active Loans
  final activeLoans = <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> loanOffers = <Map<String, dynamic>>[
    {
      'title': 'Personal Loan',
      'subtitle': 'Up to ₹5 Lakhs\nInterest from 10.5%',
      'gradient': [Color(0xFF63b5bb), Color(0xFF4285F4)],
    },
    {
      'title': 'Home Loan',
      'subtitle': 'Up to ₹50 Lakhs\nInterest from 8.4%',
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFFA726)],
    },
    {
      'title': 'Business Loan',
      'subtitle': 'Up to ₹25 Lakhs\nInterest from 11.2%',
      'gradient': [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile(); // Load user name first
    loadDashboardData();
  }

  // Load user profile to get name
  Future<void> loadUserProfile() async {
    try {
      print('Loading user profile...');
      final response = await ApiService.getProfile();
      
      print('Profile API Response: $response');
      
      if (response['success'] == true && response['data'] != null) {
        final user = response['data'];
        
        print('User data from profile: $user');
        
        // Extract user name from profile - try multiple fields
        String name = '';
        
        // Try firstname + lastname combination first
        if (user['firstname'] != null && user['lastname'] != null) {
          final first = user['firstname'].toString().trim();
          final last = user['lastname'].toString().trim();
          if (first.isNotEmpty && last.isNotEmpty) {
            name = '$first $last';
          } else if (first.isNotEmpty) {
            name = first;
          }
        }
        // Try firstname alone
        else if (user['firstname'] != null && user['firstname'].toString().trim().isNotEmpty) {
          name = user['firstname'].toString().trim();
        }
        // Try name field
        else if (user['name'] != null && user['name'].toString().trim().isNotEmpty) {
          name = user['name'].toString().trim();
        }
        // Try fullname field
        else if (user['fullname'] != null && user['fullname'].toString().trim().isNotEmpty) {
          name = user['fullname'].toString().trim();
        }
        
        print('Extracted user name: $name');
        print('Current userName.value before update: ${userName.value}');
        
        if (name.isNotEmpty) {
          userName.value = name;
          print('User name updated to: ${userName.value}');
          print('userName.value after update: ${userName.value}');
        } else {
          print('No valid name found in profile data');
        }
      } else {
        print('Profile API response not successful or no data');
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  // Load dashboard data from API
  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getDashboard();
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        
        // Load user name from dashboard (update if still 'User' or if dashboard has better data)
        if (data['user'] != null) {
          final user = data['user'];
          
          String name = '';
          // Try firstname + lastname combination first
          if (user['firstname'] != null && user['lastname'] != null) {
            final first = user['firstname'].toString().trim();
            final last = user['lastname'].toString().trim();
            if (first.isNotEmpty && last.isNotEmpty) {
              name = '$first $last';
            } else if (first.isNotEmpty) {
              name = first;
            }
          }
          // Try firstname alone
          else if (user['firstname'] != null && user['firstname'].toString().trim().isNotEmpty) {
            name = user['firstname'].toString().trim();
          }
          // Try name field
          else if (user['name'] != null && user['name'].toString().trim().isNotEmpty) {
            name = user['name'].toString().trim();
          }
          
          // Update if we got a valid name and current value is 'User' or empty
          if (name.isNotEmpty && (userName.value == 'User' || userName.value.isEmpty)) {
            userName.value = name;
            print('User name updated from dashboard: ${userName.value}');
          }
        }
        
        // Load wallet balance
        walletBalance.value = (data['balance'] ?? 
                              data['wallet_balance'] ?? 
                              data['wallet'] ?? 
                              0.0).toDouble();
        
        // Load loan eligibility
        loanEligibility.value = (data['loan_eligibility'] ?? 
                                data['eligibility'] ?? 
                                0.0).toDouble();
        
        // Load credit score
        creditScore.value = (data['credit_score'] ?? 
                            data['cibil_score'] ?? 
                            0) is int 
            ? (data['credit_score'] ?? data['cibil_score'] ?? 0) 
            : int.tryParse((data['credit_score'] ?? data['cibil_score'] ?? 0).toString()) ?? 0;
        
        // Load active EMI
        activeEMI.value = (data['active_emi'] ?? 
                          data['total_emi'] ?? 
                          0.0).toDouble();
        
        // Load today's deposit
        todayDeposit.value = (data['today_deposit'] ?? 
                             data['deposit_today'] ?? 
                             0.0).toDouble();
        
        // Load active loans from dashboard API (if available)
        if (data['active_loans'] != null && data['active_loans'] is List) {
          final dashboardLoans = (data['active_loans'] as List).map((loan) {
            final paidMonths = loan['paid_months'] ?? loan['current_month'] ?? 0;
            final totalMonths = loan['total_months'] ?? loan['tenure'] ?? 1;
            final progress = totalMonths > 0 ? (paidMonths / totalMonths).clamp(0.0, 1.0) : 0.0;
            
            return {
              'name': loan['loan_type'] ?? loan['type'] ?? 'Loan',
              'amount': '₹${_formatCurrency(loan['loan_amount'] ?? loan['amount'] ?? 0)}',
              'emi': '₹${_formatCurrency(loan['emi'] ?? loan['monthly_payment'] ?? 0)}',
              'tenure': '$paidMonths/$totalMonths months',
              'progress': progress,
              'id': 'dashboard_${loan['id']?.toString() ?? ''}',
            };
          }).toList();
          activeLoans.assignAll(dashboardLoans);
        }
        
        // Always load approved loans from all loan types API
        await _loadApprovedLoans();
        
        // Load recent transactions
        if (data['recent_transactions'] != null && data['recent_transactions'] is List) {
          recentTransactions.assignAll((data['recent_transactions'] as List).map((txn) {
            return {
              'type': txn['type'] ?? txn['transaction_type'] ?? 'Transaction',
              'amount': '₹${_formatCurrency(txn['amount'] ?? 0)}',
              'date': _formatDate(txn['date'] ?? txn['created_at']),
              'time': _formatTime(txn['time'] ?? txn['created_at']),
              'status': txn['status'] ?? 'Completed',
            };
          }).toList());
        }
      } else {
        // If no data, initialize with empty values for new users
        _initializeEmptyData();
        // Still try to load approved loans even if dashboard has no data
        await _loadApprovedLoans();
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
      // Initialize with empty values on error
      _initializeEmptyData();
      // Still try to load approved loans even on error
      await _loadApprovedLoans();
    } finally {
      isLoading.value = false;
    }
  }

  // Load approved loans from API (all loan types)
  Future<void> _loadApprovedLoans() async {
    try {
      print('🔄 Loading approved loans...');
      List<Map<String, dynamic>> allApprovedLoans = [];
      
      // Fetch all loan types
      final personalLoans = await ApiService.getPersonalLoans();
      final businessLoans = await ApiService.getBusinessLoans();
      final homeLoans = await ApiService.getHomeLoans();
      final carLoans = await ApiService.getCarLoans();
      final instantLoans = await ApiService.getInstantLoans();
      
      // Process each loan type
      final loanTypes = [
        {'data': personalLoans, 'defaultType': 'Personal Loan'},
        {'data': businessLoans, 'defaultType': 'Business Loan'},
        {'data': homeLoans, 'defaultType': 'Home Loan'},
        {'data': carLoans, 'defaultType': 'Car Loan'},
        {'data': instantLoans, 'defaultType': 'Instant Loan'},
      ];
      
      for (var loanTypeData in loanTypes) {
        try {
          final response = loanTypeData['data'] as Map<String, dynamic>;
          final defaultType = loanTypeData['defaultType'] as String;
          
          print('Checking ${defaultType}...');
          
          if (response['success'] == true && response['data'] != null) {
            final loans = response['data'] as List;
            print('Found ${loans.length} ${defaultType} loans');
            
            // Filter only approved loans
            final approvedLoansList = loans.where((loan) {
              final status = loan['status']?.toString().toLowerCase().trim() ?? '';
              final isApproved = status == 'approved';
              if (isApproved) {
                print('✅ Found approved ${defaultType}: ${loan['loan_type'] ?? defaultType} - ${loan['loan_amount']}');
              }
              return isApproved;
            }).toList();
            
            print('Found ${approvedLoansList.length} approved ${defaultType} loans');
            
            // Convert to home screen format
            final formattedLoans = approvedLoansList.map((loan) {
              final loanAmount = _toDouble(loan['loan_amount'] ?? loan['amount'], 0.0);
              final loanTenure = _toInt(loan['loan_tenure'] ?? loan['tenure'] ?? loan['tenure_months'], 0);
              final interestRate = _toDouble(loan['interest_rate'] ?? 10.5, 10.5);
              
              // Calculate EMI if not provided
              double emi = 0.0;
              if (loan['emi'] != null || loan['monthly_emi'] != null) {
                emi = _toDouble(loan['emi'] ?? loan['monthly_emi'], 0.0);
              } else if (loanAmount > 0 && loanTenure > 0 && interestRate > 0) {
                final monthlyRate = interestRate / 100 / 12;
                final powerN = pow(1 + monthlyRate, loanTenure);
                if (powerN > 1) {
                  emi = loanAmount * monthlyRate * powerN / (powerN - 1);
                }
              }
              
              final paidMonths = _toInt(loan['paid_months'] ?? loan['months_paid'], 0);
              final totalMonths = loanTenure > 0 ? loanTenure : 1;
              final progress = totalMonths > 0 ? (paidMonths / totalMonths).clamp(0.0, 1.0) : 0.0;
              
              return {
                'name': loan['loan_type']?.toString() ?? defaultType,
                'amount': '₹${_formatCurrency(loanAmount)}',
                'emi': emi > 0 ? '₹${_formatCurrency(emi)}' : 'N/A',
                'tenure': loanTenure > 0 
                  ? (loanTenure >= 12 
                      ? '${loanTenure ~/ 12} year${loanTenure ~/ 12 > 1 ? 's' : ''}'
                      : '${loanTenure} month${loanTenure > 1 ? 's' : ''}')
                  : 'N/A',
                'progress': progress,
                'id': '${defaultType}_${loan['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch}',
                'fullName': loan['full_name']?.toString(),
                'createdAt': loan['created_at']?.toString(),
              };
            }).toList();
            
            allApprovedLoans.addAll(formattedLoans);
            print('Added ${formattedLoans.length} formatted ${defaultType} loans');
          } else {
            print('⚠️ ${defaultType} API response not successful: ${response['success']}');
          }
        } catch (e) {
          print('Error processing ${loanTypeData['defaultType']}: $e');
        }
      }
      
      print('📊 Total approved loans found: ${allApprovedLoans.length}');
      
      // If activeLoans is empty or only has dashboard loans, replace with approved loans
      if (activeLoans.isEmpty || activeLoans.every((loan) {
        final id = loan['id']?.toString();
        return id != null && id.startsWith('dashboard_');
      })) {
        print('🔄 Replacing activeLoans with approved loans...');
        activeLoans.assignAll(allApprovedLoans);
        print('✅ Loaded ${allApprovedLoans.length} approved loans to active loans section');
      } else {
        // Add approved loans avoiding duplicates
        final existingIds = activeLoans.map((l) => l['id']?.toString()).where((id) => id != null && id.isNotEmpty).toSet();
        final newLoans = allApprovedLoans.where((loan) => 
          !existingIds.contains(loan['id']?.toString())
        ).toList();
        
        if (newLoans.isNotEmpty) {
          activeLoans.addAll(newLoans);
          print('✅ Added ${newLoans.length} new approved loans (${activeLoans.length} total)');
        } else {
          print('⚠️ No new approved loans to add (all are duplicates)');
        }
      }
      
      print('📋 Final activeLoans count: ${activeLoans.length}');
    } catch (e) {
      print('❌ Error loading approved loans: $e');
      print('Stack trace: ${e.toString()}');
    }
  }
  
  // Helper function to safely convert to double
  double _toDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[,\s]'), '');
      return double.tryParse(cleaned) ?? defaultValue;
    }
    return defaultValue;
  }
  
  // Helper function to safely convert to int
  int _toInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[,\s]'), '');
      return int.tryParse(cleaned) ?? defaultValue;
    }
    return defaultValue;
  }

  // Initialize empty data for new users
  void _initializeEmptyData() {
    userName.value = 'User';
    walletBalance.value = 0.0;
    loanEligibility.value = 0.0;
    creditScore.value = 0;
    activeEMI.value = 0.0;
    todayDeposit.value = 0.0;
    activeLoans.clear();
    recentTransactions.clear();
  }

  // Format currency
  String _formatCurrency(dynamic amount) {
    if (amount == null) return '0';
    final numValue = (amount is int || amount is double) 
        ? (amount is int ? amount.toDouble() : amount as double)
        : double.tryParse(amount.toString()) ?? 0.0;
    if (numValue >= 100000) {
      return '${(numValue / 100000).toStringAsFixed(2)}L';
    } else if (numValue >= 1000) {
      return '${(numValue / 1000).toStringAsFixed(1)}K';
    }
    return numValue.toStringAsFixed(0);
  }

  // Format date
  String _formatDate(dynamic date) {
    if (date == null) return 'Today';
    try {
      final dateTime = DateTime.parse(date.toString());
      final now = DateTime.now();
      final difference = now.difference(dateTime).inDays;
      
      if (difference == 0) return 'Today';
      if (difference == 1) return 'Yesterday';
      if (difference < 7) return '$difference days ago';
      
      return '${dateTime.day} ${_getMonthName(dateTime.month)}';
    } catch (e) {
      return 'Today';
    }
  }

  // Format time
  String _formatTime(dynamic time) {
    if (time == null) return '';
    try {
      final dateTime = DateTime.parse(time.toString());
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return '';
    }
  }

  // Get month name
  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  // function for bottom navigation
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  // Logout function
  Future<void> logout() async {
    try {
      // Show confirmation dialog
      final shouldLogout = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF1B2B41),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text(
                'Logout',
                style: TextStyle(color: Color(0xFF63b5bb)),
              ),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        // Sign out from Firebase Auth
        try {
          await FirebaseAuth.instance.signOut();
        } catch (e) {
          // Ignore if Firebase Auth is not initialized
        }

        // Sign out from Google Sign In if user was signed in with Google
        try {
          final GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
        } catch (e) {
          // Ignore if Google Sign In is not initialized or user wasn't signed in with Google
        }

        // Clear auth token
        await ApiService.clearToken();

        // Navigate to login screen and clear all previous routes
        Get.offAllNamed(Routes.login);

        // Show success message
        Get.snackbar(
          'Success',
          'Logged out successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
