import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class CibilController extends GetxController {
  var isLoading = false.obs;
  var cibilScore = 0.obs;
  var panNumber = ''.obs;
  var mobileNumber = ''.obs;

  Future<void> checkCibilScore() async {
    if (panNumber.value.isEmpty || panNumber.value.length != 10) {
      Get.snackbar('Error', 'Please enter a valid PAN number');
      return;
    }

    if (mobileNumber.value.isEmpty || mobileNumber.value.length != 10) {
      Get.snackbar('Error', 'Please enter a valid mobile number');
      return;
    }

    try {
      isLoading.value = true;

      final response = await ApiService.getCibilScore(
        pan: panNumber.value.toUpperCase(),
        mobile: mobileNumber.value,
      );

      if (response['success'] == true) {
        // Handle new response format with data object
        final data = response['data'];
        if (data != null && data['score'] != null) {
          cibilScore.value = (data['score'] as num).toInt();
        } else if (response['score'] != null) {
          // Fallback to old format
          cibilScore.value = (response['score'] as num).toInt();
        } else {
          cibilScore.value = 0;
        }

        Get.snackbar(
          'Success',
          'CIBIL score fetched successfully: ${cibilScore.value}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF63b5bb),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to fetch CIBIL score'),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch CIBIL score: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void subscribeToCibil() async {
    // This can be used for subscription/payment logic
    Get.snackbar(
      'Info',
      'CIBIL subscription feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF63b5bb),
      colorText: Colors.white,
    );
  }

  void showCibilDetails() {
    // Navigate to CIBIL details screen
    // Get.toNamed(Routes.cibilDetailsScreen);
  }
}