import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Senior Flutter Developer Implementation
/// Screen: StudentDashboardScreen (Student / Freelancer Profile & Jobs)
/// Theme: Premium Material 3 / Navy & Gold (RTL)
class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen>
    with SingleTickerProviderStateMixin {
  // Custom Tab State
  bool _isJobsTab = true;

  // Filter & Search States
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Image Picker State
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Categories Dummy Data
  final List<String> _categories = [
    'الكل',
    'تطوير ويب',
    'تصميم',
    'تسويق',
    'تحليل بيانات',
  ];

  // Jobs Dummy Data (List of Maps for filtering)
  final List<Map<String, dynamic>> _allJobs = [
    {
      'category': 'تطوير ويب',
      'title': 'تطوير واجهة React للمتجر الإلكتروني',
      'company': 'شركة الابتكار التقني',
      'skills': ['React', 'TypeScript', 'UI'],
      'date': '15 يوليو',
      'price': '2,500 دج',
      'isBookmarked': false,
    },
    {
      'category': 'تحليل بيانات',
      'title': 'تحليل بيانات المبيعات وإعداد تقارير',
      'company': 'البيانات الذكية',
      'skills': ['Python', 'Excel', 'Power BI'],
      'date': '25 يوليو',
      'price': '3,200 دج',
      'isBookmarked': false,
    },
    {
      'category': 'تسويق',
      'title': 'إنشاء استراتيجية تسويق رقمي',
      'company': 'وكالة رؤية',
      'skills': ['SEO', 'Social Media', 'Analytics'],
      'date': '30 يوليو',
      'price': '900 دج',
      'isBookmarked': false,
    },
    {
      'category': 'تصميم',
      'title': 'تصميم واجهات تطبيق توصيل طلبات',
      'company': 'توصيل إكس',
      'skills': ['Figma', 'UI/UX', 'Prototyping'],
      'date': '02 أغسطس',
      'price': '1,800 دج',
      'isBookmarked': true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // دالة لاختيار الصورة من الهاتف
  Future<void> _pickProfileImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        setState(() {
          _profileImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      // تأكدي راكي دايرة flutter stop ومن بعد flutter run باش ما يصرالكش هاد الـ error
    }
  }

  // Getter for filtered jobs
  List<Map<String, dynamic>> get _filteredJobs {
    return _allJobs.where((job) {
      // 1. Filter by Category
      bool matchesCategory = true;
      if (_selectedCategoryIndex != 0) {
        // 0 is 'الكل'
        matchesCategory =
            job['category'] == _categories[_selectedCategoryIndex];
      }

      // 2. Filter by Search Query
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        matchesSearch =
            job['title'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            job['company'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeaderSection(),
              _buildCustomTabToggle(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isJobsTab ? _buildJobsView() : _buildProfileView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER & NAVIGATION COMPONENTS
  // ===========================================================================

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF152D4D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Avatar (Clickable to change)
              GestureDetector(
                onTap: _pickProfileImage,
                behavior: HitTestBehavior
                    .opaque, // زدنا هادي باش يولي كليكابل حتى في البلايص الفارغة
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2A81D),
                    shape: BoxShape.circle,
                    image: _profileImage != null
                        ? DecorationImage(
                            image: FileImage(_profileImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: _profileImage == null
                      ? const Icon(Icons.person, color: Colors.white, size: 30)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // Name & Title
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'عبد الاله',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'مطور واجهات أمامية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF2A81D),
                      ),
                    ),
                  ],
                ),
              ),
              // Back Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Functional Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                    decoration: const InputDecoration(
                      hintText: 'ابحث عن فرص مناسبة...',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Cairo',
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 18,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(child: _buildTabButton('فرص العمل', true)),
            Expanded(child: _buildTabButton('ملفي الشخصي', false)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isJobs) {
    final isSelected = _isJobsTab == isJobs;
    return GestureDetector(
      onTap: () => setState(() => _isJobsTab = isJobs),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF152D4D) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // JOBS TAB (فرص العمل)
  // ===========================================================================

  Widget _buildJobsView() {
    final jobsToDisplay = _filteredJobs;

    return Column(
      children: [
        // Categories Scroll
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedCategoryIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategoryIndex = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF2A81D) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFF2A81D)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Jobs List (Dynamic & Filtered)
        Expanded(
          child: jobsToDisplay.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: jobsToDisplay.length,
                  itemBuilder: (context, index) {
                    final job = jobsToDisplay[index];
                    return _buildJobCard(
                      category: job['category'],
                      title: job['title'],
                      company: job['company'],
                      skills: List<String>.from(job['skills']),
                      date: job['date'],
                      price: job['price'],
                      isBookmarked: job['isBookmarked'],
                      // ✨ التعديل هنا: زدنا دالة باش كي نكليكيو تبدل الحالة تاع الحفظ في الماب
                      onBookmarkTap: () {
                        setState(() {
                          job['isBookmarked'] = !job['isBookmarked'];
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج مطابقة لبحثك',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard({
    required String category,
    required String title,
    required String company,
    required List<String> skills,
    required String date,
    required String price,
    required bool isBookmarked,
    required VoidCallback onBookmarkTap, // ✨ التعديل هنا: استقبلنا الدالة
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Category & Bookmark
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF152D4D),
                  ),
                ),
              ),
              // ✨ التعديل هنا: درنا الأيقونة داخل GestureDetector باش تولي تخدم
              GestureDetector(
                onTap: onBookmarkTap,
                child: Container(
                  padding: const EdgeInsets.all(4), // باش نكبرو مساحة الكليك
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked
                        ? const Color(0xFFF2A81D)
                        : Colors.grey.shade400,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF152D4D),
            ),
          ),
          const SizedBox(height: 4),
          // Company
          Text(
            company,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 12),
          // Skills Chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
          const SizedBox(height: 16),
          // Bottom Row: Date & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              Text(
                price,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF2A81D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF152D4D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'تقديم الآن',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PROFILE TAB (ملفي الشخصي)
  // ===========================================================================

  Widget _buildProfileView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF152D4D),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'عبد الاله',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'مطور واجهات أمامية - 3 سنوات خبرة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFF2A81D),
                            size: 14,
                          ),
                          const Icon(
                            Icons.star,
                            color: Color(0xFFF2A81D),
                            size: 14,
                          ),
                          const Icon(
                            Icons.star,
                            color: Color(0xFFF2A81D),
                            size: 14,
                          ),
                          const Icon(
                            Icons.star,
                            color: Color(0xFFF2A81D),
                            size: 14,
                          ),
                          const Icon(
                            Icons.star_half,
                            color: Color(0xFFF2A81D),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '4.8',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF2A81D),
                            ),
                          ),
                          Text(
                            ' (26 مراجعة)',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ... داخل الـ Row تاع Profile Tab
                  // ... داخل الـ Row تاع Profile Tab
                  GestureDetector(
                    onTap: _pickProfileImage,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2A81D),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      // هنا استعملنا ClipRRect باش الصورة تخرج داخل الإطار ديريكت
                      child: _profileImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                _profileImage!,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              ),
                            )
                          : const Icon(
                              Icons.computer,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildProfileStatCard(
                      '24',
                      'مشاريع\nمكتملة',
                      Icons.check_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildProfileStatCard(
                      '4.8',
                      'متوسط التقييم',
                      Icons.star,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildProfileStatCard(
                      '28K دج',
                      'إجمالي الأرباح',
                      Icons.show_chart,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionContainer(
          title: 'المهارات',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'React',
              'TypeScript',
              'Node.js',
              'Python',
              'Figma',
              'UI/UX',
              'Machine Learning',
            ].map((s) => _buildSkillChip(s, isLarge: true)).toList(),
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionContainer(
          title: 'تقييم السمعة',
          titleTrailing: Row(
            children: [
              const Text(
                '4.8',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF2A81D),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.workspace_premium,
                color: const Color(0xFFF2A81D).withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < 4 ? Icons.star : Icons.star_border,
                    color: const Color(0xFFF2A81D),
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildRatingProgress('جودة العمل', 4.8),
              _buildRatingProgress('الالتزام بالوقت', 4.4),
              _buildRatingProgress('التواصل', 4.6),
              _buildRatingProgress('الاحترافية', 4.8),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionContainer(
          title: 'المشاريع المكتملة',
          child: Column(
            children: [
              _buildCompletedProjectItem(
                'تطوير لوحة تحكم إدارية',
                'شركة الخليج - مايو 2025',
                '2,800 دج',
                5,
              ),
              const Divider(height: 30, color: Color(0xFFF0F2F5)),
              _buildCompletedProjectItem(
                'تصميم تطبيق جوال',
                'ريادة تك - أبريل 2025',
                '1,500 دج',
                4,
              ),
              const Divider(height: 30, color: Color(0xFFF0F2F5)),
              _buildCompletedProjectItem(
                'بناء نظام إدارة محتوى',
                'ميديا بلس - مارس 2025',
                '3,500 دج',
                5,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildProfileStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFF2A81D), size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    Widget? titleTrailing,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF152D4D),
                ),
              ),
              if (titleTrailing != null) titleTrailing,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildRatingProgress(String label, double rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            rating.toString(),
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF152D4D),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: rating / 5.0,
                backgroundColor: const Color(0xFFF0F2F5),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFF2A81D),
                ),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedProjectItem(
    String title,
    String subtitle,
    String price,
    int stars,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF152D4D),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: const Color(0xFFF2A81D),
                  size: 14,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFFF2A81D),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // SHARED UTILS
  // ===========================================================================

  Widget _buildSkillChip(String label, {bool isLarge = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 16 : 10,
        vertical: isLarge ? 8 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: isLarge ? 12 : 10,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF152D4D),
        ),
      ),
    );
  }
}
