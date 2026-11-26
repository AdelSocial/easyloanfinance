import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../routes/app_pages.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';

class InstantLoanApplicationController extends GetxController {
  // Personal Information
  var fullName = ''.obs;
  var dateOfBirth = ''.obs;
  var email = ''.obs;
  var mobileNumber = ''.obs;

  // Loan Details
  var loanAmount = ''.obs;
  var loanPurpose = ''.obs;
  var employmentType = ''.obs;

  // Nominee Information
  var nomineeName = ''.obs;
  var nomineeRelationship = ''.obs;
  var nomineeDateOfBirth = ''.obs;
  var nomineeMobileNumber = ''.obs;


  // Consent
  var consentCreditReport = false.obs;
  var consentTermsConditions = false.obs;

  // Form Validation
  get isFormValid =>
      fullName.isNotEmpty &&
          dateOfBirth.isNotEmpty &&
          email.isNotEmpty &&
          mobileNumber.isNotEmpty &&
          loanAmount.isNotEmpty &&
          loanPurpose.isNotEmpty &&
          employmentType.isNotEmpty &&
          consentCreditReport.value &&
          consentTermsConditions.value;


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
            ),
            dialogTheme: DialogThemeData(backgroundColor: Color(0xFF1E2E3D)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateOfBirth.value = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

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
      final response = await ApiService.submitInstantLoan({
        'full_name': fullName.value,
        'date_of_birth': _convertDateFormat(dateOfBirth.value),
        'email': email.value,
        'mobile': mobileNumber.value,
        'loan_amount': loanAmount.value.isNotEmpty ? double.tryParse(loanAmount.value) : null,
        'loan_purpose': loanPurpose.value.isEmpty ? null : loanPurpose.value,
        'employment_type': employmentType.value.isEmpty ? null : employmentType.value,
        // Nominee Information
        'nominee_name': nomineeName.value.isEmpty ? null : nomineeName.value,
        'nominee_relationship': nomineeRelationship.value.isEmpty ? null : nomineeRelationship.value,
        'nominee_date_of_birth': nomineeDateOfBirth.value.isNotEmpty 
            ? _convertDateFormat(nomineeDateOfBirth.value) 
            : null,
        'nominee_mobile': nomineeMobileNumber.value.isEmpty ? null : nomineeMobileNumber.value,
        // Consent
        'consent_credit_report': consentCreditReport.value,
        'consent_terms': consentTermsConditions.value,
      });

      if (response['success'] == true) {
        // Store loan ID for document upload
        await LoanStorageService.storeLoanFromResponse('instant', response);
        
        Get.snackbar(
          'Success',
          'Instant loan application submitted successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to next step (address details screen)
        Get.toNamed(Routes.instantLoanAddressDetailsScreen);
      } else {
        String errorMessage = ApiService.msg(response['message'], 'Failed to submit application');
        final errors = (response['errors'] is Map ? Map<String, dynamic>.from(response['errors'] as Map) : null);

        if (errors != null && errors.isNotEmpty) {
          final errorList = <String>[];
          errors.forEach((field, messages) {
            if (messages is List) {
              for (var msg in messages) {
                errorList.add('${field.replaceAll('_', ' ').toUpperCase()}: $msg');
              }
            } else {
              errorList.add('${field.replaceAll('_', ' ').toUpperCase()}: $messages');
            }
          });
          errorMessage = errorList.join('\n');
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          maxWidth: Get.width * 0.9,
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