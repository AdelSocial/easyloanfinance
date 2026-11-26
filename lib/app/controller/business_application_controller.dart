import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../view/business_loan/business_address_details_screen.dart';

class BusinessApplicationController extends GetxController {
  // Personal Information
  final RxString fullName = ''.obs;
  final RxString dateOfBirth = ''.obs;
  final RxString email = ''.obs;
  final RxString mobileNumber = ''.obs;
  final RxString panNumber = ''.obs;

  // Nominee Information
  var nomineeName = ''.obs;
  var nomineeRelationship = ''.obs;
  var nomineeDateOfBirth = ''.obs;
  var nomineeMobileNumber = ''.obs;

  // Business Information
  final RxString businessType = ''.obs;
  final RxString businessName = ''.obs;
  final RxString gstNumber = ''.obs;
  final RxString registrationNumber = ''.obs;
  final RxString industryType = ''.obs;

  // Loan Details
  final RxString loanAmount = ''.obs;
  final RxString loanTenure = ''.obs;
  final RxString loanPurpose = ''.obs;

  // Consent
  final RxBool consentCreditReport = false.obs;
  final RxBool consentAadhaarKYC = false.obs;
  final RxBool consentBusinessVerification = false.obs;
  final RxBool consentTerms = false.obs;

  bool get isFormValid {
    return fullName.isNotEmpty &&
        dateOfBirth.isNotEmpty &&
        email.isNotEmpty &&
        mobileNumber.isNotEmpty &&
        panNumber.isNotEmpty &&
        businessType.isNotEmpty &&
        businessName.isNotEmpty &&
        gstNumber.isNotEmpty &&
        registrationNumber.isNotEmpty &&
        industryType.isNotEmpty &&
        loanAmount.isNotEmpty &&
        loanTenure.isNotEmpty &&
        loanPurpose.isNotEmpty &&
        consentCreditReport.value &&
        consentAadhaarKYC.value &&
        consentBusinessVerification.value &&
        consentTerms.value;
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
      dateOfBirth.value = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  var isLoading = false.obs;

  Future<void> submitApplication() async {
    if (!isFormValid) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService.submitBusinessLoan({
        'full_name': fullName.value,
        'date_of_birth': dateOfBirth.value,
        'email': email.value,
        'mobile': mobileNumber.value,
        'pan_number': panNumber.value,
        'business_type': businessType.value,
        'business_name': businessName.value,
        'gst_number': gstNumber.value,
        'registration_number': registrationNumber.value,
        'industry_type': industryType.value,
        'loan_amount': loanAmount.value.isNotEmpty ? double.tryParse(loanAmount.value) : null,
        'loan_tenure': loanTenure.value.isNotEmpty ? int.tryParse(loanTenure.value) : null,
        'loan_purpose': loanPurpose.value,
        'loan_type': 'unsecured', // Default, can be changed
        'consent_credit_report': consentCreditReport.value,
        'consent_aadhaar_kyc': consentAadhaarKYC.value,
        'consent_business_verification': consentBusinessVerification.value,
        'consent_terms': consentTerms.value,
      });

      if (response['success'] == true) {
        // Store loan ID for document upload
        await LoanStorageService.storeLoanFromResponse('business', response);
        
        Get.to(() => BusinessAddressDetailsScreen());
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to submit application'),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit application: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}