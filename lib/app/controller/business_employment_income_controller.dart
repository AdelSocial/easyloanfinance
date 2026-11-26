import 'package:get/get.dart';

class BusinessEmploymentController extends GetxController {
  // Business Type
  final RxString businessType = ''.obs;
  final List<String> businessTypes = [
    'Proprietorship',
    'Partnership',
    'Private Limited',
    'LLP (Limited Liability Partnership)',
    'Public Limited',
    'One Person Company'
  ];

  // Company Details
  final RxString businessName = ''.obs;
  final RxString registrationNumber = ''.obs;
  final RxString industryType = ''.obs;

  // Financial Details
  final RxString annualTurnover = ''.obs;
  final RxString profitAfterTax = ''.obs;

  // Monthly Revenue
  final RxString monthlyRevenue = ''.obs;
  final List<String> revenueRanges = [
    '₹50,000 - ₹1 Lakh',
    '₹1 Lakh - ₹2 Lakhs',
    '₹2 Lakhs - ₹5 Lakhs',
    '₹5 Lakhs - ₹10 Lakhs',
    '₹10 Lakhs - ₹25 Lakhs',
    '₹25 Lakhs+'
  ];

  // Business Experience
  final RxString businessExperience = ''.obs;
  final List<String> experienceRanges = [
    '0-1 Year',
    '1-3 Years',
    '3-5 Years',
    '5-10 Years',
    '10+ Years'
  ];

  // Additional Information
  final RxString numberOfEmployees = ''.obs;
  final RxString loanPurpose = ''.obs;

  // ✅ Use `bool get` not `RxBool get`
  bool get isFormValid {
    return businessType.isNotEmpty &&
        businessName.isNotEmpty &&
        registrationNumber.isNotEmpty &&
        industryType.isNotEmpty &&
        annualTurnover.isNotEmpty &&
        profitAfterTax.isNotEmpty &&
        monthlyRevenue.isNotEmpty &&
        businessExperience.isNotEmpty &&
        loanPurpose.isNotEmpty;
  }

  void submitBusinessDetails() {
    if (isFormValid) {
      // print('Business Details Submitted:');
      // print('Business Type: ${businessType.value}');
      // print('Business Name: ${businessName.value}');
      // print('Registration: ${registrationNumber.value}');
      // print('Industry: ${industryType.value}');
      // print('Turnover: ${annualTurnover.value}');
      // print('PAT: ${profitAfterTax.value}');
      // print('Monthly Revenue: ${monthlyRevenue.value}');
      // print('Experience: ${businessExperience.value}');
      // print('Employees: ${numberOfEmployees.value}');
      // print('Purpose: ${loanPurpose.value}');
    }
  }
}
