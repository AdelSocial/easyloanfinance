import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProfileController>();
    // Initialize controllers with current profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeControllers();
      // Ensure default values are set (after build phase)
      // This ensures values are set before user submits
      if (controller.userProfile.value.gender.isEmpty || 
          !['Male', 'Female', 'Other'].contains(controller.userProfile.value.gender)) {
        controller.userProfile.update((profile) {
          profile!.gender = 'Male';
        });
      }
      if (controller.userProfile.value.employmentType.isEmpty || 
          !['Salaried', 'Self-Employed', 'Business', 'Professional', 'Retired'].contains(controller.userProfile.value.employmentType)) {
        controller.userProfile.update((profile) {
          profile!.employmentType = 'Salaried';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
          IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: controller.updateProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileImageSection(),
            SizedBox(height: 24),
            _buildPersonalInfoSection(),
            SizedBox(height: 24),
            _buildEmploymentSection(),
            SizedBox(height: 24),
            _buildKYCSection(),
            SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Obx(() => Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF00D4FF),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: _buildProfileImage(),
                ),
              )),

              GestureDetector(
                onTap: controller.pickProfileImage,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF00D4FF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF0C192E), width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Update Profile Picture',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    final imagePath = controller.userProfile.value.profileImage;

    if (imagePath.startsWith('/')) {
      return Image.file(
        File(imagePath),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    }

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _defaultAvatar(),
      );
    }

    return _defaultAvatar();
  }

  Widget _defaultAvatar() {
    return Container(
      color: Color(0xFF00D4FF).withOpacity(0.1),
      child: Icon(
        Icons.person_outlined,
        size: 50,
        color: Color(0xFF00D4FF),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _buildTextField(
            controller: controller.nameController,
            label: 'Full Name',
            icon: Icons.person_outlined,
            isRequired: true,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: controller.emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: controller.phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            isRequired: true,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          _buildDateField(),
          SizedBox(height: 16),
          _buildGenderDropdown(),
          SizedBox(height: 16),
          _buildTextField(
            controller: controller.addressController,
            label: 'Address',
            icon: Icons.location_on_outlined,
            maxLines: 3,
            isRequired: true,
          ),
        ],
      ),
    );
  }

  Widget _buildEmploymentSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employment Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _buildEmploymentDropdown(),
          SizedBox(height: 16),
          _buildTextField(
            controller: controller.companyController,
            label: 'Company Name',
            icon: Icons.business_outlined,
            isRequired: true,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: controller.incomeController,
            label: 'Monthly Income (₹)',
            icon: Icons.currency_rupee_outlined,
            isRequired: true,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildKYCSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KYC Documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _buildTextField(
            controller: controller.panController,
            label: 'PAN Number',
            icon: Icons.credit_card_outlined,
            isRequired: true,
            maxLength: 10,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: controller.aadhaarController,
            label: 'Aadhaar Number',
            icon: Icons.badge_outlined,
            isRequired: true,
            keyboardType: TextInputType.number,
            maxLength: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        labelStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Color(0xFF00D4FF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white54),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF00D4FF)),
        ),
        filled: true,
        fillColor: Color(0xFF0C192E),
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: controller.dobController,
      readOnly: true,
      onTap: controller.selectDate,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Date of Birth *',
        labelStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(Icons.calendar_today_outlined, color: Color(0xFF00D4FF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white54),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF00D4FF)),
        ),
        filled: true,
        fillColor: Color(0xFF0C192E),
        suffixIcon: Icon(Icons.arrow_drop_down, color: Color(0xFF00D4FF)),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Obx(() {
      // Get current value, use 'Male' as default if empty
      String selectedValue = controller.userProfile.value.gender.isNotEmpty 
          ? controller.userProfile.value.gender 
          : 'Male';
      
      return DropdownButtonFormField<String>(
        initialValue: selectedValue,
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.changeGender(newValue);
          }
        },
        dropdownColor: Color(0xFF1E2E3D),
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Gender *',
          labelStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(Icons.transgender_outlined, color: Color(0xFF00D4FF)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white54),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF00D4FF)),
          ),
          filled: true,
          fillColor: Color(0xFF0C192E),
        ),
        items: ['Male', 'Female', 'Other']
            .map((gender) => DropdownMenuItem(
          value: gender,
          child: Text(gender, style: TextStyle(color: Colors.white)),
        ))
            .toList(),
      );
    });
  }

  Widget _buildEmploymentDropdown() {
    return Obx(() {
      // Get current value, use 'Salaried' as default if empty
      String selectedValue = controller.userProfile.value.employmentType.isNotEmpty 
          ? controller.userProfile.value.employmentType 
          : 'Salaried';
      
      return DropdownButtonFormField<String>(
        initialValue: selectedValue,
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.changeEmploymentType(newValue);
          }
        },
        dropdownColor: Color(0xFF1E2E3D),
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Employment Type *',
          labelStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(Icons.work_outlined, color: Color(0xFF00D4FF)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white54),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF00D4FF)),
          ),
          filled: true,
          fillColor: Color(0xFF0C192E),
        ),
        items: ['Salaried', 'Self-Employed', 'Business', 'Professional', 'Retired']
            .map((type) => DropdownMenuItem(
          value: type,
          child: Text(type, style: TextStyle(color: Colors.white)),
        ))
            .toList(),
      );
    });
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF00D4FF),
              side: BorderSide(color: Color(0xFF00D4FF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Cancel'),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.updateProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00D4FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Save Changes',style: TextStyle(color: Colors.black),),
          ),
        ),
      ],
    );
  }

  // Helper method to get image provider (handles both local file and URL)
  // ImageProvider? _getImageProvider(String imagePath) {
  //   if (imagePath.isEmpty) return null;
  //
  //   // Check if it's a URL (starts with http:// or https://)
  //   if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
  //     return NetworkImage(imagePath);
  //   } else {
  //     // It's a local file path
  //     return FileImage(File(imagePath));
  //   }
  // }
}