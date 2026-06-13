import 'package:flutter/material.dart';
import 'package:jisrelmahara_app/screens/document_upload_screen.dart';

class CompanyRegistrationScreen extends StatefulWidget {
  const CompanyRegistrationScreen({super.key});

  @override
  State<CompanyRegistrationScreen> createState() =>
      _CompanyRegistrationScreenState();
}

class _CompanyRegistrationScreenState extends State<CompanyRegistrationScreen> {
  // Controllers pour les champs de texte
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                    const SizedBox(width: 40), // Pour centrer le titre
                    const Text(
                      'تسجيل شركة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF152D4D), // Navy Blue
                      ),
                    ),
                    // Bouton Retour
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F2F5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded, // Flèche RTL
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

              // --- Formulaire (Scrollable) ---
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // --- Badge: Step 1 of 2 ---
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF2A81D,
                          ).withOpacity(0.15), // Doré transparent
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'الخطوة 1 من 2',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD99516), // Darker gold
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // --- Input Fields ---

                      // 1. Company Name
                      _buildInputField(
                        label: 'اسم الشركة',
                        hint: 'مثال: شركة الابتكار التقني',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        fontweight: FontWeight.w600,
                      ),
                      const SizedBox(height: 20),

                      // 2. Official Email
                      _buildInputField(
                        label: 'البريد الإلكتروني الرسمي',
                        hint: 'info@company.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        fontweight: FontWeight.w600,
                      ),
                      const SizedBox(height: 20),

                      // 3. Phone Number (Adapté pour l'Algérie)
                      _buildInputField(
                        label: 'رقم الهاتف',
                        hint: ' 055X XXX XXX  ',

                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection
                            .rtl, // LTR l'numéro bache yban mriguel
                        fontweight: FontWeight.w600,
                      ),
                      const SizedBox(height: 20),

                      // 4. Password
                      _buildInputField(
                        label: 'كلمة المرور',
                        hint: '********',
                        fontweight: FontWeight.bold,
                        controller: _passwordController,
                        isPassword: true,
                      ),

                      const SizedBox(height: 40),

                      // --- Bottom Button ---
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DocumentUploadScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFF2A81D,
                            ), // Gold Button kima f l'image
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'التالي: رفع الوثائق',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(
                                0xFF152D4D,
                              ), // Texte Navy bache yban mli7 m3a l'doré
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget pour les TextFields (Reusable)
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    TextDirection? textDirection,
    required FontWeight fontweight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF152D4D),
          ),
        ),
        const SizedBox(height: 8),
        Directionality(
          // Pour forcer le LTR f num de tel si besoin (ex: +213...)
          textDirection: textDirection ?? TextDirection.rtl,
          child: TextField(
            controller: controller,
            obscureText: isPassword ? _isPasswordHidden : false,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF152D4D),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade400,
              ),
              filled: true,
              fillColor: const Color(0xFFF4F6F9), // Fond gris très clair
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              // Icône Eye pour le mot de passe
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey.shade500,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
