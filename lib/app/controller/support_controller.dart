import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class SupportController extends GetxController {
  // Selected FAQ index for expansion
  var expandedFaqIndex = RxInt(-1);

  // Support options list
  final List<SupportOption> supportOptions = [
    SupportOption(
      icon: Icons.phone_in_talk_outlined,
      title: 'Call Support',
      subtitle: '24/7 Customer Care',
      value: '9950412463',
      type: SupportType.phone,
      color: 0xFF4CAF50,
    ),
    // SupportOption(
    //   icon: Icons.chat_outlined,
    //   title: 'Live Chat',
    //   subtitle: 'Instant Help',
    //   value: 'Start Chat',
    //   type: SupportType.chat,
    //   color: 0xFF2196F3,
    // ),
    // SupportOption(
    //   icon: Icons.email_outlined,
    //   title: 'Email Support',
    //   subtitle: 'Response within 2 hours',
    //   value: 'support@easyloan.com',
    //   type: SupportType.email,
    //   color: 0xFFFF9800,
    // ),
    SupportOption(
      icon: Icons.help_outline,
      title: 'FAQ',
      subtitle: 'Common Questions',
      value: 'View FAQs',
      type: SupportType.faq,
      color: 0xFF9C27B0,
    ),
    // SupportOption(
    //   icon: Icons.location_on_outlined,
    //   title: 'Branch Locator',
    //   subtitle: 'Find Nearest Branch',
    //   value: 'View Branches',
    //   type: SupportType.branch,
    //   color: 0xFFF44336,
    // ),
    SupportOption(
      icon: Icons.chat,
      title: 'WhatsApp',
      subtitle: 'Quick Chat',
      value: '+91 9950412463',
      type: SupportType.whatsapp,
      color: 0xFF25D366,
    ),
  ];

  // FAQ items list
  final List<FaqItem> faqItems = [
    FaqItem(
      question: 'How long does loan approval take?',
      answer: 'Personal loans are approved within 24-48 hours. Home loans may take 3-5 working days for initial approval. The complete process depends on document verification.',
    ),
    FaqItem(
      question: 'What documents are required for home loan?',
      answer: 'For home loan: Income proof (salary slips/ITR), address proof, property documents, identity proof (Aadhaar/PAN), bank statements (6 months), and age proof are required.',
    ),
    FaqItem(
      question: 'Can I prepay my loan?',
      answer: 'Yes, you can prepay your loan after 6 months. Foreclosure charges may apply as per terms. No charges for partial prepayment up to 25% of principal outstanding per year.',
    ),
    FaqItem(
      question: 'What is the maximum loan amount?',
      answer: 'For personal loans: ₹25 lakhs. For home loans: ₹2 crores based on eligibility and property valuation. Business loans: up to ₹50 lakhs.',
    ),
    FaqItem(
      question: 'What is the interest rate?',
      answer: 'Interest rates vary: Personal loans 10.5% - 16% p.a., Home loans 8.4% - 9.5% p.a., Business loans 12% - 18% p.a. Rates depend on credit score and loan amount.',
    ),
    FaqItem(
      question: 'How to check application status?',
      answer: 'You can check your application status in the app under "My Applications" section, or call our customer care. You will receive regular SMS updates.',
    ),
  ];

  // Contact information
  final List<ContactInfo> contactInfo = [
    ContactInfo(
      icon: Icons.access_time_outlined,
      title: 'Working Hours',
      value: 'Mon - Fri: 09:00 AM to 07:00 PM',
    ),
    ContactInfo(
      icon: Icons.email_outlined,
      title: 'Email',
      value: 'support@easyloanfinance.com',
    ),
    ContactInfo(
      icon: Icons.phone_outlined,
      title: 'Emergency',
      value: '9950-412-463',
    ),
    ContactInfo(
      icon: Icons.language_outlined,
      title: 'Website',
      value: 'www.easyloanfinance.com',
    ),
    ContactInfo(
      icon: Icons.location_city_outlined,
      title: 'Head Office',
      value: '123 Financial Street, Mumbai - 400001',
    ),
  ];

  // Methods for handling support options
  void handleSupportOptionTap(SupportOption option) {
    switch (option.type) {
      case SupportType.phone:
        makePhoneCall(option.value);
        break;
      case SupportType.chat:
        startLiveChat();
        break;
      case SupportType.email:
        sendEmail(option.value);
        break;
      case SupportType.faq:
        toggleFaqExpansion();
        break;
      case SupportType.branch:
        viewBranches();
        break;
      case SupportType.whatsapp:
        openWhatsApp(option.value);
        break;
    }
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch phone app',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void startLiveChat() {
    Get.snackbar(
      'Live Chat',
      'Connecting you to our support executive...',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );

    // Simulate chat connection
    Future.delayed(Duration(seconds: 2), () {
      Get.defaultDialog(
        title: 'Live Chat Connected',
        titleStyle: TextStyle(color: Colors.white),
        backgroundColor: Color(0xFF1E2E3D),
        content: Column(
          children: [
            Icon(Icons.chat, size: 50, color: Color(0xFF00D4FF)),
            SizedBox(height: 16),
            Text(
              'You are now connected with our support executive. How can we help you?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('End Chat', style: TextStyle(color: Color(0xFF00D4FF))),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00D4FF)),
            child: Text('Continue Chat', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    });
  }

  void sendEmail(String email) async {
    final Uri url = Uri.parse('mailto:$email?subject=Support Request&body=Hello, I need help with...');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch email app',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Future<void> openWhatsApp(String phone) async {
    try {
      // 1️⃣ Clean phone number
      final cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

      // 2️⃣ Encode message properly
      final message = Uri.encodeComponent(
        "Hello, I need help with my loan application",
      );

      // 3️⃣ WhatsApp deep link (faster if installed)
      final Uri whatsappUrl = Uri.parse(
        "whatsapp://send?phone=$cleanedPhone&text=$message",
      );

      // 4️⃣ Web fallback
      final Uri webUrl = Uri.parse(
        "https://wa.me/$cleanedPhone?text=$message",
      );

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(
          whatsappUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await launchUrl(
          webUrl,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not launch WhatsApp',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void toggleFaqExpansion() {
    if (expandedFaqIndex.value == -1) {
      expandedFaqIndex.value = 0;
    } else {
      expandedFaqIndex.value = -1;
    }
  }

  void expandFaq(int index) {
    expandedFaqIndex.value = index;
  }

  void viewBranches() {
    Get.snackbar(
      'Branch Locator',
      'Branch locator feature coming soon',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void viewAllFaqs() {
    // Show snackbar - FAQ dialog will be handled in the screen
    Get.snackbar(
      'All FAQs',
      'Scroll down to view all frequently asked questions',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Submit support inquiry via API
  var isLoading = false.obs;
  
  Future<void> submitSupportInquiry({
    required String name,
    required String message,
    String? email,
    String? phone,
    String? subject,
  }) async {
    isLoading.value = true;

    try {
      final response = await ApiService.submitSupport({
        'name': name,
        'email': email ?? '',
        'phone': phone ?? '',
        'subject': subject ?? 'General Inquiry',
        'message': message,
      });

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Your inquiry has been submitted successfully. We will contact you soon.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to submit inquiry'),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit inquiry: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

// Models
class SupportOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final SupportType type;
  final int color;

  SupportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.type,
    required this.color,
  });
}

enum SupportType {
  phone,
  chat,
  email,
  faq,
  branch,
  whatsapp,
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({
    required this.question,
    required this.answer,
  });
}

class ContactInfo {
  final IconData icon;
  final String title;
  final String value;

  ContactInfo({
    required this.icon,
    required this.title,
    required this.value,
  });
}