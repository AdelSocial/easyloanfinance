import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/support_controller.dart';

class SupportScreen extends StatelessWidget {
  final SupportController controller = Get.put(SupportController());

  SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      appBar: AppBar(
        title: Text(
          'Support',
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
            icon: Icon(Icons.history_outlined),
            onPressed: () {
              Get.snackbar(
                'Support History',
                'View your previous support requests',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            SizedBox(height: 24),
            _buildQuickSupportSection(),
            SizedBox(height: 24),
            _buildFaqSection(),
            SizedBox(height: 24),
            _buildContactInfoSection(),
            SizedBox(height: 32),
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
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.5)),
            ),
            child: Icon(
              Icons.support_agent_outlined,
              size: 40,
              color: Color(0xFF00D4FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'How can we help you?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Our support team is available 24/7 to assist you with any questions or concerns about your loans',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outlined, size: 16, color: Color(0xFF00D4FF)),
                SizedBox(width: 6),
                Text(
                  'Average response time: 2 minutes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF00D4FF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Quick Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: controller.supportOptions.length,
          itemBuilder: (context, index) {
            return _buildSupportOptionCard(controller.supportOptions[index]);
          },
        ),
      ],
    );
  }

  Widget _buildSupportOptionCard(SupportOption option) {
    return GestureDetector(
      onTap: () => controller.handleSupportOptionTap(option),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1E2E3D),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(option.color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(option.icon, size: 20, color: Color(option.color)),
              ),
              SizedBox(height: 8),
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              SizedBox(height: 4),
              Text(
                option.subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white54,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: controller.viewAllFaqs,
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF00D4FF),
              ),
              child: Row(
                children: [
                  Text('View All'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.faqItems.take(3).length,
          itemBuilder: (context, index) {
            return _buildFaqItem(controller.faqItems[index], index,context);
          },
        ),
      ],
    );
  }

  Widget _buildFaqItem(FaqItem faq, int index,context) {
    return Obx(() => Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: controller.expandedFaqIndex.value == index
              ? Color(0xFF00D4FF).withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            faq.question,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          iconColor: Color(0xFF00D4FF),
          collapsedIconColor: Color(0xFF00D4FF),
          onExpansionChanged: (expanded) {
            if (expanded) {
              controller.expandFaq(index);
            } else {
              controller.expandFaq(-1);
            }
          },
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                faq.answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildContactInfoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2E3D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.1)),
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
                child: Icon(Icons.info_outlined, size: 20, color: Color(0xFF00D4FF)),
              ),
              SizedBox(width: 12),
              Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.contactInfo.length,
            itemBuilder: (context, index) {
              return _buildContactInfoRow(controller.contactInfo[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoRow(ContactInfo info) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF0C192E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Color(0xFF00D4FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(info.icon, size: 16, color: Color(0xFF00D4FF)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  info.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (info.title == 'Email' || info.title == 'Phone')
            IconButton(
              icon: Icon(Icons.copy_outlined, size: 16),
              onPressed: () {
                Get.snackbar(
                  'Copied',
                  '${info.value} copied to clipboard',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
            ),
        ],
      ),
    );
  }
}
