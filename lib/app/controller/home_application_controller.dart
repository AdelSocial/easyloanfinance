
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../routes/app_pages.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';

class HomeApplicationController extends GetxController {
  // Personal Information
  var fullName = ''.obs;
  var dateOfBirth = ''.obs;
  var email = ''.obs;
  var mobileNumber = ''.obs;
  var employmentType = ''.obs;

  // Property Details
  var propertyType = ''.obs;
  var propertyLocation = ''.obs;
  var propertyValue = ''.obs;
  var city = ''.obs;

  // Loan Requirements
  var loanAmount = ''.obs;
  var tenure = ''.obs;
  var annualIncome = ''.obs;
  var incomeProof = ''.obs;

  // Nominee Information
  var nomineeName = ''.obs;
  var nomineeRelationship = ''.obs;
  var nomineeDateOfBirth = ''.obs;
  var nomineeMobileNumber = ''.obs;

  // Consent
  var consentCreditReport = false.obs;
  var consentAadhaarKYC = false.obs;
  var consentPropertyVerification = false.obs;

  // Validation helpers
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidMobile(String mobile) {
    // Remove all non-digit characters and check if it's exactly 10 digits
    final digitsOnly = mobile.replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length == 10;
  }

  // Form validation
  bool get isFormValid {
    return fullName.value.trim().isNotEmpty &&
        dateOfBirth.value.isNotEmpty &&
        email.value.trim().isNotEmpty &&
        _isValidEmail(email.value.trim()) &&
        mobileNumber.value.trim().isNotEmpty &&
        _isValidMobile(mobileNumber.value.trim()) &&
        employmentType.value.isNotEmpty &&
        propertyType.value.isNotEmpty &&
        propertyLocation.value.trim().isNotEmpty &&
        propertyValue.value.trim().isNotEmpty &&
        city.value.isNotEmpty &&
        loanAmount.value.trim().isNotEmpty &&
        tenure.value.trim().isNotEmpty &&
        annualIncome.value.trim().isNotEmpty &&
        incomeProof.value.isNotEmpty &&
        nomineeName.value.trim().isNotEmpty &&
        nomineeRelationship.value.isNotEmpty &&
        nomineeDateOfBirth.value.isNotEmpty &&
        nomineeMobileNumber.value.trim().isNotEmpty &&
        _isValidMobile(nomineeMobileNumber.value.trim()) &&
        consentCreditReport.value &&
        consentAadhaarKYC.value &&
        consentPropertyVerification.value;
  }

  void selectDateOfBirth() async {
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
            ),
            dialogTheme: DialogThemeData(backgroundColor: Color(0xFF0C192E)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateOfBirth.value = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  void selectNomineeDateOfBirth() async {
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
            ), dialogTheme: DialogThemeData(backgroundColor: Color(0xFF0C192E)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      nomineeDateOfBirth.value = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  var isLoading = false.obs;

  Future<void> submitApplication() async {
    if (!isFormValid) {
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
      final response = await ApiService.submitHomeLoan({
        'full_name': fullName.value,
        'date_of_birth': dateOfBirth.value,
        'email': email.value,
        'mobile': mobileNumber.value,
        'employment_type': employmentType.value,
        'property_type': propertyType.value,
        'property_location': propertyLocation.value,
        'property_value': propertyValue.value.isNotEmpty ? double.tryParse(propertyValue.value) : null,
        'city': city.value,
        'loan_amount': loanAmount.value.isNotEmpty ? double.tryParse(loanAmount.value) : null,
        'tenure': tenure.value.isNotEmpty ? int.tryParse(tenure.value) : null,
        'annual_income': annualIncome.value.isNotEmpty ? double.tryParse(annualIncome.value) : null,
        'income_proof': incomeProof.value,
        'nominee_name': nomineeName.value,
        'nominee_relationship': nomineeRelationship.value,
        'nominee_date_of_birth': nomineeDateOfBirth.value,
        'nominee_mobile': nomineeMobileNumber.value,
        'consent_credit_report': consentCreditReport.value,
        'consent_aadhaar_kyc': consentAadhaarKYC.value,
        'consent_property_verification': consentPropertyVerification.value,
      });

      if (response['success'] == true) {
        // Store loan ID for document upload
        await LoanStorageService.storeLoanFromResponse('home', response);
        
        Get.snackbar(
          'Success',
          'Home loan application submitted successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to next screen after successful submission
        Get.toNamed(Routes.homeLoanDetailsScreen);
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