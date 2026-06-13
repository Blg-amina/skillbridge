import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'create_project_screen.dart';
import 'login_screen.dart';

/// Production-ready Company Dashboard Screen matching premium Arabic RTL layout specs.
class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen>
    with SingleTickerProviderStateMixin {
  // Navigation & Tab Control
  late TabController _tabController;

  // Form Processing & Validation
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _billingAddressController =
      TextEditingController();

  // State Management
  bool _isAnnual = false;
  bool _isPremiumPlan =
      true; // True for Premium subscription option, false for Free/Commission
  bool _isFormSubmitting = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  PlatformFile? _selectedFile;

  // Global Styling Constants
  static const Color primaryNavy = Color(0xFF152D4D);
  static const Color accentGold = Color(0xFFF2A81D);
  static const Color bgLightGrey = Color(0xFFF4F6F9);
  static const Color textGrey = Color(0xFF7F8C8D);
  static const Color successGreen = Color(0xFF2ECC71);
  static const Color warningOrange = Color(0xFFD99516);

  @override
  void initState() {
    super.initState();
    // Setting up the manual 3-tab controller framework
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      // Rebuild interface smoothly on manual swipe or tab select transitions
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _companyNameController.dispose();
    _vatController.dispose();
    _billingAddressController.dispose();
    super.dispose();
  }

  // ==========================================
  // CORE METRIC AND CONTROLLER UTILITIES
  // ==========================================

  void _navigateToPaymentTab() {
    _tabController.animateTo(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _showSnackBar('الرجاء إكمال بيانات الفوترة والدفع', primaryNavy);
  }

  void _processBillingValidation() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isFormSubmitting = true);

      // Simulate API saving latency safely
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() => _isFormSubmitting = false);
        _tabController.animateTo(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _showSnackBar(
          'تم حفظ بيانات الفوترة بنجاح. يرجى رفع إيصال السداد.',
          successGreen,
        );
      });
    } else {
      _showSnackBar(
        'يرجى ملء جميع الحقول المطلوبة بشكل صحيح',
        Colors.redAccent,
      );
    }
  }

  Future<void> _handleFileSelection() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
          _isUploading = true;
          _uploadProgress = 0.0;
        });
        _executeSimulatedUpload();
      }
    } catch (e) {
      _showSnackBar(
        'حدث خطأ أثناء اختيار الملف. يرجى المحاولة مجدداً.',
        Colors.redAccent,
      );
    }
  }

  void _executeSimulatedUpload() {
    // Linear background stream emulator for progress rendering
    const int totalSteps = 20;
    int currentStep = 0;

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return false;

      currentStep++;
      setState(() {
        _uploadProgress = currentStep / totalSteps;
      });

      if (currentStep >= totalSteps) {
        setState(() => _isUploading = false);
        return false;
      }
      return true;
    });
  }

  void _submitReceiptSubmission() {
    if (_selectedFile == null) {
      _showSnackBar('يرجى اختيار ملف الإيصال أولاً قبل الإرسال', warningOrange);
      return;
    }

    if (_isUploading) {
      _showSnackBar('يرجى الانتظار حتى اكتمال رفع الملف الحالي', warningOrange);
      return;
    }

    _showSuccessStatusDialog();
  }

  void _showSnackBar(String text, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessStatusDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            icon: const Icon(
              Icons.check_circle_rounded,
              color: successGreen,
              size: 64,
            ),
            title: const Text(
              'تم إرسال الإيصال بنجاح',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: primaryNavy,
              ),
            ),
            content: const Text(
              'تمت العملية بنجاح! الإيصال الخاص بك الآن قيد المراجعة والتدقيق من قبل الإدارة وسيتم تفعيل حسابك بالكامل خلال 24 ساعة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: primaryNavy,
                height: 1.5,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _selectedFile = null;
                    _uploadProgress = 0.0;
                  });
                  _tabController.animateTo(0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'العودة للمشاريع',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // TOP ARCHITECTURE ROOT HIERARCHY RENDERER
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgLightGrey,
        body: Column(
          children: [
            _buildPremiumHeaderView(context),
            _buildStickySegmentsTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildProjectsTabContent(),
                  _buildPaymentTabContent(),
                  _buildUploadReceiptTabContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SECTION MODULE 1: HEADER PLATFORM METRICS
  // ==========================================

  Widget _buildPremiumHeaderView(BuildContext context) {
    return Container(
      color: primaryNavy,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: accentGold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'شركة الابتكار التقني',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'عضو مميز',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: accentGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "تسجيل الخروج",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInteractiveStatCard(
                  title: 'المتقدمون',
                  count: '47',
                  trend: '+12 هذا الأسبوع',
                  icon: Icons.people_alt_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInteractiveStatCard(
                  title: 'إجمالي المشاريع',
                  count: '12',
                  trend: '+3 هذا الشهر',
                  icon: Icons.file_copy_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveStatCard({
    required String title,
    required String count,
    required String trend,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgLightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: primaryNavy, size: 20),
              ),
              const Icon(
                Icons.trending_up_rounded,
                color: successGreen,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: primaryNavy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            trend,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: successGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION MODULE 2: APP SEGMETED TAB NAVIGATION
  // ==========================================

  Widget _buildStickySegmentsTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(0, 'المشاريع'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton(1, 'الدفع'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton(2, 'رفع الإيصال'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String text) {
    final isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? primaryNavy : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? primaryNavy : Colors.grey.shade200,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SECTION MODULE 3: TAB WORKFLOW 1 - PROJECTS
  // ==========================================

  Widget _buildProjectsTabContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'عروض العمل',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryNavy,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateProjectScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 16, color: primaryNavy),
              label: const Text(
                'نشر مشروع',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryNavy,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGold,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDynamicJobPostingCard(
          title: 'تطوير تطبيق React للمتجر',
          category: 'تطوير ويب',
          status: 'في انتظار الدفع',
          statusColor: warningOrange,
          statusBgColor: const Color(0xFFFFF8ED),
          applicants: 8,
          date: '15 يوليو 2025',
          price: '2,500 دج',
          hasActionButton: true,
        ),
        _buildDynamicJobPostingCard(
          title: 'تصميم هوية بصرية للعلامة التجارية',
          category: 'تصميم جرافيك',
          status: 'نشط',
          statusColor: successGreen,
          statusBgColor: const Color(0xFFEAFAF1),
          applicants: 12,
          date: '20 يوليو 2025',
          price: '1,800 دج',
        ),
        _buildDynamicJobPostingCard(
          title: 'إعداد خطة تسويق رقمي شاملة',
          category: 'تسويق رقمي',
          status: 'مكتمل',
          statusColor: textGrey,
          statusBgColor: const Color(0xFFF0F2F5),
          applicants: 5,
          date: 'منتهي',
          price: '3,200 دج',
        ),
        _buildDynamicJobPostingCard(
          title: 'كتابة محتوى إبداعي لمنصات التواصل',
          category: 'كتابة محتوى',
          status: 'قيد المراجعة',
          statusColor: Colors.purple,
          statusBgColor: const Color(0xFFF5EEF8),
          applicants: 15,
          date: '25 يوليو 2025',
          price: '900 دج',
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDynamicJobPostingCard({
    required String title,
    required String category,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required int applicants,
    required String date,
    required String price,
    bool hasActionButton = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: bgLightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textGrey,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lens, size: 8, color: statusColor),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: primaryNavy,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.people_outline_rounded,
                    size: 16,
                    color: textGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$applicants متقدم',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textGrey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: textGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
              Text(
                price,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: accentGold,
                ),
              ),
            ],
          ),
          if (hasActionButton) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToPaymentTab,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGold,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'إتمام الدفع لتفعيل العرض',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: primaryNavy,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // SECTION MODULE 4: TAB WORKFLOW 2 - PAYMENT
  // ==========================================

  Widget _buildPaymentTabContent() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          const Text(
            'خيارات الدفع',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryNavy,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isPremiumPlan = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _isPremiumPlan ? primaryNavy : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isPremiumPlan
                            ? primaryNavy
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.card_membership_rounded,
                          color: _isPremiumPlan ? Colors.white : textGrey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'اشتراك مميز',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: _isPremiumPlan ? Colors.white : primaryNavy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isPremiumPlan = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: !_isPremiumPlan ? primaryNavy : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !_isPremiumPlan
                            ? primaryNavy
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          color: !_isPremiumPlan ? Colors.white : textGrey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'عمولة 5%',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: !_isPremiumPlan ? accentGold : primaryNavy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!_isPremiumPlan) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'نموذج العمولة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'لا تدفع شيئاً مقدماً. يتم خصم 5% فقط من قيمة المهمة عند إتمامها بنجاح.',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: textGrey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCommissionRow('قيمة المشروع', '2,500 دج'),
                  _buildCommissionRow('العمولة (5%)', '125 دج'),
                  const Divider(height: 24, color: Colors.grey),
                  _buildCommissionRow('الإجمالي', '2,625 دج', isBold: true),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _processBillingValidation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentGold,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'الموافقة على الشروط ونشر المشروع',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryNavy,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isAnnual = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isAnnual ? primaryNavy : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'سنوي',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color: _isAnnual ? Colors.white : textGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isAnnual = false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !_isAnnual ? primaryNavy : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'شهري',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color: !_isAnnual ? Colors.white : textGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryNavy,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isPremiumPlan
                            ? 'الخطة المميزة'
                            : 'الخطة المرنة الأساسية',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: accentGold,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _isPremiumPlan ? (_isAnnual ? '2,990' : '299') : '0',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _isAnnual ? 'دج / سنوي' : 'دج / شهر',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: textGrey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildBulletFeatureLine('نشر عروض عمل ومشاريع غير محدودة'),
                  _buildBulletFeatureLine(
                    'الوصول الفوري لكافة السير والملفات للمتقدمين',
                  ),
                  _buildBulletFeatureLine(
                    'دعم فني متكامل ذو أولوية على مدار الساعة 24/7',
                  ),
                  _buildBulletFeatureLine(
                    'تقارير إحصائية متقدمة لتحليل أداء التوظيف',
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'معلومات الفوترة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryNavy,
                  ),
                ),
                const SizedBox(height: 16),
                _buildValidatedInputField(
                  label: 'اسم الشركة',
                  controller: _companyNameController,
                  hint: 'أدخل الاسم الرسمي للشركة',
                ),
                const SizedBox(height: 14),
                _buildValidatedInputField(
                  label: 'الرقم الضريبي (VAT)',
                  controller: _vatController,
                  hint: 'أدخل الرقم الضريبي المكون من 15 خانة',
                  keyboardType: TextInputType.number,
                  isNumeric: true,
                ),
                const SizedBox(height: 14),
                _buildValidatedInputField(
                  label: 'عنوان الفوترة',
                  controller: _billingAddressController,
                  hint: 'الشارع، المدينة، الرمز البريدي، الدولة',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isFormSubmitting ? null : _processBillingValidation,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGold,
                disabledBackgroundColor: accentGold.withOpacity(0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isFormSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: primaryNavy,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'المتابعة لرفع إيصال الدفع',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryNavy,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildBulletFeatureLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: accentGold,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: textGrey,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: primaryNavy,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidatedInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isNumeric = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: textGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: primaryNavy,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
            filled: true,
            fillColor: bgLightGrey,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryNavy, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'هذا الحقل مطلوب ولا يمكن تركه فارغاً';
            }
            if (isNumeric && value.trim().length < 5) {
              return 'يرجى إدخال رقم ضريبي صحيح صالح';
            }
            return null;
          },
        ),
      ],
    );
  }

  // ==========================================
  // SECTION MODULE 5: TAB WORKFLOW 3 - RECEIPT
  // ==========================================

  Widget _buildUploadReceiptTabContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildCleanSummaryRow(
                'رقم الطلب',
                'INV-2025-00424',
                valueColor: primaryNavy,
                isValueBold: true,
              ),
              const Divider(height: 24, thickness: 0.8),
              _buildCleanSummaryRow(
                'المبلغ',
                '299 دج',
                valueColor: accentGold,
                isValueBold: true,
              ),
              const Divider(height: 24, thickness: 0.8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الحالة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: textGrey,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 14,
                        color: warningOrange,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'في انتظار التحقق',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: warningOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _isUploading ? null : _handleFileSelection,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selectedFile != null
                    ? successGreen
                    : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgLightGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _selectedFile != null
                        ? Icons.task_rounded
                        : Icons.cloud_upload_outlined,
                    color: _selectedFile != null ? successGreen : primaryNavy,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedFile != null
                      ? 'تم اختيار الملف بنجاح'
                      : 'ارفع صورة أو PDF للإيصال',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryNavy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _selectedFile != null
                      ? _selectedFile!.name
                      : 'اضغط للاختيار (PDF, JPG, JPEG, PNG)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: _selectedFile != null ? successGreen : textGrey,
                    fontWeight: _selectedFile != null
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (_isUploading) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: _uploadProgress,
                          backgroundColor: bgLightGrey,
                          color: primaryNavy,
                          minHeight: 4,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'جاري جلب ورفع الملف: ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: primaryNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.info_outline_rounded, color: textGrey, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تبقى عروض العمل في حالة "معلقة" حتى يتحقق المشرف من إيصال الدفع. سيفعل حسابك خلال 24 ساعة.',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: textGrey,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isUploading ? null : _submitReceiptSubmission,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryNavy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'إرسال الإيصال للمراجعة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCleanSummaryRow(
    String label,
    String value, {
    required Color valueColor,
    bool isValueBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: textGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: isValueBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
