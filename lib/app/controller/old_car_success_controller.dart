import 'package:get/get.dart';

import '../routes/app_pages.dart';

class OldCarSuccessController extends GetxController {
  var applicationNumber = 'OCL${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'.obs;
  var submissionTime = DateTime.now().obs;

  void trackApplication() {
    // Get.toNamed(Routes.oldCarApplicationTrackingScreen);
  }

  void applyForAnotherLoan() {
    Get.offAllNamed(Routes.carOptionScreen);
  }

  void goToHome() {
    Get.offAllNamed(Routes.homeScreen);
  }

  void contactSupport() {
    // Open phone dialer or email
    // You can implement phone call or email functionality here
  }

  String get formattedDate {
    return '${submissionTime.value.day}/${submissionTime.value.month}/${submissionTime.value.year}';
  }

  String get formattedTime {
    return '${submissionTime.value.hour}:${submissionTime.value.minute.toString().padLeft(2, '0')}';
  }
}