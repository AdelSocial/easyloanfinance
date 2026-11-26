
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/secured_details_controller.dart';


class SecuredDetailsScreen extends StatelessWidget {
  final SecuredDetailsController controller = Get.put(SecuredDetailsController());

  SecuredDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Secured Loan Application',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0C192E),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline, color: Colors.white70),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildProgressIndicator(),
            _buildHeaderSection(),
            SizedBox(height: 24),
            _buildAddressSection(),
            SizedBox(height: 24),
            _buildKYCSection(),
            SizedBox(height: 32),
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00D4FF).withOpacity(0.1),
            Color(0xFF0C192E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on_outlined, size: 24, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Secured Address Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Please provide your current address details for verification',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.home_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Current Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildAddressField(),
          SizedBox(height: 16),
          _buildCityField(),
          SizedBox(height: 16),
          _buildStateDropdown(),
        ],
      ),
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Address',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF2D3E50)),
          ),
          child: TextField(
            onChanged: (value) => controller.currentAddress.value = value,
            maxLines: 3,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter your complete current address',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(Icons.location_on_outlined, color: Color(0xFF00D4FF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'City',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF2D3E50)),
          ),
          child: TextField(
            onChanged: (value) => controller.city.value = value,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter your city',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(Icons.location_city_outlined, color: Color(0xFF00D4FF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'State',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),

        Obx(() => Container(
          decoration: BoxDecoration(
            color: Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF2D3E50)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              initialValue: controller.selectedState.value.isEmpty
                  ? null
                  : controller.selectedState.value,
              items: controller.states.map((String state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(
                    state,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                controller.selectedState.value = newValue ?? '';
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hint: Text(
                  'Select your state',
                  style: TextStyle(
                    color: Colors.white54, // This will make hint text visible
                    fontSize: 16,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                prefixIcon: Icon(Icons.map_outlined, color: Color(0xFF00D4FF)),
              ),
              dropdownColor: const Color(0xFF1E2E3D),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
              isExpanded: true,
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildKYCSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.verified_user_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'KYC Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Choose your preferred KYC verification method',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          _buildKYCOptions(),
        ],
      ),
    );
  }

  Widget _buildKYCOptions() {
    return Obx(() => Column(
      children: controller.kycMethods.map((method) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              controller.selectedKYCMethod.value = method;
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: controller.selectedKYCMethod.value == method
                    ? Color(0xFF00D4FF).withOpacity(0.1)
                    : Color(0xFF0C192E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.selectedKYCMethod.value == method
                      ? Color(0xFF00D4FF)
                      : Color(0xFF2D3E50),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: controller.selectedKYCMethod.value == method
                            ? Color(0xFF00D4FF)
                            : Colors.white54,
                      ),
                      color: controller.selectedKYCMethod.value == method
                          ? Color(0xFF00D4FF)
                          : Colors.transparent,
                    ),
                    child: controller.selectedKYCMethod.value == method
                        ? Icon(Icons.check, size: 14, color: Color(0xFF0C192E))
                        : SizedBox(),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      method,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _getKYCIcon(method),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }

  Widget _getKYCIcon(String method) {
    IconData icon;
    switch (method) {
      case 'Aadhaar OTP eKYC':
        icon = Icons.sms_outlined;
        break;
      case 'CKYC':
        icon = Icons.fingerprint_outlined;
        break;
      case 'DigiLocker':
        icon = Icons.lock_outline;
        break;
      case 'Video KYC':
        icon = Icons.videocam_outlined;
        break;
      default:
        icon = Icons.verified_user_outlined;
    }
    return Icon(icon, color: Color(0xFF00D4FF), size: 20);
  }

  Widget _buildContinueButton(context) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (controller.isFormValid && !controller.isLoading.value) 
            ? () => controller.submitAddressDetails() 
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isFormValid && !controller.isLoading.value 
              ? Color(0xFF00D4FF) 
              : Color(0xFF2D3E50),
          disabledBackgroundColor: Color(0xFF2D3E50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
        ),
        child: controller.isLoading.value
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: controller.isFormValid && !controller.isLoading.value 
                      ? Color(0xFF0C192E) 
                      : Colors.white54,
                ),
              ),
      ),
    ));
  }
}