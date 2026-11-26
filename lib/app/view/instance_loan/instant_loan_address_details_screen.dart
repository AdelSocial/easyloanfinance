import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/instant_loan_address_controller.dart';


class InstantLoanAddressDetailsScreen extends StatelessWidget {
  final InstantLoanAddressController controller = Get.put(InstantLoanAddressController());

  InstantLoanAddressDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Address Details',
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
            _buildHeaderCard(),
            SizedBox(height: 24),
            _buildCurrentAddressSection(),
            SizedBox(height: 24),
            _buildPermanentAddressSection(),
            SizedBox(height: 32),
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
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
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.5)),
            ),
            child: Icon(
              Icons.location_on_rounded,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Address Verification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Provide your current and permanent address for verification',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentAddressSection() {
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
          SizedBox(height: 8),
          Text(
            'Where you currently reside',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          _buildTextField(
            label: 'Address Line 1',
            hint: 'House No., Building, Street',
            icon: Icons.location_on_outlined,
            onChanged: (value) {
              controller.currentAddressLine1.value = value;
              if (controller.isSameAsCurrent.value) {
                controller.permanentAddressLine1.value = value;
              }
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Address Line 2 (Optional)',
            hint: 'Area, Landmark',
            icon: Icons.map_outlined,
            onChanged: (value) {
              controller.currentAddressLine2.value = value;
              if (controller.isSameAsCurrent.value) {
                controller.permanentAddressLine2.value = value;
              }
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'City',
                  hint: 'Enter city',
                  icon: Icons.location_city_outlined,
                  onChanged: (value) {
                    controller.currentCity.value = value;
                    if (controller.isSameAsCurrent.value) {
                      controller.permanentCity.value = value;
                    }
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'State',
                  hint: 'Enter state',
                  icon: Icons.flag_outlined,
                  onChanged: (value) {
                    controller.currentState.value = value;
                    if (controller.isSameAsCurrent.value) {
                      controller.permanentState.value = value;
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Pincode',
            hint: 'Enter 6-digit pincode',
            icon: Icons.numbers_outlined,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              controller.currentPincode.value = value;
              if (controller.isSameAsCurrent.value) {
                controller.permanentPincode.value = value;
              }
            },
          ),
          SizedBox(height: 16),
          _buildDropdownField(
            label: 'Residence Type',
            hint: 'Select residence type',
            icon: Icons.house_siding_outlined,
            items: [
              'Owned',
              'Rented',
              'Parental',
              'Company Provided',
              'Other'
            ],
            onChanged: (value) => controller.currentResidenceType.value = value ?? '',
          ),
          SizedBox(height: 16),
          _buildDropdownField(
            label: 'Stay Duration',
            hint: 'How long have you lived here?',
            icon: Icons.calendar_today_outlined,
            items: [
              'Less than 6 months',
              '6 months - 1 year',
              '1 - 2 years',
              '2 - 5 years',
              'More than 5 years'
            ],
            onChanged: (value) => controller.currentStayDuration.value = value ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildPermanentAddressSection() {
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
                child: Icon(Icons.assignment_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Permanent Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(() => _buildConsentCheckbox(
            value: controller.isSameAsCurrent.value,
            onChanged: (value) => controller.toggleSameAsCurrent(),
            text: 'Same as Current Address',
          )),
          SizedBox(height: 20),
          Obx(() => !controller.isSameAsCurrent.value
              ? Column(
            children: [
              _buildTextField(
                label: 'Address Line 1',
                hint: 'House No., Building, Street',
                icon: Icons.location_on_outlined,
                onChanged: (value) => controller.permanentAddressLine1.value = value,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Address Line 2 (Optional)',
                hint: 'Area, Landmark',
                icon: Icons.map_outlined,
                onChanged: (value) => controller.permanentAddressLine2.value = value,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'City',
                      hint: 'Enter city',
                      icon: Icons.location_city_outlined,
                      onChanged: (value) => controller.permanentCity.value = value,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'State',
                      hint: 'Enter state',
                      icon: Icons.flag_outlined,
                      onChanged: (value) => controller.permanentState.value = value,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Pincode',
                hint: 'Enter 6-digit pincode',
                icon: Icons.numbers_outlined,
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.permanentPincode.value = value,
              ),
            ],
          )
              : Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF00D4FF), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Permanent address is same as current address',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(icon, color: Color(0xFF00D4FF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              dropdownColor: Color(0xFF1E2E3D),
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(icon, color: Color(0xFF00D4FF)),
                hint: Text(
                  hint,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConsentCheckbox({
    required bool value,
    required Function(bool?) onChanged,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: value ? Color(0xFF00D4FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: value ? Color(0xFF00D4FF) : Colors.white54,
            ),
          ),
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.transparent,
            ),
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.transparent,
              checkColor: Color(0xFF0C192E),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
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