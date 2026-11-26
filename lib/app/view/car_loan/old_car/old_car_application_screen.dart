import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/old_car_application_controller.dart';
import '../../../routes/app_pages.dart';


class OldCarApplicationScreen extends StatelessWidget {
  final OldCarApplicationController controller = Get.put(OldCarApplicationController());

  OldCarApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Used Car Loan Application',
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
            _buildPersonalInfoSection(),
            SizedBox(height: 24),
            _buildCarInfoSection(),
            SizedBox(height: 24),
            _buildEmploymentSection(),
            SizedBox(height: 24),
            _buildNomineeSection(),
            SizedBox(height: 24),
            _buildConsentSection(),
            SizedBox(height: 32),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNomineeSection() {
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
                child: Icon(Icons.people_outline, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Nominee Information',
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
            'Person to receive benefits in case of unforeseen circumstances',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          _buildTextField(
            label: 'Nominee Full Name',
            hint: 'Enter nominee full name',
            icon: Icons.person_outline,
            onChanged: (value) => controller.nomineeName.value = value,
          ),
          // SizedBox(height: 16),
          //
          // _buildTextField(
          //   label: 'PAN Card or Identity Card',
          //   hint: 'Enter PAN Card or Identity Card number',
          //   icon: Icons.description,
          //   onChanged: (value) => controller.nomineeName.value = value,
          // ),
          SizedBox(height: 16),
          _buildRelationshipDropdown(),
          SizedBox(height: 16),
          _buildNomineeDateField(),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Nominee Mobile Number',
            hint: 'Enter nominee mobile number',
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            onChanged: (value) => controller.nomineeMobileNumber.value = value,
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipDropdown() {
    final List<String> relationships = [
      'Spouse',
      'Father',
      'Mother',
      'Son',
      'Daughter',
      'Brother',
      'Sister',
      'Other Relative',
      'Friend',
      'Other'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relationship with Nominee',
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
            initialValue: controller.nomineeRelationship.value.isEmpty ? null : controller.nomineeRelationship.value,
            onChanged: (String? newValue) {
              controller.nomineeRelationship.value = newValue ?? '';
            },
            items: relationships.map((String relationship) {
              return DropdownMenuItem<String>(
                value: relationship,
                child: Text(
                  relationship,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(

              hint: Text(
                'Select Relationship',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),

              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              prefixIcon: Icon(Icons.people_alt_outlined, color: Color(0xFF00D4FF)),
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

  Widget _buildNomineeDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nominee Date of Birth (DD-MM-YYYY)',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Obx(() => InkWell(
          onTap: controller.selectNomineeDateOfBirth,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF0C192E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF2D3E50)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: Color(0xFF00D4FF)),
                SizedBox(width: 12),
                Text(
                  controller.nomineeDateOfBirth.value.isEmpty
                      ? 'Select Nominee Date of Birth'
                      : controller.nomineeDateOfBirth.value,
                  style: TextStyle(
                    color: controller.nomineeDateOfBirth.value.isEmpty
                        ? Colors.white54
                        : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
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
              Icons.directions_car,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Used Car Loan Application',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Fill in your details to get financing for your pre-owned car',
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

  Widget _buildPersonalInfoSection() {
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
                child: Icon(Icons.person_outline, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Personal Information',
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
            'As per PAN/Aadhaar records',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          _buildTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            onChanged: (value) => controller.fullName.value = value,
          ),
          SizedBox(height: 16),
          _buildDateField(),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Email Address',
            hint: 'Enter your email address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => controller.email.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Mobile Number',
            hint: 'Enter your mobile number',
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            onChanged: (value) => controller.mobileNumber.value = value,
          ),
        ],
      ),
    );
  }

  Widget _buildCarInfoSection() {
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
                child: Icon(Icons.directions_car, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Car Information',
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
            label: 'Car Brand',
            hint: 'e.g., Hyundai, Maruti, Tata',
            icon: Icons.branding_watermark,
            onChanged: (value) => controller.carBrand.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Car Model',
            hint: 'e.g., Creta, Swift, Nexon',
            icon: Icons.model_training,
            onChanged: (value) => controller.carModel.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Manufacturing Year',
            hint: 'e.g., 2020, 2019',
            icon: Icons.calendar_today,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.manufacturingYear.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Registration Year',
            hint: 'e.g., 2020, 2021',
            icon: Icons.date_range,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.registrationYear.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Car Variant',
            hint: 'e.g., ZX, VX, LXI',
            icon: Icons.settings,
            onChanged: (value) => controller.carVariant.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Car Price',
            hint: 'Enter agreed car price',
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.carPrice.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Desired Loan Amount',
            hint: 'Enter loan amount required',
            icon: Icons.money,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.loanAmount.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Odometer Reading (km)',
            hint: 'Enter current odometer reading',
            icon: Icons.speed,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.odometerReading.value = value,
          ),
        ],
      ),
    );
  }

  Widget _buildEmploymentSection() {
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
                child: Icon(Icons.work_outline, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Employment Information',
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
            label: 'Employment Type',
            hint: 'e.g., Salaried, Self-Employed',
            icon: Icons.business_center,
            onChanged: (value) => controller.employmentType.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Monthly Income',
            hint: 'Enter monthly income',
            icon: Icons.currency_rupee,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.monthlyIncome.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Company Name',
            hint: 'Enter company name',
            icon: Icons.business,
            onChanged: (value) => controller.companyName.value = value,
          ),
        ],
      ),
    );
  }

  Widget _buildConsentSection() {
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
                'Consent & Authorization',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildConsentCheckbox(
            value: controller.consentCreditReport.value,
            onChanged: (value) => controller.consentCreditReport.value = value!,
            text: 'I consent to Easy Loan Finance retrieving my credit report from credit bureaus',
          ),
          SizedBox(height: 16),
          _buildConsentCheckbox(
            value: controller.consentAadhaarKYC.value,
            onChanged: (value) => controller.consentAadhaarKYC.value = value!,
            text: 'I consent to perform Aadhaar eKYC to verify my identity',
          ),
          SizedBox(height: 16),
          _buildConsentCheckbox(
            value: controller.consentCarDetails.value,
            onChanged: (value) => controller.consentCarDetails.value = value!,
            text: 'I confirm that the car details provided are accurate and complete',
          ),
          SizedBox(height: 16),
          _buildConsentCheckbox(
            value: controller.consentVehicleInspection.value,
            onChanged: (value) => controller.consentVehicleInspection.value = value!,
            text: 'I consent for vehicle inspection by Easy Loan Finance representatives',
          ),
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

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth (DD-MM-YYYY)',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Obx(() => InkWell(
          onTap: controller.selectDateOfBirth,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF0C192E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF2D3E50)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: Color(0xFF00D4FF)),
                SizedBox(width: 12),
                Text(
                  controller.dateOfBirth.value.isEmpty
                      ? 'Select Date of Birth'
                      : controller.dateOfBirth.value,
                  style: TextStyle(
                    color: controller.dateOfBirth.value.isEmpty
                        ? Colors.white54
                        : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        )),
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

  Widget _buildContinueButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:  () {
          Get.toNamed(Routes.oldCarAddressDetailsScreen);
        } ,
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isFormValid ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
          disabledBackgroundColor: Color(0xFF2D3E50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
        ),
        child: Text(
          'Continue',
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