import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/colors.dart';
import 'inter_regular_text_filed.dart';

class RoundedTextField extends StatelessWidget {
  final Color backgroundColor;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final double height;
  final String? Function()? validator;
  final Image? suffixImage;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const RoundedTextField({
    super.key,
    required this.backgroundColor,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.height = 45,
    this.validator,
    this.suffixImage,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.brightGray, // Border color
          width: 1.0,         // Border width
        ),
      ),
      child: Center(
        child: InterRegularTextFieldInput(
          backgroundColor: AppColors.carbonGrey,
          controller: controller,
          keyboardType: keyboardType,
          hintText: hintText,
          textColor: AppColors.black,
          textHintColor: AppColors.carbonGrey,
          obscureText: obscureText,
          validator: validator,
          suffixIcon: suffixImage,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
