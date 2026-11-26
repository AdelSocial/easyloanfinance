import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/loan_controller.dart';

class LoanDetailsScreen extends StatelessWidget {
  LoanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get loan item from arguments
    final LoanItem? loan = Get.arguments as LoanItem?;
    
    if (loan == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0C192E),
        appBar: AppBar(
          title: const Text(
            'Loan Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0C192E),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            'Loan details not found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: const Text(
          'Loan Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0C192E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLoanHeader(loan),
            const SizedBox(height: 20),
            _buildStatusCard(loan),
            const SizedBox(height: 20),
            _buildLoanInfoSection(loan),
            const SizedBox(height: 20),
            _buildFinancialDetailsSection(loan),
            if (loan.status == LoanStatus.approved || loan.status == LoanStatus.active) ...[
              const SizedBox(height: 20),
              _buildRepaymentSection(loan),
            ],
            if (loan.fullName != null || loan.email != null || loan.mobile != null) ...[
              const SizedBox(height: 20),
              _buildApplicantInfoSection(loan),
            ],
            const SizedBox(height: 20),
            _buildDatesSection(loan),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanHeader(LoanItem loan) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00D4FF).withOpacity(0.2),
            const Color(0xFF0C192E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00D4FF).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00D4FF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getLoanIcon(loan.type),
              size: 32,
              color: const Color(0xFF00D4FF),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loan.type,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // const SizedBox(height: 4),
                // Text(
                //   'ID: ${loan.id}',
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.white70,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(LoanItem loan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: loan.statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                loan.statusText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: loan.statusColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: loan.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: loan.statusColor.withOpacity(0.3),
              ),
            ),
            child: Icon(
              _getStatusIcon(loan.status),
              color: loan.statusColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanInfoSection(LoanItem loan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Loan Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Loan Amount', loan.formattedAmount),
          const Divider(color: Colors.white10, height: 24),
          _buildInfoRow('Interest Rate', '${loan.interestRate.toStringAsFixed(2)}%'),
          const Divider(color: Colors.white10, height: 24),
          _buildInfoRow(
            'Tenure',
            loan.tenure > 0
                ? (loan.tenure >= 12
                    ? '${loan.tenure ~/ 12} year${loan.tenure ~/ 12 > 1 ? 's' : ''} ${loan.tenure % 12 > 0 ? '${loan.tenure % 12} month${loan.tenure % 12 > 1 ? 's' : ''}' : ''}'
                    : '${loan.tenure} month${loan.tenure > 1 ? 's' : ''}')
                : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialDetailsSection(LoanItem loan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Financial Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('EMI Amount', loan.formattedEMI),
          const Divider(color: Colors.white10, height: 24),
          _buildInfoRow('Outstanding Balance', loan.formattedOutstanding),
          const Divider(color: Colors.white10, height: 24),
          _buildInfoRow('Disbursed Amount', '₹${(loan.disbursedAmount / 100000).toStringAsFixed(1)}L'),
        ],
      ),
    );
  }

  Widget _buildRepaymentSection(LoanItem loan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Repayment Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              Text(
                loan.progressText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: loan.progress,
            backgroundColor: const Color(0xFF2D3E50),
            color: const Color(0xFF00D4FF),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          if (loan.nextDueDate != null) ...[
            const Divider(color: Colors.white10, height: 24),
            _buildInfoRow('Next EMI Due', loan.nextDueText),
          ],
        ],
      ),
    );
  }

  Widget _buildApplicantInfoSection(LoanItem loan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Applicant Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (loan.fullName != null) ...[
            _buildInfoRow('Full Name', loan.fullName!),
            const Divider(color: Colors.white10, height: 24),
          ],
          if (loan.email != null) ...[
            _buildInfoRow('Email', loan.email!),
            const Divider(color: Colors.white10, height: 24),
          ],
          if (loan.mobile != null)
            _buildInfoRow('Mobile', loan.mobile!),
        ],
      ),
    );
  }

  Widget _buildDatesSection(LoanItem loan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Important Dates',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (loan.createdAt != null) ...[
            _buildInfoRow('Application Date', _formatDate(loan.createdAt!)),
            const Divider(color: Colors.white10, height: 24),
          ],
          if (loan.disbursedDate != null)
            _buildInfoRow('Disbursed Date', _formatDate(loan.disbursedDate!)),
          if (loan.disbursedDate == null && loan.createdAt != null)
            _buildInfoRow('Disbursed Date', 'Not disbursed yet'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
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

  IconData _getStatusIcon(LoanStatus status) {
    switch (status) {
      case LoanStatus.pending:
        return Icons.pending_outlined;
      case LoanStatus.approved:
        return Icons.check_circle_outline;
      case LoanStatus.rejected:
        return Icons.cancel_outlined;
      case LoanStatus.active:
        return Icons.check_circle;
      case LoanStatus.closed:
        return Icons.lock_outline;
      case LoanStatus.overdue:
        return Icons.warning_outlined;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
