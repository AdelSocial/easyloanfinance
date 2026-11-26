import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_loan_review_controller.dart';
import 'home_loan_application_success_screen.dart';

class HomeLoanSubmitScreen extends StatelessWidget {
  final HomeLoanReviewController controller = Get.put(HomeLoanReviewController());

  HomeLoanSubmitScreen({super.key});

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
            _buildPropertyDetailsCard(),
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
              Icons.home_work_outlined,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Review Home Loan Application',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please review your home loan details and property information before submitting',
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
                child: Icon(Icons.account_balance_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Home Loan Details',
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
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
          ),
        );
      }
      
      if (controller.loanDetails.isEmpty) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              'Failed to load loan details. Please try again.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
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
            bool isLoanAmount = entry.key == 'Loan Amount';
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
                    fontWeight: isTotal || isLoanAmount ? FontWeight.bold : FontWeight.normal,
                    fontSize: isTotal ? 16 : 14,
                  ),
                ),
                trailing: Text(
                  entry.value,
                  style: TextStyle(
                    color: isTotal || isLoanAmount ? Color(0xFF00D4FF) : Colors.white,
                    fontWeight: isTotal || isEMI || isLoanAmount ? FontWeight.bold : FontWeight.normal,
                    fontSize: isTotal || isLoanAmount ? 18 : 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildPropertyDetailsCard() {
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
                child: Icon(Icons.location_city_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Property Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildPropertyDetailsTable(),
        ],
      ),
    );
  }

  Widget _buildPropertyDetailsTable() {
    return Obx(() {
      if (controller.isLoadingDetails.value) {
        return Container(
          padding: EdgeInsets.all(40),
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
          ),
        );
      }
      
      if (controller.propertyDetails.isEmpty) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              'Failed to load property details. Please try again.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
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
          children: controller.propertyDetails.entries.map((entry) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: entry.key == controller.propertyDetails.entries.last.key
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
                  width: 150,
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                'Agreements & Declarations',
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
            text: 'I agree with Home Loan Key Fact Statement (KFS)',
          ),
          SizedBox(height: 16),
          _buildAgreementCheckbox(
            controller: controller.agreeTerms,
            text: 'I accept Home Loan Terms & Conditions',
          ),
          SizedBox(height: 16),
          _buildAgreementCheckbox(
            controller: controller.agreePropertyDeclaration,
            text: 'I declare that the property information provided is accurate',
          ),
          SizedBox(height: 16),
          // _buildViewDocumentsRow(),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
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
      ),
    ));
  }

  // Widget _buildViewDocumentsRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       TextButton(
  //         onPressed: () {
  //           // Navigate to Home Loan KFS document
  //           // Get.to(() => HomeLoanKFSDocumentScreen());
  //         },
  //         style: TextButton.styleFrom(
  //           foregroundColor: Color(0xFF00D4FF),
  //         ),
  //         child: Row(
  //           children: [
  //             Icon(Icons.visibility_outlined, size: 16),
  //             SizedBox(width: 6),
  //             Text('View KFS'),
  //           ],
  //         ),
  //       ),
  //       Container(
  //         height: 20,
  //         width: 1,
  //         color: Color(0xFF2D3E50),
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           // Navigate to Home Loan Terms & Conditions
  //           // Get.to(() => HomeLoanTermsConditionsScreen());
  //         },
  //         style: TextButton.styleFrom(
  //           foregroundColor: Color(0xFF00D4FF),
  //         ),
  //         child: Row(
  //           children: [
  //             Icon(Icons.description_outlined, size: 16),
  //             SizedBox(width: 6),
  //             Text('View Terms'),
  //           ],
  //         ),
  //       ),
  //       Container(
  //         height: 20,
  //         width: 1,
  //         color: Color(0xFF2D3E50),
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           // Navigate to Property Documents
  //           // Get.to(() => PropertyDocumentsScreen());
  //         },
  //         style: TextButton.styleFrom(
  //           foregroundColor: Color(0xFF00D4FF),
  //         ),
  //         child: Row(
  //           children: [
  //             Icon(Icons.folder_open_outlined, size: 16),
  //             SizedBox(width: 6),
  //             Text('Property Docs'),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSubmitButton() {
    return Obx(() => Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.isFormValid && !controller.isLoading.value
                ? () async {
                    await controller.submitApplication();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isFormValid ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
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
                    'Submit Home Loan Application',
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
          'By submitting, you confirm all provided property and financial information is accurate',
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