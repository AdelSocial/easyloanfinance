import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../view/instance_loan/instant_loan_document_upload_screen.dart';

class InstantLoanAddressController extends GetxController {
  // Current Address
  var currentAddressLine1 = ''.obs;
  var currentAddressLine2 = ''.obs;
  var currentCity = ''.obs;
  var currentState = ''.obs;
  var currentPincode = ''.obs;
  var currentResidenceType = ''.obs;
  var currentStayDuration = ''.obs;

  // Permanent Address
  var isSameAsCurrent = true.obs;
  var permanentAddressLine1 = ''.obs;
  var permanentAddressLine2 = ''.obs;
  var permanentCity = ''.obs;
  var permanentState = ''.obs;
  var permanentPincode = ''.obs;

  var isLoading = false.obs;

  // Form Validation
  get isCurrentAddressValid =>
      currentAddressLine1.value.trim().isNotEmpty &&
          currentCity.value.trim().isNotEmpty &&
          currentState.value.trim().isNotEmpty &&
          currentPincode.value.trim().isNotEmpty &&
          currentResidenceType.value.isNotEmpty &&
          currentStayDuration.value.isNotEmpty;

  get isPermanentAddressValid =>
      isSameAsCurrent.value ||
          (permanentAddressLine1.value.trim().isNotEmpty &&
              permanentCity.value.trim().isNotEmpty &&
              permanentState.value.trim().isNotEmpty &&
              permanentPincode.value.trim().isNotEmpty);

  get isFormValid => isCurrentAddressValid && isPermanentAddressValid;

  // Get validation error message
  String? get validationError {
    if (currentAddressLine1.value.trim().isEmpty) return 'Please enter address line 1';
    if (currentCity.value.trim().isEmpty) return 'Please enter city';
    if (currentState.value.trim().isEmpty) return 'Please enter state';
    if (currentPincode.value.trim().isEmpty) return 'Please enter pincode';
    if (currentResidenceType.value.isEmpty) return 'Please select residence type';
    if (currentStayDuration.value.isEmpty) return 'Please select stay duration';
    if (!isSameAsCurrent.value) {
      if (permanentAddressLine1.value.trim().isEmpty) return 'Please enter permanent address line 1';
      if (permanentCity.value.trim().isEmpty) return 'Please enter permanent city';
      if (permanentState.value.trim().isEmpty) return 'Please enter permanent state';
      if (permanentPincode.value.trim().isEmpty) return 'Please enter permanent pincode';
    }
    return null;
  }

  void toggleSameAsCurrent() {
    isSameAsCurrent.value = !isSameAsCurrent.value;
    if (isSameAsCurrent.value) {
      _copyCurrentToPermanent();
    }
  }

  void _copyCurrentToPermanent() {
    permanentAddressLine1.value = currentAddressLine1.value;
    permanentAddressLine2.value = currentAddressLine2.value;
    permanentCity.value = currentCity.value;
    permanentState.value = currentState.value;
    permanentPincode.value = currentPincode.value;
  }

  // Combine address lines into single address string
  String _combineAddress(String line1, String line2) {
    if (line2.trim().isEmpty) {
      return line1.trim();
    }
    return '${line1.trim()}, ${line2.trim()}';
  }

  Future<void> submitAddressDetails() async {
    // Check validation
    final error = validationError;
    if (error != null) {
      Get.snackbar(
        'Validation Error',
        error,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (!isFormValid) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isLoading.value = true;

    try {
      // Get the loan ID from storage
      final loanId = await LoanStorageService.getCurrentLoanId('instant');
      
      if (loanId == null) {
        Get.snackbar(
          'Error',
          'Loan application not found. Please submit the application first.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        isLoading.value = false;
        return;
      }

      // Combine current address
      final currentAddress = _combineAddress(
        currentAddressLine1.value,
        currentAddressLine2.value,
      );

      // Prepare data for API (using current address as primary address)
      final Map<String, dynamic> requestData = {
        'address': currentAddress,
        'city': currentCity.value.trim(),
        'state': currentState.value.trim(),
        'pincode': currentPincode.value.trim(),
      };

      print('Updating instant loan address details with data: $requestData');

      // Call API to update instant loan with address details
      final response = await ApiService.updateInstantLoan(loanId, requestData);

      print('API Response: $response');

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Address details saved successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to next screen after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        Get.to(() => InstantLoanDocumentUploadScreen());
      } else {
        String errorMessage = ApiService.msg(response['message'], 'Failed to save address details');
        final errors = (response['errors'] is Map ? Map<String, dynamic>.from(response['errors'] as Map) : null);

        if (errors != null && errors.isNotEmpty) {
          // Format errors for better display
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
          duration: const Duration(seconds: 4),
          maxWidth: Get.width * 0.9,
        );
      }
    } catch (e) {
      print('Error submitting address details: $e');
      Get.snackbar(
        'Error',
        'Failed to save address details: ${e.toString()}',
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