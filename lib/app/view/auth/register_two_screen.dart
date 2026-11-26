
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/register_two_controller.dart';


class RegisterTwoScreen extends StatelessWidget {
  final  RegisterTwoController controller = Get.put(RegisterTwoController());

   RegisterTwoScreen({super.key});

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
              const SizedBox(height: 10),
              _buildLogoSection(context),
              const SizedBox(height: 10),
              _buildAddressForm(context, controller),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _backButton(context),
          _stepIndicator(),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return Container(
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
      ),
    );
  }

  Widget _stepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B41),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF63b5bb).withOpacity(0.5),
        ),
      ),
      child: const Text(
        'Step 2 of 4',
        style: TextStyle(
          color: Color(0xFF63b5bb),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Logo Section
  Widget _buildLogoSection(BuildContext context) {
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
              height: context.height / 4,
              width: context.width / 2.5,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Address Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Complete your profile information',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Address Form
  Widget _buildAddressForm(BuildContext context, RegisterTwoController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2B41),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFF63b5bb).withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _formHeader(),
            const SizedBox(height: 25),
            _buildInputField(controller.addressController, 'Full Address', Icons.home_outlined),
            const SizedBox(height: 16),
            _buildInputField(controller.cityController, 'City', Icons.location_city_outlined),
            const SizedBox(height: 16),
            _buildInputField(controller.stateController, 'State', Icons.map_outlined),
            const SizedBox(height: 16),
            _buildInputField(controller.postalCodeController, 'Postal Code', Icons.numbers_outlined, keyboardType: TextInputType.number),
            const SizedBox(height: 25),
            _nextButton(controller),
            const SizedBox(height: 15),
            _progressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _formHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF63b5bb).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.5)),
          ),
          child: const Text(
            'Step 2',
            style: TextStyle(
              color: Color(0xFF63b5bb),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Address Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C192E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF63b5bb).withOpacity(0.2),
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color(0xFF63b5bb), size: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }

  Widget _nextButton(RegisterTwoController controller) {
    return Obx(() => Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: controller.isLoading.value
              ? [Colors.grey, Colors.grey.shade700]
              : [const Color(0xFF63b5bb), const Color(0xFF4a8b90)],
        ),
      ),
      child: InkWell(
        onTap: controller.isLoading.value ? null : controller.goToNextStep,
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
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue to Step 2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                  ],
                ),
        ),
      ),
    ));
  }

  Widget _progressIndicator() {
    return Column(
      children: [
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
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
                  color: Colors.white.withOpacity(0.1),
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
              '50% Completed',
              style: TextStyle(
                color: Color(0xFF63b5bb),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Step 2 of 4',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
