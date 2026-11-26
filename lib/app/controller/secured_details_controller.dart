// controllers/secured_details_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../view/business_loan/secured_loan/secured_document_screen.dart';

class SecuredDetailsController extends GetxController {
  // Address fields
  var currentAddress = ''.obs;
  var city = ''.obs;
  var selectedState = ''.obs;
  var selectedKYCMethod = ''.obs;
  var isLoading = false.obs;

  // Lists
  final List<String> states = [
    'Karnataka',
    'Maharashtra',
    'Delhi',
    'Tamil Nadu',
    'Uttar Pradesh',
    'Gujarat',
    'West Bengal',
    'Rajasthan'
  ];

  final List<String> kycMethods = [
    'Aadhaar OTP eKYC',
    'CKYC',
    'DigiLocker',
    'Video KYC'
  ];

  // Validation
  bool get isFormValid {
    return currentAddress.value.trim().isNotEmpty &&
        city.value.trim().isNotEmpty &&
        selectedState.value.isNotEmpty &&
        selectedKYCMethod.value.isNotEmpty;
  }

  // Get validation error message
  String? get validationError {
    if (currentAddress.value.trim().isEmpty) return 'Please enter your current address';
    if (city.value.trim().isEmpty) return 'Please enter your city';
    if (selectedState.value.isEmpty) return 'Please select your state';
    if (selectedKYCMethod.value.isEmpty) return 'Please select a KYC method';
    return null;
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
      final loanId = await LoanStorageService.getCurrentLoanId('business');
      
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

      // Prepare data for API
      final Map<String, dynamic> requestData = {
        'address': currentAddress.value.trim(),
        'city': city.value.trim(),
        'state': selectedState.value,
      };

      print('Updating business loan address details with data: $requestData');

      // Call API to update business loan with address details
      final response = await ApiService.updateBusinessLoan(loanId, requestData);

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
        Get.to(() => SecuredDocumentScreen());
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