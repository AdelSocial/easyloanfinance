import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/instant_loan_document_controller.dart';
import 'instant_loan_application_success_screen.dart';


class InstantLoanDocumentUploadScreen extends StatelessWidget {
  final InstantLoanDocumentController controller = Get.put(InstantLoanDocumentController());

  InstantLoanDocumentUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Document Upload',
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
            _buildHeaderCard(),
            SizedBox(height: 24),
            _buildAadhaarCardSection(),
            SizedBox(height: 16),
            _buildPanCardSection(),
            SizedBox(height: 16),
            _buildIncomeProofSection(),
            SizedBox(height: 16),
            _buildPhotographSection(),
            SizedBox(height: 32),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
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
              Icons.folder_open_rounded,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Upload Documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Upload required documents for instant loan verification and approval',
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

  Widget _buildAadhaarCardSection() {
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
                child: Icon(Icons.credit_card_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Aadhaar Card',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Upload front and back of your Aadhaar card',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDocumentUploadItem(
                  title: 'Front Side',
                  description: 'Upload front side of Aadhaar',
                  documentType: 'aadhaarFront',
                  icon: Icons.credit_card,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildDocumentUploadItem(
                  title: 'Back Side',
                  description: 'Upload back side of Aadhaar',
                  documentType: 'aadhaarBack',
                  icon: Icons.credit_card,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPanCardSection() {
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
                child: Icon(Icons.badge_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'PAN Card',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Upload clear image of your PAN card',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          _buildDocumentUploadItem(
            title: 'PAN Card',
            description: 'Upload front side of PAN card',
            documentType: 'panCard',
            icon: Icons.badge,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeProofSection() {
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
                child: Icon(Icons.attach_money_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Income Proof',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Upload salary slip and bank statement',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          _buildDocumentUploadItem(
            title: 'Salary Slip',
            description: 'Last 3 months salary slips',
            documentType: 'salarySlip',
            icon: Icons.receipt_long,
          ),
          SizedBox(height: 16),
          _buildDocumentUploadItem(
            title: 'Bank Statement',
            description: 'Last 6 months bank statement',
            documentType: 'bankStatement',
            icon: Icons.account_balance,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotographSection() {
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
                child: Icon(Icons.camera_alt_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Photograph',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Upload recent passport size photograph',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          _buildDocumentUploadItem(
            title: 'Passport Photo',
            description: 'Recent passport size photo',
            documentType: 'photograph',
            icon: Icons.photo_camera,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadItem({
    required String title,
    required String description,
    required String documentType,
    required IconData icon,
  }) {
    return Obx(() {
      bool isUploaded = false;
      switch (documentType) {
        case 'aadhaarFront':
          isUploaded = controller.aadhaarFrontUploaded.value;
          break;
        case 'aadhaarBack':
          isUploaded = controller.aadhaarBackUploaded.value;
          break;
        case 'panCard':
          isUploaded = controller.panCardUploaded.value;
          break;
        case 'salarySlip':
          isUploaded = controller.salarySlipUploaded.value;
          break;
        case 'bankStatement':
          isUploaded = controller.bankStatementUploaded.value;
          break;
        case 'photograph':
          isUploaded = controller.photographUploaded.value;
          break;
      }

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF0C192E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF00D4FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: Color(0xFF00D4FF)),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUploaded)
                  Icon(Icons.check_circle, color: Color(0xFF00D4FF), size: 24)
                else
                  Icon(Icons.upload_outlined, color: Colors.white54, size: 24),
              ],
            ),
            SizedBox(height: 12),
            if (!isUploaded)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showImageSourceDialog(documentType),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00D4FF).withOpacity(0.1),
                        foregroundColor: Color(0xFF00D4FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Color(0xFF00D4FF)),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.removeDocument(documentType),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }

  void _showImageSourceDialog(String documentType) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFF1E2E3D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Color(0xFF00D4FF)),
                  title: Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.back();
                    controller.pickDocument(ImageSource.camera, documentType);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Color(0xFF00D4FF)),
                  title: Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.back();
                    controller.pickDocument(ImageSource.gallery, documentType);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(context) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:  () {
          // Handle document submission
          Get.to(() => InstantLoanApplicationSuccessScreen());
          // Get.toNamed(Routes.instantLoanApplicationReviewScreen); // Update with your actual route
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isFormValid ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
          disabledBackgroundColor: Color(0xFF2D3E50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
        ),
        child: Text(
          'Submit Application',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: controller.isFormValid ? Color(0xFF0C192E) : Colors.white54,
          ),
        ),
      ),
    ));
  }
}