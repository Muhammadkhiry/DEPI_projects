import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.readOnly = false,
    this.controller, 
  });

  final String label;
  final String icon;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextEditingController? controller; 

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: onTap,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.black),

      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Image.asset(icon, height: 24, width: 24, color: Colors.grey),
        ),

        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),

        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey, width: 2),
        ),
      ),
    );
  }
}
