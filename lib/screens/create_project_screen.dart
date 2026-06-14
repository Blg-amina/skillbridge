import 'package:flutter/material.dart';

/// Premium Project Creation Screen with Arabic RTL layout
class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  // State Variables
  String _selectedCategory = 'تطوير ويب';
  bool _isSubmitting = false;

  // Styling Constants
  static const Color primaryNavy = Color(0xFF152D4D);
  static const Color accentGold = Color(0xFFF2A81D);
  static const Color bgLightGrey = Color(0xFFF4F6F9);
  static const Color textGrey = Color(0xFF7F8C8D);
  static const Color successGreen = Color(0xFF2ECC71);

  // Category Options
  final List<String> _categories = [
    'تطوير ويب',
    'تطوير تطبيقات',
    'تصميم جرافيك',
    'كتابة محتوى',
    'تسويق رقمي',
    'ترجمة',
    'دعم فني',
    'أخرى',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  void _submitProject() {
    debugPrint('Submit button pressed');
    debugPrint('Form valid: ${_formKey.currentState?.validate()}');
    
    if (_formKey.currentState!.validate()) {
      debugPrint('Form validation passed');
      setState(() => _isSubmitting = true);

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isSubmitting = false);
        _showSuccessDialog();
      });
    } else {
      debugPrint('Form validation failed');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: successGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: successGreen,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'تم إرسال طلبك بنجاح',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'سيتم مراجعة طلبك والتواصل معك في حال القبول',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      color: textGrey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'نشكرك على اهتمامك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: accentGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryNavy,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'حسناً',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar', 'SA'),
    );
    if (picked != null && mounted) {
      setState(() {
        _deadlineController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgLightGrey,
        appBar: _buildPremiumAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('عنوان المشروع'),
                const SizedBox(height: 12),
                _buildTitleField(),
                const SizedBox(height: 24),

                _buildSectionTitle('تصنيف المشروع'),
                const SizedBox(height: 12),
                _buildCategorySelector(),
                const SizedBox(height: 24),

                _buildSectionTitle('وصف المشروع'),
                const SizedBox(height: 12),
                _buildDescriptionField(),
                const SizedBox(height: 24),

                _buildSectionTitle('الميزانية المتوقعة (دج)'),
                const SizedBox(height: 12),
                _buildBudgetField(),
                const SizedBox(height: 24),

                _buildSectionTitle('الموعد النهائي'),
                const SizedBox(height: 12),
                _buildDeadlineField(),
                const SizedBox(height: 32),

                _buildSubmitButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildPremiumAppBar() {
    return AppBar(
  backgroundColor: primaryNavy,
  elevation: 0,
  automaticallyImplyLeading: false,
  actions: [
    IconButton(
      icon: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
  ],
  title: const Text(
    'نشر مشروع جديد',
    style: TextStyle(
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 18,
    ),
  ),
  centerTitle: true,
);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: primaryNavy,
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _titleController,
        decoration: InputDecoration(
          hintText: 'أدخل عنوان المشروع',
          hintStyle: TextStyle(
            fontFamily: 'Cairo',
            color: textGrey.withOpacity(0.6),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          color: primaryNavy,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال عنوان المشروع';
          }
          if (value.trim().length < 10) {
            return 'العنوان يجب أن يكون 10 أحرف على الأقل';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: primaryNavy,
          ),
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 15,
            color: primaryNavy,
          ),
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'اكتب تفاصيل المشروع بالتفصيل...',
          hintStyle: TextStyle(
            fontFamily: 'Cairo',
            color: textGrey.withOpacity(0.6),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          color: primaryNavy,
          height: 1.5,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال وصف المشروع';
          }
          if (value.trim().length < 30) {
            return 'الوصف يجب أن يكون 30 حرف على الأقل';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBudgetField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _budgetController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'أدخل الميزانية المتوقعة',
          hintStyle: TextStyle(
            fontFamily: 'Cairo',
            color: textGrey.withOpacity(0.6),
            fontSize: 14,
          ),
          suffixText: 'ر.س',
          suffixStyle: const TextStyle(
            fontFamily: 'Cairo',
            color: primaryNavy,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          color: primaryNavy,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال الميزانية';
          }
          final budget = double.tryParse(value);
          if (budget == null || budget <= 0) {
            return 'يرجى إدخال ميزانية صحيحة';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDeadlineField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _deadlineController,
        readOnly: true,
        onTap: _selectDate,
        decoration: InputDecoration(
          hintText: 'اختر الموعد النهائي',
          hintStyle: TextStyle(
            fontFamily: 'Cairo',
            color: textGrey.withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.calendar_today_rounded,
            color: primaryNavy,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          color: primaryNavy,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى اختيار الموعد النهائي';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitProject,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGold,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryNavy),
                ),
              )
            : const Text(
                'نشر المشروع',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryNavy,
                ),
              ),
      ),
    );
  }
}
