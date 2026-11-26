// controllers/personal_employment_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../routes/app_pages.dart';

class PersonalEmploymentController extends GetxController {
  // Employment fields
  var employmentType = ''.obs;
  var companyName = ''.obs;
  var monthlyIncome = ''.obs;
  var workExperience = ''.obs;
  var isLoading = false.obs;

  // Lists
  final List<String> employmentTypes = [
    'Salaried',
    'Self Employed'
  ];

  final List<String> incomeRanges = [
    'Below ₹25,000',
    '₹25,000 - ₹50,000',
    '₹50,000 - ₹1,00,000',
    '₹1,00,000 - ₹2,00,000',
    'Above ₹2,00,000'
  ];

  final List<String> experienceRanges = [
    'Less than 1 year',
    '1 - 3 years',
    '3 - 5 years',
    '5 - 10 years',
    'More than 10 years'
  ];

  // Validation
  bool get isFormValid {
    return employmentType.value.isNotEmpty &&
        companyName.value.trim().isNotEmpty &&
        monthlyIncome.value.isNotEmpty &&
        workExperience.value.isNotEmpty;
  }

  // Get validation error message
  String? get validationError {
    if (employmentType.value.isEmpty) return 'Please select employment type';
    if (companyName.value.trim().isEmpty) return 'Please enter company name';
    if (monthlyIncome.value.isEmpty) return 'Please select monthly income';
    if (workExperience.value.isEmpty) return 'Please select work experience';
    return null;
  }

  // Convert income range to numeric value (for backend)
  double? _convertIncomeToNumeric(String incomeRange) {
    // Extract numeric value from income range
    // Example: "₹25,000 - ₹50,000" -> 37500 (average)
    // Example: "Above ₹2,00,000" -> 250000
    try {
      if (incomeRange.contains('Below')) {
        return 20000.0; // Default for below range
      } else if (incomeRange.contains('Above')) {
        // Extract number from "Above ₹2,00,000"
        final match = RegExp(r'₹?([\d,]+)').firstMatch(incomeRange);
        if (match != null) {
          final value = double.tryParse(match.group(1)?.replaceAll(',', '') ?? '');
          if (value != null) {
            return value * 1.2; // 20% above the minimum
          }
        }
        return 250000.0; // Default fallback
      } else if (incomeRange.contains('-')) {
        // Extract numbers and calculate average
        final numbers = incomeRange.replaceAll('₹', '').replaceAll(',', '').split('-');
        if (numbers.length == 2) {
          final min = double.tryParse(numbers[0].trim());
          final max = double.tryParse(numbers[1].trim());
          if (min != null && max != null) {
            return (min + max) / 2;
          }
        }
      }
    } catch (e) {
      print('Error converting income: $e');
    }
    return null;
  }

  Future<void> submitEmploymentDetails() async {
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
      // Prepare data for API
      final Map<String, dynamic> requestData = {
        'employment_type': employmentType.value,
        'company_name': companyName.value.trim(),
      };

      // Convert income range to numeric
      final incomeNumeric = _convertIncomeToNumeric(monthlyIncome.value);
      if (incomeNumeric != null) {
        requestData['monthly_income'] = incomeNumeric;
      }

      // Note: workExperience is not in backend profile, but we can store it if needed
      // For now, we'll just save employment_type, company_name, and monthly_income

      print('Submitting employment details with data: $requestData');

      // Call API to update profile with employment details
      final response = await ApiService.updateProfile(requestData);

      print('API Response: $response');

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Employment details saved successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to next screen after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        Get.toNamed(Routes.personalDocumentUploadScreen);
      } else {
        String errorMessage = ApiService.msg(response['message'], 'Failed to save employment details');
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
      print('Error submitting employment details: $e');
      Get.snackbar(
        'Error',
        'Failed to save employment details: ${e.toString()}',
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