import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:score_progress_pretty_display/score_progress_pretty_display.dart';
import '../../controller/cibil_controller.dart';

class CibilScreen extends StatelessWidget {
  final CibilController controller = Get.put(CibilController());

  CibilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header with Back Button
              _buildHeader(context),
              _buildLogoSection(),
              // Main Content
              _buildMainContent(),
              SizedBox(height: 20,),
              _buildSubscriptionCard(),

              // Security Note
              _buildSecurityNote(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            "assets/images/logo2.png",
            height: Get.height / 8,
            width: Get.width / 2,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.account_balance,
                color: Color(0xFF63b5bb),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.all(8),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Text(
              'CIBIL Score',
              style: TextStyle(
                color: const Color(0xFF63b5bb),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        children: [
          // Title
          Text(
            'Check Your CIBIL Score to Continue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Subtitle
          Text(
            'Know your creditworthiness instantly and unlock the best loan offers.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          PrimaryArcAnimationComponent(
            score: 57,
            maxScore: 100,
            arcHeight: 250,
            arcWidth: 250,
            backgroundArcStrokeThickness: 15,
            progressArcStrokeThickness: 15,
            enableStepperEffect: true,
            isRoundEdges: true,
            minScoreTextFontSize: 32,
            maxScoreTextFontSize: 30,
            isRoundOffScoreWhileProgress: false,
            isRoundOffScore: true,
            showOutOfScoreFormat: false,
            isPrgressCurveFilled: false,
            scoreAnimationDuration: Duration(seconds: 2),
            scoreTextAnimationDuration: Duration(milliseconds: 600),

            /// Modern text styling
            scoreTextStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              height: 1,
              letterSpacing: 1.2,
              color: Colors.white,
              fontSize: 20
            ),

            /// Soft background arc
            arcBackgroundColor: Colors.red.withAlpha(50),

            arcProgressGradientColors: [
              Colors.green,
            Colors.green
          ],

            /// Glow + Smooth gradient
          ),

          SizedBox(height: 50,),
          _buildFeaturesList(),
        ],
      ),
    );
  }


  Widget _buildFeaturesList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B41).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF63b5bb).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildFeatureItem('Get instant CIBIL report + credit insights'),

          // Pricing Section
          const SizedBox(height: 20),
          _buildPricingSection(),
          const SizedBox(height: 20),

          _buildFeatureItem('Limited-time offer for Easy Loan users'),

        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Column(
      children: [
        // Original Price
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₹399',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.grey[400],
                decorationThickness: 2,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                '75% OFF',
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Discounted Price
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹99',
              style: TextStyle(
                color: const Color(0xFF63b5bb),
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 0.9,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'only',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Additional Offer Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF63b5bb).withOpacity(0.3),
                const Color(0xFF1B2B41).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF63b5bb).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flash_on,
                color: const Color(0xFF63b5bb),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Limited Time Offer',
                style: TextStyle(
                  color: const Color(0xFF63b5bb),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF63b5bb),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2B41),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFF63b5bb).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Subscribe Button
            _buildSubscribeButton(),
            const SizedBox(height: 15),

            // Terms Note
            Text(
              'One-time payment • Cancel anytime',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribeButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF63b5bb),
            Color(0xFF4a8b90),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF63b5bb).withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(Routes.homeScreen);
          },
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: Obx(() => controller.isLoading.value
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
              'Subscribe Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Text(
        'Your data is 100% secure and never shared without consent.',
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

