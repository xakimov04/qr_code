import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_code/ui/widgets/custom_floating_button.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDB623),
      floatingActionButton: const CustomFloatingActionButton(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset("assets/icons/top.png"),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/qr.png",
                  width: 150,
                  height: 150,
                ),
                const Gap(30),
                const Text(
                  "Get Started",
                  style: TextStyle(
                    fontFamily: 'itim',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Go and enjoy our features for free and make your life easy with us.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff3E3E42),
                    fontFamily: 'itim',
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset("assets/icons/bottom.png"),
          )
        ],
      ),
    );
  }
}
