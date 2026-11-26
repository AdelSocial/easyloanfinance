import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessApplicationSuccessScreen extends StatelessWidget {
  const BusinessApplicationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: context.height/6,),
              _buildSuccessContent(),
              SizedBox(height: 40,),
              GestureDetector(
                onTap: (){
                  Get.toNamed(Routes.homeScreen);
                },
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSuccessContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00D4FF).withOpacity(0.1),
            Color(0xFF0C192E).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Color(0xFF00D4FF).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Application Submitted Successfully!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Your business loan application has been received and is under review.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          _buildApplicationDetails(),
        ],
      ),
    );
  }

  Widget _buildApplicationDetails() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF00D4FF).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.confirmation_number_outlined,
            title: 'Application ID',
            value: 'BL20241128001',
            isHighlighted: true,
          ),
          SizedBox(height: 15),
          _buildDetailRow(
            icon: Icons.business_center_outlined,
            title: 'Business Name',
            value: 'ABC Enterprises Pvt. Ltd.',
          ),
          SizedBox(height: 15),
          _buildDetailRow(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Loan Amount',
            value: '₹10,00,000',
          ),
          SizedBox(height: 15),
          _buildDetailRow(
            icon: Icons.schedule_outlined,
            title: 'Processing Time',
            value: '2-3 Business Days',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    bool isHighlighted = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF00D4FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Color(0xFF00D4FF),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: isHighlighted ? Color(0xFF00D4FF) : Colors.white,
                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildActionButtons() {
  //   return Column(
  //     children: [
  //       SizedBox(
  //         width: double.infinity,
  //         height: 56,
  //         child: ElevatedButton(
  //           onPressed: () {
  //             // Download application PDF
  //             _downloadApplicationPDF();
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Color(0xFF00D4FF).withOpacity(0.1),
  //             foregroundColor: Color(0xFF00D4FF),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16),
  //               side: BorderSide(
  //                 color: Color(0xFF00D4FF).withOpacity(0.5),
  //               ),
  //             ),
  //             elevation: 0,
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(Icons.download_outlined, size: 20),
  //               SizedBox(width: 10),
  //               Text(
  //                 'Download Application PDF',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 16),
  //       SizedBox(
  //         width: double.infinity,
  //         height: 56,
  //         child: ElevatedButton(
  //           onPressed: () {
  //             // Track application status
  //             Get.toNamed('/business-application-status');
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Color(0xFF00D4FF),
  //             foregroundColor: Color(0xFF0C192E),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //             elevation: 4,
  //             shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
  //           ),
  //           child: Text(
  //             'Track Application Status',
  //             style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 16),
  //       TextButton(
  //         onPressed: () {
  //           // Go to dashboard
  //           Get.until((route) => Get.currentRoute == '/dashboard');
  //         },
  //         style: TextButton.styleFrom(
  //           foregroundColor: Colors.white70,
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(Icons.home_outlined, size: 18),
  //             SizedBox(width: 8),
  //             Text('Back to Dashboard'),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // void _downloadApplicationPDF() {
  //   // PDF download logic here
  //   Get.snackbar(
  //     'Download Started',
  //     'Your application PDF is being downloaded',
  //     backgroundColor: Color(0xFF1E2E3D),
  //     colorText: Colors.white,
  //     snackPosition: SnackPosition.BOTTOM,
  //     margin: EdgeInsets.all(16),
  //   );
  // }

}