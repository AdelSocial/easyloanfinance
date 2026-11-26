import 'dart:io';
import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/new_car_document_controller.dart';


class NewCarDocumentUploadScreen extends StatelessWidget {
  final NewCarDocumentController controller = Get.put(NewCarDocumentController());

  NewCarDocumentUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Document Upload - New Car',
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
            _buildHeaderCard(),
            SizedBox(height: 24),
            _buildKycDocumentsSection(),
            SizedBox(height: 24),
            _buildIncomeDocumentsSection(),
            SizedBox(height: 24),
            _buildCarDocumentsSection(),
            SizedBox(height: 32),
            _buildSubmitButton(),
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
              Icons.folder_open,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Document Upload',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Upload all required documents to complete your new car loan application',
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

  Widget _buildKycDocumentsSection() {
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
                child: Icon(Icons.verified_user_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'KYC Documents',
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
            title: 'PAN Card or Identity Card”',
            subtitle: 'Upload front side of image',
            documentType: 'panCard',
            isUploaded: controller.panCardUploaded.value,
          ),
          SizedBox(height: 16),
          _buildAadhaarDocumentItem(),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Passport Size Photo',
            subtitle: 'Recent white background photo',
            documentType: 'passportPhoto',
            isUploaded: controller.passportPhotoUploaded.value,
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Address Proof',
            subtitle: 'Utility bill, rental agreement, etc.',
            documentType: 'addressProof',
            isUploaded: controller.addressProofUploaded.value,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeDocumentsSection() {
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
                'Income Documents',
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
            title: 'Salary Slips',
            subtitle: 'Last 3 months salary slips',
            documentType: 'salarySlip',
            isUploaded: controller.salarySlipUploaded.value,
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Bank Statements',
            subtitle: 'Last 6 months bank statements',
            documentType: 'bankStatement',
            isUploaded: controller.bankStatementUploaded.value,
          ),
        ],
      ),
    );
  }

  Widget _buildCarDocumentsSection() {
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
                child: Icon(Icons.directions_car, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Car Documents',
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
            title: 'Car Quotation',
            subtitle: 'Dealer quotation for the new car',
            documentType: 'carQuotation',
            isUploaded: controller.carQuotationUploaded.value,
          ),
        ],
      ),
    );
  }

  Widget _buildAadhaarDocumentItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aadhaar Card',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDocumentUploadBox(
                title: 'Front Side',
                documentType: 'aadhaarFront',
                isUploaded: controller.aadhaarFrontFile.value != null,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildDocumentUploadBox(
                title: 'Back Side',
                documentType: 'aadhaarBack',
                isUploaded: controller.aadhaarBackFile.value != null,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(() => Text(
          controller.aadhaarUploaded.value ? '✓ Aadhaar uploaded' : 'Upload both sides',
          style: TextStyle(
            color: controller.aadhaarUploaded.value ? Color(0xFF00D4FF) : Colors.white54,
            fontSize: 12,
          ),
        )),
      ],
    );
  }

  Widget _buildDocumentItem({
    required String title,
    required String subtitle,
    required String documentType,
    required bool isUploaded,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        _buildDocumentUploadBox(
          title: subtitle,
          documentType: documentType,
          isUploaded: isUploaded,
        ),
      ],
    );
  }

  Widget _buildDocumentUploadBox({
    required String title,
    required String documentType,
    required bool isUploaded,
  }) {
    return Obx(() {
      final hasFile = _getFileForDocumentType(documentType) != null;

      return Container(
        decoration: BoxDecoration(
          color: Color(0xFF0C192E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
            width: isUploaded ? 2 : 1,
          ),
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUploaded ? Color(0xFF00D4FF).withOpacity(0.2) : Colors.white10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle : Icons.upload,
              color: isUploaded ? Color(0xFF00D4FF) : Colors.white54,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          trailing: hasFile
              ? IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red, size: 20),
            onPressed: () => controller.removeDocument(documentType),
          )
              : null,
          onTap: () => _showImageSourceDialog(documentType),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
      );
    });
  }

  File? _getFileForDocumentType(String documentType) {
    switch (documentType) {
      case 'panCard':
        return controller.panCardFile.value;
      case 'aadhaarFront':
        return controller.aadhaarFrontFile.value;
      case 'aadhaarBack':
        return controller.aadhaarBackFile.value;
      case 'passportPhoto':
        return controller.passportPhotoFile.value;
      case 'salarySlip':
        return controller.salarySlipFile.value;
      case 'bankStatement':
        return controller.bankStatementFile.value;
      case 'addressProof':
        return controller.addressProofFile.value;
      case 'carQuotation':
        return controller.carQuotationFile.value;
      default:
        return null;
    }
  }

  void _showImageSourceDialog(String documentType) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Color(0xFF1E2E3D),
        title: Text(
          'Upload Document',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Choose image source',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              controller.pickDocument(ImageSource.camera, documentType);
            },
            child: Text('Camera', style: TextStyle(color: Color(0xFF00D4FF))),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.pickDocument(ImageSource.gallery, documentType);
            },
            child: Text('Gallery', style: TextStyle(color: Color(0xFF00D4FF))),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        // onPressed: controller.allDocumentsUploaded ? controller.submitDocuments : null,
        onPressed: (){
          Get.toNamed(Routes.newCarApplicationSubmittedScreen);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.allDocumentsUploaded ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
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
            color: controller.allDocumentsUploaded ? Color(0xFF0C192E) : Colors.white54,
          ),
        ),
      ),
    ));
  }
}