import 'package:flutter/material.dart';
import 'package:qr_code/ui/widgets/bottom_bar.dart';

import '../screens/qr_scaner_screen.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomFloatingActionButton({super.key, required this.onPressed});

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
        onPressed: onPressed,
        backgroundColor: const Color(0xffFDB623),
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.black,
        ),
      ),
    );
  }
}
