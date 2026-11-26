import 'dart:io';
import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/profile_controller.dart';
import 'edit_profile_screen.dart';


class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with WidgetsBindingObserver {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Use Get.put to create if not exists, or reuse existing controller
    // This ensures controller is always available
    controller = Get.put(ProfileController(), permanent: false);
    // Refresh profile data every time screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfileData();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshProfileData();
    }
  }

  void _refreshProfileData() {
    controller.loadProfile().then((_) => controller.loadProfileStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: Obx(() => controller.isLoading.value 
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D4FF)),
              ),
            )
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: GestureDetector(
                onTap: (){
                  Get.offAllNamed(Routes.homeScreen);
                },
                child: Icon(Icons.arrow_back,color: Colors.white,)),

            expandedHeight: 20.0,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF0C192E),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'My Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF00D4FF).withOpacity(0.1),
                      Color(0xFF0C192E),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
                SizedBox(height: 24),
                _buildProfileStats(),
                SizedBox(height: 24),
                _buildProfileDetails(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildProfileHeader() {
    return  Container(
      padding: EdgeInsets.all(110),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Obx(() => Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF00D4FF),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: controller.userProfile.value.profileImage.isNotEmpty
                      ? Image.network(
                    controller.userProfile.value.profileImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _defaultAvatar();
                    },
                  )
                      : _defaultAvatar(),
                ),
              )),

            ],
          ),
          SizedBox(height: 16),
          Obx(() => Text(
            controller.userProfile.value.name.isNotEmpty 
                ? controller.userProfile.value.name 
                : 'No Name',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
          SizedBox(height: 4),
          Obx(() => Text(
            controller.userProfile.value.email.isNotEmpty 
                ? controller.userProfile.value.email 
                : 'No Email',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          )),
          SizedBox(height: 8),
          Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.credit_score_outlined, size: 16, color: Color(0xFF00D4FF)),
                SizedBox(width: 6),
                Text(
                  'Credit Score: ${controller.userProfile.value.creditScore > 0 ? controller.userProfile.value.creditScore : 'N/A'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF00D4FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              await Get.to(() => EditProfileScreen());
              // Refresh profile data when coming back from edit screen
              controller.loadProfile().then((_) => controller.loadProfileStats());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00D4FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: Icon(Icons.edit_outlined, size: 18,color: Colors.white,),
            label: Text(textAlign: TextAlign.center,'Edit Profile',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStats() {
    return Obx(() => controller.isLoading.value 
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(40),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D4FF)),
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: controller.profileStats.length,
              itemBuilder: (context, index) {
                return _buildStatCard(controller.profileStats[index]);
              },
            ),
          ),
    );
  }
  Widget _defaultAvatar() {
    return Container(
      color: Color(0xFF00D4FF).withOpacity(0.1),
      child: Icon(
        Icons.person_outlined,
        size: 40,
        color: Color(0xFF00D4FF),
      ),
    );
  }

  Widget _buildStatCard(ProfileStat stat) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFF00D4FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(stat.icon, size: 20, color: Color(0xFF00D4FF)),
            ),
            SizedBox(height: 12),
            Text(
              stat.value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              stat.title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(20),
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
                child: Icon(Icons.person_outlined, size: 20, color: Color(0xFF00D4FF)),
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
          SizedBox(height: 20),
          Obx(() => _buildInfoRow('Full Name', controller.userProfile.value.name.isNotEmpty ? controller.userProfile.value.name : 'Not provided')),
          Obx(() => _buildInfoRow('Email', controller.userProfile.value.email.isNotEmpty ? controller.userProfile.value.email : 'Not provided')),
          Obx(() => _buildInfoRow('Phone', controller.userProfile.value.phone.isNotEmpty ? controller.userProfile.value.phone : 'Not provided')),
          Obx(() => _buildInfoRow('Date of Birth', controller.userProfile.value.dateOfBirth.isNotEmpty ? controller.userProfile.value.dateOfBirth : 'Not provided')),
          Obx(() => _buildInfoRow('Gender', controller.userProfile.value.gender.isNotEmpty ? controller.userProfile.value.gender : 'Not provided')),
          Obx(() => _buildInfoRow('Address', controller.userProfile.value.address.isNotEmpty ? controller.userProfile.value.address : 'Not provided', isMultiLine: true)),

          SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.work_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Employment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(() => _buildInfoRow('Employment Type', controller.userProfile.value.employmentType.isNotEmpty ? controller.userProfile.value.employmentType : 'Not provided')),
          Obx(() => _buildInfoRow('Company Name', controller.userProfile.value.companyName.isNotEmpty ? controller.userProfile.value.companyName : 'Not provided')),
          Obx(() => _buildInfoRow('Monthly Income', controller.userProfile.value.monthlyIncome > 0 ? '₹${controller.userProfile.value.monthlyIncome.toStringAsFixed(0)}' : 'Not provided')),

          SizedBox(height: 24),
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
                'KYC Documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(() => _buildInfoRow('PAN Number', controller.userProfile.value.panNumber.isNotEmpty ? controller.userProfile.value.panNumber : 'Not provided')),
          Obx(() => _buildInfoRow('Aadhaar Number', controller.userProfile.value.aadhaarNumber.isNotEmpty ? controller.userProfile.value.aadhaarNumber : 'Not provided')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMultiLine = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF0C192E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: isMultiLine ? 3 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // // Helper method to get image provider (handles both local file and URL)
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