import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../view/business_loan/unsecured_loan/unsecured_details_screen.dart';


class UnsecuredBusinessController extends GetxController {
  // Applicant Information
  var fullName = ''.obs;
  var dateOfBirth = ''.obs;
  var email = ''.obs;
  var mobileNumber = ''.obs;
  var panNumber = ''.obs;

  // Business Information
  var businessType = ''.obs;
  var businessName = ''.obs;
  var gstNumber = ''.obs;
  var registrationNumber = ''.obs;
  var industryType = ''.obs;
  var businessAge = ''.obs;
  var annualTurnover = ''.obs;
  var monthlyRevenue = ''.obs;

  // Loan Requirements
  var loanAmount = ''.obs;
  var loanTenure = ''.obs;
  var loanPurpose = ''.obs;

  // Nominee Information
  var nomineeName = ''.obs;
  var nomineeRelationship = ''.obs;
  var nomineeDateOfBirth = ''.obs;
  var nomineeMobileNumber = ''.obs;

  // Consent & Authorization
  var consentCreditReport = false.obs;
  var consentAadhaarKYC = false.obs;
  var consentBusinessVerification = false.obs;
  var consentTerms = false.obs;

  // Loading state
  var isLoading = false.obs;

  // Form Validation
  RxBool get isFormValid {
    return (
        fullName.value.isNotEmpty &&
            dateOfBirth.value.isNotEmpty &&
            email.value.isNotEmpty &&
            mobileNumber.value.isNotEmpty &&
            panNumber.value.isNotEmpty &&
            businessType.value.isNotEmpty &&
            businessName.value.isNotEmpty &&
            industryType.value.isNotEmpty &&
            businessAge.value.isNotEmpty &&
            annualTurnover.value.isNotEmpty &&
            monthlyRevenue.value.isNotEmpty &&
            loanAmount.value.isNotEmpty &&
            loanTenure.value.isNotEmpty &&
            loanPurpose.value.isNotEmpty &&
            nomineeName.value.isNotEmpty &&
            nomineeRelationship.value.isNotEmpty &&
            consentCreditReport.value &&
            consentAadhaarKYC.value &&
            consentBusinessVerification.value &&
            consentTerms.value
    ).obs;
  }

  // Convert date from DD-MM-YYYY to YYYY-MM-DD format
  String? _convertDateFormat(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      // Parse DD-MM-YYYY format
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-$day';
      }
      return dateStr; // Return as is if format is different
    } catch (e) {
      return dateStr;
    }
  }

  // Date Picker for Applicant
  Future<void> selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF00D4FF),
              onPrimary: Color(0xFF0C192E),
              surface: Color(0xFF1E2E3D),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: Color(0xFF1E2E3D)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateOfBirth.value = '${picked.day.toString().padLeft(2, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.year}';
    }
  }


  // Date Picker for Nominee
  Future<void> selectNomineeDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      nomineeDateOfBirth.value = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  // Business Age Options
  final List<String> businessAgeOptions = [
    'Less than 1 year',
    '1-3 years',
    '3-5 years',
    '5-10 years',
    'More than 10 years'
  ];

  // Annual Turnover Options
  final List<String> turnoverOptions = [
    'Below ₹10 Lakhs',
    '₹10 Lakhs - ₹25 Lakhs',
    '₹25 Lakhs - ₹50 Lakhs',
    '₹50 Lakhs - ₹1 Crore',
    '₹1 Crore - ₹5 Crores',
    'Above ₹5 Crores'
  ];

  // Monthly Revenue Options
  final List<String> revenueOptions = [
    'Below ₹50,000',
    '₹50,000 - ₹1 Lakh',
    '₹1 Lakh - ₹2 Lakhs',
    '₹2 Lakhs - ₹5 Lakhs',
    'Above ₹5 Lakhs'
  ];

  // Convert business age string to integer (years)
  int? _convertBusinessAgeToYears(String? businessAgeStr) {
    if (businessAgeStr == null || businessAgeStr.isEmpty) return null;
    
    // Map business age options to approximate years
    if (businessAgeStr.contains('Less than 1')) return 0;
    if (businessAgeStr.contains('1-3')) return 2; // Average of 1-3
    if (businessAgeStr.contains('3-5')) return 4; // Average of 3-5
    if (businessAgeStr.contains('5-10')) return 7; // Average of 5-10
    if (businessAgeStr.contains('More than 10')) return 12; // Approximate
    
    return null;
  }

  // Convert turnover/revenue string to decimal
  double? _convertAmountString(String? amountStr) {
    if (amountStr == null || amountStr.isEmpty) return null;
    
    final lowerStr = amountStr.toLowerCase();
    
    // Handle specific cases for monthly revenue
    if (lowerStr.contains('below ₹50,000') || lowerStr.contains('below ₹50000')) {
      return 40000.0; // Below 50k, use 40k as representative value
    }
    if (lowerStr.contains('₹50,000 - ₹1 lakh') || lowerStr.contains('₹50000 - ₹1 lakh')) {
      return 75000.0; // Average of 50k-1L
    }
    if (lowerStr.contains('₹1 lakh - ₹2 lakhs')) {
      return 150000.0; // Average of 1L-2L
    }
    if (lowerStr.contains('₹2 lakhs - ₹5 lakhs')) {
      return 350000.0; // Average of 2L-5L
    }
    if (lowerStr.contains('above ₹5 lakhs')) {
      return 750000.0; // Above 5L, use 7.5L as representative value (within DB limit)
    }
    
    // Handle annual turnover cases
    if (lowerStr.contains('below ₹10 lakhs')) {
      return 500000.0; // Below 10L, use 5L
    }
    if (lowerStr.contains('₹10 lakhs - ₹25 lakhs')) {
      return 1750000.0; // Average of 10L-25L
    }
    if (lowerStr.contains('₹25 lakhs - ₹50 lakhs')) {
      return 3750000.0; // Average of 25L-50L
    }
    if (lowerStr.contains('₹50 lakhs - ₹1 crore')) {
      return 7500000.0; // Average of 50L-1Cr
    }
    if (lowerStr.contains('₹1 crore - ₹5 crores')) {
      return 30000000.0; // Average of 1Cr-5Cr
    }
    if (lowerStr.contains('above ₹5 crores')) {
      return 75000000.0; // Above 5Cr, use 7.5Cr (within DB limit of 99,999,999.99)
    }
    
    // Fallback: Try to extract and convert numeric value
    final match = RegExp(r'₹?\s*([\d,]+)').firstMatch(amountStr);
    if (match != null) {
      final numStr = match.group(1)!.replaceAll(',', '');
      final value = double.tryParse(numStr);
      
      if (value == null) return null;
      
      // Convert to actual value (lakhs = * 100000, crores = * 10000000)
      if (lowerStr.contains('lakh')) {
        final converted = value * 100000;
        // Ensure it doesn't exceed database limit (99,999,999.99)
        return converted > 99999999.99 ? 99999999.99 : converted;
      } else if (lowerStr.contains('crore')) {
        final converted = value * 10000000;
        // Ensure it doesn't exceed database limit (99,999,999.99)
        return converted > 99999999.99 ? 99999999.99 : converted;
      }
      
      // For plain numbers, ensure they don't exceed limit
      return value > 99999999.99 ? 99999999.99 : value;
    }
    return null;
  }

  Future<void> submitApplication() async {
    if (!isFormValid.value) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Extract numeric value from loan tenure (e.g., "24 Months" -> 24)
      int? tenureMonths;
      if (loanTenure.value.isNotEmpty) {
        final match = RegExp(r'(\d+)').firstMatch(loanTenure.value);
        if (match != null) {
          tenureMonths = int.tryParse(match.group(1)!);
        }
      }

      final response = await ApiService.submitBusinessLoan({
        'full_name': fullName.value,
        'date_of_birth': _convertDateFormat(dateOfBirth.value),
        'email': email.value,
        'mobile': mobileNumber.value,
        'pan_number': panNumber.value.isEmpty ? null : panNumber.value,
        'business_type': businessType.value,
        'business_name': businessName.value,
        'gst_number': gstNumber.value.isEmpty ? null : gstNumber.value,
        'registration_number': registrationNumber.value.isEmpty ? null : registrationNumber.value,
        'industry_type': industryType.value,
        'years_in_business': _convertBusinessAgeToYears(businessAge.value),
        'annual_turnover': _convertAmountString(annualTurnover.value),
        'monthly_income': _convertAmountString(monthlyRevenue.value), // Map monthly_revenue to monthly_income
        'loan_amount': loanAmount.value.isNotEmpty ? double.tryParse(loanAmount.value) : null,
        'loan_tenure': tenureMonths,
        'loan_purpose': loanPurpose.value,
        'loan_type': 'unsecured',
        // Nominee Information
        'nominee_name': nomineeName.value.isEmpty ? null : nomineeName.value,
        'nominee_relationship': nomineeRelationship.value.isEmpty ? null : nomineeRelationship.value,
        'nominee_date_of_birth': nomineeDateOfBirth.value.isNotEmpty 
            ? _convertDateFormat(nomineeDateOfBirth.value) 
            : null,
        'nominee_mobile': nomineeMobileNumber.value.isNotEmpty ? nomineeMobileNumber.value : null,
        // Consent & Authorization
        'consent_credit_report': consentCreditReport.value,
        'consent_aadhaar_kyc': consentAadhaarKYC.value,
        'consent_business_verification': consentBusinessVerification.value,
        'consent_terms': consentTerms.value,
      });

      if (response['success'] == true) {
        // Store loan ID for document upload
        await LoanStorageService.storeLoanFromResponse('business', response);
        
        Get.snackbar(
          'Success',
          'Application submitted successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to address details screen
        Get.to(() => UnsecuredDetailsScreen());
      } else {
        print(ApiService.msg(response['message'], 'Failed to submit application'));
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to submit application'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit application: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}