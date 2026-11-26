import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/register_three_controller.dart';

class RegisterThreeScreen extends StatelessWidget {
  final RegisterThreeController controller = Get.put(RegisterThreeController());

  RegisterThreeScreen({super.key});

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
              _buildOtpContent(context),
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
              'Step 4 of 4',
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

  Widget _buildOtpContent(context) {
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
              'Verify Your Mobile\nNumber',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              'Enter the 6-digit OTP sent to\n${controller.phoneNumber}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
            ),
            const SizedBox(height: 40),
            _buildOtpFields(context),
            const SizedBox(height: 30),
            Obx(() => Text(
              'Resend OTP in 00:${controller.resendTimer.value.toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Color(0xFF63b5bb),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )),
            const SizedBox(height: 40),
            Obx(() => _buildVerifyButton(context)),
            const SizedBox(height: 25),
            Obx(() => _buildResendLink()),
            const SizedBox(height: 20),
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
        'Step 4',
        style: TextStyle(color: Color(0xFF63b5bb), fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildOtpFields(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) => _buildOtpField(index, context)),
    );
  }

  Widget _buildOtpField(int index, BuildContext context) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF0C192E).withOpacity(0.8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: const Color(0xFF63b5bb).withOpacity(0.5), width: 1.5),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Color(0xFF63b5bb), width: 2.0),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).requestFocus(controller.focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(controller.focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  Widget _buildVerifyButton(context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(colors: [Color(0xFF63b5bb), Color(0xFF4a8b90)]),
        boxShadow: [BoxShadow(color: const Color(0xFF63b5bb).withOpacity(0.4), blurRadius: 10, spreadRadius: 2)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.isLoading.value ? null : controller.verifyOtp,
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: controller.isLoading.value
                ? const CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white))
                : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Verify & Continue',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResendLink() {
    return GestureDetector(
      onTap: controller.resendTimer.value > 0 ? null : controller.resendOtp,
      child: RichText(
        text: TextSpan(
          text: "Didn't receive OTP? ",
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          children: [
            TextSpan(
              text: 'Resend',
              style: TextStyle(
                color: controller.resendTimer.value > 0
                    ? Colors.white.withOpacity(0.3)
                    : const Color(0xFF63b5bb),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Container(
          height: 6,
          decoration: BoxDecoration(color: const Color(0xFF0C192E), borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF63b5bb), Color(0xFF4a8b90)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('100% Completed',
                style: TextStyle(color: Color(0xFF63b5bb), fontSize: 12, fontWeight: FontWeight.w600)),
            Text('Step 4 of 4', style: TextStyle(color: Colors.white54, fontSize: 12)),
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
