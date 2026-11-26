import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../routes/app_pages.dart';
import '../view/home_screen.dart';

class SecuredSuccessController extends GetxController {
  var isLoading = true.obs;
  var loanData = Rxn<Map<String, dynamic>>();
  
  // Success details
  var applicationNumber = ''.obs;
  var loanAmount = ''.obs;
  var tenure = ''.obs;
  var interestRate = '8.5%'.obs;
  var emiAmount = ''.obs;
  var disbursalTime = '5-7 Business Days'.obs;
  var collateralType = 'Not Available'.obs;
  var collateralValue = 'Not Available'.obs;
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
        applicationNumber.value = 'SBL${loanId.toString().padLeft(8, '0')}';
        
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
            
            // Update next steps based on status
            _updateNextSteps();
          }
        }
      } else {
        // Fallback if no loan ID found
        applicationNumber.value = 'SBL${DateTime.now().millisecondsSinceEpoch}';
        submittedDate.value = DateTime.now();
      }
    } catch (e) {
      print('Error loading loan data: $e');
      // Set fallback values
      applicationNumber.value = 'SBL${DateTime.now().millisecondsSinceEpoch}';
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
      tenure.value = '0 Months';
    }
    
    // Update interest rate (default for secured loans)
    interestRate.value = '8.5%';
    
    // Calculate EMI
    final amount = loan['loan_amount'] != null 
        ? (loan['loan_amount'] is num 
            ? loan['loan_amount'].toDouble() 
            : double.tryParse(loan['loan_amount'].toString()) ?? 0)
        : 0;
    final tenureMonths = loan['loan_tenure'] != null
        ? (loan['loan_tenure'] is num
            ? loan['loan_tenure'].toInt()
            : int.tryParse(loan['loan_tenure'].toString()) ?? 0)
        : 0;
    
    if (amount > 0 && tenureMonths > 0) {
      emiAmount.value = _formatCurrency(_calculateEMI(amount, 8.5, tenureMonths));
    } else {
      emiAmount.value = '₹0';
    }
    
    // Update disbursal time based on status
    if (loan['status'] != null) {
      final loanStatus = loan['status'].toString().toLowerCase();
      if (loanStatus == 'approved') {
        disbursalTime.value = '24-48 Hours';
      } else if (loanStatus == 'disbursed') {
        disbursalTime.value = 'Disbursed';
      } else {
        disbursalTime.value = '5-7 Business Days';
      }
    }
    
    // Try to get collateral information (if available in loan data)
    // Note: These fields may not be in database yet, so we'll use fallback
    if (loan['collateral_type'] != null) {
      collateralType.value = loan['collateral_type'].toString();
    }
    
    if (loan['collateral_value'] != null) {
      final value = loan['collateral_value'];
      if (value is num) {
        collateralValue.value = _formatCurrency(value.toDouble());
      } else {
        collateralValue.value = _formatCurrency(double.tryParse(value.toString()) ?? 0);
      }
    }
  }

  double _calculateEMI(double principal, double annualRate, int tenureMonths) {
    if (principal <= 0 || annualRate <= 0 || tenureMonths <= 0) return 0;
    
    // Monthly interest rate
    final monthlyRate = annualRate / 12 / 100;
    
    if (monthlyRate == 0) {
      return principal / tenureMonths;
    }
    
    // EMI formula: [P x R x (1+R)^N] / [(1+R)^N - 1]
    final emi = (principal * monthlyRate * math.pow(1 + monthlyRate, tenureMonths)) /
        (math.pow(1 + monthlyRate, tenureMonths) - 1);
    
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
        return 'Pending Review';
      case 'under_review':
        return 'Under Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'disbursed':
        return 'Disbursed';
      default:
        return status;
    }
  }

  // Next steps - dynamically updated based on status
  var nextSteps = <Map<String, dynamic>>[].obs;

  void _updateNextSteps() {
    final currentStatus = status.value.toLowerCase();
    
    final allSteps = [
      {
        'title': 'Document Verification',
        'description': 'Verification of business and personal documents',
        'time': '1-2 business days',
        'icon': Icons.verified,
        'status': currentStatus == 'pending' || currentStatus == 'under_review' ? 'pending' : 'completed'
      },
      {
        'title': 'Property Valuation',
        'description': 'Physical inspection and valuation of collateral',
        'time': '2-3 business days',
        'icon': Icons.home_work,
        'status': currentStatus == 'pending' || currentStatus == 'under_review' ? 'pending' : 
                  currentStatus == 'approved' || currentStatus == 'disbursed' ? 'completed' : 'pending'
      },
      {
        'title': 'Legal Verification',
        'description': 'Legal check of property documents',
        'time': '2-3 business days',
        'icon': Icons.gavel,
        'status': currentStatus == 'pending' || currentStatus == 'under_review' ? 'pending' : 
                  currentStatus == 'approved' || currentStatus == 'disbursed' ? 'completed' : 'pending'
      },
      {
        'title': 'Credit Assessment',
        'description': 'Business and credit evaluation',
        'time': '1-2 business days',
        'icon': Icons.assessment,
        'status': currentStatus == 'pending' || currentStatus == 'under_review' ? 'pending' : 
                  currentStatus == 'approved' || currentStatus == 'disbursed' ? 'completed' : 'pending'
      },
      {
        'title': 'Final Approval',
        'description': 'Loan sanction and approval',
        'time': '1-2 business days',
        'icon': Icons.approval,
        'status': currentStatus == 'approved' || currentStatus == 'disbursed' ? 'completed' : 'pending'
      },
      {
        'title': 'Amount Disbursal',
        'description': 'Loan amount transferred to your account',
        'time': '24 hours after approval',
        'icon': Icons.account_balance,
        'status': currentStatus == 'disbursed' ? 'completed' : 'pending'
      },
    ];
    
    nextSteps.value = allSteps;
  }

  // Loan benefits
  var benefits = [
    {
      'title': 'Lower Interest Rates',
      'description': 'Reduced rates due to collateral',
      'icon': Icons.trending_down
    },
    {
      'title': 'Higher Loan Amount',
      'description': 'Up to 60% of property value',
      'icon': Icons.attach_money
    },
    {
      'title': 'Longer Tenure',
      'description': 'Extended repayment period',
      'icon': Icons.calendar_today
    },
    {
      'title': 'Property Ownership',
      'description': 'Continue to own your property',
      'icon': Icons.security
    },
  ].obs;

  void downloadSanctionLetter() {
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
    
    Get.snackbar(
      'Download Started',
      'Sanction letter download initiated',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
    // TODO: Implement actual download functionality
  }

  void trackApplication() {
    // Navigate to loans screen to track application
    Get.toNamed(Routes.loansScreen);
  }

  void applyForAnotherLoan() async {
    // Clear current loan storage
    await LoanStorageService.clearCurrentLoan('business');
    
    // Navigate to home screen
    Get.offAll(() => HomeScreen());
  }

  void contactRelationshipManager() {
    Get.snackbar(
      'Contact Support',
      'Your relationship manager will contact you shortly',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
    // TODO: Implement actual contact functionality
  }

  void schedulePropertyValuation() {
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
    
    Get.snackbar(
      'Valuation Scheduled',
      'Property valuation will be scheduled within 24 hours. You will receive a confirmation call.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
    // TODO: Implement actual scheduling functionality
  }
}