import 'package:easy_loan_finance/app/controller/home_controller.dart';
import 'package:easy_loan_finance/app/routes/app_pages.dart';
import 'package:easy_loan_finance/app/view/loan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../quick_action/apply_loan_screen.dart';

class HomeScreen extends StatelessWidget {
  
  HomeController get controller {
    try {
      return Get.find<HomeController>();
    } catch (e) {
      return Get.put(HomeController(), permanent: true);
    }
  }

   HomeScreen({super.key}) {
     // Always refresh user name when screen is opened
     WidgetsBinding.instance.addPostFrameCallback((_) {
       controller.loadUserProfile();
     });
   }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return PopScope(
        canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0C192E),
        body: SafeArea(
          child: Obx(() => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF63b5bb),
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildHeader(),
                      const SizedBox(height: 30),
                      _buildWelcomeSection(),
                      const SizedBox(height: 25),
                      // CIBIL Score Section - नया एडिशन
                      _buildCibilScoreSection(),
                      const SizedBox(height: 30),
                      // _buildWalletBalanceCard(),
                      // const SizedBox(height: 30),
                      //
                      // // Quick Actions Section
                      // _buildQuickActionsSection(),
                      // const SizedBox(height: 30),

                      // Active Loans Section
                      _buildActiveLoansSection(),
                      const SizedBox(height: 30),

                      // // Recent Transactions
                      // _buildRecentTransactions(),
                      // const SizedBox(height: 30),

                // Loan Offers Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Loan Offers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(() => ApplyLoanScreen());
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF63b5bb),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

              GestureDetector(
                onTap: (){
                  Get.toNamed(Routes.personalApplicationScreen);
                },
                child: Container(
                  width: context.width,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Center(
                    child: Text(
                      "Apply for Loan",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
                    ],
                  ),
                )),
        ),
        bottomNavigationBar: _buildCustomBottomNavBar(),
      ),
    );
  }

  Widget _buildCibilScoreSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B2B41).withOpacity(0.9),
            const Color(0xFF0C192E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
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
          // Header with Icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF63b5bb).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF63b5bb).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.credit_score,
                  color: Color(0xFF63b5bb),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'CIBIL Score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.fiber_manual_record,
                      color: Colors.green,
                      size: 8,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Good',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Score Display
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '750',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ 900',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              // Score Range Indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF63b5bb).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Color(0xFF63b5bb),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+12 pts',
                      style: TextStyle(
                        color: Color(0xFF63b5bb),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 750 / 900, // 750 out of 900
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF63b5bb)),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 20),

          // Check CIBIL Score Button - यही मुख्य बटन है
          InkWell(
            onTap: () {
              _showCibilScoreDialog();
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF63b5bb),
                    Color(0xFF4a8b90),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF63b5bb).withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Check CIBIL Score Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Last Updated
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white.withOpacity(0.5),
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                'Last updated: 02 Feb 2026',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // CIBIL Score Check Dialog
  void _showCibilScoreDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2B41),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF63b5bb).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF63b5bb).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF63b5bb).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.credit_score,
                  color: Color(0xFF63b5bb),
                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                'Check CIBIL Score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Description
              Text(
                'We will fetch your latest CIBIL score from credit bureaus. This will not affect your credit score.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              // Options
              _buildDialogOption(
                'Refresh Now',
                Icons.refresh,
                const Color(0xFF63b5bb),
                onTap: () {
                  Get.back();
                  _showScoreUpdatedDialog();
                },
              ),

              _buildDialogOption(
                'View Report',
                Icons.description,
                Colors.blue,
                onTap: () {
                  Get.back();
                },
              ),

              _buildDialogOption(
                'Score Factors',
                Icons.analytics,
                Colors.orange,
                onTap: () {
                  Get.back();
                },
              ),

              const SizedBox(height: 15),

              // Close Button
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF63b5bb).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Color(0xFF63b5bb),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Score Updated Dialog
  void _showScoreUpdatedDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2B41),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF63b5bb).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                'Score Updated!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // New Score
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '765',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '/900',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // Change
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.green,
                      size: 12,
                    ),
                    SizedBox(width: 2),
                    Text(
                      '+15 points',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // OK Button
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF63b5bb), Color(0xFF4a8b90)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Great!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogOption(String text, IconData icon, Color color, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0C192E).withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }


  // --- Enhanced Header ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                'assets/images/fix_logo.png',
                height: 30,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.account_balance, color: Colors.white, size: 32);
                },
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Easy Loan Finance",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        // Container(
        //   decoration: BoxDecoration(
        //   ),
        //   child: Stack(
        //     children: [
        //       const CircleAvatar(
        //         radius: 20,
        //         backgroundColor: Color(0xFF63b5bb),
        //         child: Icon(Icons.person, color: Colors.white),
        //       ),
        //       Positioned(
        //         right: 0,
        //         top: 0,
        //         child: CircleAvatar(
        //           radius: 10,
        //           backgroundColor: Colors.green,
        //           child: Center(
        //               child: Text(
        //                 textAlign: TextAlign.center,
        //                 '2',style: TextStyle(fontSize: 12,color: Colors.white),)),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),


        GestureDetector(
          onTap: (){
            controller.logout();
          },
          child: Image.asset(
            'assets/images/logout.png',
            height: 45,
          ),
        ),

        // GestureDetector(
        //   onTap: () {
        //     controller.logout();
        //   },
        //   child: Container(
        //     decoration: BoxDecoration(
        //     ),
        //     child: CircleAvatar(
        //       radius: 21,
        //       backgroundColor: Color(0xFF63b5bb),
        //       child: Icon(Icons.logout, color: Colors.white),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // --- Welcome Section ---
  Widget _buildWelcomeSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Good afternoon,',
        //   style: TextStyle(
        //     color: Colors.white.withOpacity(0.8),
        //     fontSize: 18,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        // const SizedBox(height: 5),
        Text(
          '${controller.userName.value}! 👋',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFF63b5bb).withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(20),
        //     border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.3)),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Icon(Icons.verified, color: const Color(0xFF63b5bb), size: 16),
        //       const SizedBox(width: 6),
        //       Text(
        //         'Premium Member',
        //         style: TextStyle(
        //           color: const Color(0xFF63b5bb),
        //           fontSize: 12,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    ));
  }

  // --- Enhanced Wallet Balance Card ---
  Widget _buildWalletBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B2B41), Color(0xFF0C192E)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Wallet Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF63b5bb).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.5)),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Color(0xFF63b5bb),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            '₹ ${_formatCurrency(controller.walletBalance.value)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          )),
          const SizedBox(height: 10),
          Obx(() => controller.todayDeposit.value > 0
              ? Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.green[400], size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '₹${_formatCurrency(controller.todayDeposit.value)} deposited today',
                      style: TextStyle(
                        color: Colors.green[400],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink()),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0C192E).withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.1)),
            ),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBalanceItem('Loan Eligibility', _formatCurrency(controller.loanEligibility.value), Icons.credit_card_outlined),
                _buildBalanceItem('Credit Score', controller.creditScore.value.toString(), Icons.auto_graph_outlined),
                _buildBalanceItem('Active EMI', _formatCurrency(controller.activeEMI.value), Icons.receipt_long_outlined),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B41).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF63b5bb).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFF63b5bb).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: const Color(0xFF63b5bb), size: 14),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label == 'Credit Score' ? value : '₹ $value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- Quick Actions Section ---
  Widget _buildQuickActionsSection() {
    final List<Map<String, dynamic>> quickActions = [
      {'icon': Icons.credit_card, 'label': 'Apply Loan', 'color': Colors.blue},
      {'icon': Icons.account_balance_wallet, 'label': 'Top Up', 'color': Colors.green},
      {'icon': Icons.swap_horiz, 'label': 'Transfer', 'color': Colors.orange},
      {'icon': Icons.history, 'label': 'History', 'color': Colors.purple},
      {'icon': Icons.qr_code, 'label': 'Pay', 'color': Colors.red},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 115,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return GestureDetector(
                onTap: (){
                  switch(index) {
                    case 0: Get.toNamed(Routes.applyLoanScreen);
                    break;
                    case 1: Get.toNamed(Routes.topUpScreen);
                    break;
                    case 2: Get.toNamed(Routes.transferScreen);
                    break;
                    case 3: Get.toNamed(Routes.loansScreen);
                    break;
                    case 4: Get.toNamed(Routes.payScreen);
                    break;
                  }
                },
                child: Container(
                  width: 70,
                  margin: EdgeInsets.only(right: index == quickActions.length - 1 ? 0 : 15),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              action['color'] as Color,
                              action['color'].withOpacity(0.7) as Color,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(action['icon'] as IconData, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        action['label'] as String,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Active Loans Section ---
  Widget _buildActiveLoansSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Loans',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: (){
                Get.off(() => LoansScreen());
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF63b5bb),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        controller.activeLoans.isEmpty
            ? Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF1B2B41).withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Text(
              'No active loans',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        )
            : Column(
          children: controller.activeLoans
              .map<Widget>((loan) => _buildLoanCard(loan))
              .toList(),
        ),

      ],
    ));
  }

  Widget _buildLoanCard(Map<String, dynamic> loan) {
    final double progress = (loan['progress'] ?? 0).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B41).withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loan['name'] ?? 'Unknown Loan',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                loan['amount']?.toString() ?? '0',
                style: const TextStyle(
                  color: Color(0xFF63b5bb),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EMI: ${loan['emi'] ?? '-'}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Tenure: ${loan['tenure'] ?? '-'}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF63b5bb).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}% Paid',
                  style: const TextStyle(
                    color: Color(0xFF63b5bb),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            color: const Color(0xFF63b5bb),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  // --- Recent Transactions ---
  Widget _buildRecentTransactions() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                color: Color(0xFF63b5bb),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        controller.recentTransactions.isEmpty
            ? Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF1B2B41).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    'No recent transactions',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            : Column(
          children: controller.recentTransactions
              .map<Widget>(
                (transaction) => _buildTransactionTile(transaction),
          )
              .toList(),
        ),


      ],
    ));
  }

  Widget _buildTransactionTile(Map<String, dynamic> transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B41).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: transaction['type'] == 'Deposit'
                  ? Colors.green.withOpacity(0.2)
                  : transaction['type'] == 'Withdrawal'
                  ? Colors.red.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              transaction['type'] == 'Deposit'
                  ? Icons.arrow_downward
                  : transaction['type'] == 'Withdrawal'
                  ? Icons.arrow_upward
                  : Icons.account_balance_wallet,
              color: transaction['type'] == 'Deposit'
                  ? Colors.green
                  : transaction['type'] == 'Withdrawal'
                  ? Colors.red
                  : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['type'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${transaction['date']} • ${transaction['time']}',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction['amount'] as String,
                style: TextStyle(
                  color: transaction['type'] == 'Deposit' ? Colors.green : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                transaction['status'] as String,
                style: TextStyle(
                  color: transaction['status'] == 'Completed'
                      ? Colors.green
                      : Colors.orange,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoanOffersSection(context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child:  Text(
        "Loan",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B41),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
        border: const Border(
          top: BorderSide(
            color: Colors.white10,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF1B2B41),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF63b5bb),
        unselectedItemColor: Colors.white54,
        currentIndex: controller.selectedIndex.value,
        onTap: (index){
          controller.selectedIndex.value = index;
          switch (index){
            case 0 : Get.toNamed(Routes.homeScreen);
            break;
            case 1 : Get.toNamed(Routes.loansScreen);
            break;
            case 2 : Get.toNamed(Routes.profileScreen);
            break;
            case 3 : Get.toNamed(Routes.supportScreen);
            break;
          }
        },
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Loans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent_outlined),
            activeIcon: Icon(Icons.support_agent),
            label: 'Support',
          ),
        ],
      ),
    );
  }

  // Format currency helper
  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}



