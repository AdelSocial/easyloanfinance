import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../routes/app_pages.dart';

class MobileVerificationController extends GetxController {
  var mobileNumber = ''.obs;
  var isLoading = false.obs;

  final mobileNumberController = TextEditingController();

  // Validate mobile number (10 digits for India)
  bool get isMobileNumberValid => mobileNumber.value.length == 10;

  // Send OTP method
  Future<void> sendOtp() async {
    if (!isMobileNumberValid) {
      Get.snackbar(
        'Error',
        'Please enter a valid 10-digit phone number',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Add country code (+91) to phone number
      final phoneWithCountryCode = '+91${mobileNumber.value}';
      
      final response = await ApiService.sendOtp(phoneWithCountryCode);

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'OTP sent successfully to +91${mobileNumber.value}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        
        // Show OTP in development (remove in production)
        if (response['data'] != null && response['data']['otp'] != null) {
          print('OTP (Development): ${response['data']['otp']}');
          Get.snackbar('OTP (Development):', '${response['data']['otp']}',backgroundColor: Colors.white);

        }
        
        // Navigate to OTP verification screen after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        Get.toNamed(Routes.registerThreeScreen, arguments: {
          'mobileNumber': phoneWithCountryCode,
        });
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to send OTP'),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error sending OTP: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to send OTP: ${e.toString()}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    mobileNumberController.dispose();
    super.onClose();
  }
}