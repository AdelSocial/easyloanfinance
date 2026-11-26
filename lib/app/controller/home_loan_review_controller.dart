import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../view/home_loan/home_loan_application_success_screen.dart';

class HomeLoanReviewController extends GetxController {
  // Agreement checkboxes
  var agreeKFS = false.obs;
  var agreeTerms = false.obs;
  var agreePropertyDeclaration = false.obs;

  // Loan details - dynamic
  var loanDetails = <String, String>{}.obs;
  
  // Property details - dynamic
  var propertyDetails = <String, String>{}.obs;
  
  // Loading states
  var isLoading = false.obs;
  var isLoadingDetails = false.obs;
  
  var currentLoanId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    loadLoanDetails();
  }

  // Form validation
  bool get isFormValid {
    return agreeKFS.value && agreeTerms.value && agreePropertyDeclaration.value;
  }

  // Load loan details from API
  Future<void> loadLoanDetails() async {
    isLoadingDetails.value = true;
    
    try {
      // Get current loan ID
      final loanId = await LoanStorageService.getCurrentLoanId('home');
      if (loanId != null) {
        currentLoanId.value = loanId;
        
        // Fetch loan application details
        final response = await ApiService.getHomeLoans();
        
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
              // If not found by ID, use the most recent one
              if (loans.isNotEmpty) {
                currentLoan = loans.first as Map<String, dynamic>;
              }
            }
            
            if (currentLoan != null) {
              print('Loading home loan details for loan ID: $loanId');
              print('Loan data: $currentLoan');
              _updateLoanDetails(currentLoan);
              _updatePropertyDetails(currentLoan);
            } else {
              _setDefaultLoanDetails();
            }
          } else {
            _setDefaultLoanDetails();
          }
        } else {
          print('API response error: ${response['message']}');
          _setDefaultLoanDetails();
        }
      } else {
        _setDefaultLoanDetails();
      }
    } catch (e) {
      print('Error loading loan details: $e');
      _setDefaultLoanDetails();
      Get.snackbar(
        'Error',
        'Failed to load loan details: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingDetails.value = false;
    }
  }

  void _updateLoanDetails(Map<String, dynamic> loanData) {
    // Parse loan amount - handle all possible types
    double? amount;
    if (loanData['loan_amount'] != null) {
      if (loanData['loan_amount'] is String) {
        final amountStr = loanData['loan_amount'].toString().replaceAll(',', '').trim();
        amount = double.tryParse(amountStr);
      } else if (loanData['loan_amount'] is num) {
        amount = (loanData['loan_amount'] as num).toDouble();
      } else {
        // Try to parse as string if it's not a recognized type
        final amountStr = loanData['loan_amount'].toString().replaceAll(',', '').trim();
        amount = double.tryParse(amountStr);
      }
    }
    
    // Parse loan tenure - can be in months (tenure) or years (loan_tenure)
    int? tenureMonths;
    if (loanData['tenure'] != null) {
      if (loanData['tenure'] is String) {
        final tenureStr = loanData['tenure'].toString().trim();
        tenureMonths = int.tryParse(tenureStr);
      } else if (loanData['tenure'] is num) {
        tenureMonths = (loanData['tenure'] as num).toInt();
      } else {
        // Try to parse as string if it's not a recognized type
        tenureMonths = int.tryParse(loanData['tenure'].toString());
      }
    } else if (loanData['loan_tenure'] != null) {
      // If loan_tenure is in years, convert to months
      int? tenureYears;
      if (loanData['loan_tenure'] is String) {
        final tenureStr = loanData['loan_tenure'].toString().trim();
        tenureYears = int.tryParse(tenureStr);
      } else if (loanData['loan_tenure'] is num) {
        tenureYears = (loanData['loan_tenure'] as num).toInt();
      } else {
        tenureYears = int.tryParse(loanData['loan_tenure'].toString());
      }
      if (tenureYears != null) {
        tenureMonths = tenureYears * 12;
      }
    }
    
    // Default values if missing
    amount = amount ?? 5000000.0; // Default 50 lakhs
    tenureMonths = tenureMonths ?? 240; // Default 20 years
    
    // Interest rate - handle both string and numeric types
    double? interestRate;
    if (loanData['interest_rate'] != null) {
      if (loanData['interest_rate'] is String) {
        interestRate = double.tryParse(loanData['interest_rate'].toString().replaceAll(',', ''));
      } else {
        interestRate = (loanData['interest_rate'] as num?)?.toDouble();
      }
    }
    interestRate = interestRate ?? 8.4; // Default 8.4%
    
    // Calculate EMI using standard formula
    final monthlyRate = interestRate / 12 / 100;
    double emi = 0.0;
    if (monthlyRate > 0 && tenureMonths > 0) {
      emi = (amount * monthlyRate * math.pow(1 + monthlyRate, tenureMonths)) / 
            (math.pow(1 + monthlyRate, tenureMonths) - 1);
    } else {
      emi = amount / tenureMonths; // Simple division if interest is 0
    }
    
    // Calculate other values
    final totalRepayment = emi * tenureMonths;
    final totalInterest = totalRepayment - amount;
    final processingFee = (amount * 0.01).round(); // 1% of loan amount
    
    // Format tenure
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
    
    loanDetails.value = {
      'Loan Amount': '₹ ${_formatCurrency(amount)}',
      'Interest Rate': '${interestRate.toStringAsFixed(1)}% p.a.',
      'Loan Tenure': tenureDisplay,
      'EMI': '₹ ${_formatCurrency(emi)}',
      'Processing Fee': '₹ ${_formatCurrency(processingFee.toDouble())}',
      'Total Interest': '₹ ${_formatCurrency(totalInterest)}',
      'Total Repayment': '₹ ${_formatCurrency(totalRepayment)}',
    };
  }

  void _updatePropertyDetails(Map<String, dynamic> loanData) {
    // Property type
    final propertyType = loanData['property_type']?.toString() ?? 'Not specified';
    
    // Property location
    final propertyLocation = loanData['property_location']?.toString() ?? 
                           loanData['address']?.toString() ?? 'Not specified';
    
    // Builder name
    final builderName = loanData['builder_name']?.toString() ?? 'Not specified';
    
    // City
    final city = loanData['city']?.toString() ?? 'Not specified';
    
    // Property value - handle all possible types
    double? propertyValue;
    if (loanData['property_value'] != null) {
      if (loanData['property_value'] is String) {
        final valueStr = loanData['property_value'].toString().replaceAll(',', '').trim();
        propertyValue = double.tryParse(valueStr);
      } else if (loanData['property_value'] is num) {
        propertyValue = (loanData['property_value'] as num).toDouble();
      } else {
        final valueStr = loanData['property_value'].toString().replaceAll(',', '').trim();
        propertyValue = double.tryParse(valueStr);
      }
    }
    
    // Loan amount for LTV calculation - handle all possible types
    double? loanAmount;
    if (loanData['loan_amount'] != null) {
      if (loanData['loan_amount'] is String) {
        final amountStr = loanData['loan_amount'].toString().replaceAll(',', '').trim();
        loanAmount = double.tryParse(amountStr);
      } else if (loanData['loan_amount'] is num) {
        loanAmount = (loanData['loan_amount'] as num).toDouble();
      } else {
        final amountStr = loanData['loan_amount'].toString().replaceAll(',', '').trim();
        loanAmount = double.tryParse(amountStr);
      }
    }
    
    // Calculate LTV ratio
    String ltvRatio = 'Not available';
    if (propertyValue != null && propertyValue > 0 && loanAmount != null && loanAmount > 0) {
      final ltv = (loanAmount / propertyValue) * 100;
      ltvRatio = '${ltv.toStringAsFixed(1)}%';
    }
    
    propertyDetails.value = {
      'Property Type': propertyType,
      'Property Location': propertyLocation,
      'Builder Name': builderName,
      'City': city,
      'Property Value': propertyValue != null 
          ? '₹ ${_formatCurrency(propertyValue)}' 
          : 'Not specified',
      'LTV Ratio': ltvRatio,
    };
  }

  void _setDefaultLoanDetails() {
    loanDetails.value = {
      'Loan Amount': '₹ 50,00,000',
      'Interest Rate': '8.4% p.a.',
      'Loan Tenure': '20 Years',
      'EMI': '₹ 42,845',
      'Processing Fee': '₹ 15,000',
      'Total Interest': '₹ 52,82,800',
      'Total Repayment': '₹ 1,02,82,800',
    };
    
    propertyDetails.value = {
      'Property Type': 'Not specified',
      'Property Location': 'Not specified',
      'Builder Name': 'Not specified',
      'City': 'Not specified',
      'Property Value': 'Not specified',
      'LTV Ratio': 'Not available',
    };
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_IN');
    if (amount >= 10000000) { // Crore
      return '${formatter.format(amount / 10000000)} Cr';
    } else if (amount >= 100000) { // Lakh
      return '${formatter.format(amount / 100000)} L';
    } else if (amount >= 1000) { // Thousand
      return '${formatter.format(amount / 1000)} K';
    }
    return formatter.format(amount);
  }

  Future<void> submitApplication() async {
    if (!isFormValid) {
      Get.snackbar(
        'Required',
        'Please accept all agreements to continue',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFFF44336),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(Icons.error_outline, color: Colors.white),
        shouldIconPulse: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Show elegant loading dialog
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(24),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: Color(0xFF1E2E3D),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated loading indicator
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation(
                            Color(0xFF00D4FF).withOpacity(0.3),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF00D4FF)),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00D4FF).withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.send_rounded,
                          color: Color(0xFF00D4FF),
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Title with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Color(0xFF00D4FF), Color(0xFF0077FF)],
                    ).createShader(bounds),
                    child: Text(
                      'Processing',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'Submitting your application\nPlease wait...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Progress dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00D4FF).withOpacity(
                            0.3 + (0.7 * (index / 3)),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.7),
      );

      // Simulate API call with progress animation
      await Future.delayed(Duration(seconds: 2));

      // Animate dialog close with success
      await Future.delayed(Duration(milliseconds: 300));
      Get.back();

      // Show success animation before navigation
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Color(0xFF1E2E3D),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF00D4FF).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success animation
                // Lottie.asset(
                //   'assets/animations/success.json',
                //   width: 100,
                //   height: 100,
                //   repeat: false,
                // ),

                SizedBox(height: 20),

                Text(
                  'Successfully Submitted!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Your application has been received',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Wait a moment then navigate
      await Future.delayed(Duration(seconds: 1));
      Get.back();
      Get.off(() => HomeLoanApplicationSuccessScreen());

    } catch (e) {
      Get.back(); // Close loading dialog if open

      // Show error dialog instead of snackbar
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFF1E2E3D),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF44336).withOpacity(0.1),
                    border: Border.all(
                      color: Color(0xFFF44336).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 40,
                    color: Color(0xFFF44336),
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  'Submission Failed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  'An error occurred while submitting your application. Please try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          submitApplication(); // Retry
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color(0xFF00D4FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}