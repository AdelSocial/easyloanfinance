import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/personal_application_success_controller.dart';

class PersonalApplicationSuccessScreen extends StatelessWidget {

  final PersonalApplicationSuccessController controller = Get.put(PersonalApplicationSuccessController());
  PersonalApplicationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.5)),
                ),
                child: Icon(
                  Icons.check_circle_outlined,
                  size: 80,
                  color: Color(0xFF00D4FF),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Application Submitted!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Your loan application has been successfully submitted. Our team will review your application and get back to you within 24 hours.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.homeScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00D4FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0C192E),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Track application status
                },
                child: Text(
                  'Track Application Status',
                  style: TextStyle(
                    color: Color(0xFF00D4FF),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}