import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/personal_document_controller.dart';


class PersonalDocumentUploadScreen extends StatelessWidget {
  final PersonalDocumentController controller = Get.put(PersonalDocumentController());

  PersonalDocumentUploadScreen({super.key}) {
    // Refresh loan ID when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshLoanId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Personal Loan Application',
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
            // _buildProgressIndicator(),
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
                child: Icon(Icons.folder_open_outlined, size: 24, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Document Upload',
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
            'Upload required documents to complete your loan application',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          Obx(() => controller.currentLoanId.value == null
              ? Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Loan application not found. Please complete previous steps first.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox()),
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
                'Required Documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(() => _buildDocumentItem(
            title: 'Upload PAN Card (Front)',
            icon: Icons.credit_card_outlined,
            documentType: 'PAN Card',
            isUploaded: controller.panCardUploaded.value,
          )),
          SizedBox(height: 16),
          Obx(() => _buildDocumentItem(
            title: 'Upload Aadhaar (Front)',
            icon: Icons.badge_outlined,
            documentType: 'Aadhaar Front',
            isUploaded: controller.aadhaarFrontUploaded.value,
          )),
          SizedBox(height: 16),
          Obx(() => _buildDocumentItem(
            title: 'Upload Aadhaar (Back)',
            icon: Icons.badge_outlined,
            documentType: 'Aadhaar Back',
            isUploaded: controller.aadhaarBackUploaded.value,
          )),
          SizedBox(height: 16),
          Obx(() => _buildDocumentItem(
            title: 'Upload Bank Statement (PDF)',
            icon: Icons.description_outlined,
            documentType: 'Bank Statement',
            isUploaded: controller.bankStatementUploaded.value,
          )),
          SizedBox(height: 16),
          _buildSelfieItem(),
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required String title,
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
          // Document Title
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          // Upload Button
          Obx(() {
            final isLoading = controller.getLoadingState(documentType);
            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => controller.pickImage(documentType),
              style: ElevatedButton.styleFrom(
                backgroundColor: isUploaded ? Colors.green : Color(0xFF00D4FF),
                foregroundColor: Color(0xFF0C192E),
                disabledBackgroundColor: Color(0xFF2D3E50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      isUploaded ? 'Uploaded' : 'Upload',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
            );
          }),
        ],
      ), );
  }

  Widget _buildSelfieItem() {
    return Obx(() => Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF0C192E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: controller.selfieCaptured.value ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
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
              color: controller.selfieCaptured.value ? Color(0xFF00D4FF) : Colors.transparent,
              border: Border.all(
                color: controller.selfieCaptured.value ? Color(0xFF00D4FF) : Colors.white54,
              ),
            ),
            child: controller.selfieCaptured.value
                ? Icon(Icons.check, size: 16, color: Color(0xFF0C192E))
                : SizedBox(),
          ),
          SizedBox(width: 16),
          // Selfie Icon
          Icon(Icons.camera_alt_outlined, color: Color(0xFF00D4FF), size: 24),
          SizedBox(width: 12),
          // Selfie Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Capture Live Selfie',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Ensure good lighting and face the camera directly',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Capture Button
          Obx(() {
            final isLoading = controller.getLoadingState('Selfie');
            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => controller.takeSelfie(),
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.selfieCaptured.value ? Colors.green : Color(0xFF00D4FF),
                foregroundColor: Color(0xFF0C192E),
                disabledBackgroundColor: Color(0xFF2D3E50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt, size: 16),
                        SizedBox(width: 6),
                        Text(
                          controller.selfieCaptured.value ? 'Captured' : 'Capture',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
            );
          }),
        ],
      ),
    ));
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
          '${_calculateUploadedCount()}/5 documents uploaded',
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
            onPressed: controller.isFormValid
                ? () {
                    Get.toNamed(Routes.personalReviewSubmitScreen);
                  }
                : () {
                    controller.submitDocuments();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isFormValid ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
              disabledBackgroundColor: Color(0xFF2D3E50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
            ),
            child: Text(
              controller.isFormValid ? 'Submit Application' : 'Check Documents',
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
    if (controller.panCardUploaded.value) count++;
    if (controller.aadhaarFrontUploaded.value) count++;
    if (controller.aadhaarBackUploaded.value) count++;
    if (controller.bankStatementUploaded.value) count++;
    if (controller.selfieCaptured.value) count++;
    return count;
  }

  double _calculateProgressWidth() {
    final double screenWidth = Get.width - 40; // accounting for padding
    final int uploadedCount = _calculateUploadedCount();
    return (uploadedCount / 5) * screenWidth;
  }
}