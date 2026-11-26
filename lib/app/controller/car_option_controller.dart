import 'package:get/get.dart';

import '../routes/app_pages.dart';

class CarOptionController extends GetxController {
  var selectedCarType = CarType.none.obs;

  void selectCarType(CarType type) {
    selectedCarType.value = type;
  }

  void proceedToApplication() {
    if (selectedCarType.value == CarType.none) {
      Get.snackbar(
        'Selection Required',
        'Please select car type',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedCarType.value == CarType.newCar) {
      Get.toNamed(Routes.newCarApplicationScreen);
    } else {
      Get.toNamed(Routes.oldCarApplicationScreen);
    }
  }
}

enum CarType {
  none,
  newCar,
  oldCar,
}