import 'package:flutter/material.dart';
import 'package:hobe/core/theme/colors.dart';


class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool loading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.primaryStart, AppColors.primaryEnd],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryStart.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}