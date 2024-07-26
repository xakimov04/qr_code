import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String text;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xffFDB623),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
          const Gap(5),
          Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontFamily: 'itim'),
          ),
        ],
      ),
    );
  }
}
