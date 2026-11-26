import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class InstantLoanSuccessController extends GetxController {
  var loanAmount = '₹50,000'.obs;
  var applicationId = 'IL202411280001'.obs;
  var estimatedDisbursal = 'Within 24 hours'.obs;

  void downloadApplicationPDF() {
    // Handle PDF download logic
    Get.snackbar(
      'Download Started',
      'Application PDF is being downloaded',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void trackApplicationStatus() {
    // Get.toNamed(Routes.instantLoanApplicationStatusScreen);
  }

  void goToDashboard() {
    // Navigate to main dashboard
    Get.offAllNamed(Routes.homeScreen);
  }

  void contactCustomerSupport() {
    // Open customer support
    Get.snackbar(
      'Customer Support',
      'Connecting you to customer support...',
      backgroundColor: Color(0xFF00D4FF),
      colorText: Colors.white,
    );
  }
}