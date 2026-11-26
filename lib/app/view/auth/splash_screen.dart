import 'dart:async';
import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:easy_loan_finance/app/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for splash screen to show
    await Future.delayed(const Duration(seconds: 2));

    try {
      // First check Firebase Auth (for Google Sign In users)
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? firebaseUser = auth.currentUser;
      
      if (firebaseUser != null) {
        // Firebase user is logged in, navigate to home screen
        if (mounted) {
          Get.offAllNamed(Routes.homeScreen);
        }
        return;
      }

      // If no Firebase user, check backend API token
      final isLoggedIn = await ApiService.isLoggedIn();
      
      if (isLoggedIn) {
        // Token exists, validate it by calling profile API
        try {
          final profileResponse = await ApiService.getProfile();
          
          if (profileResponse['statusCode'] == 401) {
            // Token rejected by the server, clear it and go to login
            await ApiService.clearToken();
          } else {
            // Token accepted (or a temporary server issue) - keep the user signed in
            if (mounted) {
              Get.offAllNamed(Routes.homeScreen);
            }
            return;
          }
        } catch (e) {
          // Network problem - keep the saved token and continue to home
          if (mounted) {
            Get.offAllNamed(Routes.homeScreen);
          }
          return;
        }
      }
      
      // No Firebase user and no valid backend token, navigate to login screen
      if (mounted) {
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      // Error checking auth, go to login screen
      if (mounted) {
        Get.offAllNamed(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: Stack(
        children: [
          // Brand logo
          Center(
            child: Image.asset(
              "assets/images/logo2.png",
              width: context.width * 0.7,
              fit: BoxFit.contain,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

