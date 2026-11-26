import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';
import '../credit/credit_card_screen.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final TextEditingController _phoneEmailController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginScreen({super.key});

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

              // Login Form
              _buildLoginForm(context),
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
              onPressed: () => Navigator.pop(context),
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
              'Welcome Back',
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
              height: Get.height / 4,
              width: Get.width / 2.5,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.account_balance,
                  color: Color(0xFF63b5bb),
                  size: 60,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Easy Loan Finance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Sign in to your account',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(context) {
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
        child: Column(
          children: [
            // Phone/Email Field
            _buildInputField(
              controller: _phoneEmailController,
              hintText: 'Email',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            // Referral Code Field
            _buildInputField(
              controller: _referralCodeController,
              hintText: 'Referral Code',
              icon: Icons.card_giftcard_outlined,
            ),

            const SizedBox(height: 20),

            // Password Field
            _buildInputField(
              controller: _passwordController,
              hintText: 'Password',
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 30),

            // Login Button
            _buildLoginButton(context),
            const SizedBox(height: 20),

            // Forgot Password
            _buildForgotPassword(),
            const SizedBox(height: 30),

            // Divider
            _buildDivider(),
            const SizedBox(height: 30),

            // Google Sign In
            _buildGoogleSignIn(),
            const SizedBox(height: 20),

            // Register Link
            _buildRegisterLink(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
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
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF63b5bb),
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildLoginButton(context) {
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
          onTap: (controller.isLoading.value || controller.isGoogleSignInLoading.value)
              ? null
              : () {
                  controller.login(
                    phoneOrEmail: _phoneEmailController.text.trim(),
                    password: _passwordController.text,
                  );
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
                : const Text(
                    'Login',
                    style: TextStyle(
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

  Widget _buildForgotPassword() {
    return GestureDetector(
      onTap: controller.forgotPassword,
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: const Color(0xFF63b5bb),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignIn() {
    return Obx(() => AbsorbPointer(
      absorbing: controller.isLoading.value || controller.isGoogleSignInLoading.value,
      child: GestureDetector(
        onTap: () {
          if (!controller.isLoading.value && !controller.isGoogleSignInLoading.value) {
            controller.signInWithGoogle();
          }
        },
        child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0C192E).withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isGoogleSignInLoading.value)
              const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else ...[
              Image.asset(
                "assets/images/google.png",
                height: 24,
                width: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.g_mobiledata,
                    color: Colors.white,
                    size: 28,
                  );
                },
              ),
              const SizedBox(width: 12),
            ],
            Text(
              controller.isGoogleSignInLoading.value ? 'Signing in...' : 'Continue with Google',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    )));
  }

  Widget _buildRegisterLink(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.registrationScreen);
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: const Color(0xFF63b5bb),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 10,),
        GestureDetector(
          onTap: () {
            Get.to(() => CreditCardScreen());
          },
          child: Text(
            'Credit Screen',
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