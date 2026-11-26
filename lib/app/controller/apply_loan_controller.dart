import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class ApplyLoanController extends GetxController {
  // Loan types data
  final List<LoanType> loanTypes = [
    LoanType(
      id: 1,
      title: "Personal Loan",
      subtitle: "Quick approval • Low interest • Flexible EMI",
      features: ["Up to ₹25 Lakhs", "24-48 hrs approval", "No collateral"],
      icon: Icons.person_outlined,
      gradient: [0xff6A00FF, 0xff9D4DFF],
      route: Routes.personalApplicationScreen,
      isPopular: true,
    ),
    LoanType(
      id: 2,
      title: "Home Loan",
      subtitle: "Best interest rates for your dream home",
      features: ["Up to ₹2 Crores", "Low interest rates", "Long tenure"],
      icon: Icons.home_outlined,
      gradient: [0xff0062FF, 0xff33BBFF],
      route: Routes.homeApplicationScreen,
      isPopular: false,
    ),
    LoanType(
      id: 3,
      title: "Business Loan",
      subtitle: "Grow your business with instant funding",
      features: ["Up to ₹50 Lakhs", "Quick disbursal", "Flexible repayment"],
      icon: Icons.business_center_outlined,
      gradient: [0xff00C68A, 0xff0AFFC8],
      route: Routes.businessApplicationScreen,
      isPopular: false,
    ),
  ];

  // Features list for why choose us section
  final List<FeatureItem> features = [
    FeatureItem(
      icon: Icons.verified_outlined,
      title: "100% Digital Process",
      subtitle: "Complete your application online with minimal documentation",
    ),
    FeatureItem(
      icon: Icons.speed_outlined,
      title: "Instant Approval",
      subtitle: "Get loan approval within 24-48 hours",
    ),
    FeatureItem(
      icon: Icons.security_outlined,
      title: "Safe & Secure",
      subtitle: "Your data is protected with bank-level security",
    ),
    FeatureItem(
      icon: Icons.support_agent_outlined,
      title: "24/7 Support",
      subtitle: "Our team is always here to help you",
    ),
  ];

  // Handle loan type selection
  void selectLoanType(LoanType loanType) {
    // You can add analytics or tracking here
    _logLoanSelection(loanType);

    // Navigate to the respective loan application screen
    Get.toNamed(loanType.route);
  }

  void _logLoanSelection(LoanType loanType) {
    if (kDebugMode) {
      print('User selected: ${loanType.title}');
    }
    // Add analytics tracking here
    // Analytics.track('loan_type_selected', {'loan_type': loanType.title});
  }

  // Get color from hex
  Color getColor(int hexColor) {
    return Color(hexColor);
  }

  // Check if user has pre-approved offers
  bool get hasPreApprovedOffers => true;

  // Get pre-approved amount (you can modify this based on user data)
  String get preApprovedAmount => "₹5,00,000";

  // Get user's credit score (you can integrate with actual data)
  int get userCreditScore => 785;
}

class LoanType {
  final int id;
  final String title;
  final String subtitle;
  final List<String> features;
  final IconData icon;
  final List<int> gradient;
  final String route;
  final bool isPopular;

  LoanType({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.icon,
    required this.gradient,
    required this.route,
    this.isPopular = false,
  });
}

class FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}