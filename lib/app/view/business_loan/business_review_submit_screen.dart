import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/business_review_controller.dart';

class BusinessReviewSubmitScreen extends StatelessWidget {
  final BusinessReviewController controller = Get.put(BusinessReviewController());

  BusinessReviewSubmitScreen({super.key});

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
            _buildBusinessDetailsCard(),
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
              Icons.business_center_outlined,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Business Loan Review',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please review your business loan details before submitting the application',
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
                'Business Loan Summary',
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
          bool isBusinessAmount = entry.key == 'Loan Amount';
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
                  color: isTotal || isBusinessAmount ? Color(0xFF00D4FF) : Colors.white70,
                  fontWeight: isTotal || isBusinessAmount ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 16 : 14,
                ),
              ),
              trailing: Text(
                entry.value,
                style: TextStyle(
                  color: isTotal || isBusinessAmount ? Color(0xFF00D4FF) : Colors.white,
                  fontWeight: isTotal || isEMI || isBusinessAmount ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal || isBusinessAmount ? 18 : 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBusinessDetailsCard() {
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
          // Business Details Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.business_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Business Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Business Details
          _buildBusinessDetailsTable(),
        ],
      ),
    );
  }

  Widget _buildBusinessDetailsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0C192E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF2D3E50)),
      ),
      child: Column(
        children: controller.businessDetails.entries.map((entry) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: entry.key == controller.businessDetails.entries.last.key
                    ? BorderSide.none
                    : BorderSide(color: Color(0xFF2D3E50)),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              title: Text(
                entry.key,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              trailing: SizedBox(
                width: MediaQuery.of(Get.context!).size.width * 0.4,
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
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
                'Business Agreements',
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
            value: controller.agreeKFS.value,
            onChanged: (value) => controller.agreeKFS.value = value!,
            text: 'I agree with Business Loan Key Fact Statement (KFS)',
          ),
          SizedBox(height: 16),
          _buildAgreementCheckbox(
            value: controller.agreeTerms.value,
            onChanged: (value) => controller.agreeTerms.value = value!,
            text: 'I accept Business Loan Terms & Conditions',
          ),
          SizedBox(height: 16),
          _buildAgreementCheckbox(
            value: controller.agreeBusinessCompliance.value,
            onChanged: (value) => controller.agreeBusinessCompliance.value = value!,
            text: 'I confirm all business documents are accurate and compliant',
          ),
          SizedBox(height: 16),
          _buildViewDocumentsRow(),
        ],
      ),
    );
  }

  Widget _buildAgreementCheckbox({
    required bool value,
    required Function(bool?) onChanged,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: value ? Color(0xFF00D4FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: value ? Color(0xFF00D4FF) : Colors.white54,
            ),
          ),
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.transparent,
            ),
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.transparent,
              checkColor: Color(0xFF0C192E),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewDocumentsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            // Navigate to Business KFS document
            // Get.to(() => BusinessKFSDocumentScreen());
          },
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF00D4FF),
          ),
          child: Row(
            children: [
              Icon(Icons.visibility_outlined, size: 13),
              SizedBox(width: 2),
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
          onPressed: () {
            // Navigate to Business Terms & Conditions
            // Get.to(() => BusinessTermsConditionsScreen());
          },
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF00D4FF),
          ),
          child: Row(
            children: [
              Icon(Icons.description_outlined, size: 13),
              SizedBox(width: 2),
              Text('View Terms'),
            ],
          ),
        ),
        Container(
          height: 20,
          width: 1,
          color: Color(0xFF2D3E50),
        ),
        TextButton(
          onPressed: () {
            // Navigate to Business Compliance Guidelines
            // Get.to(() => BusinessComplianceScreen());
          },
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF00D4FF),
          ),
          child: Row(
            children: [
              Icon(Icons.rule_outlined, size: 13),
              SizedBox(width: 2),
              Text('Compliance'),
            ],
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
            onPressed:  () {
              Get.toNamed(Routes.businessApplicationSuccessScreen);
            } ,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isFormValid ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
              disabledBackgroundColor: Color(0xFF2D3E50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
            ),
            child: Text(
              'Submit Business Application',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: controller.isFormValid ? Color(0xFF0C192E) : Colors.white54,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'By submitting, you confirm all business information and documents are accurate',
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