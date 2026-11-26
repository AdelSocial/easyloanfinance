import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';

class OldCarDocumentController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;
  var currentLoanId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    _loadLoanId();
  }

  Future<void> _loadLoanId() async {
    final loanId = await LoanStorageService.getCurrentLoanId('car');
    if (loanId != null) {
      currentLoanId.value = loanId;
    }
  }

  // Document files
  var panCardFile = Rxn<File>();
  var aadhaarFrontFile = Rxn<File>();
  var aadhaarBackFile = Rxn<File>();
  var passportPhotoFile = Rxn<File>();
  var salarySlipFile = Rxn<File>();
  var bankStatementFile = Rxn<File>();
  var addressProofFile = Rxn<File>();
  var carRCFile = Rxn<File>();
  var carInsuranceFile = Rxn<File>();
  var carPhotosFile = Rxn<File>();

  // Upload status
  var panCardUploaded = false.obs;
  var aadhaarUploaded = false.obs;
  var passportPhotoUploaded = false.obs;
  var salarySlipUploaded = false.obs;
  var bankStatementUploaded = false.obs;
  var addressProofUploaded = false.obs;
  var carRCUploaded = false.obs;
  var carInsuranceUploaded = false.obs;
  var carPhotosUploaded = false.obs;

  bool get allDocumentsUploaded =>
      panCardUploaded.value &&
          aadhaarUploaded.value &&
          passportPhotoUploaded.value &&
          salarySlipUploaded.value &&
          bankStatementUploaded.value &&
          addressProofUploaded.value &&
          carRCUploaded.value &&
          carInsuranceUploaded.value &&
          carPhotosUploaded.value;

  Future<void> pickDocument(ImageSource source, String documentType) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 90,
      );

      if (image != null) {
        final File file = File(image.path);
        _assignFileToDocumentType(file, documentType);
        await _uploadDocumentToAPI(documentType, file.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFF0C192E),
        colorText: Colors.white,
      );
    }
  }

  void _assignFileToDocumentType(File file, String documentType) {
    switch (documentType) {
      case 'panCard':
        panCardFile.value = file;
        break;
      case 'aadhaarFront':
        aadhaarFrontFile.value = file;
        break;
      case 'aadhaarBack':
        aadhaarBackFile.value = file;
        break;
      case 'passportPhoto':
        passportPhotoFile.value = file;
        break;
      case 'salarySlip':
        salarySlipFile.value = file;
        break;
      case 'bankStatement':
        bankStatementFile.value = file;
        break;
      case 'addressProof':
        addressProofFile.value = file;
        break;
      case 'carRC':
        carRCFile.value = file;
        break;
      case 'carInsurance':
        carInsuranceFile.value = file;
        break;
      case 'carPhotos':
        carPhotosFile.value = file;
        break;
    }
  }

  void _updateUploadStatus(String documentType, bool status) {
    switch (documentType) {
      case 'panCard':
        panCardUploaded.value = status;
        break;
      case 'aadhaarFront':
      case 'aadhaarBack':
        aadhaarUploaded.value = status;
        break;
      case 'passportPhoto':
        passportPhotoUploaded.value = status;
        break;
      case 'salarySlip':
        salarySlipUploaded.value = status;
        break;
      case 'bankStatement':
        bankStatementUploaded.value = status;
        break;
      case 'addressProof':
        addressProofUploaded.value = status;
        break;
      case 'carRC':
        carRCUploaded.value = status;
        break;
      case 'carInsurance':
        carInsuranceUploaded.value = status;
        break;
      case 'carPhotos':
        carPhotosUploaded.value = status;
        break;
    }
  }

  void removeDocument(String documentType) {
    switch (documentType) {
      case 'panCard':
        panCardFile.value = null;
        panCardUploaded.value = false;
        break;
      case 'aadhaarFront':
        aadhaarFrontFile.value = null;
        break;
      case 'aadhaarBack':
        aadhaarBackFile.value = null;
        break;
      case 'passportPhoto':
        passportPhotoFile.value = null;
        passportPhotoUploaded.value = false;
        break;
      case 'salarySlip':
        salarySlipFile.value = null;
        salarySlipUploaded.value = false;
        break;
      case 'bankStatement':
        bankStatementFile.value = null;
        bankStatementUploaded.value = false;
        break;
      case 'addressProof':
        addressProofFile.value = null;
        addressProofUploaded.value = false;
        break;
      case 'carRC':
        carRCFile.value = null;
        carRCUploaded.value = false;
        break;
      case 'carInsurance':
        carInsuranceFile.value = null;
        carInsuranceUploaded.value = false;
        break;
      case 'carPhotos':
        carPhotosFile.value = null;
        carPhotosUploaded.value = false;
        break;
    }

    // Update Aadhaar status if both front and back are removed
    if (documentType == 'aadhaarFront' || documentType == 'aadhaarBack') {
      if (aadhaarFrontFile.value == null && aadhaarBackFile.value == null) {
        aadhaarUploaded.value = false;
      }
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
        loanType: 'car',
        loanId: currentLoanId.value.toString(),
        documentType: documentType,
        filePath: filePath,
      );

      if (response['success'] == true) {
        _updateUploadStatus(documentType, true);
        Get.snackbar(
          'Success',
          'Document uploaded successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        _updateUploadStatus(documentType, false);
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to upload document'),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _updateUploadStatus(documentType, false);
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
    if (allDocumentsUploaded) {
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
        backgroundColor: Color(0xFF0C192E),
        colorText: Colors.white,
      );
    }
  }
}