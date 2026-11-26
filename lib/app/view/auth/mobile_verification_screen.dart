
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/mobile_verification_controller.dart';

class MobileVerificationScreen extends StatelessWidget {
  final MobileVerificationController controller = Get.put(MobileVerificationController());

  MobileVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeader(context),
              const SizedBox(height: 10),
              _buildLogoSection(screenHeight, screenWidth),
              const SizedBox(height: 20),
              _buildMobileContent(context),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.3),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
              onPressed: () => Get.back(),
              padding: const EdgeInsets.all(8),
            ),
          ),

          // Step Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.5)),
            ),
            child: const Text(
              'Step 3 of 4',
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

  Widget _buildLogoSection(double height, double width) {
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
              'assets/images/logo2.png',
              height: height / 5,
              width: width / 3,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_balance,
                color: Color(0xFF63b5bb),
                size: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileContent(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2B41),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, spreadRadius: 2)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _stepTag(),
                const SizedBox(width: 8),
                Text(
                  'Mobile Verification',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Enter Your Mobile\nNumber',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              'We will send you a 6-digit OTP to verify your mobile number',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
            ),
            const SizedBox(height: 40),
            _buildMobileNumberField(context),
            const SizedBox(height: 30),
            _buildSendOtpButton(context),
            const SizedBox(height: 25),
            _buildProgressIndicator(),
            const SizedBox(height: 15),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _stepTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF63b5bb).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.5)),
      ),
      child: const Text(
        'Step 3',
        style: TextStyle(color: Color(0xFF63b5bb), fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildMobileNumberField(context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C192E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Country Code
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41).withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '+91',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  color: const Color(0xFF63b5bb).withOpacity(0.8),
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Mobile Number Field
          Expanded(
            child: TextFormField(
              controller: controller.mobileNumberController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                hintText: 'Enter your mobile number',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
                suffixIcon: controller.mobileNumberController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.7)),
                    onPressed: () => controller.mobileNumberController.clear(),
                  )
                      : const SizedBox.shrink(),
              ),
              onChanged: (value) => controller.mobileNumber.value = value,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildSendOtpButton(context) {
    return Obx(() => Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: controller.isLoading.value || !controller.isMobileNumberValid
              ? [Colors.grey, Colors.grey.shade700]
              : [
                  const Color(0xFF63b5bb),
                  const Color(0xFF4a8b90),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: (controller.isLoading.value || !controller.isMobileNumberValid
                    ? Colors.grey
                    : const Color(0xFF63b5bb))
                .withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.isLoading.value || !controller.isMobileNumberValid
              ? null
              : controller.sendOtp,
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: controller.isLoading.value
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Send OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ));
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF63b5bb), Color(0xFF4a8b90)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '75% Completed',
              style: TextStyle(
                color: Color(0xFF63b5bb),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Step 3 of 4',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Text(
        'Empowering Agents. Simplifying Finance.',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontStyle: FontStyle.italic,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}