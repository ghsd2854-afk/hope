import 'package:flutter/material.dart';
import 'package:hobe/core/theme/colors.dart';

class CustomInput extends StatelessWidget {

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final Widget? suffix;

  const CustomInput({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      obscureText: isPassword,

      decoration: InputDecoration(

        hintText: hint,

        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),

        prefixIcon: Icon(
          icon,
          color: Colors.deepPurple,
        ),

        suffixIcon: suffix,

        filled: true,

        fillColor: Colors.white,

        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),

        border: OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(12),

          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        enabledBorder: OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(12),

          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: const OutlineInputBorder(

          borderRadius:
              BorderRadius.all(
            Radius.circular(12),
          ),

          borderSide: BorderSide(
            color: Color(0xFF8B5CF6),
            width: 1.5,
          ),
        ),

        errorBorder: const OutlineInputBorder(

          borderRadius:
              BorderRadius.all(
            Radius.circular(12),
          ),

          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}