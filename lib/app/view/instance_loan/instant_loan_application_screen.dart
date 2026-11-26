import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/instant_loan_application_controller.dart';
import '../../routes/app_pages.dart';


class InstantLoanApplicationScreen extends StatelessWidget {
  final InstantLoanApplicationController controller = Get.put(InstantLoanApplicationController());

  InstantLoanApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Instant Loan Application',
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
            _buildLoanDetailsSection(),
            SizedBox(height: 24),
            _buildNomineeSection(),
            SizedBox(height: 24),
            _buildConsentSection(),
            SizedBox(height: 32),
            _buildContinueButton(context),
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
              Icons.bolt_rounded,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Quick Instant Loan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Get instant approval with minimal documentation and quick disbursal',
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

  Widget _buildLoanDetailsSection() {
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
                child: Icon(Icons.credit_card_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Loan Details',
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
            'Tell us about your loan requirements',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          _buildTextField(
            label: 'Loan Amount (₹)',
            hint: 'Enter desired loan amount',
            icon: Icons.currency_rupee_outlined,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.loanAmount.value = value,
          ),
          SizedBox(height: 16),
          _buildDropdownField(
            label: 'Loan Purpose',
            hint: 'Select loan purpose',
            icon: Icons.category_outlined,
            items: [
              'Medical Emergency',
              'Education Fees',
              'Home Renovation',
              'Travel',
              'Wedding',
              'Business',
              'Personal',
              'Other'
            ],
            onChanged: (value) => controller.loanPurpose.value = value ?? '',
          ),
          SizedBox(height: 16),
          _buildDropdownField(
            label: 'Employment Type',
            hint: 'Select employment type',
            icon: Icons.work_outline,
            items: [
              'Salaried',
              'Self-Employed',
              'Business',
              'Freelancer',
              'Student',
              'Unemployed'
            ],
            onChanged: (value) => controller.employmentType.value = value ?? '',
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
          Obx(() => _buildConsentCheckbox(
            value: controller.consentCreditReport.value,
            onChanged: (value) => controller.consentCreditReport.value = value!,
            text: 'I consent to Easy Loan Finance retrieving my credit report from credit bureaus',
          )),
          SizedBox(height: 16),
          Obx(() => _buildConsentCheckbox(
            value: controller.consentTermsConditions.value,
            onChanged: (value) => controller.consentTermsConditions.value = value!,
            text: 'I agree to the terms and conditions and privacy policy for instant loan',
          )),
        ],
      ),
    );
  }

  Widget _buildConsentCheckbox({
    required bool value,
    required Function(bool?) onChanged,
    required String text,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value ? Color(0xFF00D4FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: value ? Color(0xFF00D4FF) : Colors.white54,
                width: 2,
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
      ),
    );
  }

  Widget _buildContinueButton(context) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (controller.isFormValid && !controller.isLoading.value) 
            ? () => controller.submitApplication() 
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