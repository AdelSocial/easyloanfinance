
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayController extends GetxController {
  // Text Controller
  TextEditingController upiController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // Selected UPI App
  var selectedApp = "".obs;

  // Wallet Balance
  var walletBalance = 12500.obs;

  // Recent Payments List
  var recentPayments = [
    {
      "name": "Rohan Mehta",
      "details": "GPay • ₹2,000",
      "time": "2 hours ago",
      "status": "success"
    },
    {
      "name": "Grocery Store",
      "details": "UPI • ₹780",
      "time": "1 day ago",
      "status": "success"
    },
    {
      "name": "Cab Driver",
      "details": "Paytm • ₹320",
      "time": "2 days ago",
      "status": "success"
    },
    {
      "name": "Restaurant",
      "details": "PhonePe • ₹1,200",
      "time": "3 days ago",
      "status": "success"
    },
  ].obs;

  // Available UPI apps with icons
  var upiApps = [
    {
      "name": "GPay",
      "icon": Icons.payment,
      "color": 0xFF4285F4
    },
    {
      "name": "PhonePe",
      "icon": Icons.phone_iphone,
      "color": 0xFF5B259F
    },
    {
      "name": "Paytm",
      "icon": Icons.account_balance_wallet,
      "color": 0xFF00BAF2
    },
    {
      "name": "BHIM",
      "icon": Icons.currency_rupee,
      "color": 0xFF0F9D58
    }
  ].obs;

  // Select UPI App
  void selectUPI(String app) {
    selectedApp.value = app;
  }

  // Proceed to Pay
  void proceedToPay() {
    if (upiController.text.isEmpty && selectedApp.value.isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter UPI ID or select UPI app",
        colorText: Colors.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (amountController.text.isEmpty || double.parse(amountController.text) <= 0) {
      Get.snackbar(
        "Enter Amount",
        "Please enter a valid amount",
        colorText: Colors.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    double amount = double.parse(amountController.text);
    if (amount > walletBalance.value) {
      Get.snackbar(
        "Insufficient Balance",
        "You don't have enough balance for this payment",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Simulate successful payment
    walletBalance.value -= amount.toInt();

    Get.dialog(
      _buildSuccessDialog(amount),
      barrierDismissible: false,
    );
  }

  Widget _buildSuccessDialog(double amount) {
    return Dialog(
      backgroundColor: Color(0xFF1E2E3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Icon(Icons.check, size: 40, color: Colors.green),
            ),
            SizedBox(height: 20),
            Text(
              "Payment Successful!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "₹ ${amount.toStringAsFixed(0)} paid successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  // Clear form
                  upiController.clear();
                  amountController.clear();
                  selectedApp.value = "";
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00D4FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quick amount selection
  void setQuickAmount(String amount) {
    amountController.text = amount.replaceAll('₹ ', '').replaceAll(',', '');
  }

  @override
  void onClose() {
    upiController.dispose();
    amountController.dispose();
    super.onClose();
  }
}