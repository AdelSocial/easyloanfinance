import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../services/api_service.dart';
import '../services/loan_storage_service.dart';

class PersonalDocumentController extends GetxController {
  // Document upload status
  var panCardUploaded = false.obs;
  var aadhaarFrontUploaded = false.obs;
  var aadhaarBackUploaded = false.obs;
  var bankStatementUploaded = false.obs;
  var selfieCaptured = false.obs;

  // File paths (optional - if you want to store file paths)
  var panCardPath = ''.obs;
  var aadhaarFrontPath = ''.obs;
  var aadhaarBackPath = ''.obs;
  var bankStatementPath = ''.obs;
  var selfiePath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  // Validation
  bool get isFormValid {
    return panCardUploaded.value &&
        aadhaarFrontUploaded.value &&
        aadhaarBackUploaded.value &&
        bankStatementUploaded.value &&
        selfieCaptured.value;
  }

  // Individual loading states for each document
  var isLoadingPanCard = false.obs;
  var isLoadingAadhaarFront = false.obs;
  var isLoadingAadhaarBack = false.obs;
  var isLoadingBankStatement = false.obs;
  var isLoadingSelfie = false.obs;
  
  // General loading state (for submit)
  var isLoading = false.obs;
  var currentLoanId = Rxn<int>();
  
  // Helper method to get loading state for a document type
  bool getLoadingState(String documentType) {
    switch (documentType) {
      case 'PAN Card':
        return isLoadingPanCard.value;
      case 'Aadhaar Front':
        return isLoadingAadhaarFront.value;
      case 'Aadhaar Back':
        return isLoadingAadhaarBack.value;
      case 'Bank Statement':
        return isLoadingBankStatement.value;
      case 'Selfie':
        return isLoadingSelfie.value;
      default:
        return false;
    }
  }
  
  // Helper method to set loading state for a document type
  void setLoadingState(String documentType, bool value) {
    switch (documentType) {
      case 'PAN Card':
        isLoadingPanCard.value = value;
        break;
      case 'Aadhaar Front':
        isLoadingAadhaarFront.value = value;
        break;
      case 'Aadhaar Back':
        isLoadingAadhaarBack.value = value;
        break;
      case 'Bank Statement':
        isLoadingBankStatement.value = value;
        break;
      case 'Selfie':
        isLoadingSelfie.value = value;
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadLoanId();
  }

  Future<void> _loadLoanId() async {
    try {
      final loanId = await LoanStorageService.getCurrentLoanId('personal');
      if (loanId != null) {
        currentLoanId.value = loanId;
        print('Loaded loan ID: $loanId');
      } else {
        print('No loan ID found in storage');
        // Try to get from personal application controller if available
        // This is a fallback if loan ID wasn't stored properly
      }
    } catch (e) {
      print('Error loading loan ID: $e');
    }
  }

  // Refresh loan ID (call this if loan was just created)
  Future<void> refreshLoanId() async {
    await _loadLoanId();
  }

  // Upload document to API
  Future<void> uploadDocument(String documentType, String? filePath) async {
    if (filePath == null || filePath.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a file first',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (currentLoanId.value == null) {
      Get.snackbar(
        'Error',
        'Loan application not found. Please submit application first.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    setLoadingState(documentType, true);

    try {
      print('Uploading document: $documentType');
      print('Loan ID: ${currentLoanId.value}');
      print('File path: $filePath');

      final response = await ApiService.uploadDocument(
        loanType: 'personal',
        loanId: currentLoanId.value.toString(),
        documentType: documentType.toLowerCase().replaceAll(' ', '_'),
        filePath: filePath,
      );

      print('Upload response: $response');

      if (response['success'] == true) {
        // Update upload status
        switch (documentType) {
          case 'PAN Card':
            panCardUploaded.value = true;
            panCardPath.value = filePath;
            break;
          case 'Aadhaar Front':
            aadhaarFrontUploaded.value = true;
            aadhaarFrontPath.value = filePath;
            break;
          case 'Aadhaar Back':
            aadhaarBackUploaded.value = true;
            aadhaarBackPath.value = filePath;
            break;
          case 'Bank Statement':
            bankStatementUploaded.value = true;
            bankStatementPath.value = filePath;
            break;
          case 'Selfie':
            selfieCaptured.value = true;
            selfiePath.value = filePath;
            break;
        }

        Get.snackbar(
          'Success',
          '$documentType uploaded successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        String errorMessage = ApiService.msg(response['message'], 'Failed to upload document');
        final errors = (response['errors'] is Map ? Map<String, dynamic>.from(response['errors'] as Map) : null);

        if (errors != null && errors.isNotEmpty) {
          final errorList = <String>[];
          errors.forEach((field, messages) {
            if (messages is List) {
              for (var msg in messages) {
                errorList.add('${field.replaceAll('_', ' ').toUpperCase()}: $msg');
              }
            } else {
              errorList.add('${field.replaceAll('_', ' ').toUpperCase()}: $messages');
            }
          });
          errorMessage = errorList.join('\n');
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          maxWidth: Get.width * 0.9,
        );
      }
    } catch (e) {
      print('Upload error: $e');
      Get.snackbar(
        'Error',
        'Failed to upload document: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      setLoadingState(documentType, false);
    }
  }

  // Image picker for documents
  Future<void> pickImage(String documentType) async {
    try {
      // Check if already uploaded
      bool alreadyUploaded = false;
      switch (documentType) {
        case 'PAN Card':
          alreadyUploaded = panCardUploaded.value;
          break;
        case 'Aadhaar Front':
          alreadyUploaded = aadhaarFrontUploaded.value;
          break;
        case 'Aadhaar Back':
          alreadyUploaded = aadhaarBackUploaded.value;
          break;
        case 'Bank Statement':
          alreadyUploaded = bankStatementUploaded.value;
          break;
      }

      if (alreadyUploaded) {
        // Show option to re-upload
        final shouldReupload = await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: const Color(0xFF1B2B41),
            title: const Text(
              'Re-upload Document',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'This document is already uploaded. Do you want to replace it?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text(
                  'Replace',
                  style: TextStyle(color: Color(0xFF00D4FF)),
                ),
              ),
            ],
          ),
        );

        if (shouldReupload != true) {
          return;
        }
      }

      // For Bank Statement, use file picker to allow PDF
      if (documentType == 'Bank Statement') {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        );

        if (result != null && result.files.single.path != null) {
          await uploadDocument(documentType, result.files.single.path!);
        }
      } else {
        // For images, use image picker
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 1920,
          maxHeight: 1920,
        );
        
        if (image != null) {
          await uploadDocument(documentType, image.path);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Camera for selfie
  Future<void> takeSelfie() async {
    try {
      if (selfieCaptured.value) {
        // Show option to re-capture
        final shouldRecapture = await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: const Color(0xFF1B2B41),
            title: const Text(
              'Re-capture Selfie',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Selfie is already captured. Do you want to capture again?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text(
                  'Recapture',
                  style: TextStyle(color: Color(0xFF00D4FF)),
                ),
              ),
            ],
          ),
        );

        if (shouldRecapture != true) {
          return;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      
      if (image != null) {
        await uploadDocument('Selfie', image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture selfie: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void submitDocuments() {
    if (isFormValid) {
      Get.snackbar(
        'Success',
        'All documents uploaded successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      // Navigate to review screen
      Get.toNamed('/personal-review-submit');
    } else {
      final missingDocs = <String>[];
      if (!panCardUploaded.value) missingDocs.add('PAN Card');
      if (!aadhaarFrontUploaded.value) missingDocs.add('Aadhaar Front');
      if (!aadhaarBackUploaded.value) missingDocs.add('Aadhaar Back');
      if (!bankStatementUploaded.value) missingDocs.add('Bank Statement');
      if (!selfieCaptured.value) missingDocs.add('Selfie');

      Get.snackbar(
        'Incomplete',
        'Please upload all required documents:\n${missingDocs.join(', ')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        maxWidth: Get.width * 0.9,
      );
    }
  }
}