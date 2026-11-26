import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/personal_application_controller.dart';

class PersonalApplicationScreen extends StatelessWidget {
  final PersonalApplicationController controller = Get.put(PersonalApplicationController());
  final _formKey = GlobalKey<FormState>();

  PersonalApplicationScreen({super.key}) {
    // Ensure checkboxes are unchecked when screen opens
    controller.resetCheckboxes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Apply For Loan Application',
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              SizedBox(height: 24),
              _buildPersonalInfoSection(),
              SizedBox(height: 24),
              _buildKYCAndAddressSection(),
              SizedBox(height: 24),
              _buildNomineeSection(),
              SizedBox(height: 24),
              _buildConsentSection(),
              SizedBox(height: 32),
              _buildContinueButton(context),
            ],
          ),
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
              Icons.assignment_ind_rounded,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Complete Your Application',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Fill in your details to proceed with your loan application',
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
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final mobileRegex = RegExp(r'^[0-9]{10}$');
                final cleanedMobile = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (!mobileRegex.hasMatch(cleanedMobile)) {
                  return 'Please enter a valid 10-digit mobile number';
                }
              }
              return null;
            },
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email address';
              }
              final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Mobile Number',
            hint: 'Enter your mobile number',
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            onChanged: (value) => controller.mobileNumber.value = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter mobile number';
              }
              final mobileRegex = RegExp(r'^[0-9]{10}$');
              final cleanedMobile = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (!mobileRegex.hasMatch(cleanedMobile)) {
                return 'Please enter a valid 10-digit mobile number';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildLoanCategoryDropdown(),
          SizedBox(height: 16),
          _buildLoanAmountField(),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Loan Tenure (Months)',
            hint: 'Enter loan tenure in months',
            icon: Icons.calendar_month,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.loanTenure.value = value,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final tenure = int.tryParse(value);
                if (tenure == null || tenure <= 0) {
                  return 'Please enter a valid tenure';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKYCAndAddressSection() {
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
                'KYC & Address Details',
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
            label: 'PAN Number',
            hint: 'Enter PAN number',
            icon: Icons.credit_card_outlined,
            onChanged: (value) =>
            controller.panNumber.value = value.toUpperCase(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'PAN number is required';
              }

              // final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
              //
              // if (!panRegex.hasMatch(value.trim().toUpperCase())) {
              //   return 'Please enter a valid PAN number';
              // }

              return null;
            },
          ),

          SizedBox(height: 16),
          _buildTextField(
            label: 'Aadhaar Number',
            hint: 'Enter 12-digit Aadhaar number',
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.aadhaarNumber.value = value,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (cleaned.length != 12) {
                  return 'Aadhaar number must be 12 digits';
                }
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Address',
            hint: 'Enter your address',
            icon: Icons.location_on_outlined,
            onChanged: (value) => controller.address.value = value,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'City',
                  hint: 'Enter city',
                  icon: Icons.location_city_outlined,
                  onChanged: (value) => controller.city.value = value,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: 'State',
                  hint: 'Enter state',
                  icon: Icons.map_outlined,
                  onChanged: (value) => controller.state.value = value,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Pincode',
            hint: 'Enter pincode',
            icon: Icons.pin_outlined,
            keyboardType: TextInputType.number,
            onChanged: (value) => controller.pincode.value = value,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (cleaned.length != 6) {
                  return 'Pincode must be 6 digits';
                }
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildKycMethodDropdown(),
          SizedBox(height: 16),
          _buildTextField(
            label: 'CKYC Number (Optional)',
            hint: 'Enter CKYC number if available',
            icon: Icons.numbers_outlined,
            onChanged: (value) => controller.ckycNumber.value = value,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Locker ID (Optional)',
            hint: 'Enter locker ID if available',
            icon: Icons.lock_outline,
            onChanged: (value) => controller.lockerId.value = value,
          ),
          SizedBox(height: 16),
          Obx(() => Row(
            children: [
              Checkbox(
                value: controller.videoKyc.value,
                onChanged: (value) => controller.videoKyc.value = value ?? false,
                activeColor: Color(0xFF00D4FF),
                checkColor: Color(0xFF0C192E),
              ),
              Expanded(
                child: Text(
                  'Video KYC Completed',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildKycMethodDropdown() {
    final kycMethods = [
      'aadhaar_otp',
      'ckyc',
      'digital_locker',
      'video_kyc'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KYC Method',
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
            value: controller.kycMethod.value.isEmpty ? null : controller.kycMethod.value,
            onChanged: (String? newValue) {
              controller.kycMethod.value = newValue ?? '';
            },
            items: kycMethods.map((String method) {
              // Display name mapping for better UX
              String displayName = method;
              switch (method) {
                case 'aadhaar_otp':
                  displayName = 'Aadhaar OTP';
                  break;
                case 'ckyc':
                  displayName = 'CKYC';
                  break;
                case 'digital_locker':
                  displayName = 'Digital Locker';
                  break;
                case 'video_kyc':
                  displayName = 'Video KYC';
                  break;
              }
              return DropdownMenuItem<String>(
                value: method,
                child: Text(
                  displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              hint: Text(
                'Select KYC Method',
                style: TextStyle(
                  color: Colors.white54, // This will make hint text visible
                  fontSize: 16,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              prefixIcon: Icon(Icons.verified_user_outlined, color: Color(0xFF00D4FF)),
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

  Widget _buildLoanAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Amount',
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
          child: TextFormField(
            key: ValueKey('loan_amount_field'),
            controller: TextEditingController(text: controller.loanAmount.value)
              ..selection = TextSelection.collapsed(offset: controller.loanAmount.value.length),
            onChanged: (value) {
              // Remove any non-numeric characters except decimal point
              final cleanedValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
              // Ensure only one decimal point
              final parts = cleanedValue.split('.');
              if (parts.length > 2) {
                return; // Don't update if multiple decimal points
              }
              // Limit decimal places to 2
              if (parts.length == 2 && parts[1].length > 2) {
                return; // Don't update if more than 2 decimal places
              }
              controller.loanAmount.value = cleanedValue;
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(color: Colors.white),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), // Allow numbers and up to 2 decimal places
            ],
            decoration: InputDecoration(
              hintText: 'Enter loan amount (e.g., 50000)',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(Icons.currency_rupee, color: Color(0xFF00D4FF)),
              suffixIcon: controller.loanAmount.value.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.white54, size: 20),
                      onPressed: () {
                        controller.loanAmount.value = '';
                      },
                    )
                  : null,
              errorStyle: TextStyle(color: Colors.red, fontSize: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter loan amount';
              }
              final amount = double.tryParse(value);
              if (amount == null) {
                return 'Please enter a valid amount';
              }
              if (amount <= 0) {
                return 'Loan amount must be greater than 0';
              }
              if (amount < 1000) {
                return 'Minimum loan amount is ₹1,000';
              }
              if (amount > 100000000) {
                return 'Maximum loan amount is ₹10,00,00,000';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
  Widget _buildLoanCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Color(0xFF0C192E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFF00D4FF).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Obx(() {
            // Show loading indicator while categories are loading
            if (controller.isLoadingCategories.value) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      color: Color(0xFF00D4FF),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D4FF)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Loading categories...',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Build dropdown items from API categories
            List<DropdownMenuItem<String>> dropdownItems = [];
            
            if (controller.categories.isNotEmpty) {
              // Use categories from API
              dropdownItems = controller.categories.map<DropdownMenuItem<String>>((category) {
                final categoryName = category['name']?.toString() ?? '';
                return DropdownMenuItem<String>(
                  value: categoryName,
                  child: Text(
                    categoryName,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList();
            } else {
              // Fallback to default categories if API fails
              dropdownItems = [
                'Personal Loan Plans',
                'Business Loan',
                'Home Loan',
                'Loan Against Property (LAP)',
                'Vehicle Loan (Car / Two-Wheeler Loan)',
                'Education Loan',
                'Gold Loan',
                'Instant Loan',
                'Working Capital Loan',
                'Startup Loan',
                'MSME / SME Loan',
                'Agriculture Loan',
                'Loan Against Salary',
                'Balance Transfer Loan',
                'Credit Card Loan',
                'Medical Loan',
                'Wedding Loan',
                'Travel Loan',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList();
            }

            return DropdownButtonFormField<String>(
              value: controller.selectedLoanCategory.value.isEmpty
                  ? null
                  : controller.selectedLoanCategory.value,
              onChanged: (newValue) {
                controller.selectedLoanCategory.value = newValue ?? '';
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                prefixIcon: Icon(
                  Icons.category_outlined,
                  color: Color(0xFF00D4FF),
                  size: 20,
                ),
                hint: Text(
                  'Select loan category',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 16),
              dropdownColor: Color(0xFF1E2E3D),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF00D4FF),
                size: 24,
              ),
              isExpanded: true,
              items: dropdownItems,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a loan category';
                }
                return null;
              },
            );
          }),
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
            value: controller.consentAadhaarKYC.value,
            onChanged: (value) => controller.consentAadhaarKYC.value = value!,
            text: 'I consent to perform Aadhaar eKYC to verify my identity',
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
      ),
    );
  }

  Widget _buildContinueButton(context) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (controller.isFormValid && !controller.isLoading.value)
            ? () {
                if (_formKey.currentState!.validate()) {
                  controller.submitApplication();
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: (controller.isFormValid && !controller.isLoading.value)
              ? Color(0xFF00D4FF)
              : Color(0xFF2D3E50),
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
                  color: (controller.isFormValid && !controller.isLoading.value)
                      ? Color(0xFF0C192E)
                      : Colors.white54,
                ),
              ),
      ),
    ));
  }
}