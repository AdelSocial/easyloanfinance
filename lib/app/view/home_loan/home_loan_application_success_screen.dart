import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/home_loan_review_controller.dart';
import '../../services/loan_storage_service.dart';
import '../../services/api_service.dart';
import '../../routes/app_pages.dart';

class HomeLoanApplicationSuccessScreen extends StatefulWidget {
  const HomeLoanApplicationSuccessScreen({super.key});

  @override
  State<HomeLoanApplicationSuccessScreen> createState() => _HomeLoanApplicationSuccessScreenState();
}

class _HomeLoanApplicationSuccessScreenState extends State<HomeLoanApplicationSuccessScreen> {
  HomeLoanReviewController? controller;
  String applicationNumber = '';
  DateTime? submittedDate;
  Map<String, dynamic>? loanData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Try to get controller, but don't fail if it doesn't exist
    try {
      controller = Get.find<HomeLoanReviewController>();
    } catch (e) {
      controller = null;
    }
    _loadLoanData();
  }

  Future<void> _loadLoanData() async {
    try {
      final loanId = await LoanStorageService.getCurrentLoanId('home');
      if (loanId != null) {
        // Generate application number from loan ID
        applicationNumber = 'HL${loanId.toString().padLeft(8, '0')}';
        
        // Fetch loan data to get created_at date
        final response = await ApiService.getHomeLoans();
        if (response['success'] == true && response['data'] != null) {
          final loans = response['data'] as List;
          final currentLoan = loans.firstWhere(
            (loan) => loan['id'] == loanId,
            orElse: () => loans.isNotEmpty ? loans.first : null,
          );
          
          if (currentLoan != null) {
            loanData = currentLoan as Map<String, dynamic>;
            // Parse created_at date
            if (currentLoan['created_at'] != null) {
              try {
                submittedDate = DateTime.parse(currentLoan['created_at'].toString());
              } catch (e) {
                submittedDate = DateTime.now();
              }
            } else {
              submittedDate = DateTime.now();
            }
          } else {
            submittedDate = DateTime.now();
          }
        } else {
          submittedDate = DateTime.now();
        }
      } else {
        // Fallback if no loan ID
        applicationNumber = 'HL${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
        submittedDate = DateTime.now();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading loan data: $e');
      }
      applicationNumber = 'HL${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      submittedDate = DateTime.now();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0C192E),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 40),
              _buildSuccessAnimation(),
              SizedBox(height: 32),
              _buildSuccessMessage(),
              SizedBox(height: 40),
              _buildApplicationDetailsCard(),
              SizedBox(height: 32),
              _buildNextStepsCard(),
              SizedBox(height: 40),
              _buildActionButtons(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Color(0xFF00D4FF).withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outlined,
              size: 60,
              color: Color(0xFF00D4FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Text(
          'Application Submitted Successfully!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          'Your home loan application has been received and is under process. Our relationship manager will contact you within 24 hours.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildApplicationDetailsCard() {
    return Container(
      width: double.infinity,
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
        border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.receipt_long_outlined, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Application Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildDetailRow(
            icon: Icons.confirmation_number_outlined,
            title: 'Application Number',
            value: applicationNumber,
            isImportant: true,
          ),
          SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            title: 'Submitted Date',
            value: submittedDate != null
                ? '${submittedDate!.day}/${submittedDate!.month}/${submittedDate!.year}'
                : DateFormat('dd/MM/yyyy').format(DateTime.now()),
          ),
          SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.schedule_outlined,
            title: 'Submitted Time',
            value: submittedDate != null
                ? '${submittedDate!.hour}:${submittedDate!.minute.toString().padLeft(2, '0')}'
                : DateFormat('HH:mm').format(DateTime.now()),
          ),
          SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.phone_in_talk_outlined,
            title: 'Contact Support',
            value: '1800-123-4567',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    bool isImportant = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF0C192E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF2D3E50)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Color(0xFF00D4FF)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: isImportant ? Color(0xFF00D4FF) : Colors.white,
                    fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard() {
    return Container(
      width: double.infinity,
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.list_alt_outlined, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Next Steps',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildStepItem(
            number: 1,
            title: 'Verification Call',
            description: 'Our executive will call you within 24 hours to verify details',
          ),
          SizedBox(height: 16),
          _buildStepItem(
            number: 2,
            title: 'Document Collection',
            description: 'We will collect required property and income documents',
          ),
          SizedBox(height: 16),
          _buildStepItem(
            number: 3,
            title: 'Property Valuation',
            description: 'Technical team will visit for property assessment',
          ),
          SizedBox(height: 16),
          _buildStepItem(
            number: 4,
            title: 'Sanction & Disbursement',
            description: 'Loan amount will be disbursed after final approval',
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required int number,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF0C192E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF2D3E50)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF00D4FF)),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: Color(0xFF00D4FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Download application summary
              _downloadApplicationSummary();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00D4FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_outlined, color: Color(0xFF0C192E)),
                SizedBox(width: 8),
                Text(
                  'Download Application Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C192E),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              // Navigate to home screen where user can see their applications
              Get.offAllNamed(Routes.homeScreen);
              // Show message that they can track status from home screen
              Future.delayed(Duration(milliseconds: 500), () {
                Get.snackbar(
                  'Track Application',
                  'You can track your application status from the home screen',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Color(0xFF00D4FF),
                  colorText: Colors.white,
                  duration: Duration(seconds: 3),
                );
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF00D4FF),
              side: BorderSide(color: Color(0xFF00D4FF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.track_changes_outlined),
                SizedBox(width: 8),
                Text(
                  'Track Application Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        TextButton(
          onPressed: () {
            // Go to dashboard
            Get.offAllNamed(Routes.homeScreen);
          },
          child: Text(
            'Back to Dashboard',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white54,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _downloadApplicationSummary() async {
    try {
      // Show loading
      Get.dialog(
        Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF1E2E3D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF00D4FF)),
                SizedBox(height: 16),
                Text(
                  'Preparing summary...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Prepare application summary text
      String summary = _generateApplicationSummary();

      // Close loading dialog
      Get.back();

      // Show summary in dialog with copy option
      _showSummaryDialog(summary);
    } catch (e) {
      Get.back(); // Close dialog if still open
      Get.snackbar(
        'Error',
        'Failed to prepare summary: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showSummaryDialog(String summary) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.7),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0xFF1E2E3D),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Application Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF0C192E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      summary,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Copy to clipboard
                        _copyToClipboard(summary);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color(0xFF00D4FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copy, size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Copy',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.back(); // Close dialog
    Get.snackbar(
      'Copied',
      'Application summary copied to clipboard',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  String _generateApplicationSummary() {
    final buffer = StringBuffer();
    buffer.writeln('HOME LOAN APPLICATION SUMMARY');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('');
    buffer.writeln('Application Number: $applicationNumber');
    
    if (submittedDate != null) {
      buffer.writeln('Submitted Date: ${DateFormat('dd/MM/yyyy').format(submittedDate!)}');
      buffer.writeln('Submitted Time: ${DateFormat('HH:mm').format(submittedDate!)}');
    }
    
    buffer.writeln('');
    buffer.writeln('LOAN DETAILS:');
    buffer.writeln('─────────────────────────────────────');
    
    if (controller != null && controller!.loanDetails.isNotEmpty) {
      controller!.loanDetails.forEach((key, value) {
        buffer.writeln('$key: $value');
      });
    } else {
      buffer.writeln('Loan details not available');
    }
    
    buffer.writeln('');
    buffer.writeln('PROPERTY DETAILS:');
    buffer.writeln('─────────────────────────────────────');
    
    if (controller != null && controller!.propertyDetails.isNotEmpty) {
      controller!.propertyDetails.forEach((key, value) {
        buffer.writeln('$key: $value');
      });
    } else {
      buffer.writeln('Property details not available');
    }
    
    if (loanData != null) {
      buffer.writeln('');
      buffer.writeln('APPLICANT DETAILS:');
      buffer.writeln('─────────────────────────────────────');
      if (loanData!['full_name'] != null) {
        buffer.writeln('Name: ${loanData!['full_name']}');
      }
      if (loanData!['email'] != null) {
        buffer.writeln('Email: ${loanData!['email']}');
      }
      if (loanData!['mobile'] != null) {
        buffer.writeln('Mobile: ${loanData!['mobile']}');
      }
    }
    
    buffer.writeln('');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('Thank you for choosing Easy Loan Finance!');
    buffer.writeln('Our team will contact you within 24 hours.');
    buffer.writeln('');
    buffer.writeln('Support: 1800-123-4567');
    
    return buffer.toString();
  }
}