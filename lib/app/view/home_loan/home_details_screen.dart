import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_details_controller.dart';

class HomeLoanDetailsScreen extends StatelessWidget {
  final HomeLoanDetailsController controller = Get.put(HomeLoanDetailsController());
  HomeLoanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Home Loan Application',
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
            _buildHeaderSection(),
            SizedBox(height: 24),
            _buildLoanDetailsSection(),
            SizedBox(height: 24),
            _buildPropertyDetailsSection(),
            SizedBox(height: 24),
            _buildIncomeDetailsSection(),
            SizedBox(height: 32),
            _buildContinueButton(),
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
                child: Icon(Icons.home_work_outlined, size: 24, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Home Loan Details',
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
            'Provide details about your home loan requirements',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
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
          _buildSectionHeader(
            icon: Icons.currency_rupee_outlined,
            title: 'Loan Requirements',
          ),
          SizedBox(height: 20),
          _buildLoanAmountField(),
          SizedBox(height: 16),
          _buildPropertyValueField(),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildInterestRateField()),
              SizedBox(width: 16),
              Expanded(child: _buildLoanTenureField()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetailsSection() {
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
          _buildSectionHeader(
            icon: Icons.apartment_outlined,
            title: 'Property Details',
          ),
          SizedBox(height: 20),
          _buildPropertyTypeDropdown(),
          SizedBox(height: 16),
          _buildCityDropdown(),
          SizedBox(height: 16),
          _buildBuilderNameField(),
        ],
      ),
    );
  }

  Widget _buildIncomeDetailsSection() {
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
          _buildSectionHeader(
            icon: Icons.attach_money_outlined,
            title: 'Income Details',
          ),
          SizedBox(height: 20),
          _buildEmploymentTypeDropdown(),
          SizedBox(height: 16),
          _buildMonthlyIncomeField(),
        ],
      ),
    );
  }

  // Reusable Widgets for HomeLoanDetailsScreen
  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Color(0xFF00D4FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Color(0xFF00D4FF)),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLoanAmountField() {
    return _buildTextField(
      label: 'Loan Amount Required',
      hint: 'Enter loan amount',
      icon: Icons.currency_rupee,
      onChanged: (value) => controller.loanAmount.value = value,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildPropertyValueField() {
    return _buildTextField(
      label: 'Property Value',
      hint: 'Enter property value',
      icon: Icons.currency_rupee,
      onChanged: (value) => controller.propertyValue.value = value,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildInterestRateField() {
    return _buildTextField(
      label: 'Expected Interest Rate (%)',
      hint: '8.5%',
      icon: Icons.percent,
      onChanged: (value) => controller.interestRate.value = value,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildLoanTenureField() {
    return _buildTextField(
      label: 'Loan Tenure (Years)',
      hint: '20 years',
      icon: Icons.calendar_today,
      onChanged: (value) => controller.loanTenure.value = value,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildBuilderNameField() {
    return _buildTextField(
      label: 'Builder/Project Name',
      hint: 'Enter builder or project name',
      icon: Icons.business_outlined,
      onChanged: (value) => controller.builderName.value = value,
    );
  }

  Widget _buildMonthlyIncomeField() {
    return _buildTextField(
      label: 'Monthly Income',
      hint: 'Enter monthly income',
      icon: Icons.currency_rupee,
      onChanged: (value) => controller.monthlyIncome.value = value,
      keyboardType: TextInputType.number,
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

  Widget _buildPropertyTypeDropdown() {
    return _buildDropdownField(
      label: 'Property Type',
      hint: 'Select property type',
      icon: Icons.category_outlined,
      value: controller.selectedPropertyType.value,
      items: controller.propertyTypes,
      onChanged: (value) => controller.selectedPropertyType.value = value ?? '',
    );
  }

  Widget _buildCityDropdown() {
    return _buildDropdownField(
      label: 'City',
      hint: 'Select city',
      icon: Icons.location_city_outlined,
      value: controller.city.value,
      items: controller.cities,
      onChanged: (value) => controller.city.value = value ?? '',
    );
  }

  Widget _buildEmploymentTypeDropdown() {
    return _buildDropdownField(
      label: 'Employment Type',
      hint: 'Select employment type',
      icon: Icons.work_outline,
      value: controller.employmentType.value,
      items: controller.employmentTypes,
      onChanged: (value) => controller.employmentType.value = value ?? '',
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required String value,
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
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: value.isEmpty ? null : value,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: onChanged,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hint: Text(
                  hint,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                prefixIcon: Icon(icon, color: Color(0xFF00D4FF)),
              ),
              dropdownColor: Color(0xFF1E2E3D),
              icon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
              isExpanded: true,
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
        onPressed: controller.isFormValid && !controller.isLoading.value
            ? () async {
                await controller.submitHomeLoanDetails();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isFormValid ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
          disabledBackgroundColor: Color(0xFF2D3E50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
        ),
        child: controller.isLoading.value
            ? SizedBox(
                height: 24,
                width: 24,
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
                  color: controller.isFormValid ? Color(0xFF0C192E) : Colors.white54,
                ),
              ),
      ),
    ));
  }
}