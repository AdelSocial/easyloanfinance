import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/business_document_controller.dart';


class BusinessDocumentUploadScreen extends StatelessWidget {
  final BusinessDocumentController controller = Get.put(BusinessDocumentController());

  BusinessDocumentUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Business Loan Application',
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline, color: Colors.white70),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            _buildHeaderSection(),
            SizedBox(height: 24),
            _buildDocumentUploadSection(),
            SizedBox(height: 32),
            _buildContinueButton(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.business_center_outlined, size: 24, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Business Document Upload',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Upload required business documents to complete your loan application',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadSection() {
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
                child: Icon(Icons.upload_file_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Required Business Documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildDocumentItem(
            title: 'Business PAN Card',
            subtitle: 'Upload scanned copy of business PAN',
            icon: Icons.business_outlined,
            documentType: 'Business PAN',
            isUploaded: controller.businessPanUploaded.value,
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'GST Registration Certificate',
            subtitle: 'Upload GST certificate copy',
            icon: Icons.receipt_long_outlined,
            documentType: 'GST Certificate',
            isUploaded: controller.gstCertificateUploaded.value,
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Business Address Proof',
            subtitle: 'Utility bill, rent agreement, or property tax receipt',
            icon: Icons.location_on_outlined,
            documentType: 'Business Address Proof',
            isUploaded: controller.addressProofUploaded.value,
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Business Bank Statements',
            subtitle: 'Last 6 months business bank statements (PDF)',
            icon: Icons.description_outlined,
            documentType: 'Bank Statements',
            isUploaded: controller.bankStatementsUploaded.value,
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Business License/Registration',
            subtitle: 'Shop Act, MSME, or business registration certificate',
            icon: Icons.assignment_outlined,
            documentType: 'Business License',
            isUploaded: controller.businessLicenseUploaded.value,
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'ITR Last 2 Years',
            subtitle: 'Income Tax Returns for last 2 financial years',
            icon: Icons.pie_chart_rounded,
            documentType: 'ITR Documents',
            isUploaded: controller.itrUploaded.value,
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Financial Statements',
            subtitle: 'Balance Sheet and Profit & Loss statements',
            icon: Icons.account_balance_outlined,
            documentType: 'Financial Statements',
            isUploaded: controller.financialStatementsUploaded.value,
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Proprietor/Director KYC',
            subtitle: 'PAN, Aadhaar of business owner/director',
            icon: Icons.verified_user_outlined,
            documentType: 'Owner KYC',
            isUploaded: controller.ownerKycUploaded.value,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required String documentType,
    required bool isUploaded,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF0C192E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUploaded ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
        ),
      ),
      child: Row(
        children: [
          // Checkbox/Status Icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUploaded ? Color(0xFF00D4FF) : Colors.transparent,
              border: Border.all(
                color: isUploaded ? Color(0xFF00D4FF) : Colors.white54,
              ),
            ),
            child: isUploaded
                ? Icon(Icons.check, size: 16, color: Color(0xFF0C192E))
                : SizedBox(),
          ),
          SizedBox(width: 16),
          // Document Icon
          Icon(icon, color: Color(0xFF00D4FF), size: 24),
          SizedBox(width: 12),
          // Document Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Upload Button
          ElevatedButton(
            onPressed: () => controller.pickDocument(documentType),
            style: ElevatedButton.styleFrom(
              backgroundColor: isUploaded ? Colors.green : Color(0xFF00D4FF),
              foregroundColor: Color(0xFF0C192E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              isUploaded ? 'Uploaded' : 'Upload',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Obx(() => Column(
      children: [
        // Progress indicator
        Container(
          width: double.infinity,
          height: 6,
          decoration: BoxDecoration(
            color: Color(0xFF2D3E50),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: _calculateProgressWidth(),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Text(
          '${_calculateUploadedCount()}/8 documents uploaded',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.businessReviewSubmitScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isFormValid ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
              disabledBackgroundColor: Color(0xFF2D3E50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
            ),
            child: Text(
              'Review Business Application',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: controller.isFormValid ? Color(0xFF0C192E) : Colors.white54,
              ),
            ),
          ),
        ),
      ],
    ));
  }

  int _calculateUploadedCount() {
    int count = 0;
    if (controller.businessPanUploaded.value) count++;
    if (controller.gstCertificateUploaded.value) count++;
    if (controller.addressProofUploaded.value) count++;
    if (controller.bankStatementsUploaded.value) count++;
    if (controller.businessLicenseUploaded.value) count++;
    if (controller.itrUploaded.value) count++;
    if (controller.financialStatementsUploaded.value) count++;
    if (controller.ownerKycUploaded.value) count++;
    return count;
  }

  double _calculateProgressWidth() {
    final double screenWidth = Get.width - 40;
    final int uploadedCount = _calculateUploadedCount();
    return (uploadedCount / 8) * screenWidth;
  }

}