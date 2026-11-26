
// controllers/personal_application_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../routes/app_pages.dart';

class PersonalApplicationController extends GetxController {
  // Form fields
  var fullName = ''.obs;
  var dateOfBirth = ''.obs;
  var email = ''.obs;
  var mobileNumber = ''.obs;
  RxString selectedLoanCategory = ''.obs; // Loan category/type
  var consentCreditReport = false.obs;
  var consentAadhaarKYC = false.obs;

  // Categories list
  var categories = <Map<String, dynamic>>[].obs;
  var isLoadingCategories = false.obs;

  // Loan Information
  var loanAmount = ''.obs;
  var loanTenure = ''.obs;

  // KYC and Address Information
  var panNumber = ''.obs;
  var aadhaarNumber = ''.obs;
  var address = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var pincode = ''.obs;
  var kycMethod = ''.obs;
  var ckycNumber = ''.obs;
  var lockerId = ''.obs;
  var videoKyc = false.obs;

  // Nominee Information
  var nomineeName = ''.obs;
  var nomineeRelationship = ''.obs;
  var nomineeDateOfBirth = ''.obs;
  var nomineeMobileNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure checkboxes are unchecked when screen opens
    resetCheckboxes();
    // Load categories from API
    loadCategories();
  }

  // Load loan categories from API
  Future<void> loadCategories() async {
    isLoadingCategories.value = true;
    try {
      final response = await ApiService.getCategories();
      print('Categories API Response: $response');
      
      // Handle different response formats
      bool isSuccess = false;
      List<dynamic> categoriesData = [];
      
      if (response['status'] == 'success') {
        isSuccess = true;
        categoriesData = response['data']?['categories'] ?? [];
      } else if (response['success'] == true) {
        isSuccess = true;
        categoriesData = response['data']?['categories'] ?? [];
      }
      
      if (isSuccess && categoriesData is List) {
        final List<Map<String, dynamic>> categoriesList = categoriesData.map<Map<String, dynamic>>((cat) {
          if (cat is Map<String, dynamic>) {
            return {
              'id': cat['id'],
              'name': cat['name']?.toString() ?? '',
              'description': cat['description']?.toString() ?? '',
            };
          } else {
            // If it's an object, try to access properties
            try {
              return {
                'id': cat.id,
                'name': cat.name?.toString() ?? '',
                'description': cat.description?.toString() ?? '',
              };
            } catch (e) {
              return {
                'id': 0,
                'name': cat.toString(),
                'description': '',
              };
            }
          }
        }).toList();
        
        categories.assignAll(categoriesList);
        print('Categories loaded: ${categories.length}');
      } else {
        print('No categories found in response');
      }
    } catch (e) {
      print('Error loading categories: $e');
      // Keep default categories if API fails - will use fallback in dropdown
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Reset checkboxes to unchecked state
  void resetCheckboxes() {
    consentCreditReport.value = false;
    consentAadhaarKYC.value = false;
  }

  // Email validation regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Mobile validation (10 digits)
  bool _isValidMobile(String mobile) {
    if (mobile.isEmpty) return false;
    // Remove all non-digit characters
    final cleanedMobile = mobile.replaceAll(RegExp(r'[^0-9]'), '');
    // Check if it's exactly 10 digits
    return cleanedMobile.length == 10;
  }

  // Validation
  bool get isFormValid {
    final fullNameValid = fullName.value.trim().isNotEmpty;
    final dateOfBirthValid = dateOfBirth.value.isNotEmpty;
    final emailValid = email.value.trim().isNotEmpty && _isValidEmail(email.value.trim());
    final mobileValid = mobileNumber.value.trim().isNotEmpty && _isValidMobile(mobileNumber.value);
    final loanCategoryValid = selectedLoanCategory.value.trim().isNotEmpty;
    final loanAmountValid = loanAmount.value.trim().isNotEmpty && _isValidLoanAmount(loanAmount.value);
    final consentCreditValid = consentCreditReport.value;
    final consentAadhaarValid = consentAadhaarKYC.value;
    
    final isValid = fullNameValid &&
        dateOfBirthValid &&
        emailValid &&
        mobileValid &&
        loanCategoryValid &&
        loanAmountValid &&
        consentCreditValid &&
        consentAadhaarValid;
    
    return isValid;
  }

  // Loan amount validation
  bool _isValidLoanAmount(String amount) {
    if (amount.isEmpty) return false;
    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) return false;
    return parsedAmount >= 1000 && parsedAmount <= 100000000;
  }

  // Get validation error message
  String? get validationError {
    if (fullName.value.trim().isEmpty) return 'Please enter your full name';
    if (dateOfBirth.value.isEmpty) return 'Please select your date of birth';
    if (email.value.trim().isEmpty) return 'Please enter your email address';
    if (!_isValidEmail(email.value.trim())) return 'Please enter a valid email address';
    if (mobileNumber.value.trim().isEmpty) return 'Please enter your mobile number';
    if (!_isValidMobile(mobileNumber.value.trim())) return 'Please enter a valid 10-digit mobile number';
    if (selectedLoanCategory.value.trim().isEmpty) return 'Please select a loan category';
    if (loanAmount.value.trim().isEmpty) return 'Please enter loan amount';
    if (!_isValidLoanAmount(loanAmount.value)) {
      final amount = double.tryParse(loanAmount.value);
      if (amount == null) return 'Please enter a valid loan amount';
      if (amount < 1000) return 'Minimum loan amount is ₹1,000';
      if (amount > 100000000) return 'Maximum loan amount is ₹10,00,00,000';
      return 'Please enter a valid loan amount';
    }
    if (!consentCreditReport.value) return 'Please consent to credit report retrieval';
    if (!consentAadhaarKYC.value) return 'Please consent to Aadhaar eKYC';
    return null;
  }

  // Date picker
  Future<void> selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF00D4FF),
              onPrimary: Color(0xFF0C192E),
              surface: Color(0xFF1E2E3D),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: Color(0xFF1E2E3D)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateOfBirth.value = '${picked.day.toString().padLeft(2, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.year}';
    }
  }


  void selectNomineeDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF00D4FF),
              onPrimary: Color(0xFF0C192E),
              surface: Color(0xFF1E2E3D),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: Color(0xFF0C192E)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      nomineeDateOfBirth.value = DateFormat('dd-MM-yyyy').format(picked);
    }
  }


  var isLoading = false.obs;

  // Convert date from DD-MM-YYYY to YYYY-MM-DD format
  String? _convertDateFormat(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      // Parse DD-MM-YYYY format
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-$day';
      }
      return dateStr; // Return as is if format is different
    } catch (e) {
      return dateStr;
    }
  }

  // Submit application
  Future<void> submitApplication() async {
    // Check validation and show specific error
    final error = validationError;
    if (error != null) {
      Get.snackbar(
        'Validation Error',
        error,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (!isFormValid) {
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isLoading.value = true;

    try {
      // Prepare data for API
      final Map<String, dynamic> requestData = {
        'full_name': fullName.value.trim(),
        'date_of_birth': _convertDateFormat(dateOfBirth.value) ?? dateOfBirth.value,
        'email': email.value.trim(),
        'mobile': mobileNumber.value.trim(),
        'loan_type': selectedLoanCategory.value.trim(), // Loan category/type
        'loan_amount': double.parse(loanAmount.value.trim()), // Loan amount (required)
      };

      // Add loan tenure (always send, null if empty)
      if (loanTenure.value.isNotEmpty) {
        final tenure = int.tryParse(loanTenure.value);
        requestData['loan_tenure'] = tenure;
      } else {
        requestData['loan_tenure'] = null;
      }

      // Add nominee information (always send, null if empty)
      requestData['nominee_name'] = nomineeName.value.trim().isNotEmpty 
          ? nomineeName.value.trim() 
          : null;
      requestData['nominee_relationship'] = nomineeRelationship.value.trim().isNotEmpty 
          ? nomineeRelationship.value.trim() 
          : null;
      requestData['nominee_date_of_birth'] = nomineeDateOfBirth.value.trim().isNotEmpty 
          ? (_convertDateFormat(nomineeDateOfBirth.value) ?? nomineeDateOfBirth.value) 
          : null;
      requestData['nominee_mobile'] = nomineeMobileNumber.value.trim().isNotEmpty 
          ? nomineeMobileNumber.value.trim() 
          : null;

      // Add KYC and Address fields (send all fields, even if empty)
      requestData['pan_number'] = panNumber.value.trim().isNotEmpty 
          ? panNumber.value.trim().toUpperCase() 
          : null;
      requestData['aadhaar_number'] = aadhaarNumber.value.trim().isNotEmpty 
          ? aadhaarNumber.value.trim() 
          : null;
      requestData['address'] = address.value.trim().isNotEmpty 
          ? address.value.trim() 
          : null;
      requestData['city'] = city.value.trim().isNotEmpty 
          ? city.value.trim() 
          : null;
      requestData['state'] = state.value.trim().isNotEmpty 
          ? state.value.trim() 
          : null;
      requestData['pincode'] = pincode.value.trim().isNotEmpty 
          ? pincode.value.trim() 
          : null;
      
      // Always send kyc_method, even if empty (as null)
      if (kycMethod.value.trim().isNotEmpty) {
        requestData['kyc_method'] = kycMethod.value.trim();
      } else {
        requestData['kyc_method'] = null;
      }
      
      print('KYC Method value in controller: ${kycMethod.value}');
      print('KYC Method being sent to API: ${requestData['kyc_method']}');
      requestData['ckyc_number'] = ckycNumber.value.trim().isNotEmpty 
          ? ckycNumber.value.trim() 
          : null;
      requestData['locker_id'] = lockerId.value.trim().isNotEmpty 
          ? lockerId.value.trim() 
          : null;
      requestData['video_kyc'] = videoKyc.value;

      // Add consent fields
      requestData['consent_credit_report'] = consentCreditReport.value;
      requestData['consent_aadhaar_kyc'] = consentAadhaarKYC.value;

      print('Submitting personal loan application with data: $requestData');

      final response = await ApiService.submitPersonalLoan(requestData);

      print('API Response: $response');

      if (response['success'] == true) {
        // Store loan ID for document upload
        await LoanStorageService.storeLoanFromResponse('personal', response);
        
        Get.snackbar(
          'Success',
          'Loan application submitted successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        // Navigate to next screen after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        Get.toNamed(Routes.personalAddressDetailsScreen);
      } else {
        String errorMessage = ApiService.msg(response['message'], 'Failed to submit application');
        final errors = (response['errors'] is Map ? Map<String, dynamic>.from(response['errors'] as Map) : null);
        
        if (errors != null && errors.isNotEmpty) {
          // Format errors for better display
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
          'Validation Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          maxWidth: Get.width * 0.9,
        );
      }
    } catch (e) {
      print('Error submitting application: $e');
      Get.snackbar(
        'Error',
        'Failed to submit application: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }
}