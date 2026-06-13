import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Layout b l'arabe (RTL)
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA), // Off-white clean background
        body: SafeArea(
          child: Column(
            children: [
              // --- Top Bar (Skip Button & Dots) ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip Button (تخطي)
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to Auth Screen direct
                      },
                      child: Text(
                        'تخطي',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    // Pagination Dots (reversed order to match PageView 0->1->2 in RTL)
                    Row(
                      children: [
                        _buildDot(isActive: _currentPage == 0),
                        const SizedBox(width: 6),
                        _buildDot(isActive: _currentPage == 1),
                        const SizedBox(width: 6),
                        _buildDot(isActive: _currentPage == 2),
                      ],
                    ),
                  ],
                ),
              ),

              // --- PageView for Onboarding Content ---
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    // 🔥 Page 1: أنشئ ملفك المهني
                    _buildOnboardingPage(
                      iconWidget: _buildProfileIllustration(),
                      title: 'أنشئ ملفك المهني',
                      description: 'ابرز مهاراتك وخبراتك لتجذب أفضل الشركات',
                    ),
                    
                    // 🔥 Page 2: اكتشف فرص مميزة (Hadi li zadnaha)
                    _buildOnboardingPage(
                      iconWidget: _buildOpportunitiesIllustration(),
                      title: 'اكتشف فرص مميزة',
                      description: 'تصفح مشاريع حقيقية من شركات رائدة وابدأ\nمسيرتك المهنية',
                    ),
                    
                    // 🔥 Page 3: ابدأ العمل
                    _buildOnboardingPage(
                      iconWidget: _buildGetStartedIllustration(),
                      title: 'ابدأ العمل بنجاح',
                      description: 'أنجز المشاريع بنجاح واحصل على أموالك بأمان\nعبر المنصة',
                    ),
                  ],
                ),
              ),

              // --- Bottom Action Button ---
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // TODO: Navigate to Auth Screen
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2A81D), // Gold Color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 16,
                          color: const Color(0xFF152D4D),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _currentPage < 2 ? 'التالي' : 'ابدأ الآن',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF152D4D), // Navy Blue Text
                          ),
                        ),
                      ],
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

  // --- Helper Widgets ---

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF2A81D) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive ? [
          BoxShadow(
            color: const Color(0xFFF2A81D).withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ] : null,
      ),
    );
  }

  Widget _buildOnboardingPage({
    required Widget iconWidget,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          iconWidget,
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF152D4D), // Primary Navy Blue
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  // Illustration Page 1 (CV + Profile)
  Widget _buildProfileIllustration() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade100, // Light grey outer circle
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(
              0xFFF2A81D,
            ).withOpacity(0.1), // Light gold inner circle
            border: Border.all(
              color: const Color(0xFFF2A81D).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 60,
                color: Color(0xFFF2A81D), // Gold icon
              ),
              Positioned(
                bottom: 15,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.contact_page_outlined,
                    size: 24,
                    color: Color(0xFF152D4D), // Navy Blue
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Illustration Page 2 (ID Card + Checkmark) (Hadi jdida ta3 image)
  Widget _buildOpportunitiesIllustration() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade100, // Light grey outer circle
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF152D4D).withOpacity(0.05), // Light navy tint
            border: Border.all(
              color: const Color(0xFF152D4D).withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Main ID card icon
              const Icon(
                Icons.assignment_ind_outlined, 
                size: 60,
                color: Color(0xFF152D4D), // Navy Blue
              ),
              // Little gold Checkmark overlapping
              Positioned(
                bottom: 15,
                right: 15,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 28,
                    color: Color(0xFFF2A81D), // Gold
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Illustration Page 3 (Get Started - Wallet/Payment)
  Widget _buildGetStartedIllustration() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade100, // Light grey outer circle
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF2A81D).withOpacity(0.1), // Light gold inner circle
            border: Border.all(
              color: const Color(0xFFF2A81D).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.handshake_outlined,
                size: 60,
                color: Color(0xFFF2A81D), // Gold icon
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 28,
                    color: Color(0xFF152D4D), // Navy
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}