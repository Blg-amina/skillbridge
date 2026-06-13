import 'package:flutter/material.dart';
import 'package:jisrelmahara_app/screens/company_dashboard_screen.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  // Variable bach nbadlo l'état ta3 l'interface (mocking the upload process)
  bool _isUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // --- Custom Top AppBar ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    const Text(
                      'رفع الوثائق',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF152D4D),
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
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Color(0xFF152D4D),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // --- Badge: Step 2 of 2 ---
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2A81D).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'الخطوة 2 من 2',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD99516),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- Title and Subtitle ---
                      const Text(
                        'رفع السجل التجاري (C20)',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF152D4D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'يرجى رفع نسخة من السجل التجاري (C20) بصيغة PDF للتحقق من هوية شركتك.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // --- Upload Area (Clickable to test the state change) ---
                      GestureDetector(
                        onTap: () {
                          // Toggling the state for demonstration
                          setState(() {
                            _isUploaded = !_isUploaded;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              // Si c'est uploadé, bordure verte. Sinon, bordure bleu gris clair.
                              color: _isUploaded
                                  ? const Color(0xFF2ECC71)
                                  : const Color(0xFFD3D8E0),
                              width: 1.5,
                            ),
                          ),
                          child: _isUploaded
                              ? _buildSuccessState()
                              : _buildInitialState(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- Warning / Info Alert Box ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8ED), // Orange très clair
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF2A81D).withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.bolt_rounded, // Icône éclair (Lightning)
                              color: Color(0xFFF2A81D),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'سيتم مراجعة وثائقك خلال 24 ساعة. يمكنك الاطلاع على الفرص المتاحة بانتظار التحقق.',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFD99516),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                      if (_isUploaded) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CompanyDashboardScreen(),
                          ),
                          (route) =>
                              false, // false = yems7 ga3 l'stack (historique)
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CompanyDashboardScreen(),
                          ),
                          (route) =>
                              false, // false = yems7 ga3 l'stack (historique)
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // Changement de couleur selon l'état
                      backgroundColor: _isUploaded
                          ? const Color(0xFFF2A81D)
                          : const Color(0xFF152D4D),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _isUploaded ? 'إتمام التسجيل' : 'تخطي لوقت لاحق',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _isUploaded
                            ? const Color(0xFF152D4D)
                            : Colors.white,
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

  // L'UI ki ykoun mazal ma dar upload (Image 1)
  Widget _buildInitialState() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.file_upload_outlined,
            color: Color(0xFFF2A81D),
            size: 30,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'ارفع السجل التجاري',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF152D4D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'اسحب وأفلت الملف هنا أو اضغط للاختيار',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'PDF, JPG, PNG — حجم أقصى 10 ميجابايت',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF152D4D),
            ),
          ),
        ),
      ],
    );
  }

  // L'UI ki l'fichier yatla3 b success (Image 2)
  Widget _buildSuccessState() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: Color(0xFF2ECC71), // Vert
          size: 60,
        ),
        const SizedBox(height: 16),
        const Text(
          'تم رفع الملف بنجاح!',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF152D4D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'document_C20_company.pdf',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2ECC71).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'قيد المراجعة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF27AE60), // Vert foncé
            ),
          ),
        ),
      ],
    );
  }
}
