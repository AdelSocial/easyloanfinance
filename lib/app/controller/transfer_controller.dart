import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferController extends GetxController {
  // Selected Beneficiary
  var selectedBeneficiary = "".obs;

  // Text Controllers
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  // Wallet Balance
  var walletBalance = 85000.obs;

  // Beneficiary List
  var beneficiaryList = [
    {
      "name": "Rohan Mehta",
      "details": "HDFC Bank • 2819",
      "image": "",
      "type": "bank"
    },
    {
      "name": "Anjali Verma",
      "details": "SBI • 9932",
      "image": "",
      "type": "bank"
    },
    {
      "name": "Office Account",
      "details": "ICICI • 5510",
      "image": "",
      "type": "bank"
    },
    {
      "name": "Priya Sharma",
      "details": "UPI • priya@okhdfc",
      "image": "",
      "type": "upi"
    },
  ].obs;

  // Recent Contacts
  var recentContacts = [
    {"name": "Rohan", "amount": "₹ 5,000", "time": "2 hrs ago"},
    {"name": "Anjali", "amount": "₹ 2,000", "time": "1 day ago"},
    {"name": "Office", "amount": "₹ 10,000", "time": "2 days ago"},
  ];

  // Select Beneficiary
  void selectBeneficiary(String name) {
    selectedBeneficiary.value = name;
  }

  // Send Money
  void sendMoney() {
    if (selectedBeneficiary.value.isEmpty) {
      Get.snackbar(
        "Select Beneficiary",
        "Please select a beneficiary to continue",
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
        "You don't have enough balance for this transfer",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Simulate successful transfer
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
              "Transfer Successful!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "₹ ${amount.toStringAsFixed(0)} sent to ${selectedBeneficiary.value}",
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
                  Get.back();
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
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }
}