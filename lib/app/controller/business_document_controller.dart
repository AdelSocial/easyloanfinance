import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';

class BusinessDocumentController extends GetxController {
  var isLoading = false.obs;
  var currentLoanId = Rxn<int>();

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

  // Document upload status
  var businessPanUploaded = false.obs;
  var gstCertificateUploaded = false.obs;
  var addressProofUploaded = false.obs;
  var bankStatementsUploaded = false.obs;
  var businessLicenseUploaded = false.obs;
  var itrUploaded = false.obs;
  var financialStatementsUploaded = false.obs;
  var ownerKycUploaded = false.obs;

  // Form validation
  get isFormValid =>
      businessPanUploaded.value &&
          gstCertificateUploaded.value &&
          addressProofUploaded.value &&
          bankStatementsUploaded.value &&
          businessLicenseUploaded.value &&
          itrUploaded.value &&
          financialStatementsUploaded.value &&
          ownerKycUploaded.value;

  // Document picker method
  Future<void> pickDocument(String documentType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        await _uploadDocumentToAPI(documentType, filePath);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick document: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _uploadDocumentToAPI(String documentType, String filePath) async {
    if (currentLoanId.value == null) {
      Get.snackbar('Error', 'Loan application not found. Please submit application first.');
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService.uploadDocument(
        loanType: 'business',
        loanId: currentLoanId.value.toString(),
        documentType: documentType.toLowerCase().replaceAll(' ', '_'),
        filePath: filePath,
      );

      if (response['success'] == true) {
        _updateUploadStatus(documentType, true);
        Get.snackbar(
          'Success',
          '$documentType uploaded successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to upload document'),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _updateUploadStatus(String documentType, bool status) {
    switch (documentType) {
      case 'Business PAN':
        businessPanUploaded.value = status;
        break;
      case 'GST Certificate':
        gstCertificateUploaded.value = status;
        break;
      case 'Business Address Proof':
        addressProofUploaded.value = status;
        break;
      case 'Bank Statements':
        bankStatementsUploaded.value = status;
        break;
      case 'Business License':
        businessLicenseUploaded.value = status;
        break;
      case 'ITR Documents':
        itrUploaded.value = status;
        break;
      case 'Financial Statements':
        financialStatementsUploaded.value = status;
        break;
      case 'Owner KYC':
        ownerKycUploaded.value = status;
        break;
    }
  }

  // Reset all documents
  void resetDocuments() {
    businessPanUploaded.value = false;
    gstCertificateUploaded.value = false;
    addressProofUploaded.value = false;
    bankStatementsUploaded.value = false;
    businessLicenseUploaded.value = false;
    itrUploaded.value = false;
    financialStatementsUploaded.value = false;
    ownerKycUploaded.value = false;
  }
}