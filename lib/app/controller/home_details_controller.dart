
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/loan_storage_service.dart';
import '../routes/app_pages.dart';

class HomeLoanDetailsController extends GetxController {
  // Loan Details
  var loanAmount = ''.obs;
  var propertyValue = ''.obs;
  var interestRate = ''.obs;
  var loanTenure = ''.obs;

  // Property Details
  var selectedPropertyType = ''.obs;
  var city = ''.obs;
  var builderName = ''.obs;

  // Income Details
  var employmentType = ''.obs;
  var monthlyIncome = ''.obs;

  var isLoading = false.obs;
  var currentLoanId = Rxn<int>();

  // Options
  List<String> propertyTypes = [
    'Under Construction',
    'Ready to Move',
    'Resale',
    'Plot'
  ];

  List<String> employmentTypes = [
    'Salaried',
    'Self Employed Business',
    'Self Employed Professional'
  ];

  List<String> cities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Pune',
    'Ahmedabad'
  ];

  @override
  void onInit() {
    super.onInit();
    _loadLoanId();
  }

  Future<void> _loadLoanId() async {
    final loanId = await LoanStorageService.getCurrentLoanId('home');
    if (loanId != null) {
      currentLoanId.value = loanId;
    }
  }

  // Form validation
  bool get isFormValid {
    return loanAmount.value.trim().isNotEmpty &&
        propertyValue.value.trim().isNotEmpty &&
        employmentType.value.isNotEmpty &&
        monthlyIncome.value.trim().isNotEmpty;
  }

  Future<void> submitHomeLoanDetails() async {
    if (!isFormValid) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (currentLoanId.value == null) {
      Get.snackbar(
        'Error',
        'Loan application not found. Please complete previous steps first.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService.updateHomeLoan(
        currentLoanId.value!,
        {
          'loan_amount': loanAmount.value.trim().isNotEmpty 
              ? double.tryParse(loanAmount.value.trim()) 
              : null,
          'property_value': propertyValue.value.trim().isNotEmpty 
              ? double.tryParse(propertyValue.value.trim()) 
              : null,
          'interest_rate': interestRate.value.trim().isNotEmpty 
              ? double.tryParse(interestRate.value.trim()) 
              : null,
          'loan_tenure': loanTenure.value.trim().isNotEmpty 
              ? int.tryParse(loanTenure.value.trim()) 
              : null,
          'tenure': loanTenure.value.trim().isNotEmpty 
              ? int.tryParse(loanTenure.value.trim()) 
              : null,
          'property_type': selectedPropertyType.value.isNotEmpty 
              ? selectedPropertyType.value 
              : null,
          'city': city.value.isNotEmpty ? city.value : null,
          'builder_name': builderName.value.trim().isNotEmpty 
              ? builderName.value.trim() 
              : null,
          'employment_type': employmentType.value.isNotEmpty 
              ? employmentType.value 
              : null,
          'monthly_income': monthlyIncome.value.trim().isNotEmpty 
              ? double.tryParse(monthlyIncome.value.trim()) 
              : null,
        },
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Home loan details updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to next screen after successful submission
        Get.toNamed(Routes.homeLoanDocumentUploadScreen);
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to update home loan details'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update home loan details: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}