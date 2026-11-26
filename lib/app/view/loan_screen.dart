
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/loan_controller.dart';
import '../routes/app_pages.dart';


class LoansScreen extends StatelessWidget {
  final LoansController controller = Get.put(LoansController());

  LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Inquiry Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0C192E),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add_circle_outline),
        //     onPressed: () {
        //       // Get.toNamed('/apply-loan');
        //     },
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshLoans(),
        color: Color(0xFF00D4FF),
        child: Column(
          children: [
            _buildSummaryCards(),
            SizedBox(height: 16),
            _buildTabBar(),
            SizedBox(height: 16),
            Expanded(child: _buildLoanList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Obx(() {
      final totalOutstanding = controller.getTotalOutstanding();
      final totalEMI = controller.getTotalEMI();

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Outstanding',
                value: '₹${(totalOutstanding / 100000).toStringAsFixed(1)}L',
                icon: Icons.account_balance_wallet_outlined,
                color: Color(0xFF00D4FF),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Monthly EMI',
                value: '₹${totalEMI.toInt()}',
                icon: Icons.payments_outlined,
                color: Color(0xFF4CAF50),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Inquiries',
                value: (controller.pendingLoans.length + controller.approvedLoans.length + controller.rejectedLoans.length).toString(),
                icon: Icons.inbox_outlined,
                color: Color(0xFFFF9800),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab('Pending', 0),
          _buildTab('Approved', 1),
          _buildTab('Rejected', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    return Obx(() => Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: controller.selectedTabIndex.value == index
                ? Color(0xFF00D4FF)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: controller.selectedTabIndex.value == index
                  ? Color(0xFF0C192E)
                  : Colors.white54,
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildLoanList() {
    return Obx(() {
      final selectedIndex = controller.selectedTabIndex.value;
      List<LoanItem> loans = [];

      switch (selectedIndex) {
        case 0:
          loans = controller.pendingLoans;
          break;
        case 1:
          loans = controller.approvedLoans;
          break;
        case 2:
          loans = controller.rejectedLoans;
          break;
      }

      if (loans.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: loans.length,
        itemBuilder: (context, index) {
          return _buildLoanCard(loans[index]);
        },
      );
    });
  }

  Widget _buildLoanCard(LoanItem loan) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Loan Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF00D4FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getLoanIcon(loan.type),
                    size: 20,
                    color: Color(0xFF00D4FF),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.type,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '${loan.fullName != null ? '${loan.fullName}' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                      if (loan.createdAt != null) ...[
                        SizedBox(height: 2),
                        Text(
                          'Applied: ${_formatDate(loan.createdAt!)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: loan.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: loan.statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    loan.statusText,
                    style: TextStyle(
                      fontSize: 10,
                      color: loan.statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loan Details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildLoanDetail('Loan Amount', loan.formattedAmount),
                _buildLoanDetail('Interest Rate', '${loan.interestRate.toStringAsFixed(1)}%'),
                _buildLoanDetail('Tenure', loan.tenure > 0 
                  ? (loan.tenure >= 12 
                      ? '${loan.tenure ~/ 12} year${loan.tenure ~/ 12 > 1 ? 's' : ''}'
                      : '${loan.tenure} month${loan.tenure > 1 ? 's' : ''}')
                  : 'N/A'),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Progress and EMI Info (for approved loans)
          if (loan.status == LoanStatus.approved || loan.status == LoanStatus.active) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Repayment Progress',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                      Text(
                        loan.progressText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: loan.progress,
                    backgroundColor: Color(0xFF2D3E50),
                    color: Color(0xFF00D4FF),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next EMI Due',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          loan.nextDueText,
                          style: TextStyle(
                            fontSize: 14,
                            color: loan.dueTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EMI Amount',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          loan.formattedEMI,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],

          // Action Buttons
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF0C192E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                if (loan.status == LoanStatus.approved || loan.status == LoanStatus.active) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => controller.payEMI(loan),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00D4FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(Icons.payment, size: 16),
                      label: Text('Pay EMI',style: TextStyle(color: Colors.black),),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.viewLoanDetails(loan),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF00D4FF),
                      side: BorderSide(color: Color(0xFF00D4FF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(Icons.visibility_outlined, size: 16),
                    label: Text('View'),
                  ),
                ),
                // SizedBox(width: 8),
                // IconButton(
                //   onPressed: () => controller.downloadStatement(loan),
                //   icon: Icon(Icons.download_outlined, color: Color(0xFF00D4FF)),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanDetail(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFF1E2E3D),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 60,
              color: Color(0xFF00D4FF).withOpacity(0.3),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Loan Inquiries',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            controller.selectedTabIndex.value == 0
                ? 'No pending loan inquiries'
                : controller.selectedTabIndex.value == 1
                ? 'No approved loan inquiries'
                : 'No rejected loan inquiries found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed(Routes.personalApplicationScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00D4FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: Icon(Icons.add,color: Colors.white,),
            label: Text('Apply for Loan',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  IconData _getLoanIcon(String loanType) {
    final typeLower = loanType.toLowerCase();
    if (typeLower.contains('home')) {
      return Icons.home_outlined;
    } else if (typeLower.contains('personal') || typeLower.contains('startup')) {
      return Icons.person_outlined;
    } else if (typeLower.contains('business')) {
      return Icons.business_outlined;
    } else if (typeLower.contains('car') || typeLower.contains('vehicle')) {
      return Icons.directions_car_outlined;
    } else if (typeLower.contains('instant') || typeLower.contains('quick')) {
      return Icons.flash_on_outlined;
    }
    return Icons.account_balance_wallet_outlined;
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
}