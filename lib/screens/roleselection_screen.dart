// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:jisrelmahara_app/screens/company_registration_screen.dart';
import 'package:jisrelmahara_app/screens/student_registartion_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  // -1: Aucune sélection, 0: Entreprise (شركة), 1: Étudiant/Diplômé (طالب/خريج)
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA), // Off-white très léger
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    // Titre centré (Ndirouh f wesset b spacing)
                    const SizedBox(
                      width: 40,
                    ), // Espace pour centrer l'élément suivant
                    const Text(
                      'إنشاء حساب',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF152D4D),
                      ),
                    ),
                    // Bouton Retour (Kima f design: mdawer b gris clair)
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
              ),

              const SizedBox(height: 32),

              // --- Titres ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'من أنت؟',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF152D4D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اختر نوع حسابك للمتابعة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- Options Cards ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // 1. Carte Entreprise (شركة)
                      _buildRoleCard(
                        index: 0,
                        title: 'شركة',
                        subtitle: 'انشر مشاريع واعثر على المواهب المناسبة',
                        iconData: Icons.business_outlined,
                        // Couleurs pour "Entreprise" ki tkoun sélectionnée
                        selectedBgColor: const Color(0xFF152D4D), // Navy Blue
                        selectedTitleColor: Colors.white,
                        selectedSubtitleColor: Colors.grey.shade300,
                        selectedIconBoxColor: const Color(
                          0xFF0F1C2E,
                        ), // Very dark navy
                        selectedIconBorderColor: const Color(
                          0xFFF2A81D,
                        ).withOpacity(0.5),
                        selectedIconColor: const Color(0xFFF2A81D), // Gold
                        // Couleurs ki tkoun machi sélectionnée
                        unselectedIconBoxColor: const Color(
                          0xFFF2A81D,
                        ).withOpacity(0.15),
                        unselectedIconColor: const Color(0xFFF2A81D),
                      ),

                      const SizedBox(height: 16),

                      // 2. Carte Étudiant / Diplômé (طالب / خريج)
                      _buildRoleCard(
                        index: 1,
                        title: 'طالب / خريج',
                        subtitle: 'اكتشف فرص العمل الحر وابن مسيرتك',
                        iconData: Icons.school_outlined,
                        // Couleurs pour "Étudiant" ki tkoun sélectionnée
                        selectedBgColor: const Color(0xFFF2A81D), // Gold
                        selectedTitleColor: const Color(0xFF152D4D), // Navy
                        selectedSubtitleColor: const Color(
                          0xFF152D4D,
                        ).withOpacity(0.7),
                        selectedIconBoxColor: const Color(
                          0xFFD99516,
                        ), // Darker gold
                        selectedIconBorderColor: Colors.transparent,
                        selectedIconColor: const Color(0xFF152D4D),
                        // Couleurs ki tkoun machi sélectionnée
                        unselectedIconBoxColor: const Color(0xFFF0F2F5),
                        unselectedIconColor: const Color(0xFF152D4D),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Bottom "Continue" Button ---
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedIndex == -1
                        ? null // Bouton désactivé ida makheyer walo
                        : () {
                            if (_selectedIndex == 0) {
                              // L'utilisateur kheyyer "شركة" (Entreprise)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CompanyRegistrationScreen(),
                                ),
                              );
                            } else {
                              // L'utilisateur kheyyer "طالب / خريج" (Étudiant / Diplômé)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StudentRegistrationScreen(),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF152D4D), // Navy Blue
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: _selectedIndex == -1 ? 0 : 5,
                      shadowColor: const Color(0xFF152D4D).withOpacity(0.3),
                    ),
                    child: Text(
                      'التالي',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _selectedIndex == -1
                            ? Colors.grey.shade500
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

  // L'widget li ybni les cartes (Reusable w fih Animation)
  Widget _buildRoleCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData iconData,
    required Color selectedBgColor,
    required Color selectedTitleColor,
    required Color selectedSubtitleColor,
    required Color selectedIconBoxColor,
    required Color selectedIconBorderColor,
    required Color selectedIconColor,
    required Color unselectedIconBoxColor,
    required Color unselectedIconColor,
  }) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? selectedBgColor : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedBgColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icon Section
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: isSelected
                    ? selectedIconBoxColor
                    : unselectedIconBoxColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? selectedIconBorderColor
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  iconData,
                  size: 28,
                  color: isSelected ? selectedIconColor : unselectedIconColor,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? selectedTitleColor
                          : const Color(0xFF152D4D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? selectedSubtitleColor
                          : Colors.grey.shade500,
                      height: 1.4,
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
}
