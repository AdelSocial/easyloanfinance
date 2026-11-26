import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/old_car_success_controller.dart';


class OldCarSuccessScreen extends StatelessWidget {
  final OldCarSuccessController controller = Get.put(OldCarSuccessController());

  OldCarSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 40),
              _buildSuccessIcon(),
              SizedBox(height: 32),
              _buildSuccessTitle(),
              SizedBox(height: 16),
              _buildSuccessMessage(),
              SizedBox(height: 40),
              _buildApplicationCard(),
              SizedBox(height: 32),
              _buildNextSteps(),
              SizedBox(height: 40),
              _buildActionButtons(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00D4FF).withOpacity(0.3),
            Color(0xFF00D4FF).withOpacity(0.1),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.5), width: 3),
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0xFF00D4FF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            size: 40,
            color: Color(0xFF0C192E),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessTitle() {
    return Text(
      'Application Submitted!',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Your used car loan application has been received successfully. '
            'We will contact you shortly to schedule vehicle inspection.',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white70,
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildApplicationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E2E3D),
            Color(0xFF0C192E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_turned_in, color: Color(0xFF00D4FF), size: 24),
              SizedBox(width: 8),
              Text(
                'Application Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildInfoRow(
            icon: Icons.confirmation_number,
            label: 'Application ID',
            value: controller.applicationNumber.value,
            isImportant: true,
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Submission Date',
            value: controller.formattedDate,
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Submission Time',
            value: controller.formattedTime,
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.schedule,
            label: 'Expected Response',
            value: 'Within 48 Hours',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isImportant = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF0C192E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFF00D4FF), size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isImportant ? 18 : 16,
                    fontWeight: isImportant ? FontWeight.bold : FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextSteps() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Steps',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _buildStepItem(
            step: 1,
            title: 'Document Verification',
            description: 'Review of your submitted KYC and income documents',
          ),
          SizedBox(height: 16),
          _buildStepItem(
            step: 2,
            title: 'Vehicle Inspection',
            description: 'Physical inspection of the used car by our experts',
          ),
          SizedBox(height: 16),
          _buildStepItem(
            step: 3,
            title: 'Car Valuation',
            description: 'Assessment of car value and loan eligibility',
          ),
          SizedBox(height: 16),
          _buildStepItem(
            step: 4,
            title: 'Final Approval & Disbursement',
            description: 'Loan approval and fund transfer process',
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required int step,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Color(0xFF00D4FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: Color(0xFF0C192E),
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.trackApplication,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00D4FF),
              foregroundColor: Color(0xFF0C192E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: Color(0xFF00D4FF).withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.track_changes, size: 20),
                SizedBox(width: 8),
                Text(
                  'Track Application Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: controller.applyForAnotherLoan,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF00D4FF),
                    side: BorderSide(color: Color(0xFF00D4FF), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Apply for Another Loan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: controller.goToHome,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        TextButton(
          onPressed: controller.contactSupport,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.help_outline, color: Color(0xFF00D4FF), size: 20),
              SizedBox(width: 8),
              Text(
                'Need Help? Contact Support',
                style: TextStyle(
                  color: Color(0xFF00D4FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}