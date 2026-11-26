import 'package:get/get.dart';

class NewCarAddressController extends GetxController {
  // Residential Address
  var addressLine1 = ''.obs;
  var addressLine2 = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var pincode = ''.obs;
  var residenceType = ''.obs;

  // Office Address (optional)
  var officeAddressLine1 = ''.obs;
  var officeAddressLine2 = ''.obs;
  var officeCity = ''.obs;
  var officeState = ''.obs;
  var officePincode = ''.obs;

  // Duration
  var yearsAtCurrentAddress = ''.obs;
  var monthsAtCurrentAddress = ''.obs;

  // Same as residential
  var sameAsResidential = false.obs;

  bool get isFormValid =>
      addressLine1.value.isNotEmpty &&
          city.value.isNotEmpty &&
          state.value.isNotEmpty &&
          pincode.value.isNotEmpty &&
          residenceType.value.isNotEmpty &&
          yearsAtCurrentAddress.value.isNotEmpty;

  void toggleSameAsResidential() {
    sameAsResidential.value = !sameAsResidential.value;
    if (sameAsResidential.value) {
      officeAddressLine1.value = addressLine1.value;
      officeAddressLine2.value = addressLine2.value;
      officeCity.value = city.value;
      officeState.value = state.value;
      officePincode.value = pincode.value;
    } else {
      officeAddressLine1.value = '';
      officeAddressLine2.value = '';
      officeCity.value = '';
      officeState.value = '';
      officePincode.value = '';
    }
  }

  void submitAddress() {
    if (isFormValid) {
      // Handle address submission
      // Get.toNamed(Routes.newCarDocumentUploadScreen);
    }
  }
}