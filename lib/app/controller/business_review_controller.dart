import 'package:get/get.dart';

class BusinessReviewController extends GetxController {
  // Agreement checkboxes
  var agreeKFS = false.obs;
  var agreeTerms = false.obs;
  var agreeBusinessCompliance = false.obs;

  // Loan details map
  final Map<String, String> loanDetails = {
    'Loan Amount': '₹10,00,000',
    'Interest Rate': '12.5% per annum',
    'Loan Tenure': '36 Months',
    'EMI': '₹33,609',
    'Processing Fee': '₹15,000',
    'Total Repayment': '₹12,09,924',
  };

  // Business details map
  final Map<String, String> businessDetails = {
    'Business Name': 'ABC Enterprises Pvt. Ltd.',
    'Business Type': 'Private Limited',
    'Registration No.': 'U72900MH2023PTC123456',
    'Business Age': '5 Years',
    'Annual Turnover': '₹2.5 Crores',
    'Business Address': '123 Business Street, Mumbai, Maharashtra',
  };

  // Form validation
  bool get isFormValid => agreeKFS.value && agreeTerms.value && agreeBusinessCompliance.value;

  // Submit application method
  void submitApplication() {
    if (isFormValid) {
      // API call or processing logic here
      Get.toNamed('/business-application-success');
    }
  }
}