import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../routes/app_pages.dart';

class NewCarApplicationController extends GetxController {
  // Personal Information
  var fullName = ''.obs;
  var dateOfBirth = ''.obs;
  var email = ''.obs;
  var mobileNumber = ''.obs;

  // Car Information
  var carModel = ''.obs;
  var carBrand = ''.obs;
  var carVariant = ''.obs;
  var exShowroomPrice = ''.obs;
  var loanAmount = ''.obs;

  // Employment Information
  var employmentType = ''.obs;
  var monthlyIncome = ''.obs;
  var companyName = ''.obs;

  // Nominee Information
  var nomineeName = ''.obs;
  var nomineeRelationship = ''.obs;
  var nomineeDateOfBirth = ''.obs;
  var nomineeMobileNumber = ''.obs;

  // Consent
  var consentCreditReport = false.obs;
  var consentAadhaarKYC = false.obs;
  var consentCarDetails = false.obs;

  bool get isFormValid =>
      fullName.value.isNotEmpty &&
          dateOfBirth.value.isNotEmpty &&
          email.value.isNotEmpty &&
          mobileNumber.value.isNotEmpty &&
          carModel.value.isNotEmpty &&
          carBrand.value.isNotEmpty &&
          exShowroomPrice.value.isNotEmpty &&
          employmentType.value.isNotEmpty &&
          monthlyIncome.value.isNotEmpty &&
          nomineeName.value.isNotEmpty &&
          nomineeRelationship.value.isNotEmpty &&
          nomineeDateOfBirth.value.isNotEmpty &&
          consentCreditReport.value &&
          consentAadhaarKYC.value &&
          consentCarDetails.value;

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
            ), dialogTheme: DialogThemeData(backgroundColor: Color(0xFF0C192E)),
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
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService.submitNewCarLoan({
        'full_name': fullName.value,
        'date_of_birth': dateOfBirth.value,
        'email': email.value,
        'mobile': mobileNumber.value,
        'employment_type': employmentType.value,
        'car_make': carBrand.value,
        'car_model': carModel.value,
        'car_variant': carVariant.value,
        'car_price': exShowroomPrice.value.isNotEmpty ? double.tryParse(exShowroomPrice.value) : null,
        'loan_amount': loanAmount.value.isNotEmpty ? double.tryParse(loanAmount.value) : null,
        'annual_income': monthlyIncome.value.isNotEmpty ? (double.tryParse(monthlyIncome.value) ?? 0) * 12 : null,
        'consent_credit_report': consentCreditReport.value,
        'consent_aadhaar_kyc': consentAadhaarKYC.value,
      });

      if (response['success'] == true) {
        // Store loan ID for document upload
        await LoanStorageService.storeLoanFromResponse('car', response);
        
        Get.snackbar(
          'Success',
          'New car loan application submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(Routes.newCarAddressDetailsScreen);
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