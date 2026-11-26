import 'package:easy_loan_finance/app/view/business_loan/unsecured_loan/unsecured_details_screen.dart';
import 'package:easy_loan_finance/app/view/business_loan/unsecured_loan/unsecured_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/unsecured_document_controller.dart';

class UnsecuredDocumentScreen extends StatelessWidget {
  final UnsecuredDocumentController controller = Get.put(UnsecuredDocumentController());

   UnsecuredDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Document Upload - Unsecured Business Loan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0C192E),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              Get.defaultDialog(
                title: 'Document Guidelines',
                titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                backgroundColor: Color(0xFF1E2E3D),
                content: SizedBox(
                  width: Get.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('• Clear, readable documents', style: TextStyle(color: Colors.white70)),
                      Text('• File size: Max 2MB', style: TextStyle(color: Colors.white70)),
                      Text('• Formats: JPG, PNG, PDF', style: TextStyle(color: Colors.white70)),
                      Text('• All fields marked with * are mandatory', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            SizedBox(height: 20),
            _buildIdentityDocumentsSection(),
            SizedBox(height: 20),
            _buildBusinessDocumentsSection(),
            SizedBox(height: 20),
            _buildFinancialDocumentsSection(),
            SizedBox(height: 20),
            _buildAdditionalDocumentsSection(),
            SizedBox(height: 30),
            _buildSubmitButton(),
            SizedBox(height: 20),
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
        borderRadius: BorderRadius.circular(16),
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
                child: Icon(Icons.folder_open, size: 24, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Upload Documents',
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
            'Please upload clear copies of all required documents for your unsecured business loan application',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                Icon(Icons.security, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your documents are securely encrypted and protected',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityDocumentsSection() {
    return _buildDocumentSection(
      title: 'Identity & Address Proof',
      icon: Icons.verified_user,
      documents: [
        Obx(() => _buildDocumentItem(
          title: 'PAN Card *',
          description: 'Clear copy of PAN card',
          isMandatory: true,
          documentType: 'PAN Card',
          isUploaded: controller.panCardUploaded.value,
        )),
        Obx(() => _buildDocumentItem(
          title: 'Aadhaar Card *',
          description: controller.aadhaarFrontFile.value != null && controller.aadhaarBackFile.value != null
              ? 'Front and Back uploaded'
              : controller.aadhaarFrontFile.value != null
                  ? 'Front uploaded, Back required'
                  : controller.aadhaarBackFile.value != null
                      ? 'Back uploaded, Front required'
                      : 'Front and Back side required',
          isMandatory: true,
          documentType: 'Aadhaar Card',
          isUploaded: controller.aadhaarUploaded.value,
          hasMultipleFiles: true,
        )),
        Obx(() => _buildDocumentItem(
          title: 'Photograph *',
          description: 'Passport size recent photo',
          isMandatory: true,
          documentType: 'Photograph',
          isUploaded: controller.photographUploaded.value,
        )),
        Obx(() => _buildDocumentItem(
          title: 'Signature *',
          description: 'Scanned signature on white paper',
          isMandatory: true,
          documentType: 'Signature',
          isUploaded: controller.signatureUploaded.value,
        )),
      ],
    );
  }

  Widget _buildBusinessDocumentsSection() {
    return _buildDocumentSection(
      title: 'Business Documents',
      icon: Icons.business,
      documents: [
        Obx(() => _buildDocumentItem(
          title: 'Business Proof *',
          description: 'GST Certificate/Shop Act License',
          isMandatory: true,
          documentType: 'Business Proof',
          isUploaded: controller.businessProofUploaded.value,
        )),
        Obx(() => _buildDocumentItem(
          title: 'Business Address Proof *',
          description: 'Utility bill/Rental agreement',
          isMandatory: true,
          documentType: 'Business Address Proof',
          isUploaded: controller.businessAddressProofUploaded.value,
        )),
      ],
    );
  }

  Widget _buildFinancialDocumentsSection() {
    return _buildDocumentSection(
      title: 'Financial Documents',
      icon: Icons.attach_money,
      documents: [
        Obx(() => _buildDocumentItem(
          title: 'Bank Statements *',
          description: 'Last 6 months business account',
          isMandatory: true,
          documentType: 'Bank Statements',
          isUploaded: controller.bankStatementUploaded.value,
        )),
        Obx(() => _buildDocumentItem(
          title: 'ITR Documents',
          description: 'Last 2 years Income Tax Returns',
          isMandatory: false,
          documentType: 'ITR Documents',
          isUploaded: controller.itrUploaded.value,
        )),
      ],
    );
  }

  Widget _buildAdditionalDocumentsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note_add, color: Color(0xFF00D4FF)),
              SizedBox(width: 12),
              Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF0C192E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Document Requirements',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• All documents should be clear and readable\n'
                      '• File size should not exceed 2MB per document\n'
                      '• Supported formats: JPG, PNG, PDF\n'
                      '• Ensure documents are not expired\n'
                      '• Business documents should be in business name',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentSection({
    required String title,
    required IconData icon,
    required List<Widget> documents,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFF00D4FF)),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Column(children: documents),
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required String title,
    required String description,
    required bool isMandatory,
    required String documentType,
    required bool isUploaded,
    bool hasMultipleFiles = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF0C192E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUploaded ? Colors.green : Colors.white24,
          width: isUploaded ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUploaded ? Colors.green.withOpacity(0.1) : Color(0xFF00D4FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle : Icons.circle_outlined,
              color: isUploaded ? Colors.green : Color(0xFF00D4FF),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isMandatory) ...[
                      SizedBox(width: 6),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                if (hasMultipleFiles) ...[
                  SizedBox(height: 4),
                  Text(
                    'Multiple files required',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 12),
          if (!isUploaded)
            Obx(() {
              final isUploading = controller.isDocumentUploading(documentType);
              return ElevatedButton(
                onPressed: (isUploading || controller.isLoading.value) 
                    ? null 
                    : () => controller.pickDocument(documentType),
                style: ElevatedButton.styleFrom(
                  backgroundColor: (isUploading || controller.isLoading.value)
                      ? Color(0xFF2D3E50)
                      : Color(0xFF00D4FF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isUploading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text('Upload'),
              );
            })
          else
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text(
                  'Uploaded',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red, size: 18),
                  onPressed: () => controller.removeDocument(documentType),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF1E2E3D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                controller.isAllMandatoryDocumentsUploaded ? Icons.check_circle : Icons.warning,
                color: controller.isAllMandatoryDocumentsUploaded ? Colors.green : Colors.orange,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.isAllMandatoryDocumentsUploaded
                      ? 'All mandatory documents uploaded. You can now submit your application.'
                      : 'Please upload all mandatory documents marked with * to proceed.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: (controller.isAllMandatoryDocumentsUploaded && !controller.isLoading.value) 
                ? () => controller.submitDocuments() 
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isAllMandatoryDocumentsUploaded && !controller.isLoading.value 
                  ? Color(0xFF00D4FF) 
                  : Color(0xFF2D3E50),
              disabledBackgroundColor: Color(0xFF2D3E50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
            ),
            child: controller.isLoading.value
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Submit Documents',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: controller.isAllMandatoryDocumentsUploaded && !controller.isLoading.value 
                          ? Color(0xFF0C192E) 
                          : Colors.white54,
                    ),
                  ),
          ),
        ),
      ],
    ));
  }
}