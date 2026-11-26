import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';

class HomeLoanDocumentController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var currentLoanId = Rxn<int>();

  // Using Maps for better scalability and management
  final Map<String, RxBool> _loadingStates = {};
  final Map<String, RxBool> _pickerActiveStates = {};
  final Map<String, RxBool> _uploadedStates = {};

  @override
  void onInit() {
    super.onInit();
    _loadLoanId();
    _initializeStates();
  }

  // Initialize all states for document types
  void _initializeStates() {
    final documentTypes = [
      'PAN Card',
      'Aadhaar Card',
      'Address Proof',
      'Income Proof',
      'Bank Statements',
      'Property Documents',
      'Photograph',
      'Signature',
    ];

    for (var type in documentTypes) {
      _loadingStates[type] = false.obs;
      _pickerActiveStates[type] = false.obs;
      _uploadedStates[type] = false.obs;
    }
  }

  Future<void> _loadLoanId() async {
    try {
      final loanId = await LoanStorageService.getCurrentLoanId('home');
      if (loanId != null) {
        currentLoanId.value = loanId;
        print('Loaded loan ID: $loanId');
      } else {
        print('No loan ID found in storage');
      }
    } catch (e) {
      print('Error loading loan ID: $e');
    }
  }

  // Get loading state for specific document type
  RxBool getLoadingState(String documentType) {
    return _loadingStates[documentType] ?? false.obs;
  }

  // Get picker active state for specific document type
  RxBool getPickerActiveState(String documentType) {
    return _pickerActiveStates[documentType] ?? false.obs;
  }

  // Get uploaded state for specific document type
  RxBool getUploadedState(String documentType) {
    return _uploadedStates[documentType] ?? false.obs;
  }

  // Get upload status for specific document type
  bool getUploadStatus(String documentType) {
    return _uploadedStates[documentType]?.value ?? false;
  }

  // Form validation - check if all documents are uploaded
  bool get isFormValid {
    return _uploadedStates.values.every((state) => state.value);
  }

  // Count of uploaded documents
  int get uploadedCount {
    return _uploadedStates.values.where((state) => state.value).length;
  }

  // Percentage of uploaded documents
  double get uploadProgress {
    final total = _uploadedStates.length;
    if (total == 0) return 0.0;
    return uploadedCount / total;
  }

  Future<void> pickDocument(String documentType) async {
    // Get specific observables for this document
    final RxBool? pickerActiveObs = _pickerActiveStates[documentType];
    final RxBool? loadingObs = _loadingStates[documentType];
    final RxBool? uploadedObs = _uploadedStates[documentType];

    // Safety checks
    if (pickerActiveObs == null || loadingObs == null || uploadedObs == null) {
      print('Unknown document type: $documentType');
      return;
    }

    // Prevent concurrent picker calls for THIS SPECIFIC DOCUMENT
    if (pickerActiveObs.value) {
      print('Picker already active for $documentType');
      return;
    }

    // Check if this specific document is already uploading
    if (loadingObs.value) {
      print('Already loading $documentType');
      return;
    }

    // Check if document is already uploaded
    if (uploadedObs.value) {
      print('$documentType already uploaded');
      return;
    }

    // Set picker active for THIS SPECIFIC DOCUMENT only
    pickerActiveObs.value = true;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 90,
      );

      if (image != null) {
        print('Image selected for $documentType: ${image.path}');
        await _uploadDocumentToAPI(documentType, image.path);
      } else {
        print('User cancelled image picker for $documentType');
        // User cancelled, reset picker for THIS DOCUMENT only
        pickerActiveObs.value = false;
      }
    } catch (e) {
      print('Error picking image for $documentType: $e');
      Get.snackbar(
        'Error',
        'Failed to pick document: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      // Reset picker for THIS DOCUMENT on error
      pickerActiveObs.value = false;
    }
  }

  Future<void> _uploadDocumentToAPI(String documentType, String filePath) async {
    // Get specific observables for this document
    final RxBool? pickerActiveObs = _pickerActiveStates[documentType];
    final RxBool? loadingObs = _loadingStates[documentType];
    final RxBool? uploadedObs = _uploadedStates[documentType];

    if (pickerActiveObs == null || loadingObs == null || uploadedObs == null) {
      return;
    }

    if (currentLoanId.value == null) {
      Get.snackbar(
        'Error',
        'Loan application not found. Please submit application first.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      pickerActiveObs.value = false;
      return;
    }

    // Set individual loading state
    loadingObs.value = true;

    try {
      print('Uploading $documentType for loan ID: ${currentLoanId.value}');

      final response = await ApiService.uploadDocument(
        loanType: 'home',
        loanId: currentLoanId.value!.toString(),
        documentType: _getApiDocumentType(documentType),
        filePath: filePath,
      );

      if (response['success'] == true) {
        uploadedObs.value = true;
        print('$documentType uploaded successfully');

        Get.snackbar(
          'Success ✅',
          '$documentType uploaded successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: Duration(seconds: 2),
        );
      } else {
        print('API Error for $documentType: ${response['message']}');
        Get.snackbar(
          'Upload Failed',
          ApiService.msg(response['message'], 'Failed to upload $documentType'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Upload error for $documentType: $e');
      Get.snackbar(
        'Connection Error',
        'Failed to upload: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      // Reset loading states for THIS DOCUMENT only
      loadingObs.value = false;
      // Reset picker active for THIS DOCUMENT only
      pickerActiveObs.value = false;

      // Update UI
      update();
    }
  }

  // Convert display document type to API document type
  String _getApiDocumentType(String displayType) {
    switch (displayType) {
      case 'PAN Card':
        return 'pan_card';
      case 'Aadhaar Card':
        return 'aadhaar_card';
      case 'Address Proof':
        return 'address_proof';
      case 'Income Proof':
        return 'income_proof';
      case 'Bank Statements':
        return 'bank_statements';
      case 'Property Documents':
        return 'property_documents';
      case 'Photograph':
        return 'photograph';
      case 'Signature':
        return 'signature';
      default:
        return displayType.toLowerCase().replaceAll(' ', '_');
    }
  }

  // Reset all states (for testing or re-upload)
  void resetAllDocuments() {
    for (var state in _uploadedStates.values) {
      state.value = false;
    }
    for (var state in _loadingStates.values) {
      state.value = false;
    }
    for (var state in _pickerActiveStates.values) {
      state.value = false;
    }
    update();
  }

  // Reset specific document (if user wants to re-upload)
  void resetDocument(String documentType) {
    final uploadedObs = _uploadedStates[documentType];
    final loadingObs = _loadingStates[documentType];
    final pickerObs = _pickerActiveStates[documentType];

    if (uploadedObs != null) uploadedObs.value = false;
    if (loadingObs != null) loadingObs.value = false;
    if (pickerObs != null) pickerObs.value = false;

    update();
  }

  // Check if any document is currently being uploaded
  bool get isAnyUploading {
    return _loadingStates.values.any((state) => state.value);
  }

  // Check if any picker is active
  bool get isAnyPickerActive {
    return _pickerActiveStates.values.any((state) => state.value);
  }

  // Get all document types
  List<String> get documentTypes {
    return _uploadedStates.keys.toList();
  }

  // Get document status for debugging
  Map<String, Map<String, bool>> getDocumentStatus() {
    final Map<String, Map<String, bool>> status = {};

    for (var type in _uploadedStates.keys) {
      status[type] = {
        'uploaded': _uploadedStates[type]?.value ?? false,
        'loading': _loadingStates[type]?.value ?? false,
        'pickerActive': _pickerActiveStates[type]?.value ?? false,
      };
    }

    return status;
  }
}