
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/register_controller.dart';
import 'package:easy_loan_finance/app/routes/app_pages.dart';

class RegistrationScreen extends StatelessWidget {

  final RegistrationController controller = Get.put(RegistrationController());

   RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildLogoSection(context),
              const SizedBox(height: 10),
              _buildRegistrationForm(controller, context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- HEADER ----------
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
              onPressed: () => Get.back(),
              padding: const EdgeInsets.all(8),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.5)),
            ),
            child: const Text(
              'Step 1 of 4',
              style: TextStyle(
                color: Color(0xFF63b5bb),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- LOGO SECTION ----------
  Widget _buildLogoSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41).withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.3), width: 2),
            ),
            child: Image.asset(
              'assets/images/logo2.png',
              height: context.height / 6,
              width: context.width / 3,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.account_balance, color: Color(0xFF63b5bb), size: 60),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Easy Loan Finance',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            'Create Your Account',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ---------- REGISTRATION FORM ----------
  Widget _buildRegistrationForm(RegistrationController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2B41),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepTitle(),
            const SizedBox(height: 20),
            _buildInputField(controller.fullNameController, 'Full Name', Icons.person_outline),
            const SizedBox(height: 16),
            _buildInputField(controller.emailController, 'Email Address', Icons.mail_outline, keyboardType: TextInputType.emailAddress),
            // const SizedBox(height: 16),
            // _buildInputField(controller.phoneController, 'Phone Number', Icons.phone_android, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildInputField(controller.referralCodeController, 'Referral Code', Icons.card_giftcard_outlined),
            const SizedBox(height: 16),

            // Password
            Obx(() => _buildInputField(
              controller.passwordController,
              'Password',
              Icons.lock_outline,
              isPassword: true,
              showPassword: controller.showPassword.value,
              onTogglePasswordVisibility: () => controller.showPassword.toggle(),
            )),
            const SizedBox(height: 16),

            // Confirm Password
            Obx(() => _buildInputField(
              controller.confirmPasswordController,
              'Confirm Password',
              Icons.lock_outline,
              isPassword: true,
              showPassword: controller.showConfirmPassword.value,
              onTogglePasswordVisibility: () => controller.showConfirmPassword.toggle(),
            )),
            const SizedBox(height: 5),

            // Terms Checkbox
            Obx(() => _buildTermsCheckbox(controller)),
            const SizedBox(height: 20),

            // Next Button
            _buildNextButton(controller),
            const SizedBox(height: 20),

            _buildLoginSection(),
            const SizedBox(height: 15),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ---------- SMALL WIDGETS ----------
  Widget _buildStepTitle() => Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF63b5bb).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Step 1', style: TextStyle(color: Color(0xFF63b5bb), fontSize: 12, fontWeight: FontWeight.w600)),
      ),
      const SizedBox(width: 8),
      const Text('Registration', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
    ],
  );

  Widget _buildInputField(
      TextEditingController controller,
      String hintText,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
        bool isPassword = false,
        bool showPassword = false,
        VoidCallback? onTogglePasswordVisibility,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C192E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.2), width: 1.5),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        keyboardType: keyboardType,
        obscureText: isPassword && !showPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color(0xFF63b5bb)),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: const Color(0xFF63b5bb)),
            onPressed: onTogglePasswordVisibility,
          )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(RegistrationController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Checkbox(
            value: controller.agreeToTerms.value,
            onChanged: (value) => controller.agreeToTerms.value = value ?? false,
            activeColor: const Color(0xFF63b5bb),
            side: const BorderSide(color: Colors.white54),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'I agree to the ', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                const TextSpan(text: 'Terms and Conditions', style: TextStyle(color: Color(0xFF63b5bb))),
                TextSpan(text: ' and ', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                const TextSpan(text: 'Privacy Policy', style: TextStyle(color: Color(0xFF63b5bb))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(RegistrationController controller) {
    return Obx(() => ElevatedButton(
      onPressed: controller.isLoading.value ? null : controller.goToNextScreen,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF63b5bb),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        disabledBackgroundColor: Colors.grey,
      ),
      child: controller.isLoading.value
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text('Next', style: TextStyle(fontSize: 18, color: Colors.white)),
    ));
  }

  Widget _buildLoginSection() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Already have an account? ', style: TextStyle(color: Colors.white.withOpacity(0.7))),
      GestureDetector(
        onTap: () {
          Get.offAllNamed(Routes.login);
        },
        child: const Text('Log In', style: TextStyle(color: Color(0xFF63b5bb), fontWeight: FontWeight.w600)),
      ),
    ],
  );

  Widget _buildFooter() => const Center(
    child: Text(
      'Empowering Agents. Simplifying Finance.',
      style: TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic),
    ),
  );
}
