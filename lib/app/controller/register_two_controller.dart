import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class RegisterTwoController extends GetxController {
  // TextEditingControllers
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();

  // Observable states
  var isLoading = false.obs;

  // Next button function - Validates and saves address to API
  Future<void> goToNextStep() async {
    // Validate form
    if (addressController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your full address',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (cityController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your city',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (stateController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your state',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (postalCodeController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your postal code',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Save address to profile
    await saveAddress();
  }

  // Save address to profile via API
  Future<void> saveAddress() async {
    isLoading.value = true;

    try {
      final response = await ApiService.updateProfile({
        'address': addressController.text,
        'city': cityController.text,
        'state': stateController.text,
        'postal_code': postalCodeController.text,
      });

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Address saved successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        // Navigate to next screen after successful save
        Get.toNamed(Routes.mobileVerificationScreen);
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to save address'),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error saving address: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to save address: ${e.toString()}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Dispose controllers
  @override
  void onClose() {
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    super.onClose();
  }
}
