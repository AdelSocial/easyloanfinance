import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CreditCardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> creditCards = [
    {
      'type': 'Visa Platinum',
      'bank': 'HDFC Bank',
      'limit': '₹5,00,000',
      'cashback': '5%',
      'annualFee': '₹500',
      'color1': const Color(0xFF1B2B41),
      'color2': const Color(0xFF2C3E50),
      'icon': Icons.credit_card,
      'benefits': ['Airport Lounge', 'Fuel Surcharge Waiver', 'Movie Offers'],
      'rating': 4.5,
      'reviews': 1240,
      'offer': 'Zero Fee for 1st Year',
      'image': 'visa_card.png',
    },
    {
      'type': 'Mastercard World',
      'bank': 'ICICI Bank',
      'limit': '₹3,00,000',
      'cashback': '2%',
      'annualFee': '₹299',
      'color1': const Color(0xFF63b5bb),
      'color2': const Color(0xFF4a8b90),
      'icon': Icons.credit_score,
      'benefits': ['Shopping Discounts', 'EMI Options', 'Reward Points'],
      'rating': 4.2,
      'reviews': 890,
      'offer': 'Welcome Gift Voucher',
      'image': 'mastercard.png',
    },
    {
      'type': 'RuPay Platinum',
      'bank': 'SBI Card',
      'limit': '₹2,00,000',
      'cashback': '1.5%',
      'annualFee': '₹199',
      'color1': const Color(0xFF0C192E),
      'color2': const Color(0xFF1B2B41),
      'icon': Icons.payment,
      'benefits': ['UPI Integration', 'Domestic Lounge', 'Bill Splits'],
      'rating': 4.0,
      'reviews': 2100,
      'offer': '1% Fuel Surcharge Waiver',
      'image': 'rupay.png',
    },
    {
      'type': 'American Express',
      'bank': 'Amex',
      'limit': '₹8,00,000',
      'cashback': '3%',
      'annualFee': '₹1000',
      'color1': const Color(0xFF2C3E50),
      'color2': const Color(0xFF34495E),
      'icon': Icons.card_membership,
      'benefits': ['Travel Points', 'Dining Offers', 'Hotel Discounts'],
      'rating': 4.7,
      'reviews': 560,
      'offer': '2x Reward Points',
      'image': 'amex.png',
    },
  ];

  final List<Map<String, dynamic>> featuredCards = [
    {
      'title': 'Premium Travel Card',
      'subtitle': 'Unlimited Lounge Access',
      'image': Icons.flight_takeoff,
      'color': const Color(0xFF63b5bb),
    },
    {
      'title': 'Shopping Special',
      'subtitle': '5% Cashback on Shopping',
      'image': Icons.shopping_bag,
      'color': const Color(0xFF4a8b90),
    },
    {
      'title': 'Fuel Saver',
      'subtitle': '2% Fuel Surcharge Waiver',
      'image': Icons.local_gas_station,
      'color': const Color(0xFF1B2B41),
    },
  ];

  final List<String> categories = [
    'All Cards',
    'Premium',
    'Cashback',
    'Travel',
    'Shopping',
    'Fuel',
    'Lifestyle',
    'Student',
    'Business'
  ];

  final RxInt selectedCategory = 0.obs;
  final RxBool isGridView = false.obs;
  final RxString selectedSort = 'Popular'.obs;

  CreditCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192E),
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header with Stats
            _buildEnhancedHeader(context),

            // Featured Cards Carousel
            _buildFeaturedCarousel(),

            // Search Bar with Advanced Filters
            _buildAdvancedSearchBar(),

            // Categories Horizontal Scroll
            _buildCategoriesList(),

            // Sort and View Toggle
            _buildSortAndViewToggle(),

            // Credit Cards Grid/List
            Expanded(
              child: Obx(() => isGridView.value
                  ? _buildCreditCardsGrid()
                  : _buildCreditCardsList()),
            ),
          ],
        ),
      ),

      // Floating Action Button for Comparison
      floatingActionButton: _buildCompareFAB(),
    );
  }

  Widget _buildEnhancedHeader(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B2B41).withOpacity(0.9),
            const Color(0xFF0C192E),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF63b5bb).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
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
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Credit Cards',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${creditCards.length}+ cards available',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: const Color(0xFF63b5bb),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Top Rated',
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
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(top: 15),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 140,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.85,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
        ),
        itemCount: featuredCards.length,
        itemBuilder: (context, index, realIndex) {
          final card = featuredCards[index];
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [card['color'], card['color'].withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        card['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        card['subtitle'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Limited Offer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Icon(
                    card['image'],
                    color: Colors.white.withOpacity(0.3),
                    size: 60,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdvancedSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B2B41).withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFF63b5bb).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: TextFormField(
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search by bank, card type...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF63b5bb),
              size: 20,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.2),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Color(0xFF63b5bb), size: 20),
                  onPressed: () {
                    // Voice search
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: Color(0xFF63b5bb), size: 20),
                  onPressed: () {
                    _showAdvancedFilterSheet(Get.context!);
                  },
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => selectedCategory.value = index,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: selectedCategory.value == index
                    ? const LinearGradient(
                  colors: [Color(0xFF63b5bb), Color(0xFF4a8b90)],
                )
                    : null,
                color: selectedCategory.value == index
                    ? null
                    : const Color(0xFF1B2B41).withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selectedCategory.value == index
                      ? Colors.transparent
                      : const Color(0xFF63b5bb).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: selectedCategory.value == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: selectedCategory.value == index
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortAndViewToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sort Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Obx(() => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSort.value,
                dropdownColor: const Color(0xFF1B2B41),
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF63b5bb)),
                items: ['Popular', 'Newest', 'Rating', 'Cashback', 'Limit']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      'Sort: $value',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedSort.value = value;
                  }
                },
              ),
            )),
          ),

          // View Toggle
          Row(
            children: [
              _buildViewToggleButton(Icons.grid_view, true),
              const SizedBox(width: 8),
              _buildViewToggleButton(Icons.list, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton(IconData icon, bool isGrid) {
    return Obx(() => GestureDetector(
      onTap: () => isGridView.value = isGrid,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isGridView.value == isGrid
              ? const Color(0xFF63b5bb)
              : const Color(0xFF1B2B41),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF63b5bb).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isGridView.value == isGrid ? Colors.white : Colors.white.withOpacity(0.5),
          size: 20,
        ),
      ),
    ));
  }

  Widget _buildCreditCardsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: creditCards.length,
      itemBuilder: (context, index) {
        return _buildEnhancedCardItem(creditCards[index]);
      },
    );
  }

  Widget _buildCreditCardsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: creditCards.length,
      itemBuilder: (context, index) {
        return _buildGridCardItem(creditCards[index]);
      },
    );
  }

  Widget _buildEnhancedCardItem(Map<String, dynamic> card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
          // Card Front with Premium Badge
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [card['color1'], card['color2']],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            card['icon'],
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card['type'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              card['bank'],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            card['rating'].toString(),
                            style: const TextStyle(
                              color: Colors.amber,
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

                // Offer Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF63b5bb).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_offer,
                        color: Color(0xFF63b5bb),
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        card['offer'],
                        style: const TextStyle(
                          color: Color(0xFF63b5bb),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Limit', card['limit']),
                    _buildStatItem('Cashback', card['cashback']),
                    _buildStatItem('Fee', card['annualFee']),
                  ],
                ),
              ],
            ),
          ),

          // Card Back with Enhanced Features
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B41),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: const Color(0xFF63b5bb).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Benefits with icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: card['benefits'].map<Widget>((benefit) {
                    return _buildBenefitChip(benefit);
                  }).toList(),
                ),

                const SizedBox(height: 15),

                // Progress Bar for Eligibility
                _buildEligibilityProgress(),

                const SizedBox(height: 15),

                // Action Buttons with Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildEnhancedActionButton(
                        'Apply',
                        Icons.arrow_forward,
                        onTap: () => _showApplyDialog(card),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildEnhancedActionButton(
                        'Compare',
                        Icons.compare_arrows,
                        isOutlined: true,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Reviews and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.rate_review,
                      color: Color(0xFF63b5bb),
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${card['reviews']} reviews',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCardItem(Map<String, dynamic> card) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [card['color1'], card['color2']],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF63b5bb).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  card['icon'],
                  color: Colors.white,
                  size: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 10),
                      const SizedBox(width: 2),
                      Text(
                        card['rating'].toString(),
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Card Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card['type'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  card['bank'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF63b5bb).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    card['offer'].substring(0, 15) + '...',
                    style: const TextStyle(
                      color: Color(0xFF63b5bb),
                      fontSize: 8,
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Limit',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 9,
                      ),
                    ),
                    Text(
                      card['limit'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cashback',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 9,
                      ),
                    ),
                    Text(
                      card['cashback'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildSmallActionButton('Apply Now'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitChip(String benefit) {
    IconData icon;
    if (benefit.contains('Lounge')) icon = Icons.airplanemode_active;
    else if (benefit.contains('Shopping')) icon = Icons.shopping_bag;
    else if (benefit.contains('Cashback')) icon = Icons.money;
    else if (benefit.contains('Travel')) icon = Icons.flight;
    else if (benefit.contains('Fuel')) icon = Icons.local_gas_station;
    else icon = Icons.star;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF63b5bb).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF63b5bb),
            size: 10,
          ),
          const SizedBox(width: 4),
          Text(
            benefit.length > 10 ? '${benefit.substring(0, 8)}...' : benefit,
            style: const TextStyle(
              color: Color(0xFF63b5bb),
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEligibilityProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Eligibility Score',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
            const Text(
              '85%',
              style: TextStyle(
                color: Color(0xFF63b5bb),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: 0.85,
          backgroundColor: Colors.white.withOpacity(0.1),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF63b5bb)),
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }

  Widget _buildEnhancedActionButton(String text, IconData icon,
      {bool isOutlined = false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: isOutlined ? null : const LinearGradient(
            colors: [Color(0xFF63b5bb), Color(0xFF4a8b90)],
          ),
          color: isOutlined ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(10),
          border: isOutlined ? Border.all(
            color: const Color(0xFF63b5bb).withOpacity(0.5),
            width: 1,
          ) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isOutlined ? const Color(0xFF63b5bb) : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              icon,
              color: isOutlined ? const Color(0xFF63b5bb) : Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallActionButton(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF63b5bb), Color(0xFF4a8b90)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCompareFAB() {
    return FloatingActionButton(
      onPressed: () {
        _showCompareBottomSheet();
      },
      backgroundColor: const Color(0xFF63b5bb),
      child: const Icon(Icons.compare_arrows),
    );
  }

  void _showAdvancedFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Color(0xFF1B2B41),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Advanced Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterSection('Credit Limit Range', [
                      'Below ₹1L',
                      '₹1L - ₹3L',
                      '₹3L - ₹5L',
                      'Above ₹5L'
                    ]),
                    _buildFilterSection('Card Type', [
                      'Visa',
                      'Mastercard',
                      'RuPay',
                      'Amex'
                    ]),
                    _buildFilterSection('Annual Fee', [
                      'Free',
                      'Below ₹500',
                      '₹500 - ₹1000',
                      'Above ₹1000'
                    ]),
                    _buildFilterSection('Benefits', [
                      'Cashback',
                      'Travel',
                      'Shopping',
                      'Fuel',
                      'Lounge',
                      'Movie'
                    ]),
                    _buildSliderFilter('Minimum Credit Score', 650, 900, 750),
                    _buildSliderFilter('Cashback Percentage', 0, 5, 2),
                  ],
                ),
              ),
            ),

            // Apply Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildEnhancedActionButton(
                      'Reset All',
                      Icons.refresh,
                      isOutlined: true,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildEnhancedActionButton(
                      'Apply Filters',
                      Icons.check,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
              selected: false,
              backgroundColor: const Color(0xFF0C192E),
              selectedColor: const Color(0xFF63b5bb),
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: const Color(0xFF63b5bb).withOpacity(0.3),
                ),
              ),
              onSelected: (selected) {},
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSliderFilter(String title, int min, int max, int defaultValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              min.toString(),
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            Expanded(
              child: Slider(
                value: defaultValue.toDouble(),
                min: min.toDouble(),
                max: max.toDouble(),
                activeColor: const Color(0xFF63b5bb),
                inactiveColor: Colors.white.withOpacity(0.2),
                onChanged: (value) {},
              ),
            ),
            Text(
              max.toString(),
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showCompareBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1B2B41),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Compare Cards',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select up to 3 cards to compare',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: creditCards.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [creditCards[index]['color1'], creditCards[index]['color2']],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF63b5bb).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          creditCards[index]['icon'],
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          creditCards[index]['type'].split(' ').first,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildEnhancedActionButton(
              'Compare Selected',
              Icons.compare,
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showApplyDialog(Map<String, dynamic> card) {
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
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFF63b5bb),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  card['icon'],
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Apply for ${card['type']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'From ${card['bank']}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              _buildDialogOption('Quick Approval', Icons.flash_on, Colors.green),
              _buildDialogOption('Check Eligibility', Icons.verified, Colors.blue),
              _buildDialogOption('Required Documents', Icons.description, Colors.orange),
              _buildDialogOption('EMI Options', Icons.calendar_month, Colors.purple),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildEnhancedActionButton(
                      'Cancel',
                      Icons.close,
                      isOutlined: true,
                      onTap: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildEnhancedActionButton(
                      'Proceed',
                      Icons.arrow_forward,
                      onTap: () {
                        Get.back();
                      },
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

  Widget _buildDialogOption(String text, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0C192E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
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
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
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
    );
  }
}