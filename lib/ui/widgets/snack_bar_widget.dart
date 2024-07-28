import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SnackBarWidget extends StatelessWidget {
  final String message;
  final bool isError;

  const SnackBarWidget({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: isError ? Colors.red : const Color(0xffFDB623),
      content: Row(
        children: [
          Icon(
            isError ? Icons.error : Icons.check,
            color: Colors.black,
          ),
          const Gap(10),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              color: isError ? Colors.white : Colors.black,
              fontFamily: 'itim',
            ),
          ),
        ],
      ),
    );
  }
}
