
import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class RegistrationController extends GetxController {
  // Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final referralCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable states
  var agreeToTerms = false.obs;
  var showPassword = false.obs;
  var showConfirmPassword = false.obs;
  var isLoading = false.obs;

  // ✅ Next Button Logic - Validates and registers user
  Future<void> goToNextScreen() async {
    if (!agreeToTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please agree to the terms and conditions.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Validate form
    if (fullNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name',backgroundColor: Colors.white);
      return;
    }
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email',backgroundColor: Colors.white);
      return;
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters',backgroundColor: Colors.white);
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match',backgroundColor: Colors.white);
      return;
    }

    // Register user first
    await register();
  }

  // Register user
  Future<void> register() async {
    isLoading.value = true;

    try {
      final response = await ApiService.register(
        name: fullNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        referralCode: referralCodeController.text.isEmpty ? null : referralCodeController.text,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Registration successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.toNamed(Routes.registerTwoScreen);
        // // Show CIBIL check popup after successful registration
        // _showCibilCheckDialog();
      } else {
        Get.snackbar('Error', ApiService.msg(response['message'], 'Registration failed'),backgroundColor: Colors.white);
        print('Error: ${ApiService.msg(response['message'], 'Registration failed')}');

      }
    } catch (e) {
      print('Error, Registration failed: ${e.toString()}');
      Get.snackbar('Error', 'Registration failed: ${e.toString()}',backgroundColor: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Show CIBIL check dialog after registration
  // void _showCibilCheckDialog() {
  //   Get.dialog(
  //     CibilCheckDialog(
  //       phoneNumber: phoneController.text,
  //       onComplete: (checked) {
  //         // Navigate to next screen after CIBIL check (or skip)
  //         Get.toNamed(Routes.registerTwoScreen);
  //       },
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    referralCodeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
