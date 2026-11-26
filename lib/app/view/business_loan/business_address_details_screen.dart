import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/business_address_details_controller.dart';

class BusinessAddressDetailsScreen extends StatelessWidget {
  final BusinessAddressDetailsController controller = Get.put(BusinessAddressDetailsController());

  BusinessAddressDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Business Loan Application',
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
            _buildBusinessAddressSection(),
            SizedBox(height: 16),
            _buildOwnershipSection(),
            SizedBox(height: 16),
            _buildAddressProofSection(),
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
                child: Icon(Icons.business_outlined, size: 24, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Business Address Details',
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
            'Please provide your business and correspondence address details',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessAddressSection() {
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
                child: Icon(Icons.business_center_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Business Premises Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildAddressField(
            label: 'Business Address',
            hint: 'Enter complete business premises address',
            icon: Icons.location_on_outlined,
            onChanged: (value) => controller.businessAddress.value = value,
            maxLines: 3,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAddressField(
                  label: 'City',
                  hint: 'Enter city',
                  icon: Icons.location_city_outlined,
                  onChanged: (value) => controller.city.value = value,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildAddressField(
                  label: 'Pincode',
                  hint: 'Pincode',
                  icon: Icons.pin_outlined,
                  onChanged: (value) => controller.pincode.value = value,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildStateDropdown(),
          SizedBox(height: 16),
          _buildAddressField(
            label: 'Business Type Premises',
            hint: 'e.g., Office, Shop, Factory, etc.',
            icon: Icons.type_specimen_outlined,
            onChanged: (value) => controller.premisesType.value = value,
          ),
        ],
      ),
    );
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'State/Province',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          onChanged: (String? newValue) {
            controller.selectedState.value = newValue ?? '';
          },
          items: [
            'California',
            'New York',
            'Texas',
            'Florida',
            'Illinois',
            'Washington',
            'Arizona',
            'Colorado',
            // Add more states as needed
          ].map((String state) {
            return DropdownMenuItem<String>(
              value: state,
              child: Text(
                state,
                style: TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hint: Text(
              'Select your state',
              style: TextStyle(
                color: Colors.white54, // This will make hint text visible
                fontSize: 16,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF2D3E50)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF2D3E50)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF00D4FF)),
            ),
            filled: true,
            fillColor: Color(0xFF0C192E),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            prefixIcon: Icon(Icons.location_on_outlined, color: Color(0xFF00D4FF)),
          ),
          dropdownColor: Color(0xFF1E2E3D),
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
          isExpanded: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a state';
            }
            return null;
          },
        ),
      ],
    );
  }
  Widget _buildOwnershipSection() {
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
                child: Icon(Icons.home_work_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Premises Ownership',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Business Premises Type',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
           Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildOwnershipOption('Owned', Icons.house_outlined),
              _buildOwnershipOption('Rented', Icons.home_work_outlined),
              _buildOwnershipOption('Leased', Icons.assignment_outlined),
              _buildOwnershipOption('Parental', Icons.family_restroom_outlined),
            ],
          ),
          SizedBox(height: 16),
          if (controller.premisesOwnership.value == 'Rented' ||
              controller.premisesOwnership.value == 'Leased')
            _buildAddressField(
              label: 'Monthly Rent Amount',
              hint: 'Enter monthly rent',
              icon: Icons.currency_rupee_outlined,
              onChanged: (value) => controller.monthlyRent.value = value,
              keyboardType: TextInputType.number,
            ),
        ],
      ),
    );
  }

  Widget _buildOwnershipOption(String type, IconData icon) {
    return Obx(() => InkWell(
      onTap: () => controller.premisesOwnership.value = type,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: controller.premisesOwnership.value == type
              ? Color(0xFF00D4FF).withOpacity(0.1)
              : Color(0xFF0C192E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.premisesOwnership.value == type
                ? Color(0xFF00D4FF)
                : Color(0xFF2D3E50),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 18,
                color: controller.premisesOwnership.value == type
                    ? Color(0xFF00D4FF)
                    : Colors.white70
            ),
            SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                color: controller.premisesOwnership.value == type
                    ? Colors.white
                    : Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildAddressProofSection() {
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
                child: Icon(Icons.description_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Address Proof',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Select Address Proof Document',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
            initialValue: controller.selectedAddressProof.value.isEmpty ? null : controller.selectedAddressProof.value,
            items: [
              'Aadhaar Card',
              'Passport',
              'Voter ID',
              'Driving License',
              'Utility Bill (Electricity/Water)',
              'Property Tax Receipt',
              'Lease/Rent Agreement'
            ].map((String document) {
              return DropdownMenuItem<String>(
                value: document,
                child: Text(
                  document,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              controller.selectedAddressProof.value = newValue ?? '';
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hint: Text(
                'Select address proof document',
                style: TextStyle(
                  color: Colors.white54, // This will make hint text visible
                  fontSize: 16,
                ),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF2D3E50)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF2D3E50)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF00D4FF)),
              ),
              filled: true,
              fillColor: Color(0xFF0C192E),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(Icons.description_outlined, color: Color(0xFF00D4FF)),
            ),
            dropdownColor: Color(0xFF1E2E3D),
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
            isExpanded: true,
          )),
          SizedBox(height: 16),
          _buildDocumentUploadSection(),
        ],
      ),
    );
  }

  Widget _buildAddressField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    int maxLines = 1,
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
            maxLines: maxLines,
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

  Widget _buildContinueButton(BuildContext context) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed(Routes.businessEmploymentIncomeScreen);
        } ,
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isFormValid ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
          disabledBackgroundColor: Color(0xFF2D3E50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
        ),
        child: Text(
          'Continue to Employment Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: controller.isFormValid ? Color(0xFF0C192E) : Colors.white54,
          ),
        ),
      ),
    ));
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
                'KYC Verification',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildKYCField(
            label: 'KYC Document Type',
            hint: 'Select KYC document',
            icon: Icons.description_outlined,
            isDropdown: true,
            options: [
              'Aadhaar Card',
              'PAN Card',
              'Passport',
              'Voter ID',
              'Driving License'
            ],
          ),
          SizedBox(height: 16),
          _buildKYCField(
            label: 'Document Number',
            hint: 'Enter document number',
            icon: Icons.numbers_outlined,
            onChanged: (value) => controller.kycDocumentNumber.value = value,
          ),
          SizedBox(height: 16),
          _buildDocumentUploadSection(),
        ],
      ),
    );
  }

  Widget _buildKYCField({
    required String label,
    required String hint,
    required IconData icon,
    bool isDropdown = false,
    List<String>? options,
    Function(String)? onChanged,
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
        if (isDropdown && options != null)
          DropdownButtonFormField<String>(
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (onChanged != null && newValue != null) {
                onChanged(newValue);
              }
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hint: Text(
                hint,
                style: TextStyle(
                  color: Colors.white54, // This will make hint text visible
                  fontSize: 16,
                ),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF2D3E50)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF2D3E50)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF00D4FF)),
              ),
              filled: true,
              fillColor: Color(0xFF0C192E),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              prefixIcon: Icon(icon, color: Color(0xFF00D4FF)),
            ),
            dropdownColor: Color(0xFF1E2E3D),
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
            isExpanded: true,
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF0C192E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF2D3E50)),
            ),
            child: TextField(
              onChanged: onChanged,
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

  Widget _buildDocumentUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload KYC Document',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 12),
        Obx(() => InkWell(
          onTap: () {
            // Implement KYC document upload functionality
            controller.uploadKYCDocument();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF0C192E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: controller.isKYCDocumentUploaded.value
                    ? Colors.green
                    : Color(0xFF2D3E50),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  controller.isKYCDocumentUploaded.value
                      ? Icons.verified_outlined
                      : Icons.cloud_upload_outlined,
                  color: controller.isKYCDocumentUploaded.value
                      ? Colors.green
                      : Color(0xFF00D4FF),
                  size: 40,
                ),
                SizedBox(height: 8),
                Text(
                  controller.isKYCDocumentUploaded.value
                      ? 'KYC Document Uploaded Successfully'
                      : 'Click to Upload KYC Document',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!controller.isKYCDocumentUploaded.value)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Supported formats: PDF, JPG, PNG (Max 5MB)',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}