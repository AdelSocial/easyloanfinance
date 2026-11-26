import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/top_up_controller.dart';

class TopUpScreen extends StatelessWidget {
  final TopUpController controller = Get.put(TopUpController());

  TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Icon(Icons.arrow_back_rounded,color: Colors.white,)),
            expandedHeight: 30.0,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF0C192E),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Top Up Wallet',
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWalletBalanceCard(),
                  const SizedBox(height: 30),
                  _buildAmountInputSection(),
                  const SizedBox(height: 25),
                  _buildQuickAmountSection(),
                  const SizedBox(height: 30),
                  _buildPaymentMethodsSection(),
                  const SizedBox(height: 40),
                  _buildAddMoneyButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletBalanceCard() {
    return Obx(() => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
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
            spreadRadius: 2,
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
                "Current Balance",
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
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
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
          SizedBox(height: 10),
          Text(
            "Last top up: Today, 2:30 PM",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildAmountInputSection() {
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
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF1E2E3D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: controller.amount.value.isNotEmpty
                  ? Color(0xFF00D4FF).withOpacity(0.5)
                  : Colors.white10,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 5),
              )
            ],
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
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                  onChanged: controller.setAmount,
                  controller: TextEditingController(text: controller.amount.value),
                  decoration: InputDecoration(
                    hintText: "0.00",
                    hintStyle: TextStyle(color: Colors.white30, fontSize: 22),
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  maxLength: 10,
                ),
              ),
              if (controller.amount.value.isNotEmpty)
                GestureDetector(
                  onTap: () => controller.setAmount(""),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white54, size: 18),
                  ),
                ),
            ],
          ),
        )),
        SizedBox(height: 8),
        Obx(() => Text(
          controller.amount.value.isNotEmpty
              ? "You'll add ₹${controller.amount.value} to your wallet"
              : "Enter the amount you want to add",
          style: TextStyle(
            color: controller.amount.value.isNotEmpty ? Color(0xFF00D4FF) : Colors.white54,
            fontSize: 12,
          ),
        )),
      ],
    );
  }

  Widget _buildQuickAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Amount",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildQuickAmountChip("₹ 500"),
            _buildQuickAmountChip("₹ 1,000"),
            _buildQuickAmountChip("₹ 2,000"),
            _buildQuickAmountChip("₹ 5,000"),
            _buildQuickAmountChip("₹ 10,000"),
            _buildQuickAmountChip("₹ 20,000"),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAmountChip(String amount) {
    return Obx(() {
      bool isSelected = controller.amount.value == amount.replaceAll("₹ ", "");
      return GestureDetector(
        onTap: () => controller.selectQuickAmount(amount.replaceAll("₹ ", "")),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
              colors: [Color(0xFF00D4FF), Color(0xFF0097CC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : LinearGradient(
              colors: [Color(0xFF1E2E3D), Color(0xFF0C192E)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Color(0xFF00D4FF) : Colors.white24,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Color(0xFF00D4FF).withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]
                : [],
          ),
          child: Text(
            amount,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPaymentMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Payment Method",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        _buildPaymentMethodCard(
          title: "UPI Payment",
          subtitle: "Instant transfer using UPI",
          icon: Icons.payment_outlined,
          iconColor: Color(0xFF4CAF50),
        ),
        SizedBox(height: 12),
        _buildPaymentMethodCard(
          title: "Debit / Credit Card",
          subtitle: "Pay using your card",
          icon: Icons.credit_card_outlined,
          iconColor: Color(0xFF2196F3),
        ),
        SizedBox(height: 12),
        _buildPaymentMethodCard(
          title: "Net Banking",
          subtitle: "Transfer from your bank",
          icon: Icons.account_balance_outlined,
          iconColor: Color(0xFFFF9800),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Obx(() {
      bool isSelected = controller.selectedMethod.value == title;
      return GestureDetector(
        onTap: () => controller.selectMethod(title),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF00D4FF).withOpacity(0.1) : Color(0xFF1E2E3D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Color(0xFF00D4FF) : Colors.transparent,
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
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Color(0xFF00D4FF) : Colors.white30,
                    width: 2,
                  ),
                  color: isSelected ? Color(0xFF00D4FF) : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 14, color: Colors.white)
                    : SizedBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAddMoneyButton() {
    return Obx(() => Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            onPressed: controller.amount.value.isNotEmpty && controller.selectedMethod.value.isNotEmpty
                ? controller.addMoney
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.amount.value.isNotEmpty && controller.selectedMethod.value.isNotEmpty
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
                  Icons.add_circle_outlined,
                  color: controller.amount.value.isNotEmpty && controller.selectedMethod.value.isNotEmpty
                      ? Colors.white
                      : Colors.white54,
                ),
                SizedBox(width: 10),
                Text(
                  "Add Money",
                  style: TextStyle(
                    color: controller.amount.value.isNotEmpty && controller.selectedMethod.value.isNotEmpty
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
          "Your money will be added instantly to your wallet",
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