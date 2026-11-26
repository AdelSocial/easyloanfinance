import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';
import '../routes/app_pages.dart';
import '../view/auth/forgot_password_screen.dart';

class LoginController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var isGoogleSignInLoading = false.obs;

  // Method to handle user login
  Future<void> login({
    required String phoneOrEmail,
    required String password,
  }) async {
    if (phoneOrEmail.isEmpty) {
      Get.snackbar('Error', 'Please enter email or phone', backgroundColor: Colors.white);
      return;
    }

    if (password.isEmpty) {
      Get.snackbar('Error', 'Please enter password', backgroundColor: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      // Use userLogin method for regular users
      final response = await ApiService.userLogin(
        phoneOrEmail: phoneOrEmail.trim(),
        password: password,
      );

      print('User Login response: $response');
      
      // Verify token was saved
      final token = await ApiService.getToken();
      print('Token after login: ${token != null ? "Saved" : "NOT SAVED"}');

      if (response['success'] == true) {
        // Get user data from response
        final userData = response['data']?['user'];
        final userRole = response['data']?['role'] ?? 'user';
        
        Get.snackbar(
          'Success',
          'Login successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to home screen
        Get.offAllNamed(Routes.homeScreen);
      } else {
        String errorMessage = ApiService.msg(response['message'], 'Login failed');
        final statusCode = response['statusCode'] ?? 500;
        
        // Handle specific error messages
        if (statusCode == 401) {
          errorMessage = 'Invalid email/phone or password. Please check your credentials.';
        } else if (statusCode == 403) {
          errorMessage = 'Your account is inactive. Please contact administrator.';
        } else if (statusCode == 422) {
          errorMessage = 'Please fill all required fields correctly.';
        }
        
        final errors = (response['errors'] is Map ? Map<String, dynamic>.from(response['errors'] as Map) : null);
        if (errors != null && errors.isNotEmpty) {
          final errorList = errors.values.expand((e) => e is List ? e : [e]).toList();
          if (errorList.isNotEmpty) {
            errorMessage = errorList.join('\n');
          }
        }
        
        Get.snackbar(
          'Login Failed',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Login Exception: $e');
      Get.snackbar(
        'Error',
        'Connection error. Please check your internet connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to handle forgot password
  void forgotPassword() {
    Get.to(() => ForgotPasswordScreen());
  }

  // Method to handle Google Sign In
  Future<void> signInWithGoogle() async {
    // Prevent concurrent calls
    if (isGoogleSignInLoading.value) {
      return;
    }
    
    isGoogleSignInLoading.value = true;
    
    try {
      // Initialize Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Sign out first to ensure fresh sign in
      // await googleSignIn.signOut();

      // Sign in with Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign in
        isGoogleSignInLoading.value = false;
        return;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase Authentication
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      // Get Firebase user
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Get user details
        final String email = firebaseUser.email ?? googleUser.email;
        final String name = firebaseUser.displayName ?? googleUser.displayName ?? '';
        final String? photoUrl = firebaseUser.photoURL ?? googleUser.photoUrl;

        // Get Firebase ID token for backend authentication
        try {
          final String? firebaseToken = await firebaseUser.getIdToken();
          
          if (firebaseToken != null) {
            // Try to authenticate with backend using Firebase token
            try {
              final backendResponse = await ApiService.googleSignIn(
                firebaseToken: firebaseToken,
                email: email,
                name: name,
              );
              
              if (backendResponse['success'] == true || backendResponse['token'] != null) {
                // Backend authentication successful, token saved
                Get.snackbar(
                  'Success',
                  'Google Sign In successful!\nEmail: $email\nName: $name',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              } else {
                // Backend endpoint might not exist, but Firebase sign in is successful
                Get.snackbar(
                  'Success',
                  'Google Sign In successful!\nNote: Backend authentication pending',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              }
            } catch (e) {
              // Backend authentication failed, but Firebase sign in is successful
              // User can still use the app, but API calls might fail
              print('Backend authentication error: $e');
              Get.snackbar(
                'Success',
                'Google Sign In successful!\nEmail: $email\nName: $name',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            }
          } else {
            // No Firebase token, but sign in is successful
            Get.snackbar(
              'Success',
              'Google Sign In successful!\nEmail: $email\nName: $name',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
        } catch (e) {
          // Error getting Firebase token, but sign in is successful
          print('Error getting Firebase token: $e');
          Get.snackbar(
            'Success',
            'Google Sign In successful!\nEmail: $email\nName: $name',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
        
        // Navigate to home screen
        Get.offAllNamed(Routes.homeScreen);
      } else {
        throw Exception('Failed to sign in to Firebase');
      }

    } catch (e) {
      print("object${e.toString()}");
      Get.snackbar(
        'Error',
        'Google Sign In failed: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isGoogleSignInLoading.value = false;
    }
  }

  // Method to handle social login (deprecated, use signInWithGoogle instead)
  void socialLogin(String platform) {
    if (platform.toLowerCase() == 'google') {
      signInWithGoogle();
    } else {
      Get.snackbar('Social Login', 'Logging in with $platform');
    }
  }
}