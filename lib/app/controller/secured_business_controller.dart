import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../view/business_loan/secured_loan/secured_details_screen.dart';


class SecuredBusinessController extends GetxController {
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

  // Loan Requirements
  var loanAmount = ''.obs;
  var loanTenure = ''.obs;
  var loanPurpose = ''.obs;

  // Nominee Information
  var nomineeName = ''.obs;
  var nomineeRelationship = ''.obs;
  var nomineeDateOfBirth = ''.obs;
  var nomineeMobileNumber = ''.obs;

  // Collateral Information
  var collateralType = ''.obs;
  var collateralValue = ''.obs;
  var collateralDescription = ''.obs;
  var propertyOwnership = ''.obs;
  var propertyAddress = ''.obs;

  // Consent & Authorization
  var consentCreditReport = false.obs;
  var consentAadhaarKYC = false.obs;
  var consentBusinessVerification = false.obs;
  var consentTerms = false.obs;
  var consentCollateralVerification = false.obs;
  var consentPropertyValuation = false.obs;

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
            loanAmount.value.isNotEmpty &&
            loanTenure.value.isNotEmpty &&
            loanPurpose.value.isNotEmpty &&
            nomineeName.value.isNotEmpty &&
            nomineeRelationship.value.isNotEmpty &&
            collateralType.value.isNotEmpty &&
            collateralValue.value.isNotEmpty &&
            propertyOwnership.value.isNotEmpty &&
            propertyAddress.value.isNotEmpty &&
            consentCreditReport.value &&
            consentAadhaarKYC.value &&
            consentBusinessVerification.value &&
            consentCollateralVerification.value &&
            consentPropertyValuation.value &&
            consentTerms.value
    ).obs;
  }

  // Date Pickers
  Future<void> selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateOfBirth.value = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

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

  // Collateral Types
  final List<String> collateralTypes = [
    'Residential Property',
    'Commercial Property',
    'Land',
    'Fixed Deposit',
    'Insurance Policy',
    'Machinery & Equipment',
    'Stocks & Bonds',
    'Other'
  ];

  // Property Ownership Types
  final List<String> ownershipTypes = [
    'Self Owned',
    'Joint Ownership',
    'Family Owned',
    'Leased Property'
  ];

  // Convert date from DD-MM-YYYY to YYYY-MM-DD format
  String? _convertDateFormat(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-$day';
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }

  // Convert business age string to integer (years)
  int? _convertBusinessAgeToYears(String? businessAgeStr) {
    if (businessAgeStr == null || businessAgeStr.isEmpty) return null;
    
    if (businessAgeStr.contains('Less than 1')) return 0;
    if (businessAgeStr.contains('1-3')) return 2;
    if (businessAgeStr.contains('3-5')) return 4;
    if (businessAgeStr.contains('5-10')) return 7;
    if (businessAgeStr.contains('More than 10')) return 12;
    
    return null;
  }

  // Convert turnover string to decimal
  double? _convertAmountString(String? amountStr) {
    if (amountStr == null || amountStr.isEmpty) return null;
    
    final lowerStr = amountStr.toLowerCase();
    
    if (lowerStr.contains('below ₹10 lakhs')) {
      return 500000.0;
    }
    if (lowerStr.contains('₹10 lakhs - ₹25 lakhs')) {
      return 1750000.0;
    }
    if (lowerStr.contains('₹25 lakhs - ₹50 lakhs')) {
      return 3750000.0;
    }
    if (lowerStr.contains('₹50 lakhs - ₹1 crore')) {
      return 7500000.0;
    }
    if (lowerStr.contains('₹1 crore - ₹5 crores')) {
      return 30000000.0;
    }
    if (lowerStr.contains('above ₹5 crores')) {
      return 75000000.0;
    }
    
    final match = RegExp(r'₹?\s*([\d,]+)').firstMatch(amountStr);
    if (match != null) {
      final numStr = match.group(1)!.replaceAll(',', '');
      final value = double.tryParse(numStr);
      
      if (lowerStr.contains('lakh')) {
        final converted = value != null ? value * 100000 : null;
        return converted != null && converted > 99999999.99 ? 99999999.99 : converted;
      } else if (lowerStr.contains('crore')) {
        final converted = value != null ? value * 10000000 : null;
        return converted != null && converted > 99999999.99 ? 99999999.99 : converted;
      }
      return value != null && value > 99999999.99 ? 99999999.99 : value;
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
        'loan_amount': loanAmount.value.isNotEmpty ? double.tryParse(loanAmount.value) : null,
        'loan_tenure': tenureMonths,
        'loan_purpose': loanPurpose.value,
        'loan_type': 'secured',
        // Nominee Information
        'nominee_name': nomineeName.value.isEmpty ? null : nomineeName.value,
        'nominee_relationship': nomineeRelationship.value.isEmpty ? null : nomineeRelationship.value,
        'nominee_date_of_birth': nomineeDateOfBirth.value.isNotEmpty 
            ? _convertDateFormat(nomineeDateOfBirth.value) 
            : null,
        'nominee_mobile': nomineeMobileNumber.value.isNotEmpty ? nomineeMobileNumber.value : null,
        // Collateral Information (Note: These fields may need to be added to database)
        // For now, we'll send them but they may not be saved if not in fillable
        'collateral_type': collateralType.value.isEmpty ? null : collateralType.value,
        'collateral_value': collateralValue.value.isNotEmpty ? double.tryParse(collateralValue.value) : null,
        'collateral_description': collateralDescription.value.isEmpty ? null : collateralDescription.value,
        'property_ownership': propertyOwnership.value.isEmpty ? null : propertyOwnership.value,
        'property_address': propertyAddress.value.isEmpty ? null : propertyAddress.value,
        // Consent & Authorization
        'consent_credit_report': consentCreditReport.value,
        'consent_aadhaar_kyc': consentAadhaarKYC.value,
        'consent_business_verification': consentBusinessVerification.value,
        'consent_collateral_verification': consentCollateralVerification.value,
        'consent_property_valuation': consentPropertyValuation.value,
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
        Get.to(() => SecuredDetailsScreen());
      } else {
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

  // Reset Form
  void resetForm() {
    fullName.value = '';
    dateOfBirth.value = '';
    email.value = '';
    mobileNumber.value = '';
    panNumber.value = '';
    businessType.value = '';
    businessName.value = '';
    gstNumber.value = '';
    registrationNumber.value = '';
    industryType.value = '';
    businessAge.value = '';
    annualTurnover.value = '';
    loanAmount.value = '';
    loanTenure.value = '';
    loanPurpose.value = '';
    nomineeName.value = '';
    nomineeRelationship.value = '';
    nomineeDateOfBirth.value = '';
    nomineeMobileNumber.value = '';
    collateralType.value = '';
    collateralValue.value = '';
    collateralDescription.value = '';
    propertyOwnership.value = '';
    propertyAddress.value = '';
    consentCreditReport.value = false;
    consentAadhaarKYC.value = false;
    consentBusinessVerification.value = false;
    consentTerms.value = false;
    consentCollateralVerification.value = false;
    consentPropertyValuation.value = false;
  }
}