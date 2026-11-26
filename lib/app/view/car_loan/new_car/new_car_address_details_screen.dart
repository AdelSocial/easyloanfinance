import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/new_car_address_controller.dart';


class NewCarAddressDetailsScreen extends StatelessWidget {
  final NewCarAddressController controller = Get.put(NewCarAddressController());

  NewCarAddressDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Address Details - New Car',
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            SizedBox(height: 24),
            _buildResidentialAddressSection(),
            SizedBox(height: 24),
            _buildAddressDurationSection(),
            SizedBox(height: 24),
            _buildOfficeAddressSection(),
            SizedBox(height: 32),
            _buildSubmitButton(),
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
              Icons.location_on,
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
            'Please provide your current residential and office address details',
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

  Widget _buildResidentialAddressSection() {
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
                'Residential Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildTextField(
            label: 'Address Line 1',
            hint: 'House No., Building, Street',
            icon: Icons.home_work_outlined,
            onChanged: (value) => controller.addressLine1.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Address Line 2',
            hint: 'Area, Locality',
            icon: Icons.location_city_outlined,
            onChanged: (value) => controller.addressLine2.value = value,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'City',
                  hint: 'Enter city',
                  icon: Icons.location_city,
                  onChanged: (value) => controller.city.value = value,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'Pincode',
                  hint: 'Pincode',
                  icon: Icons.pin_drop_outlined,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.pincode.value = value,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildResidenceTypeDropdown(),
        ],
      ),
    );
  }

  Widget _buildAddressDurationSection() {
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
                child: Icon(Icons.calendar_today_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Duration at Current Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Years',
                  hint: 'Years',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.yearsAtCurrentAddress.value = value,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'Months',
                  hint: 'Months',
                  icon: Icons.date_range,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => controller.monthsAtCurrentAddress.value = value,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeAddressSection() {
    return Obx(() => Container(
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
                child: Icon(Icons.business_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Office Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: controller.sameAsResidential.value,
                onChanged: (value) => controller.toggleSameAsResidential(),
                activeColor: Color(0xFF00D4FF),
                checkColor: Color(0xFF0C192E),
              ),
              Text(
                'Same as Residential Address',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (!controller.sameAsResidential.value) ...[
            _buildTextField(
              label: 'Office Address Line 1',
              hint: 'Office Building, Street',
              icon: Icons.business_center,
              onChanged: (value) => controller.officeAddressLine1.value = value,
            ),
            SizedBox(height: 16),
            _buildTextField(
              label: 'Office Address Line 2',
              hint: 'Area, Locality',
              icon: Icons.location_city_outlined,
              onChanged: (value) => controller.officeAddressLine2.value = value,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'City',
                    hint: 'Enter city',
                    icon: Icons.location_city,
                    onChanged: (value) => controller.officeCity.value = value,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'Pincode',
                    hint: 'Pincode',
                    icon: Icons.pin_drop_outlined,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => controller.officePincode.value = value,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ));
  }

  Widget _buildResidenceTypeDropdown() {
    final List<String> residenceTypes = [
      'Owned',
      'Rented',
      'Parental',
      'Company Provided',
      'Other'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Residence Type',
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
          child: Obx(() => DropdownButtonFormField<String>(
            initialValue: controller.residenceType.value.isEmpty ? null : controller.residenceType.value,
            onChanged: (String? newValue) {
              controller.residenceType.value = newValue ?? '';
            },
            items: residenceTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              hintText: 'Select Residence Type',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(Icons.home_work_outlined, color: Color(0xFF00D4FF)),
              suffixIcon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
            ),
            dropdownColor: Color(0xFF1E2E3D),
            iconSize: 24,
            isExpanded: true,
            style: TextStyle(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          )),
        ),
      ],
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

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        // onPressed: controller.isFormValid ? controller.submitAddress : null,
        onPressed: (){
          Get.toNamed(Routes.newCarDocumentUploadScreen);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isFormValid ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
          disabledBackgroundColor: Color(0xFF2D3E50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
        ),
        child: Text(
          'Continue to Documents',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: controller.isFormValid ? Color(0xFF0C192E) : Colors.white54,
          ),
        ),
      ),
    ));
  }
}