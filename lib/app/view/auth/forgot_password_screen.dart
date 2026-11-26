import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';
import '../../services/api_service.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final RxInt _currentStep = 0.obs;
  final RxBool _isOtpSent = false.obs;
  final RxBool _isOtpVerified = false.obs;
  final RxString _passwordText = ''.obs;

  ForgotPasswordScreen({super.key}) {
    // Listen to password changes for reactive requirements
    _newPasswordController.addListener(() {
      _passwordText.value = _newPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header with Back Button
              _buildHeader(context),

              // Logo Section
              _buildLogoSection(),

              // Forgot Password Form
              _buildForgotPasswordForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
              onPressed: () => Get.back(),
              padding: const EdgeInsets.all(8),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Text(
              'Reset Password',
              style: TextStyle(
                color: const Color(0xFF63b5bb),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41).withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Image.asset(
              "assets/images/logo2.png",
              height: Get.height / 5,
              width: Get.width / 3,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.lock_reset,
                  color: Color(0xFF63b5bb),
                  size: 50,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Reset Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 5),
          Obx(() => Text(
            _getStepSubtitle(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          )),
        ],
      ),
    );
  }

  String _getStepSubtitle() {
    switch (_currentStep.value) {
      case 0:
        return 'Enter your email to receive OTP';
      case 1:
        return 'Enter OTP sent to your email';
      case 2:
        return 'Create your new password';
      default:
        return 'Reset your password';
    }
  }

  Widget _buildForgotPasswordForm(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2B41),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFF63b5bb).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Obx(() => Column(
          children: [
            // Progress Steps
            _buildProgressSteps(),
            const SizedBox(height: 30),

            // Step Content
            _buildStepContent(),
            const SizedBox(height: 30),

            // Action Button
            _buildActionButton(),
            const SizedBox(height: 20),

            // Resend OTP (only for step 1)
            if (_currentStep.value == 1 && _isOtpSent.value)
              _buildResendOtpButton(),

            const SizedBox(height: 10),

            // Back to Login
            _buildLoginLink(),
          ],
        )),
      ),
    );
  }

  // Widget _buildProgressSteps() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       _buildStepIndicator(0, 'Email'),
  //       _buildStepConnector(),
  //       _buildStepIndicator(1, 'OTP'),
  //       _buildStepConnector(),
  //       _buildStepIndicator(2, 'Password'),
  //     ],
  //   );
  // }

  Widget _buildProgressSteps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStepIndicator(0, 'Email'),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.only(right: 4,left: 4,bottom: 20),
            color: _currentStep.value >= 1
                ? const Color(0xFF63b5bb)
                : Colors.white.withOpacity(0.3),
          ),
        ),
        _buildStepIndicator(1, 'OTP'),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.only(right: 4,left: 4,bottom: 20),
            color: _currentStep.value >= 2
                ? const Color(0xFF63b5bb)
                : Colors.white.withOpacity(0.3),
          ),
        ),
        _buildStepIndicator(2, 'Password'),
      ],
    );
  }

// _buildStepConnector() method को हटा दें या comment कर दें
/*
Widget _buildStepConnector() {
  return Expanded(
    child: Divider(
      color: Colors.white.withOpacity(0.3),
      thickness: 1,
      height: 1,
    ),
  );
}
*/
  Widget _buildStepIndicator(int stepNumber, String label) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentStep.value >= stepNumber
                ? const Color(0xFF63b5bb)
                : Colors.white.withOpacity(0.1),
            border: Border.all(
              color: const Color(0xFF63b5bb).withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Center(
            child: _currentStep.value > stepNumber
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
              '${stepNumber + 1}',
              style: TextStyle(
                color: _currentStep.value >= stepNumber
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: _currentStep.value >= stepNumber
                ? const Color(0xFF63b5bb)
                : Colors.white.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Divider(
          color: Colors.white.withOpacity(0.3),
          thickness: 1,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep.value) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildOtpStep();
      case 2:
        return _buildPasswordStep();
      default:
        return _buildEmailStep();
    }
  }

  Widget _buildEmailStep() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0C192E).withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF63b5bb).withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: const Color(0xFF63b5bb),
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'We will send a verification code to this email',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0C192E).withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF63b5bb).withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLength: 6,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 8,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '••••••',
              hintStyle: const TextStyle(
                color: Colors.white38,
                fontSize: 18,
                letterSpacing: 8,
              ),
              counterText: '',
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.sms_outlined,
                color: const Color(0xFF63b5bb),
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
            onChanged: (value) {
              // Auto-verify if 6 digits entered
              if (value.length == 6 && _isOtpSent.value) {
                // Optional: Auto-verify can be added here
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Enter 6-digit code sent to ${_emailController.text}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      children: [
        // New Password Field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0C192E).withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF63b5bb).withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'New Password',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.lock_outline,
                color: const Color(0xFF63b5bb),
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Confirm Password Field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0C192E).withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF63b5bb).withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Confirm New Password',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.lock_reset_outlined,
                color: const Color(0xFF63b5bb),
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Password Requirements
        _buildPasswordRequirements(),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    return Obx(() {
      final password = _passwordText.value;
      final hasMinLength = password.length >= 8;
      final hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      final hasLowerCase = password.contains(RegExp(r'[a-z]'));
      final hasDigit = password.contains(RegExp(r'[0-9]'));
      final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0C192E).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password Requirements:',
              style: TextStyle(
                color: const Color(0xFF63b5bb),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildRequirementItem('At least 8 characters long', hasMinLength),
            _buildRequirementItem('Contains uppercase letter', hasUpperCase),
            _buildRequirementItem('Contains lowercase letter', hasLowerCase),
            _buildRequirementItem('Contains number', hasDigit),
            _buildRequirementItem('Contains special character', hasSpecialChar),
          ],
        ),
      );
    });
  }

  Widget _buildRequirementItem(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.circle_outlined,
            color: isValid ? Colors.green : Colors.white.withOpacity(0.3),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isValid ? Colors.white : Colors.white.withOpacity(0.5),
                fontSize: 13,
                decoration: isValid ? null : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Obx(() => Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF63b5bb),
            Color(0xFF4a8b90),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF63b5bb).withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (controller.isLoading.value) return;
            _handleActionButton();
          },
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: controller.isLoading.value
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
              _getActionButtonText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    ));
  }

  String _getActionButtonText() {
    switch (_currentStep.value) {
      case 0:
        return 'Send OTP';
      case 1:
        return 'Verify OTP';
      case 2:
        return 'Reset Password';
      default:
        return 'Continue';
    }
  }

  void _handleActionButton() {
    switch (_currentStep.value) {
      case 0:
        _sendOtp();
        break;
      case 1:
        _verifyOtp();
        break;
      case 2:
        _resetPassword();
        break;
    }
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    controller.isLoading.value = true;

    try {
      final response = await ApiService.forgotPassword(email);

      if (response['success'] == true) {
        _isOtpSent.value = true;
        _currentStep.value = 1;
        
        // Show OTP in development mode if available
        String message = 'Verification code sent to $email';
        if (response['data'] != null && response['data']['otp'] != null) {
          message += '\nOTP: ${response['data']['otp']} (Development mode)';
        }
        
        Get.snackbar(
          'OTP Sent',
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF63b5bb),
          colorText: Colors.white,
          duration: Duration(seconds: response['data'] != null && response['data']['otp'] != null ? 10 : 3),
        );
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Failed to send OTP'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send OTP: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      controller.isLoading.value = false;
    }
  }

  Future<void> _verifyOtp() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter a valid 6-digit OTP',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email is required',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    controller.isLoading.value = true;

    try {
      final response = await ApiService.verifyResetOtp(
        email: email,
        otp: otp,
      );

      if (response['success'] == true) {
        _isOtpVerified.value = true;
        _currentStep.value = 2;
        Get.snackbar(
          'OTP Verified',
          'Successfully verified. Please set your new password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          ApiService.msg(response['message'], 'Invalid or expired OTP'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to verify OTP: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      controller.isLoading.value = false;
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both passwords',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate password requirements
    bool hasUpperCase = newPassword.contains(RegExp(r'[A-Z]'));
    bool hasLowerCase = newPassword.contains(RegExp(r'[a-z]'));
    bool hasDigit = newPassword.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = newPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUpperCase || !hasLowerCase || !hasDigit || !hasSpecialChar) {
      Get.snackbar(
        'Error',
        'Password must contain uppercase, lowercase, number and special character',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
      return;
    }

    if (otp.isEmpty || otp.length != 6) {
      Get.snackbar(
        'Error',
        'OTP is required',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    controller.isLoading.value = true;

    try {
      final response = await ApiService.resetPassword(
        email: email,
        otp: otp,
        password: newPassword,
        passwordConfirmation: confirmPassword,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Password reset successfully. Please login with your new password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        
        // Clear all fields
        _emailController.clear();
        _otpController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        _currentStep.value = 0;
        _isOtpSent.value = false;
        _isOtpVerified.value = false;
        
        Future.delayed(const Duration(seconds: 2), () {
          Get.back(); // Go back to login screen
        });
      } else {
        String errorMessage = ApiService.msg(response['message'], 'Failed to reset password');
        final errors = (response['errors'] is Map ? Map<String, dynamic>.from(response['errors'] as Map) : null);
        
        if (errors != null && errors.isNotEmpty) {
          final errorList = errors.values.expand((e) => e is List ? e : [e]).toList();
          errorMessage = errorList.join('\n');
        }
        
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reset password: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      controller.isLoading.value = false;
    }
  }

  Widget _buildResendOtpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive code? ",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            if (!controller.isLoading.value) {
              _otpController.clear();
              _sendOtp();
            }
          },
          child: Text(
            'Resend OTP',
            style: TextStyle(
              color: const Color(0xFF63b5bb),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Remember password? ",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: Text(
            'Login',
            style: TextStyle(
              color: const Color(0xFF63b5bb),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}