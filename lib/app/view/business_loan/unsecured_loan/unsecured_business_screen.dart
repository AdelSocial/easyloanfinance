import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/unsecured_business_controller.dart';

class UnsecuredBusinessScreen extends StatelessWidget {
  final UnsecuredBusinessController controller = Get.put(UnsecuredBusinessController());

  UnsecuredBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Unsecured Business Loan',
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
            _buildPersonalInfoSection(),
            SizedBox(height: 24),
            _buildBusinessInfoSection(),
            SizedBox(height: 24),
            _buildFinancialInfoSection(),
            SizedBox(height: 24),
            _buildNomineeSection(),
            SizedBox(height: 24),
            _buildLoanDetailsSection(),
            SizedBox(height: 24),
            _buildConsentSection(),
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
              Icons.credit_card,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Unsecured Business Loan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'No collateral required • Quick approval • Interest from 11.5%',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green),
            ),
            child: Text(
              'No Collateral Required',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
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
                'Applicant Information',
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
            'Primary applicant details (Business Owner/Director)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          _buildTextField(
            label: 'Full Name *',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            onChanged: (value) => controller.fullName.value = value,
          ),
          SizedBox(height: 16),
          _buildDateField(),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Email Address *',
            hint: 'Enter your email address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => controller.email.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Mobile Number *',
            hint: 'Enter your mobile number',
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            onChanged: (value) => controller.mobileNumber.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'PAN Number *',
            hint: 'Enter your PAN number',
            icon: Icons.credit_card_outlined,
            onChanged: (value) => controller.panNumber.value = value,
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoSection() {
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
                child: Icon(Icons.business_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Business Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildBusinessTypeDropdown(),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Business Name *',
            hint: 'Enter registered business name',
            icon: Icons.business,
            onChanged: (value) => controller.businessName.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'GST Number',
            hint: 'Enter GST registration number',
            icon: Icons.numbers,
            onChanged: (value) => controller.gstNumber.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Business Registration Number',
            hint: 'CIN/Registration number',
            icon: Icons.assignment_outlined,
            onChanged: (value) => controller.registrationNumber.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Industry Type *',
            hint: 'e.g., Manufacturing, Retail, IT Services',
            icon: Icons.category_outlined,
            onChanged: (value) => controller.industryType.value = value,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialInfoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money, color: Color(0xFF00D4FF)),
              SizedBox(width: 12),
              Text(
                'Financial Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildBusinessAgeDropdown(),
          SizedBox(height: 16),
          _buildAnnualTurnoverDropdown(),
          SizedBox(height: 16),
          _buildMonthlyRevenueDropdown(),
        ],
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
            label: 'Nominee Full Name *',
            hint: 'Enter nominee full name',
            icon: Icons.person_outline,
            onChanged: (value) => controller.nomineeName.value = value,
          ),
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
                child: Icon(Icons.monetization_on_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Loan Requirements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildLoanAmountField(),
          SizedBox(height: 16),
          _buildLoanTenureDropdown(),
          SizedBox(height: 16),
          _buildLoanPurposeField(),
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
                'Business Consent & Authorization',
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
            text: 'I consent to credit report verification from credit bureaus',
          )),
          SizedBox(height: 16),
          Obx(() => _buildConsentCheckbox(
            value: controller.consentAadhaarKYC.value,
            onChanged: (value) => controller.consentAadhaarKYC.value = value!,
            text: 'I consent to perform Aadhaar eKYC to verify my identity',
          )),
          SizedBox(height: 16),
          Obx(() => _buildConsentCheckbox(
            value: controller.consentBusinessVerification.value,
            onChanged: (value) => controller.consentBusinessVerification.value = value!,
            text: 'I consent to business verification through GST and other government portals',
          )),
          SizedBox(height: 16),
          Obx(() => _buildConsentCheckbox(
            value: controller.consentTerms.value,
            onChanged: (value) => controller.consentTerms.value = value!,
            text: 'I agree to the Terms & Conditions and Privacy Policy',
          )),
        ],
      ),
    );
  }

  Widget _buildBusinessTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Type *',
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
          child: DropdownButtonFormField<String>(
            value: controller.businessType.value.isEmpty ? null : controller.businessType.value,
            onChanged: (value) => controller.businessType.value = value!,
            items: [
              'Proprietorship',
              'Partnership',
              'Private Limited',
              'Public Limited',
              'LLP (Limited Liability Partnership)',
              'One Person Company'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            decoration: InputDecoration(

              hint: Text(
                'Select Business Type',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),

              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              prefixIcon: Icon(Icons.business_center_outlined, color: Color(0xFF00D4FF)),
            ),
            dropdownColor: Color(0xFF1E2E3D),
            style: TextStyle(color: Colors.white),
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
          ),
        )),
      ],
    );
  }

  Widget _buildBusinessAgeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Age *',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF2D3E50)),
          ),
          child: Obx(() => DropdownButtonFormField<String>(
            value: controller.businessAge.value.isEmpty ? null : controller.businessAge.value,
            onChanged: (value) => controller.businessAge.value = value!,
            items: controller.businessAgeOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            decoration: InputDecoration(
              hint: Text(
                'Select Business Age',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF00D4FF)),
            ),
            dropdownColor: Color(0xFF1E2E3D),
            style: TextStyle(color: Colors.white),
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
          )),
        ),
      ],
    );
  }

  Widget _buildAnnualTurnoverDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Annual Turnover *',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF2D3E50)),
          ),
          child: Obx(() => DropdownButtonFormField<String>(
            value: controller.annualTurnover.value.isEmpty ? null : controller.annualTurnover.value,
            onChanged: (value) => controller.annualTurnover.value = value!,
            items: controller.turnoverOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            decoration: InputDecoration(
              hint: Text(
                'Select Annual Turnover',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              prefixIcon: Icon(Icons.bar_chart, color: Color(0xFF00D4FF)),
            ),
            dropdownColor: Color(0xFF1E2E3D),
            style: TextStyle(color: Colors.white),
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
          )),
        ),
      ],
    );
  }

  Widget _buildMonthlyRevenueDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Revenue *',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF2D3E50)),
          ),
          child: Obx(() => DropdownButtonFormField<String>(
            value: controller.monthlyRevenue.value.isEmpty ? null : controller.monthlyRevenue.value,
            onChanged: (value) => controller.monthlyRevenue.value = value!,
            items: controller.revenueOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            decoration: InputDecoration(
              hint: Text(
                'Select Monthly Revenue',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: Icon(Icons.trending_up, color: Color(0xFF00D4FF)),
            ),
            dropdownColor: Color(0xFF1E2E3D),
            style: TextStyle(color: Colors.white),
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
          )),
        ),
      ],
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
          'Relationship with Nominee *',
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
            value: controller.nomineeRelationship.value.isEmpty ? null : controller.nomineeRelationship.value,
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
              hintText: 'Select Relationship',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: Icon(Icons.people_alt_outlined, color: Color(0xFF00D4FF)),
            ),
            dropdownColor: Color(0xFF1E2E3D),
            iconSize: 24,
            isExpanded: true,
            style: TextStyle(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
          )),
        ),
      ],
    );
  }

  Widget _buildLoanAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Amount Required (₹) *',
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
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.loanAmount.value = value,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter required loan amount',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(Icons.currency_rupee, color: Color(0xFF00D4FF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoanTenureDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Loan Tenure *',
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
          child: DropdownButtonFormField<String>(
            value: controller.loanTenure.value.isEmpty ? null : controller.loanTenure.value,
            onChanged: (value) => controller.loanTenure.value = value!,
            items: [
              '12 Months',
              '24 Months',
              '36 Months',
              '48 Months',
              '60 Months',
              '72 Months',
              '84 Months'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              hint: Text(
                'Select Loan Tenure',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: Icon(Icons.calendar_today_outlined, color: Color(0xFF00D4FF)),
            ),
            dropdownColor: Color(0xFF1E2E3D),
            style: TextStyle(color: Colors.white),
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
          ),
        )),
      ],
    );
  }

  Widget _buildLoanPurposeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Purpose *',
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
            onChanged: (value) => controller.loanPurpose.value = value,
            style: TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Describe the purpose of this business loan...\n(e.g., Working capital, Expansion, Equipment purchase, etc.)',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(Icons.description_outlined, color: Color(0xFF00D4FF)),
            ),
          ),
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
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2D3E50)),
          ),
          child: TextFormField(
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            validator: validator,

            /// 🚫 Emoji Block
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp(
                  r'[\u{1F600}-\u{1F64F}'
                  r'\u{1F300}-\u{1F5FF}'
                  r'\u{1F680}-\u{1F6FF}'
                  r'\u{1F700}-\u{1F77F}'
                  r'\u{1F780}-\u{1F7FF}'
                  r'\u{1F800}-\u{1F8FF}'
                  r'\u{1F900}-\u{1F9FF}'
                  r'\u{1FA00}-\u{1FAFF}'
                  r'\u{2600}-\u{26FF}'
                  r'\u{2700}-\u{27BF}]',
                  unicode: true,
                ),
              ),
            ],

            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(icon, color: const Color(0xFF00D4FF)),
              errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
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
          'Date of Birth (DD-MM-YYYY) *',
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

  Widget _buildConsentCheckbox({
    required bool value,
    required Function(bool?) onChanged,
    required String text,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
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
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (controller.isFormValid.value && !controller.isLoading.value) 
            ? () => controller.submitApplication() 
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isFormValid.value && !controller.isLoading.value 
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
                'Submit Application',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: controller.isFormValid.value && !controller.isLoading.value 
                      ? Color(0xFF0C192E) 
                      : Colors.white54,
                ),
              ),
      ),
    ));
  }
}