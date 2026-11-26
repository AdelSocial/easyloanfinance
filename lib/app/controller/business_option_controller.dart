
import 'package:easy_loan_finance/app/view/business_loan/unsecured_loan/unsecured_business_screen.dart';
import 'package:get/get.dart';


import '../view/business_loan/secured_loan/secured_business_screen.dart';

class BusinessOptionController extends GetxController {
  var selectedBusinessType = BusinessType.none.obs;

  void selectBusinessType(BusinessType type) {
    selectedBusinessType.value = type;
  }

  void proceedToApplication() {
    if (selectedBusinessType.value == BusinessType.none) {
      Get.snackbar(
        'Selection Required',
        'Please select business loan type',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedBusinessType.value == BusinessType.unsecured) {
      Get.to(() => UnsecuredBusinessScreen());

      // Get.toNamed(Routes.unsecuredBusinessApplicationScreen);
    } else {
      Get.to(() => SecuredBusinessScreen());

      // Get.toNamed(Routes.securedBusinessApplicationScreen);
    }
  }
}

enum BusinessType {
  none,
  unsecured,
  secured,
}