import 'package:flutter/material.dart';
import 'package:jisrelmahara_app/screens/student_uploaddocument_screen.dart';

/// شاشة تسجيل الطالب - الخطوة الأولى بناءً على التصميم في image_d33297.png
class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({super.key});

  @override
  State<StudentRegistrationScreen> createState() =>
      _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // متحكمات الحقول نصية
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _specializationController = TextEditingController();
  final _passwordController = TextEditingController();

  // حالة إظهار/إخفاء كلمة المرور
  bool _obscurePassword = true;

  // الألوان المتوافقة مع الهوية البصرية للتطبيق
  static const Color primaryNavy = Color(0xFF152D4D);
  static const Color accentGold = Color(0xFFF2A81D);
  static const Color bgLightGrey = Color(0xFFF8FAFC);
  static const Color fieldBgColor = Color(0xFFF1F5F9);
  static const Color textGrey = Color(0xFF7F8C8D);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _specializationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    // التأكد من أن جميع الحقول صحيحة قبل الانتقال
    if (_formKey.currentState!.validate()) {
      // كود الانتقال للشاشة الثانية (رفع الوثائق)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StudentDocumentUploadScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          TextDirection.rtl, // يدعم اللغة العربية بالكامل كما في الصورة
      child: Scaffold(
        backgroundColor: bgLightGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الجزء العلوي: زر الرجوع وعنوان الشاشة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 40,
                      ), // لموازنة زر الرجوع في الجهة المقابلة
                      const Text(
                        'تسجيل الطالب',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryNavy,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0F2F5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons
                                .arrow_forward_ios_rounded, // Flèche vers la droite en RTL
                            size: 16,
                            color: Color(0xFF152D4D),
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Yweli lel Login
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // مؤشر الخطوة (الخطوة 1 من 2)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFFEF5E7,
                      ), // خلفية برتقالية فاتحة جداً
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'الخطوة 1 من 2',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD99516),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // حقل الاسم الكامل
                  _buildInputField(
                    label: 'الاسم الكامل',
                    hint: 'مثال: أحمد محمد العلي',
                    controller: _nameController,
                    validator: (val) =>
                        val!.isEmpty ? 'يرجى إدخال الاسم الكامل' : null,
                  ),
                  const SizedBox(height: 20),

                  // حقل البريد الإلكتروني
                  _buildInputField(
                    label: 'البريد الإلكتروني',
                    hint: 'student@university.edu',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(val)) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // حقل التخصص الأكاديمي
                  _buildInputField(
                    label: 'التخصص الأكاديمي',
                    hint: 'مثال: هندسة البرمجيات',
                    controller: _specializationController,
                    validator: (val) =>
                        val!.isEmpty ? 'يرجى إدخال التخصص الأكاديمي' : null,
                  ),
                  const SizedBox(height: 20),

                  // حقل كلمة المرور مع زر الإظهار/الإخفاء على اليسار
                  _buildInputField(
                    label: 'كلمة المرور',
                    hint: '********',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: textGrey,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (val) => val!.length < 6
                        ? 'كلمة المرور يجب أن لا تقل عن 6 رموز'
                        : null,
                  ),
                  const SizedBox(height: 40),

                  // زر الانتقال للخطوة التالية
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onNextPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentGold,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'التالي: رفع الوثائق',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryNavy,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت مخصص لبناء الحقول لضمان نظافة الكود وتطابق التصميم
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: primaryNavy,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: primaryNavy,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: Color(0xFFB4BCC6),
            ),
            filled: true,
            fillColor: fieldBgColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: suffixIcon, // يظهر تلقائياً على اليسار بسبب الـ RTL
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: accentGold, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
