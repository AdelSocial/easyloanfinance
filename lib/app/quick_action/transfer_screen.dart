
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/transfer_controller.dart';

class TransferScreen extends StatelessWidget {
  final TransferController controller = Get.put(TransferController());

  TransferScreen({super.key});

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
      backgroundColor: Color(0xFF0C192E),
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Transfer Money',
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
            _buildRecentContacts(),
            SizedBox(height: 25),
            _buildBeneficiarySection(),
            SizedBox(height: 25),
            _buildAmountSection(),
            SizedBox(height: 25),
            _buildNoteSection(),
            SizedBox(height: 35),
            _buildSendButton(),
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

  Widget _buildRecentContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Transfers",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.recentContacts.length,
            itemBuilder: (context, index) {
              final contact = controller.recentContacts[index];
              return Container(
                width: 120,
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF1E2E3D),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      contact["name"]!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      contact["amount"]!,
                      style: TextStyle(
                        color: Color(0xFF00D4FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      contact["time"]!,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBeneficiarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Beneficiary",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to add beneficiary screen
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, size: 14, color: Color(0xFF00D4FF)),
                    SizedBox(width: 4),
                    Text(
                      "Add New",
                      style: TextStyle(
                        color: Color(0xFF00D4FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Obx(() => Column(
          children: controller.beneficiaryList.map((beneficiary) {
            return _buildBeneficiaryTile(beneficiary);
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildBeneficiaryTile(Map<String, String> beneficiary) {
    bool isSelected = controller.selectedBeneficiary.value == beneficiary["name"];
    bool isUPI = beneficiary["type"] == "upi";

    return GestureDetector(
      onTap: () => controller.selectBeneficiary(beneficiary["name"]!),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isUPI ? Colors.purple.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isUPI ? Icons.payment : Icons.account_balance,
                color: isUPI ? Colors.purple : Colors.blue,
                size: 24,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    beneficiary["name"]!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    beneficiary["details"]!,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
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
            _buildQuickAmountChip("₹ 500"),
            _buildQuickAmountChip("₹ 1,000"),
            _buildQuickAmountChip("₹ 2,000"),
            _buildQuickAmountChip("₹ 5,000"),
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

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Note (Optional)",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF1E2E3D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: TextField(
            controller: controller.noteController,
            maxLines: 2,
            style: TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: "Add a note for this transaction...",
              hintStyle: TextStyle(color: Colors.white30),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return Obx(() => Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            onPressed: controller.selectedBeneficiary.value.isNotEmpty &&
                controller.amountController.text.isNotEmpty
                ? controller.sendMoney
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.selectedBeneficiary.value.isNotEmpty &&
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
                  Icons.send_outlined,
                  color: controller.selectedBeneficiary.value.isNotEmpty &&
                      controller.amountController.text.isNotEmpty
                      ? Colors.white
                      : Colors.white54,
                ),
                SizedBox(width: 10),
                Text(
                  "Send Money",
                  style: TextStyle(
                    color: controller.selectedBeneficiary.value.isNotEmpty &&
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
          "Transfer will be processed instantly",
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