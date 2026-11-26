import 'package:get/get.dart';

import '../routes/app_pages.dart';

class OldCarApplicationSubmittedController extends GetxController {
  var applicationNumber = 'OCL${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'.obs;
  var submissionTime = DateTime.now().obs;

  void trackApplication() {
    // Navigate to application tracking screen
    // Get.toNamed(Routes.oldCarApplicationTrackingScreen);
  }

  void applyForAnotherLoan() {
    Get.offAllNamed(Routes.carOptionScreen);
  }

  void goToHome() {
    Get.offAllNamed(Routes.homeScreen);
  }

  String get formattedTime {
    return '${submissionTime.value.day}/${submissionTime.value.month}/${submissionTime.value.year} at ${submissionTime.value.hour}:${submissionTime.value.minute.toString().padLeft(2, '0')}';
  }
}