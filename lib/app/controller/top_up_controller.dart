import 'package:get/get.dart';

class TopUpController extends GetxController {
  // Wallet balance
  RxDouble walletBalance = 85000.0.obs;

  // Entered amount
  RxString amount = "".obs;

  // Selected payment method
  RxString selectedMethod = "".obs;

  // Update amount from textfield
  void setAmount(String value) {
    amount.value = value;
  }

  // From quick chip
  void selectQuickAmount(String value) {
    amount.value = value.replaceAll("₹ ", "");
  }

  // Select payment option
  void selectMethod(String method) {
    selectedMethod.value = method;
  }

  // VALIDATION
  bool validate() {
    if (amount.value.isEmpty || double.tryParse(amount.value) == null) {
      Get.snackbar("Error", "Enter a valid amount");
      return false;
    }

    if (selectedMethod.isEmpty) {
      Get.snackbar("Error", "Please select a payment method");
      return false;
    }

    return true;
  }

  // ADD MONEY API CALL OR PROCESS
  void addMoney() {
    if (!validate()) return;

    Get.snackbar("Success",
        "₹${amount.value} added using ${selectedMethod.value}");

    amount.value = "";
    selectedMethod.value = "";
  }
}
