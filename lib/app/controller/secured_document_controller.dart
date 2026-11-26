import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../view/business_loan/secured_loan/secured_success_screen.dart';

class SecuredDocumentController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;
  var currentLoanId = Rxn<int>();
  var uploadingDocumentType = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _loadLoanId();
  }

  Future<void> _loadLoanId() async {
    final loanId = await LoanStorageService.getCurrentLoanId('business');
    if (loanId != null) {
      currentLoanId.value = loanId;
    }
  }

  // Identity Documents
  var panCardFile = Rx<File?>(null);
  var aadhaarFrontFile = Rx<File?>(null);
  var aadhaarBackFile = Rx<File?>(null);
  var photographFile = Rx<File?>(null);
  var signatureFile = Rx<File?>(null);

  // Business Documents
  var businessProofFile = Rx<File?>(null);
  var businessAddressProofFile = Rx<File?>(null);
  var gstCertificateFile = Rx<File?>(null);
  var incorporationCertificateFile = Rx<File?>(null);

  // Financial Documents
  var bankStatementFile = Rx<File?>(null);
  var itrFile = Rx<File?>(null);
  var balanceSheetFile = Rx<File?>(null);
  var profitLossFile = Rx<File?>(null);

  // Collateral Documents
  var propertyDocumentsFile = Rx<File?>(null);
  var ownershipProofFile = Rx<File?>(null);
  var valuationReportFile = Rx<File?>(null);
  var propertyTaxReceiptFile = Rx<File?>(null);

  // Upload status
  var panCardUploaded = false.obs;
  var aadhaarUploaded = false.obs;
  var photographUploaded = false.obs;
  var signatureUploaded = false.obs;
  var businessProofUploaded = false.obs;
  var businessAddressProofUploaded = false.obs;
  var gstCertificateUploaded = false.obs;
  var bankStatementUploaded = false.obs;
  var itrUploaded = false.obs;
  var propertyDocumentsUploaded = false.obs;
  var ownershipProofUploaded = false.obs;
  var valuationReportUploaded = false.obs;

  // Validation
  bool get isAllMandatoryDocumentsUploaded {
    return panCardUploaded.value &&
        aadhaarUploaded.value &&
        photographUploaded.value &&
        signatureUploaded.value &&
        businessProofUploaded.value &&
        businessAddressProofUploaded.value &&
        bankStatementUploaded.value &&
        itrUploaded.value &&
        propertyDocumentsUploaded.value &&
        ownershipProofUploaded.value &&
        valuationReportUploaded.value;
  }

  Future<void> pickDocument(String documentType) async {
    if (currentLoanId.value == null) {
      Get.snackbar(
        'Error',
        'Loan application not found. Please submit application first.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // For Aadhaar Card, check if we need front or back
      if (documentType == 'Aadhaar Card') {
        if (aadhaarFrontFile.value == null) {
          await _pickAadhaarSide('Aadhaar Front');
        } else if (aadhaarBackFile.value == null) {
          await _pickAadhaarSide('Aadhaar Back');
        } else {
          Get.snackbar(
            'Info',
            'Both Aadhaar sides are already uploaded',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
          );
        }
        return;
      }

      // Show source selection dialog
      final source = await Get.dialog<ImageSource>(
        AlertDialog(
          backgroundColor: Color(0xFF1E2E3D),
          title: Text(
            'Select Source',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF00D4FF)),
                title: Text('Gallery', style: TextStyle(color: Colors.white)),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFF00D4FF)),
                title: Text('Camera', style: TextStyle(color: Colors.white)),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file, color: Color(0xFF00D4FF)),
                title: Text('File Picker (PDF)', style: TextStyle(color: Colors.white)),
                onTap: () => Get.back(result: null), // null means file picker
              ),
            ],
          ),
        ),
      );

      String? filePath;

      if (source == null) {
        // Use file picker for PDFs
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        );

        if (result != null && result.files.single.path != null) {
          filePath = result.files.single.path!;
        } else {
          return;
        }
      } else {
        // Use image picker
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 2048,
          maxHeight: 2048,
          imageQuality: 90,
        );

        if (image != null) {
          filePath = image.path;
        } else {
          return;
        }
      }

      if (filePath != null) {
        await _uploadDocumentToAPI(documentType, filePath);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick document: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickAadhaarSide(String side) async {
    try {
      final source = await Get.dialog<ImageSource>(
        AlertDialog(
          backgroundColor: Color(0xFF1E2E3D),
          title: Text(
            'Select Source for $side',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF00D4FF)),
                title: Text('Gallery', style: TextStyle(color: Colors.white)),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFF00D4FF)),
                title: Text('Camera', style: TextStyle(color: Colors.white)),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (image != null) {
        await _uploadDocumentToAPI(side, image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick $side: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _uploadDocumentToAPI(String documentType, String filePath) async {
    if (currentLoanId.value == null) {
      Get.snackbar(
        'Error',
        'Loan application not found. Please submit application first.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    uploadingDocumentType.value = documentType;
    isLoading.value = true;

    try {
      // Convert document type to API format
      String apiDocumentType = documentType.toLowerCase().replaceAll(' ', '_');
      
      final response = await ApiService.uploadDocument(
        loanType: 'business',
        loanId: currentLoanId.value.toString(),
        documentType: apiDocumentType,
        filePath: filePath,
      );

      if (response['success'] == true) {
        _updateDocumentStatus(documentType, File(filePath));
        Get.snackbar(
          'Success',
          '$documentType uploaded successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to upload document'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      uploadingDocumentType.value = null;
    }
  }

  void _updateDocumentStatus(String documentType, File file) {
    switch (documentType) {
      case 'PAN Card':
      case 'pan_card':
        panCardFile.value = file;
        panCardUploaded.value = true;
        break;
      case 'Aadhaar Front':
      case 'aadhaar_front':
        aadhaarFrontFile.value = file;
        if (aadhaarBackFile.value != null) {
          aadhaarUploaded.value = true;
        }
        break;
      case 'Aadhaar Back':
      case 'aadhaar_back':
        aadhaarBackFile.value = file;
        if (aadhaarFrontFile.value != null) {
          aadhaarUploaded.value = true;
        }
        break;
      case 'Photograph':
      case 'photograph':
        photographFile.value = file;
        photographUploaded.value = true;
        break;
      case 'Signature':
      case 'signature':
        signatureFile.value = file;
        signatureUploaded.value = true;
        break;
      case 'Business Proof':
      case 'business_proof':
        businessProofFile.value = file;
        businessProofUploaded.value = true;
        break;
      case 'Business Address Proof':
      case 'business_address_proof':
        businessAddressProofFile.value = file;
        businessAddressProofUploaded.value = true;
        break;
      case 'GST Certificate':
      case 'gst_certificate':
        gstCertificateFile.value = file;
        gstCertificateUploaded.value = true;
        break;
      case 'Bank Statements':
      case 'bank_statements':
        bankStatementFile.value = file;
        bankStatementUploaded.value = true;
        break;
      case 'ITR Documents':
      case 'itr_documents':
        itrFile.value = file;
        itrUploaded.value = true;
        break;
      case 'Property Documents':
      case 'property_documents':
        propertyDocumentsFile.value = file;
        propertyDocumentsUploaded.value = true;
        break;
      case 'Ownership Proof':
      case 'ownership_proof':
        ownershipProofFile.value = file;
        ownershipProofUploaded.value = true;
        break;
      case 'Valuation Report':
      case 'valuation_report':
        valuationReportFile.value = file;
        valuationReportUploaded.value = true;
        break;
      case 'Property Tax Receipt':
      case 'property_tax_receipt':
        propertyTaxReceiptFile.value = file;
        break;
    }
  }

  void removeDocument(String documentType) {
    switch (documentType) {
      case 'PAN Card':
        panCardFile.value = null;
        panCardUploaded.value = false;
        break;
      case 'Aadhaar Card':
        aadhaarFrontFile.value = null;
        aadhaarBackFile.value = null;
        aadhaarUploaded.value = false;
        break;
      case 'Photograph':
        photographFile.value = null;
        photographUploaded.value = false;
        break;
      case 'Signature':
        signatureFile.value = null;
        signatureUploaded.value = false;
        break;
      case 'Business Proof':
        businessProofFile.value = null;
        businessProofUploaded.value = false;
        break;
      case 'Business Address Proof':
        businessAddressProofFile.value = null;
        businessAddressProofUploaded.value = false;
        break;
      case 'GST Certificate':
        gstCertificateFile.value = null;
        gstCertificateUploaded.value = false;
        break;
      case 'Bank Statements':
        bankStatementFile.value = null;
        bankStatementUploaded.value = false;
        break;
      case 'ITR Documents':
        itrFile.value = null;
        itrUploaded.value = false;
        break;
      case 'Property Documents':
        propertyDocumentsFile.value = null;
        propertyDocumentsUploaded.value = false;
        break;
      case 'Ownership Proof':
        ownershipProofFile.value = null;
        ownershipProofUploaded.value = false;
        break;
      case 'Valuation Report':
        valuationReportFile.value = null;
        valuationReportUploaded.value = false;
        break;
      case 'Property Tax Receipt':
        propertyTaxReceiptFile.value = null;
        break;
    }
  }

  Future<void> submitDocuments() async {
    if (!isAllMandatoryDocumentsUploaded) {
      Get.snackbar(
        'Incomplete',
        'Please upload all mandatory documents marked with * including collateral documents',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return;
    }

    isLoading.value = true;

    try {
      // All documents are already uploaded via API
      // Just navigate to success screen
      Get.snackbar(
        'Success',
        'All documents submitted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      await Future.delayed(Duration(milliseconds: 500));
      Get.to(() => SecuredSuccessScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit documents: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Check if a specific document is currently uploading
  bool isDocumentUploading(String documentType) {
    return uploadingDocumentType.value == documentType && isLoading.value;
  }
}