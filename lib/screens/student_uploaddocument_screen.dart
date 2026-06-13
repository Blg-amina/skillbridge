import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jisrelmahara_app/screens/student_dashboard_screen.dart';

/// شاشة تسجيل الطالب - الخطوة الثانية (رفع الوثائق)
class StudentDocumentUploadScreen extends StatefulWidget {
  const StudentDocumentUploadScreen({super.key});

  @override
  State<StudentDocumentUploadScreen> createState() =>
      _StudentDocumentUploadScreenState();
}

class _StudentDocumentUploadScreenState
    extends State<StudentDocumentUploadScreen> {
  // متغيرات لتخزين الملفات المرفوعة
  PlatformFile? _cvFile;
  PlatformFile? _idFile;

  // حالة التحميل (باش نبينو للـ user بلي رانا نرسلو فالدواسة)
  bool _isSubmitting = false;

  // الألوان المتوافقة مع الهوية البصرية (نفسها تاع الخطوة 1)
  static const Color primaryNavy = Color(0xFF152D4D);
  static const Color accentGold = Color(0xFFF2A81D);
  static const Color bgLightGrey = Color(0xFFF8FAFC);
  static const Color fieldBgColor = Color(0xFFF1F5F9);
  static const Color textGrey = Color(0xFF7F8C8D);
  static const Color successGreen = Color(0xFF2ECC71);

  // دالة لاختيار الملفات
  Future<void> _pickDocument(String docType) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          if (docType == 'cv') {
            _cvFile = result.files.first;
          } else if (docType == 'id') {
            _idFile = result.files.first;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'حدث خطأ أثناء اختيار الملف. يرجى المحاولة مجدداً.',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // دالة إتمام التسجيل
  void _submitRegistration() {
    if (_cvFile == null || _idFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى رفع جميع الوثائق المطلوبة (السيرة الذاتية وإثبات الهوية)',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // محاكاة إرسال البيانات للسيرفر (API)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      // إظهار رسالة نجاح
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            icon: const Icon(
              Icons.check_circle_rounded,
              color: successGreen,
              size: 60,
            ),
            title: const Text(
              'تم التسجيل بنجاح!',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: primaryNavy,
              ),
            ),
            content: const Text(
              'تم استلام بياناتك ووثائقك بنجاح. سيتم مراجعة حسابك وتفعيله قريباً.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', color: textGrey),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Yeddik directement l StudentDashboardScreen w yemsa7 l'historique ta3 les pages
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentDashboardScreen(),
                    ),
                    (route) => false, // false ma3netha yemsa7 ga3 l'stack
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'الانتقال للرئيسية',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: primaryNavy,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgLightGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الجزء العلوي: زر الرجوع وعنوان الشاشة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: primaryNavy,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // مؤشر الخطوة (الخطوة 2 من 2)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF5E7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'الخطوة 2 من 2',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD99516),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // نص إرشادي
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'المستندات المطلوبة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'يرجى إرفاق المستندات التالية بصيغة PDF أو صور واضحة لتأكيد هويتك الأكاديمية.',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: textGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // زر رفع السيرة الذاتية
                _buildUploadBox(
                  title: 'السيرة الذاتية (CV)',
                  file: _cvFile,
                  onTap: () => _pickDocument('cv'),
                ),
                const SizedBox(height: 20),

                // زر رفع البطاقة الجامعية أو الهوية
                _buildUploadBox(
                  title: 'البطاقة الجامعية / الهوية',
                  file: _idFile,
                  onTap: () => _pickDocument('id'),
                ),
                const SizedBox(height: 40),

                // زر إتمام التسجيل
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGold,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: primaryNavy,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'إتمام التسجيل',
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
    );
  }

  // ويدجت مخصص لصناديق رفع الملفات
  Widget _buildUploadBox({
    required String title,
    required PlatformFile? file,
    required VoidCallback onTap,
  }) {
    final bool hasFile = file != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: primaryNavy,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: hasFile ? successGreen.withOpacity(0.05) : fieldBgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasFile ? successGreen : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  hasFile
                      ? Icons.check_circle_rounded
                      : Icons.cloud_upload_outlined,
                  color: hasFile ? successGreen : textGrey,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  hasFile ? 'تم إرفاق الملف بنجاح' : 'اضغط هنا لرفع الملف',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: hasFile ? successGreen : primaryNavy,
                  ),
                ),
                if (hasFile) ...[
                  const SizedBox(height: 4),
                  Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: textGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
