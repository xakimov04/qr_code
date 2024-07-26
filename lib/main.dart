import 'package:flutter/material.dart';
import 'package:qr_code/ui/screens/qr_scaner_screen.dart';
import 'package:qr_code/ui/screens/splash_screen.dart';
import 'package:qr_code/ui/widgets/bottom_bar.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoarding(),
    );
  }
}
