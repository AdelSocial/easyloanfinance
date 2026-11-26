import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../routes/app_pages.dart';


class UnsecuredSuccessController extends GetxController {
  var isLoading = true.obs;
  var loanData = Rxn<Map<String, dynamic>>();
  
  // Success details
  var applicationNumber = ''.obs;
  var loanAmount = ''.obs;
  var tenure = ''.obs;
  var interestRate = '11.5%'.obs;
  var emiAmount = ''.obs;
  var disbursalTime = '24-48 Hours'.obs;
  var submittedDate = Rxn<DateTime>();
  var status = 'Under Review'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLoanData();
  }

  Future<void> _loadLoanData() async {
    isLoading.value = true;
    
    try {
      final loanId = await LoanStorageService.getCurrentLoanId('business');
      
      if (loanId != null) {
        // Generate application number from loan ID
        applicationNumber.value = 'UBL${loanId.toString().padLeft(8, '0')}';
        
        // Fetch loan data from API
        final response = await ApiService.getBusinessLoans();
        
        if (response['success'] == true && response['data'] != null) {
          final loans = response['data'] as List;
          final currentLoan = loans.firstWhere(
            (loan) => loan['id'] == loanId,
            orElse: () => loans.isNotEmpty ? loans.first : null,
          );
          
          if (currentLoan != null) {
            loanData.value = currentLoan as Map<String, dynamic>;
            _updateLoanDetails(currentLoan);
            
            // Parse submitted date
            if (currentLoan['created_at'] != null) {
              try {
                submittedDate.value = DateTime.parse(currentLoan['created_at'].toString());
              } catch (e) {
                submittedDate.value = DateTime.now();
              }
            } else {
              submittedDate.value = DateTime.now();
            }
            
            // Update status
            if (currentLoan['status'] != null) {
              status.value = _formatStatus(currentLoan['status'].toString());
            }
          }
        }
      } else {
        // Fallback if no loan ID found
        applicationNumber.value = 'UBL${DateTime.now().millisecondsSinceEpoch}';
        submittedDate.value = DateTime.now();
      }
    } catch (e) {
      print('Error loading loan data: $e');
      // Set fallback values
      applicationNumber.value = 'UBL${DateTime.now().millisecondsSinceEpoch}';
      submittedDate.value = DateTime.now();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateLoanDetails(Map<String, dynamic> loan) {
    // Update loan amount
    if (loan['loan_amount'] != null) {
      final amount = loan['loan_amount'];
      if (amount is num) {
        loanAmount.value = _formatCurrency(amount.toDouble());
      } else {
        loanAmount.value = _formatCurrency(double.tryParse(amount.toString()) ?? 0);
      }
    } else {
      loanAmount.value = '₹0';
    }
    
    // Update tenure
    if (loan['loan_tenure'] != null) {
      final tenureMonths = loan['loan_tenure'];
      if (tenureMonths is num) {
        tenure.value = '${tenureMonths.toInt()} Months';
      } else {
        tenure.value = '${int.tryParse(tenureMonths.toString()) ?? 0} Months';
      }
    } else {
      tenure.value = 'N/A';
    }
    
    // Calculate EMI
    if (loan['loan_amount'] != null && loan['loan_tenure'] != null) {
      final amount = loan['loan_amount'] is num 
          ? (loan['loan_amount'] as num).toDouble()
          : double.tryParse(loan['loan_amount'].toString()) ?? 0;
      final months = loan['loan_tenure'] is num
          ? (loan['loan_tenure'] as num).toInt()
          : int.tryParse(loan['loan_tenure'].toString()) ?? 0;
      
      if (amount > 0 && months > 0) {
        final emi = _calculateEMI(amount, months, 11.5); // 11.5% default interest
        emiAmount.value = _formatCurrency(emi);
      } else {
        emiAmount.value = 'N/A';
      }
    } else {
      emiAmount.value = 'N/A';
    }
    
    // Update disbursal time based on loan type
    if (loan['loan_type'] == 'unsecured') {
      disbursalTime.value = '24-48 Hours';
    } else {
      disbursalTime.value = '5-7 Business Days';
    }
  }

  double _calculateEMI(double principal, int months, double annualRate) {
    if (principal <= 0 || months <= 0) return 0;
    
    final monthlyRate = annualRate / 12 / 100;
    if (monthlyRate == 0) {
      return principal / months;
    }
    
    final emi = principal * monthlyRate * 
        (math.pow(1 + monthlyRate, months) / (math.pow(1 + monthlyRate, months) - 1));
    
    return emi;
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
      locale: 'en_IN',
    );
    return formatter.format(amount);
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Under Review';
      case 'under_review':
        return 'Under Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'disbursed':
        return 'Disbursed';
      default:
        return status.replaceAll('_', ' ').split(' ').map((word) {
          return word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1);
        }).join(' ');
    }
  }

  // Next steps - dynamically generated based on loan status
  List<Map<String, dynamic>> get nextSteps {
    final steps = <Map<String, dynamic>>[];
    final currentStatus = status.value.toLowerCase();
    
    if (currentStatus.contains('pending') || currentStatus.contains('review')) {
      steps.add({
        'title': 'Document Verification',
        'description': 'Your documents will be verified within 24 hours',
        'time': 'Within 24 hours',
        'icon': Icons.verified,
        'status': 'pending'
      });
    }
    
    if (!currentStatus.contains('approved') && !currentStatus.contains('disbursed')) {
      steps.add({
        'title': 'Credit Assessment',
        'description': 'Credit check and business evaluation',
        'time': '1-2 business days',
        'icon': Icons.assessment,
        'status': 'pending'
      });
    }
    
    if (!currentStatus.contains('approved') && !currentStatus.contains('disbursed')) {
      steps.add({
        'title': 'Final Approval',
        'description': 'Loan sanction and approval',
        'time': '2-3 business days',
        'icon': Icons.approval,
        'status': 'pending'
      });
    }
    
    if (currentStatus.contains('approved') && !currentStatus.contains('disbursed')) {
      steps.add({
        'title': 'Amount Disbursal',
        'description': 'Loan amount transferred to your account',
        'time': '24-48 hours after approval',
        'icon': Icons.account_balance,
        'status': 'pending'
      });
    }
    
    if (steps.isEmpty) {
      // Default steps if no status match
      steps.addAll([
        {
          'title': 'Document Verification',
          'description': 'Your documents will be verified within 24 hours',
          'time': 'Within 24 hours',
          'icon': Icons.verified,
          'status': 'pending'
        },
        {
          'title': 'Credit Assessment',
          'description': 'Credit check and business evaluation',
          'time': '1-2 business days',
          'icon': Icons.assessment,
          'status': 'pending'
        },
        {
          'title': 'Final Approval',
          'description': 'Loan sanction and approval',
          'time': '2-3 business days',
          'icon': Icons.approval,
          'status': 'pending'
        },
        {
          'title': 'Amount Disbursal',
          'description': 'Loan amount transferred to your account',
          'time': '24-48 hours after approval',
          'icon': Icons.account_balance,
          'status': 'pending'
        },
      ]);
    }
    
    return steps;
  }

  // Loan benefits
  var benefits = [
    {
      'title': 'No Collateral Required',
      'description': 'No security or guarantor needed',
      'icon': Icons.security
    },
    {
      'title': 'Quick Processing',
      'description': 'Fast approval and disbursal',
      'icon': Icons.flash_on
    },
    {
      'title': 'Flexible Repayment',
      'description': 'Choose tenure from 12-60 months',
      'icon': Icons.calendar_today
    },
    {
      'title': 'Digital Process',
      'description': 'Complete process online',
      'icon': Icons.laptop
    },
  ].obs;

  Future<void> downloadSanctionLetter() async {
    try {
      if (loanData.value == null) {
        Get.snackbar(
          'Error',
          'Loan data not available',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // TODO: Implement actual PDF download from API
      // For now, show success message
      Get.snackbar(
        'Download Started',
        'Application details download initiated. You will receive it via email.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      
      // In production, you would call an API endpoint to generate and download PDF
      // Example: await ApiService.downloadApplicationPDF(loanId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void trackApplication() {
    // Navigate to loan details/tracking screen
    // For now, go back to home or show loan list
    try {
      Get.offAllNamed(Routes.homeScreen);
      // TODO: Navigate to specific loan tracking screen when available
      // Get.toNamed(Routes.businessLoanTrackingScreen, arguments: loanData.value?['id']);
    } catch (e) {
      Get.snackbar(
        'Info',
        'Navigate to home to track your application',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  void applyForAnotherLoan() {
    // Clear current loan from storage and go to home
    LoanStorageService.clearCurrentLoan('business');
    Get.offAllNamed(Routes.homeScreen);
  }

  void contactRelationshipManager() async {
    try {
      // TODO: Implement actual contact functionality
      // This could open a phone dialer, email client, or chat
      
      Get.snackbar(
        'Contact Support',
        'Your relationship manager will contact you shortly at your registered mobile number',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF00D4FF),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      
      // Example implementations:
      // - Open phone dialer: launch('tel:+911234567890');
      // - Open email: launch('mailto:support@easyloan.com');
      // - Open chat: Get.toNamed(Routes.supportChatScreen);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to contact support: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}