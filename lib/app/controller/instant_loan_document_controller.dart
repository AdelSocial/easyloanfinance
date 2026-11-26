import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';

class InstantLoanDocumentController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;
  var currentLoanId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    _loadLoanId();
  }

  Future<void> _loadLoanId() async {
    final loanId = await LoanStorageService.getCurrentLoanId('instant');
    if (loanId != null) {
      currentLoanId.value = loanId;
    }
  }

  // Document files
  var aadhaarFront = Rxn<File>();
  var aadhaarBack = Rxn<File>();
  var panCard = Rxn<File>();
  var salarySlip = Rxn<File>();
  var bankStatement = Rxn<File>();
  var photograph = Rxn<File>();

  // Upload status
  var aadhaarFrontUploaded = false.obs;
  var aadhaarBackUploaded = false.obs;
  var panCardUploaded = false.obs;
  var salarySlipUploaded = false.obs;
  var bankStatementUploaded = false.obs;
  var photographUploaded = false.obs;

  // Form Validation
  get isFormValid =>
      aadhaarFrontUploaded.value &&
          aadhaarBackUploaded.value &&
          panCardUploaded.value &&
          salarySlipUploaded.value &&
          bankStatementUploaded.value &&
          photographUploaded.value;

  Future<void> pickDocument(ImageSource source, String documentType) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final file = File(image.path);
        _updateDocument(documentType, file);
        await _uploadDocumentToAPI(documentType, file.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _updateDocument(String documentType, File file) {
    switch (documentType) {
      case 'aadhaarFront':
        aadhaarFront.value = file;
        aadhaarFrontUploaded.value = true;
        break;
      case 'aadhaarBack':
        aadhaarBack.value = file;
        aadhaarBackUploaded.value = true;
        break;
      case 'panCard':
        panCard.value = file;
        panCardUploaded.value = true;
        break;
      case 'salarySlip':
        salarySlip.value = file;
        salarySlipUploaded.value = true;
        break;
      case 'bankStatement':
        bankStatement.value = file;
        bankStatementUploaded.value = true;
        break;
      case 'photograph':
        photograph.value = file;
        photographUploaded.value = true;
        break;
    }
  }

  void removeDocument(String documentType) {
    switch (documentType) {
      case 'aadhaarFront':
        aadhaarFront.value = null;
        aadhaarFrontUploaded.value = false;
        break;
      case 'aadhaarBack':
        aadhaarBack.value = null;
        aadhaarBackUploaded.value = false;
        break;
      case 'panCard':
        panCard.value = null;
        panCardUploaded.value = false;
        break;
      case 'salarySlip':
        salarySlip.value = null;
        salarySlipUploaded.value = false;
        break;
      case 'bankStatement':
        bankStatement.value = null;
        bankStatementUploaded.value = false;
        break;
      case 'photograph':
        photograph.value = null;
        photographUploaded.value = false;
        break;
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
        loanType: 'instant',
        loanId: currentLoanId.value.toString(),
        documentType: documentType,
        filePath: filePath,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Document uploaded successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Revert upload status on failure
        removeDocument(documentType);
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to upload document'),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      removeDocument(documentType);
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

  void submitDocuments() {
    if (isFormValid) {
      Get.snackbar(
        'Success',
        'All documents uploaded successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Incomplete',
        'Please upload all required documents',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
}