import 'package:flutter/material.dart';
import 'package:qr_code/ui/widgets/bottom_bar.dart';

import '../screens/qr_scaner_screen.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65.0,
      height: 65.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0xffFDB623),
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomBar(),
            ),
            (route) => false,
          );
        },
        backgroundColor: const Color(0xffFDB623),
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.black,
        ),
      ),
    );
  }
}
