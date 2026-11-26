import 'dart:async';
import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class RegisterThreeController extends GetxController {
  // OTP Fields controllers
  final otpControllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  final resendTimer = 25.obs;
  var isLoading = false.obs;
  Timer? _timer;

  var phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get phone number from arguments
    if (Get.arguments != null && Get.arguments['mobileNumber'] != null) {
      phoneNumber.value = Get.arguments['mobileNumber'];
    }
    startTimer();
  }

  // Start 25 second timer
  void startTimer() {
    resendTimer.value = 25;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value == 0) {
        timer.cancel();
      } else {
        resendTimer.value--;
      }
    });
  }

  // Get OTP from controllers
  String getOtp() {
    return otpControllers.map((controller) => controller.text).join();
  }

  // Verify OTP and Register
  Future<void> verifyOtp() async {
    final otp = getOtp();
    if (otp.length != 6) {
      Get.snackbar('Error', 'Please enter complete OTP');
      return;
    }

    if (phoneNumber.value.isEmpty) {
      Get.snackbar('Error', 'Phone number not found');
      return;
    }

    isLoading.value = true;

    try {
      // Verify OTP
      print('Verifying OTP for phone: ${phoneNumber.value}, OTP: $otp');
      final otpResponse = await ApiService.verifyOtp(
        phone: phoneNumber.value,
        otp: otp,
      );

      print('OTP Response: $otpResponse');

      if (otpResponse['success'] == true) {
        // OTP verified successfully, navigate directly to home screen
        Get.snackbar(
          'Success',
          'OTP verified successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.homeScreen);
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(otpResponse['message'], 'Invalid OTP'),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error, Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    if (resendTimer.value == 0) {
      try {
        final response = await ApiService.sendOtp(phoneNumber.value);
        if (response['success'] == true) {
          startTimer();
          Get.snackbar(
            "OTP Sent",
            "A new OTP has been sent to your number.",
            backgroundColor: Colors.green.withOpacity(0.6),
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to resend OTP');
      }
    }
  }

  @override
  void onClose() {
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.onClose();
  }
}
