import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';

import '../view/personal_loan/personal_application_success_screen.dart';

class PersonalReviewController extends GetxController {
  // Agreement checkboxes
  var agreeKFS = false.obs;
  var agreeTerms = false.obs;

  // Loan details
  var loanDetails = <String, String>{}.obs;
  
  // Loading states
  var isLoading = false.obs;
  var isLoadingDetails = false.obs;
  
  var currentLoanId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    loadLoanDetails();
  }

  // Load loan details from API
  Future<void> loadLoanDetails() async {
    isLoadingDetails.value = true;
    
    try {
      // Get current loan ID
      final loanId = await LoanStorageService.getCurrentLoanId('personal');
      if (loanId != null) {
        currentLoanId.value = loanId;
        
        // Fetch loan application details
        final response = await ApiService.getPersonalLoans();
        
        if (response['success'] == true && response['data'] != null) {
          final loans = response['data'] as List;
          if (loans.isNotEmpty) {
            // Find the current loan by ID
            Map<String, dynamic>? currentLoan;
            try {
              currentLoan = loans.firstWhere(
                (loan) => loan['id'] == loanId || loan['id'].toString() == loanId.toString(),
              ) as Map<String, dynamic>?;
            } catch (e) {
              // If not found by ID, try to get the most recent one
              if (loans.isNotEmpty) {
                currentLoan = loans.first as Map<String, dynamic>;
              }
            }
            
            if (currentLoan != null) {
              if (kDebugMode) {
                print('Loading loan details for loan ID: $loanId');
                print('Loan data: $currentLoan');
              }
              // Extract and format loan details
              _updateLoanDetails(currentLoan);
            } else {
              if (kDebugMode) {
                print('Loan not found for ID: $loanId');
              }
              _setDefaultLoanDetails();
            }
          } else {
            _setDefaultLoanDetails();
          }
        } else {
          if (kDebugMode) {
            print('API response error: ${response['message']}');
          }
          Get.snackbar(
            'Error',
            ApiService.msg(response['message'], 'Failed to load loan details'),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
          _setDefaultLoanDetails();
        }
      } else {
        if (kDebugMode) {
          print('No loan ID found in storage');
        }
        _setDefaultLoanDetails();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading loan details: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to load loan details: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      _setDefaultLoanDetails();
    } finally {
      isLoadingDetails.value = false;
    }
  }

  // Refresh loan details
  Future<void> refreshLoanDetails() async {
    await loadLoanDetails();
  }

  void _updateLoanDetails(Map<String, dynamic> loanData) {
    if (kDebugMode) {
      print('Loan Data received: $loanData');
      print('Loan Amount: ${loanData['loan_amount']}');
      print('Loan Tenure: ${loanData['loan_tenure']}');
    }
    
    // Parse loan amount - handle both string and numeric values
    double? amount;
    if (loanData['loan_amount'] != null) {
      if (loanData['loan_amount'] is String) {
        amount = double.tryParse(loanData['loan_amount'].toString().replaceAll(',', '').trim());
      } else {
        amount = (loanData['loan_amount'] as num?)?.toDouble();
      }
    }
    
    // Try alternative field names for loan amount
    if (amount == null || amount <= 0) {
      if (loanData['amount'] != null) {
        if (loanData['amount'] is String) {
          amount = double.tryParse(loanData['amount'].toString().replaceAll(',', '').trim());
        } else {
          amount = (loanData['amount'] as num?)?.toDouble();
        }
      }
    }
    
    // Parse loan tenure - handle both string and numeric values
    // Note: loan_tenure is stored in months in the database
    int? tenureMonths;
    if (loanData['loan_tenure'] != null) {
      if (loanData['loan_tenure'] is String) {
        tenureMonths = int.tryParse(loanData['loan_tenure'].toString().trim());
      } else {
        tenureMonths = (loanData['loan_tenure'] as num?)?.toInt();
      }
    } else if (loanData['tenure'] != null) {
      // Fallback to 'tenure' field if 'loan_tenure' is not available
      if (loanData['tenure'] is String) {
        tenureMonths = int.tryParse(loanData['tenure'].toString().trim());
      } else {
        tenureMonths = (loanData['tenure'] as num?)?.toInt();
      }
    }
    
    // Show available data even if some fields are missing
    // Don't show error, show what we have
    Map<String, String> details = {};
    
    // Add loan amount if available
    if (amount != null && amount > 0) {
      details['Amount'] = '₹ ${_formatCurrency(amount)}';
    } else {
      details['Amount'] = 'Not specified';
    }
    
    // Add tenure if available
    if (tenureMonths != null && tenureMonths > 0) {
      final tenureYears = tenureMonths / 12;
      String tenureDisplay;
      if (tenureYears >= 1) {
        if (tenureYears == tenureYears.roundToDouble()) {
          tenureDisplay = '${tenureYears.toInt()} ${tenureYears.toInt() == 1 ? 'Year' : 'Years'}';
        } else {
          tenureDisplay = '${tenureYears.toStringAsFixed(1)} Years';
        }
      } else {
        tenureDisplay = '$tenureMonths ${tenureMonths == 1 ? 'Month' : 'Months'}';
      }
      details['Tenure'] = tenureDisplay;
    } else {
      details['Tenure'] = 'Not specified';
    }
    
    // If both amount and tenure are missing, show error
    if ((amount == null || amount <= 0) && (tenureMonths == null || tenureMonths <= 0)) {
      loanDetails.value = {
        'Error': 'Loan details not available. Please complete the application form.',
      };
      return;
    }
    
    // Use default values if missing for calculations
    final effectiveAmount = amount ?? 0.0;
    final effectiveTenure = tenureMonths ?? 12; // Default 12 months if not specified
    
    // Interest rate - can be from API or default
    double? interestRate;
    if (loanData['interest_rate'] != null) {
      if (loanData['interest_rate'] is String) {
        interestRate = double.tryParse(loanData['interest_rate'].toString());
      } else {
        interestRate = (loanData['interest_rate'] as num?)?.toDouble();
      }
    }
    interestRate = interestRate ?? 12.5; // Default 12.5%
    details['Interest Rate (APR)'] = '${interestRate.toStringAsFixed(1)}%';
    
    // Calculate EMI only if we have valid amount and tenure
    if (effectiveAmount > 0 && effectiveTenure > 0) {
      // Calculate EMI using standard formula: EMI = [P x R x (1+R)^N] / [(1+R)^N - 1]
      // Where P = Principal, R = Monthly Interest Rate, N = Number of months
      final monthlyRate = interestRate / 12 / 100;
      double emi = 0.0;
      
      if (monthlyRate > 0 && effectiveTenure > 0) {
        final powerTerm = math.pow(1 + monthlyRate, effectiveTenure);
        emi = (effectiveAmount * monthlyRate * powerTerm) / (powerTerm - 1);
        // Round EMI to 2 decimal places
        emi = (emi * 100).round() / 100;
      } else {
        // If rate is 0 or tenure is 0, just divide amount by tenure
        emi = effectiveTenure > 0 ? (effectiveAmount / effectiveTenure * 100).round() / 100 : 0.0;
      }
      
      // Calculate other values
      final totalRepayment = (emi * effectiveTenure * 100).round() / 100; // Round to 2 decimal places
      final totalInterest = ((totalRepayment - effectiveAmount) * 100).round() / 100; // Round to 2 decimal places
      final processingFee = (effectiveAmount * 0.01).round(); // 1% of loan amount, rounded
      
      details['EMI'] = '₹ ${_formatCurrency(emi)}';
      details['Processing Fee'] = '₹ ${_formatCurrency(processingFee.toDouble())}';
      details['Total Interest Payable'] = '₹ ${_formatCurrency(totalInterest)}';
      details['Total Repayment'] = '₹ ${_formatCurrency(totalRepayment)}';
    } else {
      // If amount or tenure is missing, show placeholder
      details['EMI'] = 'Not available';
      details['Processing Fee'] = 'Not available';
      details['Total Interest Payable'] = 'Not available';
      details['Total Repayment'] = 'Not available';
    }
    
    loanDetails.value = details;
  }

  void _setDefaultLoanDetails() {
    // Don't set default values - show error instead
    loanDetails.value = {
      'Error': 'Unable to load loan details. Please try again.',
    };
  }

  String _formatCurrency(double amount) {
    // Format with Indian number system with proper comma separation
    // For amounts less than 1 lakh, show with commas
    if (amount < 100000) {
      // Format with commas for thousands
      final parts = amount.toStringAsFixed(2).split('.');
      final integerPart = parts[0];
      final decimalPart = parts.length > 1 ? parts[1] : '00';
      
      // Add commas for thousands
      String formatted = '';
      int count = 0;
      for (int i = integerPart.length - 1; i >= 0; i--) {
        if (count == 3) {
          formatted = ',' + formatted;
          count = 0;
        }
        formatted = integerPart[i] + formatted;
        count++;
      }
      
      // Remove trailing zeros from decimal part
      String cleanDecimal = decimalPart.replaceAll(RegExp(r'0+$'), '');
      if (cleanDecimal.isEmpty) {
        return formatted;
      }
      return '$formatted.$cleanDecimal';
    } else if (amount >= 10000000) {
      // Crores
      final crores = amount / 10000000;
      if (crores == crores.roundToDouble()) {
        return '${crores.toInt()} Cr';
      }
      return '${crores.toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      // Lakhs
      final lakhs = amount / 100000;
      if (lakhs == lakhs.roundToDouble()) {
        return '${lakhs.toInt()} Lakh';
      }
      return '${lakhs.toStringAsFixed(2)} Lakh';
    } else {
      // Fallback
      return amount.toStringAsFixed(2);
    }
  }

  // Validation
  bool get isFormValid {
    return agreeKFS.value && agreeTerms.value;
  }

  Future<void> submitApplication() async {
    if (!isFormValid) {
      Get.snackbar(
        'Required',
        'Please accept all terms and conditions',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (currentLoanId.value == null) {
      Get.snackbar(
        'Error',
        'Loan application not found. Please complete previous steps.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    isLoading.value = true;

    try {
      // Show loading dialog
      Get.dialog(
        Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF1E2E3D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF00D4FF)),
                SizedBox(height: 16),
                Text(
                  'Submitting Application...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Finalize/submit the application
      // The application is already submitted, we just need to mark it as submitted
      // or update status if there's an endpoint for it
      // For now, we'll just navigate to success screen
      // In future, you can add an API call here to update the status
      
      Get.back(); // Close loading dialog

      // Show success message
      Get.snackbar(
        'Success',
        'Personal loan application submitted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      // Navigate to success screen
      await Future.delayed(Duration(milliseconds: 500));
      Get.offAll(() => PersonalApplicationSuccessScreen());
    } catch (e) {
      Get.back(); // Close loading dialog if open
      
      Get.snackbar(
        'Error',
        'Failed to submit application: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }
}