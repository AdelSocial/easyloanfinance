import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../routes/app_pages.dart';
import '../services/api_service.dart';

class ProfileController extends GetxController {
  // User profile data
  var userProfile = UserProfile(
    name: 'Tanishq',
    email: 'Tanishq.@example.com',
    phone: '+91 9876543210',
    dateOfBirth: '1990-05-15',
    gender: 'Male',
    address: '123, Sector 62, Noida, Uttar Pradesh - 201309',
    panNumber: 'ABCDE1234F',
    aadhaarNumber: '1234 5678 9012',
    creditScore: 785,
    employmentType: 'Salaried',
    companyName: 'Tech Solutions Pvt. Ltd.',
    monthlyIncome: 75000,
    profileImage: '',
  ).obs;

  // Edit mode
  var isEditMode = false.obs;

  // Form controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var dobController = TextEditingController();
  var addressController = TextEditingController();
  var panController = TextEditingController();
  var aadhaarController = TextEditingController();
  var companyController = TextEditingController();
  var incomeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Set default values if empty
    if (userProfile.value.employmentType.isEmpty) {
      userProfile.value.employmentType = 'Salaried';
    }
    if (userProfile.value.gender.isEmpty) {
      userProfile.value.gender = 'Male';
    }
    loadProfile().then((_) {
      // Set defaults after loading if still empty
      if (userProfile.value.employmentType.isEmpty) {
        userProfile.value.employmentType = 'Salaried';
      }
      if (userProfile.value.gender.isEmpty) {
        userProfile.value.gender = 'Male';
      }
      loadProfileStats();
    });
  }

  void _initializeControllers() {
    nameController.text = userProfile.value.name;
    emailController.text = userProfile.value.email;
    phoneController.text = userProfile.value.phone;
    dobController.text = userProfile.value.dateOfBirth;
    addressController.text = userProfile.value.address;
    panController.text = userProfile.value.panNumber;
    aadhaarController.text = userProfile.value.aadhaarNumber;
    companyController.text = userProfile.value.companyName;
    incomeController.text = userProfile.value.monthlyIncome > 0 
        ? userProfile.value.monthlyIncome.toStringAsFixed(0)
        : '';
  }
  
  // Make _initializeControllers accessible from EditProfileScreen
  void initializeControllers() {
    _initializeControllers();
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    if (!isEditMode.value) {
      // Reset to original values when canceling edit
      _initializeControllers();
    }
  }

  var isLoading = false.obs;

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getProfile();
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        // Handle fullname (if available) or construct from firstname/lastname
        String fullName = data['name'] ?? 
                         data['fullname'] ?? 
                         (data['firstname'] != null && data['lastname'] != null
                             ? '${data['firstname']} ${data['lastname']}'
                             : '') ??
                         '';
        
        userProfile.value = UserProfile(
          name: fullName,
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          dateOfBirth: data['date_of_birth'] ?? '',
          gender: data['gender'] ?? '',
          address: data['address'] ?? '',
          panNumber: data['pan_number'] ?? '',
          aadhaarNumber: data['aadhaar_number'] ?? '',
          creditScore: (data['credit_score'] ?? 0) is int 
              ? data['credit_score'] ?? 0 
              : int.tryParse(data['credit_score'].toString()) ?? 0,
          employmentType: data['employment_type'] ?? '',
          companyName: data['company_name'] ?? '',
          monthlyIncome: (data['monthly_income'] ?? 0) is double
              ? (data['monthly_income'] ?? 0).toDouble()
              : double.tryParse(data['monthly_income'].toString()) ?? 0.0,
          profileImage: data['image'] ?? 
                       data['profile_image'] ?? 
                       '',
        );
        _initializeControllers();
      }
    } catch (e) {
      print('Error loading profile: $e');
      Get.snackbar('Error', 'Failed to load profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    // Ensure gender and employment_type have valid values before validation
    if (userProfile.value.gender.isEmpty || 
        !['Male', 'Female', 'Other'].contains(userProfile.value.gender)) {
      userProfile.update((profile) {
        profile!.gender = 'Male';
      });
    }
    if (userProfile.value.employmentType.isEmpty || 
        !['Salaried', 'Self-Employed', 'Business', 'Professional', 'Retired'].contains(userProfile.value.employmentType)) {
      userProfile.update((profile) {
        profile!.employmentType = 'Salaried';
      });
    }
    
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      // Get values - ensure they are valid strings
      String gender = userProfile.value.gender.isNotEmpty 
          ? userProfile.value.gender.toString()
          : 'Male';
      String employmentType = userProfile.value.employmentType.isNotEmpty 
          ? userProfile.value.employmentType.toString()
          : 'Salaried';
      
      print('Sending update data:');
      print('Gender: "$gender" (type: ${gender.runtimeType}, length: ${gender.length})');
      print('Employment Type: "$employmentType" (type: ${employmentType.runtimeType}, length: ${employmentType.length})');
      print('UserProfile gender: ${userProfile.value.gender}');
      print('UserProfile employmentType: ${userProfile.value.employmentType}');
      
      final response = await ApiService.updateProfile({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'date_of_birth': dobController.text.trim().isNotEmpty ? dobController.text.trim() : null,
        'gender': gender,
        'address': addressController.text.trim(),
        'pan_number': panController.text.trim(),
        'aadhaar_number': aadhaarController.text.trim(),
        'employment_type': employmentType,
        'company_name': companyController.text.trim(),
        'monthly_income': incomeController.text.trim().isNotEmpty 
            ? double.tryParse(incomeController.text.trim()) ?? 0 
            : 0,
      });

      print('Update Profile Response: $response');
      print('Response success: ${response['success']}');
      print('Response status: ${response['status']}');
      print('Response statusCode: ${response['statusCode']}');
      
      // Check for success - handle different response formats
      bool isSuccess = false;
      if (response['success'] == true) {
        isSuccess = true;
      } else if (response['statusCode'] != null) {
        // If statusCode is 2xx and success is not explicitly false
        int? statusCode = response['statusCode'];
        if (statusCode != null && statusCode >= 200 && statusCode < 300 && response['success'] != false) {
          isSuccess = true;
        }
      } else if (response['status'] == 'success') {
        isSuccess = true;
      }
      
      if (isSuccess) {
        print('Profile update successful, refreshing data...');
        
        // Refresh profile from API to get latest data
        await loadProfile();
        await loadProfileStats();
        
        // Also update text controllers with latest data
        _initializeControllers();

        isEditMode.value = false;
        
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        // Wait a bit for snackbar to show, then go back
        await Future.delayed(Duration(milliseconds: 500));
        Get.offNamed(Routes.profileScreen);
        // Go back to profile screen
        Get.back();
      } else {
        // Handle validation errors
        String errorMessage = ApiService.msg(response['message'], 'Failed to update profile');
        final errors = response['errors'];
        
        if (errors != null && errors is Map) {
          // Format validation errors
          List<String> errorList = [];
          errors.forEach((key, value) {
            if (value is List) {
              errorList.addAll(value.map((e) => e.toString()));
            } else {
              errorList.add(value.toString());
            }
          });
          if (errorList.isNotEmpty) {
            errorMessage = errorList.join('\n');
          }
        }
        
        print('Update Profile Error: $errorMessage');
        print('Full Error Response: $response');
        
        Get.snackbar(
          'Error', 
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Exception in updateProfile: $e');
      Get.snackbar('Error', 'Failed to update profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return false;
    }
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return false;
    }
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return false;
    }
    if (panController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter PAN number');
      return false;
    }
    return true;
  }

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // Compress image to 85% quality
      maxWidth: 1024, // Resize to max 1024px width
      maxHeight: 1024, // Resize to max 1024px height
    );

    if (image != null) {
      // Show local image immediately
      userProfile.update((profile) {
        profile!.profileImage = image.path;
      });

      // Upload image to server
      isLoading.value = true;
      try {
        final response = await ApiService.uploadProfileImage(image.path);
        
        if (response['success'] == true) {
          // Update profile with server URL
          final imageUrl = response['data']?['image_url'] ?? 
                          response['data']?['user']?['image'] ??
                          '';
          
          if (imageUrl.isNotEmpty) {
            userProfile.update((profile) {
              profile!.profileImage = imageUrl;
            });
          }
          
          Get.snackbar(
            'Success',
            'Profile picture uploaded successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        } else {
          // Keep local image but show error
          Get.snackbar(
            'Upload Failed',
            ApiService.msg(response['message'], 'Failed to upload image. Image saved locally.'),
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      } catch (e) {
        print('Error uploading profile image: $e');
        Get.snackbar(
          'Upload Error',
          'Failed to upload image: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void changeGender(String? newGender) {
    if (newGender != null) {
      userProfile.update((profile) {
        profile!.gender = newGender;
      });
    }
  }

  void changeEmploymentType(String? newType) {
    if (newType != null) {
      userProfile.update((profile) {
        profile!.employmentType = newType;
      });
    }
  }

  void selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      dobController.text = formattedDate;
      userProfile.update((profile) {
        profile!.dateOfBirth = formattedDate;
      });
    }
  }

  // Profile statistics - dynamic
  var profileStats = <ProfileStat>[].obs;

  // Load profile statistics from dashboard
  Future<void> loadProfileStats() async {
    try {
      final response = await ApiService.getDashboard();
      if (response['success'] == true || response['status'] == 'success') {
        final data = response['data'] ?? {};
        final insights = data['insights'] ?? {};
        final user = data['user'] ?? {};
        
        // Calculate years with us (from created_at)
        final createdAt = user['created_at'];
        int yearsWithUs = 0;
        if (createdAt != null) {
          try {
            final createdDate = DateTime.parse(createdAt.toString());
            final now = DateTime.now();
            yearsWithUs = now.year - createdDate.year;
            if (now.month < createdDate.month || 
                (now.month == createdDate.month && now.day < createdDate.day)) {
              yearsWithUs--;
            }
          } catch (e) {
            yearsWithUs = 0;
          }
        }

        // Calculate total loans from insights or running loans
        int totalLoans = (insights['running_loan'] ?? 0) + (insights['pending_loan'] ?? 0);
        
        // Update profile stats
        profileStats.assignAll([
          ProfileStat(
            title: 'Total Loans', 
            value: totalLoans.toString(), 
            icon: Icons.account_balance_wallet_outlined
          ),
          ProfileStat(
            title: 'Active Loans', 
            value: (insights['running_loan'] ?? 0).toString(), 
            icon: Icons.trending_up_outlined
          ),
          ProfileStat(
            title: 'Credit Score', 
            value: userProfile.value.creditScore > 0 
                ? userProfile.value.creditScore.toString() 
                : 'N/A', 
            icon: Icons.credit_score_outlined
          ),
          ProfileStat(
            title: 'Years with us', 
            value: yearsWithUs > 0 ? yearsWithUs.toString() : '0', 
            icon: Icons.calendar_today_outlined
          ),
        ]);
      }
    } catch (e) {
      print('Error loading profile stats: $e');
      // Set default stats if API fails
      profileStats.assignAll([
        ProfileStat(title: 'Total Loans', value: '0', icon: Icons.account_balance_wallet_outlined),
        ProfileStat(title: 'Active Loans', value: '0', icon: Icons.trending_up_outlined),
        ProfileStat(title: 'Credit Score', value: 'N/A', icon: Icons.credit_score_outlined),
        ProfileStat(title: 'Years with us', value: '0', icon: Icons.calendar_today_outlined),
      ]);
    }
  }
}

class UserProfile {
  String name;
  String email;
  String phone;
  String dateOfBirth;
  String gender;
  String address;
  String panNumber;
  String aadhaarNumber;
  int creditScore;
  String employmentType;
  String companyName;
  double monthlyIncome;
  String profileImage;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.panNumber,
    required this.aadhaarNumber,
    required this.creditScore,
    required this.employmentType,
    required this.companyName,
    required this.monthlyIncome,
    required this.profileImage,
  });
}

class ProfileStat {
  final String title;
  final String value;
  final IconData icon;

  ProfileStat({
    required this.title,
    required this.value,
    required this.icon,
  });
}