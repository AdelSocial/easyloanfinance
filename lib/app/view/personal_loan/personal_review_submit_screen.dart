import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/personal_review_controller.dart';

class PersonalReviewSubmitScreen extends StatelessWidget {
  final PersonalReviewController controller = Get.put(PersonalReviewController());

  PersonalReviewSubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Easy Loan Finance',
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            SizedBox(height: 24),
            _buildLoanSummaryCard(),
            SizedBox(height: 24),
            _buildAgreementSection(),
            SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00D4FF).withOpacity(0.1),
            Color(0xFF0C192E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.5)),
            ),
            child: Icon(
              Icons.task_alt_outlined,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Review and Submit',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please review your loan details before submitting the application',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanSummaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Loan Type Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.account_balance_wallet_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Personal Loan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Loan Details Table
          _buildLoanDetailsTable(),
        ],
      ),
    );
  }

  Widget _buildLoanDetailsTable() {
    return Obx(() {
      if (controller.isLoadingDetails.value) {
        return Container(
          padding: EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF2D3E50)),
          ),
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
          ),
        );
      }
      
      if (controller.loanDetails.isEmpty) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Loan details not available. Please complete the application form.',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      
      // Check if there's an error
      if (controller.loanDetails.containsKey('Error')) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      controller.loanDetails['Error'] ?? 'Unable to load loan details',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => controller.refreshLoanDetails(),
                icon: Icon(Icons.refresh, size: 16),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00D4FF),
                  foregroundColor: Color(0xFF0C192E),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      
      return Container(
        decoration: BoxDecoration(
          color: Color(0xFF0C192E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF2D3E50)),
        ),
        child: Column(
          children: controller.loanDetails.entries.map((entry) {
            bool isTotal = entry.key == 'Total Repayment';
            bool isEMI = entry.key == 'EMI';
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: entry.key == controller.loanDetails.entries.last.key
                      ? BorderSide.none
                      : BorderSide(color: Color(0xFF2D3E50)),
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: Text(
                  entry.key,
                  style: TextStyle(
                    color: isTotal ? Color(0xFF00D4FF) : Colors.white70,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    fontSize: isTotal ? 16 : 14,
                  ),
                ),
                trailing: Text(
                  entry.value,
                  style: TextStyle(
                    color: isTotal ? Color(0xFF00D4FF) : Colors.white,
                    fontWeight: isTotal || isEMI ? FontWeight.bold : FontWeight.normal,
                    fontSize: isTotal ? 18 : 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildAgreementSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.gavel_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Agreements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildAgreementCheckbox(
            controller: controller.agreeKFS,
            text: 'I agree with Key Fact Statement (KFS)',
          ),
          SizedBox(height: 16),
          _buildAgreementCheckbox(
            controller: controller.agreeTerms,
            text: 'I accept Loan Terms & Conditions',
          ),
          SizedBox(height: 16),
          _buildViewDocumentsRow(),
        ],
      ),
    );
  }

  Widget _buildAgreementCheckbox({
    required RxBool controller,
    required String text,
  }) {
    return Obx(() => InkWell(
      onTap: () => controller.value = !controller.value,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: controller.value ? Color(0xFF00D4FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: controller.value ? Color(0xFF00D4FF) : Colors.white54,
              ),
            ),
            child: Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.transparent,
              ),
              child: Checkbox(
                value: controller.value,
                onChanged: (value) => controller.value = value!,
                activeColor: Colors.transparent,
                checkColor: Color(0xFF0C192E),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildViewDocumentsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () => _showKFSDialog(),
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF00D4FF),
          ),
          child: Row(
            children: [
              Icon(Icons.visibility_outlined, size: 16),
              SizedBox(width: 6),
              Text('View KFS'),
            ],
          ),
        ),
        Container(
          height: 20,
          width: 1,
          color: Color(0xFF2D3E50),
        ),
        TextButton(
          onPressed: () => _showTermsDialog(),
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF00D4FF),
          ),
          child: Row(
            children: [
              Icon(Icons.description_outlined, size: 16),
              SizedBox(width: 6),
              Text('View Terms'),
            ],
          ),
        ),
      ],
    );
  }

  void _showKFSDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.8),
          decoration: BoxDecoration(
            color: Color(0xFF1E2E3D),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF00D4FF), size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Key Fact Statement (KFS)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildKFSSection(
                        'Loan Details',
                        [
                          'Loan Amount: As per your application',
                          'Interest Rate: 12.5% - 18% per annum (APR)',
                          'Loan Tenure: 12 to 60 months',
                          'Processing Fee: 1% of loan amount (minimum ₹500)',
                          'Prepayment Charges: Nil',
                          'Late Payment Charges: 2% per month on overdue amount',
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildKFSSection(
                        'Interest Calculation',
                        [
                          'Interest is calculated on reducing balance method',
                          'EMI includes both principal and interest',
                          'Interest rate may vary based on credit profile',
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildKFSSection(
                        'Fees & Charges',
                        [
                          'Processing Fee: 1% of loan amount',
                          'GST: 18% on processing fee',
                          'Late Payment Fee: 2% per month',
                          'Bounce Charges: ₹500 per bounce',
                          'No prepayment charges',
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildKFSSection(
                        'Important Information',
                        [
                          'Loan approval is subject to credit assessment',
                          'Interest rate is fixed for the loan tenure',
                          'EMI amount remains constant throughout the tenure',
                          'Early closure is allowed without any charges',
                          'All charges are clearly disclosed upfront',
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Footer
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF0C192E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00D4FF),
                      foregroundColor: Color(0xFF0C192E),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'I Understand',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void _showTermsDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.8),
          decoration: BoxDecoration(
            color: Color(0xFF1E2E3D),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.gavel_outlined, color: Color(0xFF00D4FF), size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermsSection(
                        '1. Loan Agreement',
                        'By accepting these terms, you agree to repay the loan amount along with interest and applicable charges as per the schedule.',
                      ),
                      SizedBox(height: 20),
                      _buildTermsSection(
                        '2. Interest Rate',
                        'The interest rate is fixed for the entire loan tenure. The rate is determined based on your credit profile and loan amount.',
                      ),
                      SizedBox(height: 20),
                      _buildTermsSection(
                        '3. Repayment',
                        'You agree to pay the EMI on the due date every month. Failure to pay may result in late payment charges and impact your credit score.',
                      ),
                      SizedBox(height: 20),
                      _buildTermsSection(
                        '4. Prepayment',
                        'You can prepay the loan in full or part at any time without any prepayment charges. Interest will be calculated on the outstanding principal.',
                      ),
                      SizedBox(height: 20),
                      _buildTermsSection(
                        '5. Default',
                        'If you fail to pay three consecutive EMIs, the loan will be considered in default, and legal action may be initiated.',
                      ),
                      SizedBox(height: 20),
                      _buildTermsSection(
                        '6. Documentation',
                        'You agree to provide all necessary documents and information. Any false information may lead to loan rejection or legal action.',
                      ),
                      SizedBox(height: 20),
                      _buildTermsSection(
                        '7. Credit Bureau',
                        'Your loan details will be reported to credit bureaus. Timely repayment will improve your credit score.',
                      ),
                      SizedBox(height: 20),
                      _buildTermsSection(
                        '8. Dispute Resolution',
                        'Any disputes will be resolved through arbitration as per Indian laws. The jurisdiction will be the courts of your city.',
                      ),
                    ],
                  ),
                ),
              ),
              // Footer
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF0C192E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00D4FF),
                      foregroundColor: Color(0xFF0C192E),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'I Accept',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildKFSSection(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00D4FF),
          ),
        ),
        SizedBox(height: 12),
        ...points.map((point) => Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 6, right: 12),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  point,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00D4FF),
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: (controller.isFormValid && !controller.isLoading.value)
                ? () => controller.submitApplication()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: (controller.isFormValid && !controller.isLoading.value)
                  ? Color(0xFF00D4FF)
                  : Color(0xFF2D3E50),
              disabledBackgroundColor: Color(0xFF2D3E50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
            ),
            child: controller.isLoading.value
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Submit Application',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: (controller.isFormValid && !controller.isLoading.value)
                          ? Color(0xFF0C192E)
                          : Colors.white54,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'By submitting, you confirm all provided information is accurate',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
      ],
    ));
  }
}