import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/pay_controller.dart';

class PayScreen extends StatelessWidget {
  final PayController controller = Get.put(PayController());

  PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildContent(),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 30.0,
      floating: false,
      pinned: true,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
      ),
      backgroundColor: Color(0xFF0C192E),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Pay',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF00D4FF).withOpacity(0.1),
                Color(0xFF0C192E),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletCard(),
            SizedBox(height: 30),
            _buildQRScanSection(),
            SizedBox(height: 30),
            _buildUPIInputSection(),
            SizedBox(height: 25),
            _buildAmountSection(),
            SizedBox(height: 30),
            _buildUPIAppsSection(),
            SizedBox(height: 30),
            _buildRecentPaymentsSection(),
            SizedBox(height: 35),
            _buildPayButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Obx(() => Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E2E3D),
            Color(0xFF0C192E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00D4FF).withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.account_balance_wallet_outlined,
                    color: Color(0xFF00D4FF), size: 20),
              ),
              SizedBox(width: 12),
              Text(
                "Available Balance",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹ ${controller.walletBalance.value}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward, size: 14, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      "Active",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildQRScanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Scan & Pay",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            // Open QR Scanner
            Get.snackbar(
              "QR Scanner",
              "Opening camera to scan QR code",
              colorText: Colors.white,
              backgroundColor: Colors.blue,
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E2E3D),
                  Color(0xFF0C192E),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFF00D4FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.5)),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_outlined,
                    color: Color(0xFF00D4FF),
                    size: 40,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Tap to Scan QR Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Scan any UPI QR code to pay instantly",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUPIInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter UPI ID",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF1E2E3D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.person_outlined, color: Color(0xFF00D4FF), size: 20),
              ),
              SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: controller.upiController,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "example@upi",
                    hintStyle: TextStyle(color: Colors.white30),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter Amount",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF1E2E3D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "₹",
                  style: TextStyle(
                    color: Color(0xFF00D4FF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "0.00",
                    hintStyle: TextStyle(color: Colors.white30, fontSize: 22),
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  maxLength: 10,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildQuickAmountChip("₹ 100"),
            _buildQuickAmountChip("₹ 500"),
            _buildQuickAmountChip("₹ 1,000"),
            _buildQuickAmountChip("₹ 2,000"),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAmountChip(String amount) {
    return GestureDetector(
      onTap: () => controller.setQuickAmount(amount),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFF1E2E3D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
        ),
        child: Text(
          amount,
          style: TextStyle(
            color: Color(0xFF00D4FF),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildUPIAppsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "UPI Apps",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Obx(() => GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.9,
          ),
          itemCount: controller.upiApps.length,
          itemBuilder: (context, index) {
            final app = controller.upiApps[index];
            return _buildUPIAppCard(app);
          },
        )),
      ],
    );
  }

  Widget _buildUPIAppCard(Map<String, dynamic> app) {
    bool isSelected = controller.selectedApp.value == app["name"];
    Color appColor = Color(app["color"] as int);

    return GestureDetector(
      onTap: () => controller.selectUPI(app["name"]),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? appColor.withOpacity(0.2) : Color(0xFF1E2E3D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? appColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: appColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                app["icon"] as IconData,
                color: appColor,
                size: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              app["name"],
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPaymentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Payments",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // View all payments
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
                ),
                child: Text(
                  "View All",
                  style: TextStyle(
                    color: Color(0xFF00D4FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Obx(() => Column(
          children: controller.recentPayments.take(3).map((payment) {
            return _buildRecentPaymentTile(payment);
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildRecentPaymentTile(Map<String, String> payment) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.check_circle_outlined,
              color: Colors.green,
              size: 24,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment["name"]!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  payment["details"]!,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  payment["time"]!,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white54, size: 20),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Obx(() => Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            onPressed: (controller.upiController.text.isNotEmpty ||
                controller.selectedApp.value.isNotEmpty) &&
                controller.amountController.text.isNotEmpty
                ? controller.proceedToPay
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: (controller.upiController.text.isNotEmpty ||
                  controller.selectedApp.value.isNotEmpty) &&
                  controller.amountController.text.isNotEmpty
                  ? Color(0xFF00D4FF)
                  : Color(0xFF2D3E50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.payment_outlined,
                  color: (controller.upiController.text.isNotEmpty ||
                      controller.selectedApp.value.isNotEmpty) &&
                      controller.amountController.text.isNotEmpty
                      ? Colors.white
                      : Colors.white54,
                ),
                SizedBox(width: 10),
                Text(
                  "Proceed to Pay",
                  style: TextStyle(
                    color: (controller.upiController.text.isNotEmpty ||
                        controller.selectedApp.value.isNotEmpty) &&
                        controller.amountController.text.isNotEmpty
                        ? Colors.white
                        : Colors.white54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Text(
          "Payment will be processed securely",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    ));
  }
}