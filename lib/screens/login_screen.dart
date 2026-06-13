import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers pour récupérer les textes mba3d (Firebase)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Layout RTL pour l'arabe
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // --- Header Section (Navy Blue Background) ---
              Container(
                width: double.infinity,
                height: 270,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 40,
                  bottom: 40,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0F1C2E), Color(0xFF152D4D)],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/image.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'جسر المهارات',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'SkillBridge',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF2A81D),
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),

              // --- Form Section (White Background) ---
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    // Welcome Texts
                    const Text(
                      'مرحباً بعودتك',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF152D4D), // Navy Blue
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'سجل دخولك للمتابعة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Email Field
                    _buildInputField(
                      label: 'البريد الإلكتروني',
                      hint: 'example@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    _buildInputField(
                      label: 'كلمة المرور',
                      hint: '********',
                      controller: _passwordController,
                      isPassword: true,
                    ),

                    const SizedBox(height: 12),

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Forgot Password logic
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFF2A81D), // Gold
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement Login
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF152D4D), // Navy Blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Divider "أو"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'أو',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Navigate to Sign Up
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF152D4D),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF152D4D),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24), // Bottom padding
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Input Fields
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF152D4D), // Navy Blue
          ),
        ),
        const SizedBox(height: 8),
        // Custom TextField
        TextField(
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
            fillColor: const Color(0xFFF4F6F9), // Very light grey background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            // L'icone ta3 l'3in (Eye Icon) pour le mot de passe
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
      ],
    );
  }
}
