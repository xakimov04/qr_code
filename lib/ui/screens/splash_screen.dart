
import 'package:flutter/material.dart';
import 'package:qr_code/ui/screens/onboardin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/bottom_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOnboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
    if (isOnboardingCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomBar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
