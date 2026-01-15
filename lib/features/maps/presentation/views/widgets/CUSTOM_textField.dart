import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    this.onChanged,

    required this.controller,
    this.onTap,
    required this.hintText,
  });
  final void Function(String)? onChanged;
  final String? hintText;
  final TextEditingController controller;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 15,
      right: 15,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText ?? "ابحث عن منطقة...",
          filled: true,
          fillColor: Colors.white,
          prefixIcon: GestureDetector(
            onTap: onTap,
            child: Icon(color: Colors.blue, Icons.location_on),
          ),

          suffixIcon: GestureDetector(onTap: onTap, child: Icon(Icons.search)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
