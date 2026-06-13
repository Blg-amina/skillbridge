import 'package:flutter/material.dart';
import 'package:jisrelmahara_app/screens/onboarding_screen1.dart';
import 'package:jisrelmahara_app/screens/splash_screen.dart';

// Bédli l'chemin 3la 7sab win 7attiti le fichier ta3 splash screen

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); // Nst7a9ouha mba3d ki nzidou Firebase
  runApp(const SkillBridgeApp());
}

class SkillBridgeApp extends StatelessWidget {
  const SkillBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillBridge DZ',
      debugShowCheckedModeBanner: false, // Bache n7ayou hadik l'bande rouge ta3 "DEBUG"
      theme: ThemeData(
        fontFamily: 'Cairo', // L'ecriture li mfahemin 3liha
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF152D4D), // Navy Blue
          primary: const Color(0xFF152D4D),
          secondary: const Color(0xFFF2A81D), // Gold
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        // '/auth': (context) => const AuthScreen(), // Nst7a9ouha mba3d ki nzidou l'auth screen
      },
    );
  }
}