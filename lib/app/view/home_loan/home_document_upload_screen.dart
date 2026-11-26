import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_loan_document_controller.dart';
import '../../routes/app_pages.dart';

class HomeLoanDocumentUploadScreen extends StatelessWidget {
  final HomeLoanDocumentController controller = Get.put(HomeLoanDocumentController());

  HomeLoanDocumentUploadScreen({super.key});

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
            _buildDocumentUploadSection(),
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
                child: Icon(Icons.folder_copy_outlined, size: 24, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Home Loan Document Upload',
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
            'Upload required documents to complete your home loan application',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadSection() {
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
                child: Icon(Icons.upload_file_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Required Home Loan Documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildDocumentItem(
            title: 'PAN Card',
            subtitle: 'Upload scanned copy of PAN card (Front & Back)',
            icon: Icons.credit_card_outlined,
            documentType: 'PAN Card',
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Aadhaar Card',
            subtitle: 'Upload scanned copy of Aadhaar card (Front & Back)',
            icon: Icons.badge_outlined,
            documentType: 'Aadhaar Card',
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Address Proof',
            subtitle: 'Passport, Driving License, Voter ID, or Utility Bill',
            icon: Icons.location_on_outlined,
            documentType: 'Address Proof',
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Income Proof',
            subtitle: 'Salary slips (last 3 months) or ITR (last 2 years)',
            icon: Icons.attach_money_outlined,
            documentType: 'Income Proof',
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Bank Statements',
            subtitle: 'Last 6 months bank statements (PDF)',
            icon: Icons.description_outlined,
            documentType: 'Bank Statements',
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Property Documents',
            subtitle: 'Sale deed, Agreement, Property papers',
            icon: Icons.home_work_outlined,
            documentType: 'Property Documents',
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Passport Size Photograph',
            subtitle: 'Recent passport size color photograph',
            icon: Icons.camera_alt_outlined,
            documentType: 'Photograph',
          ),
          SizedBox(height: 16),
          _buildDocumentItem(
            title: 'Signature',
            subtitle: 'Scanned copy of your signature',
            icon: Icons.draw_outlined,
            documentType: 'Signature',
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required String documentType,
  }) {
    return Obx(() {
      final uploaded = controller.getUploadedState(documentType).value;
      final isLoading = controller.getLoadingState(documentType).value;
      final isThisPickerActive = controller.getPickerActiveState(documentType).value;

      // Determine if THIS SPECIFIC button should be disabled
      final bool isDisabled = isLoading || isThisPickerActive || uploaded;

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF0C192E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: uploaded ? Color(0xFF00D4FF) : Color(0xFF2D3E50),
            width: uploaded ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox/Status Icon
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: uploaded ? Color(0xFF00D4FF) : Colors.transparent,
                border: Border.all(
                  color: uploaded ? Color(0xFF00D4FF) : Colors.white54,
                  width: 1.5,
                ),
              ),
              child: uploaded
                  ? Center(
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: Color(0xFF0C192E),
                ),
              )
                  : null,
            ),
            SizedBox(width: 16),

            // Document Icon
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFF00D4FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Color(0xFF00D4FF), size: 22),
            ),
            SizedBox(width: 12),

            // Document Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Upload Button
            AbsorbPointer(
              absorbing: isDisabled,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 90,
                ),
                child: ElevatedButton(
                  onPressed: isDisabled
                      ? null
                      : () {
                    // Additional safety check
                    if (!controller.getLoadingState(documentType).value &&
                        !controller.getPickerActiveState(documentType).value &&
                        !controller.getUploadedState(documentType).value) {
                      controller.pickDocument(documentType);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uploaded
                        ? Colors.green.withOpacity(0.2)
                        : (isDisabled
                        ? Color(0xFF2D3E50)
                        : Color(0xFF00D4FF)),
                    foregroundColor: uploaded
                        ? Colors.green
                        : (isDisabled ? Colors.white54 : Color(0xFF0C192E)),
                    disabledForegroundColor: Colors.white54,
                    disabledBackgroundColor: Color(0xFF2D3E50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 0,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: isLoading
                      ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      uploaded
                          ? Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Colors.green,
                      )
                          : Icon(
                        Icons.upload,
                        size: 14,
                        color: isDisabled
                            ? Colors.white54
                            : Color(0xFF0C192E),
                      ),
                      SizedBox(width: 4),
                      Text(
                        uploaded ? 'Done' : 'Upload',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildContinueButton() {
    return Obx(() {
      final isFormValid = controller.isFormValid;
      final uploadedCount = controller.uploadedCount;
      final uploadProgress = controller.uploadProgress;
      final isAnyUploading = controller.isAnyUploading;
      final isAnyPickerActive = controller.isAnyPickerActive;

      return Column(
        children: [
          // Progress indicator
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: Color(0xFF2D3E50),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                // Background
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Progress
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width: (Get.width - 40) * uploadProgress,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF00D4FF),
                        Color(0xFF0099CC),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          // Progress text with upload status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$uploadedCount/8 documents uploaded',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              if (isAnyUploading || isAnyPickerActive)
                Row(
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF00D4FF),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Uploading...',
                      style: TextStyle(
                        color: Color(0xFF00D4FF),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          SizedBox(height: 20),

          // Continue Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isFormValid && !isAnyUploading && !isAnyPickerActive
                  ? () {
                Get.toNamed(Routes.homeLoanSubmitScreen);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFormValid
                    ? Color(0xFF00D4FF)
                    : Color(0xFF2D3E50),
                disabledBackgroundColor: Color(0xFF2D3E50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: isFormValid ? 4 : 0,
                shadowColor: isFormValid
                    ? Color(0xFF00D4FF).withOpacity(0.3)
                    : Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAnyUploading || isAnyPickerActive)
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    isFormValid
                        ? 'Review Home Loan Application'
                        : 'Complete All Uploads',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isFormValid
                          ? Color(0xFF0C192E)
                          : Colors.white54,
                    ),
                  ),
                  if (isFormValid && !isAnyUploading && !isAnyPickerActive)
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF0C192E),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Tips section
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1E2E3D).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFF00D4FF).withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 18,
                      color: Color(0xFF00D4FF),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Upload Tips',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• Ensure documents are clear and readable\n'
                      '• File size should be less than 5MB\n'
                      '• Supported formats: JPG, PNG, PDF\n'
                      '• Upload all documents before proceeding',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Debug info (optional - remove in production)
          SizedBox(height: 16),
          // Use kDebugMode from foundation.dart instead of Get.isDebugMode
          // Remove this section in production
          /*
          if (kDebugMode)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug Info:',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Any Uploading: $isAnyUploading',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Any Picker Active: $isAnyPickerActive',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Progress: ${(uploadProgress * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          */
        ],
      );
    });
  }
}