import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InterRegularTextFieldInput extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final Color? textColor;
  final Color? textHintColor;
  final double fontSize;
  final TextInputType keyboardType;
  final Color backgroundColor;
  final bool obscureText;
  final Icon? prefixIcon;
  final Image? suffixIcon;
  final int? maxLength;
  final String? Function()? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;


  const InterRegularTextFieldInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.textColor,
    this.textHintColor,
    this.fontSize = 14.0,
    this.keyboardType = TextInputType.text,
    this.backgroundColor = Colors.white,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.onChanged
  });

  @override
  _InterRegularTextFieldInputState createState() =>
      _InterRegularTextFieldInputState();
}

class _InterRegularTextFieldInputState
    extends State<InterRegularTextFieldInput> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText; // Initialize with provided value
  }

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      style: TextStyle(color: widget.textColor ?? Colors.black),
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText,
        counterText: "",
        hintStyle: TextStyle(
          color:
              widget.textHintColor?.withValues(
                red: 1,
                green: 1,
                blue: 1,
                alpha: 0.6,
              ) ??
              widget.textColor, // Hint text color
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w400,
          fontFamily: "Inter",
        ),
        contentPadding: const EdgeInsets.only(bottom: 14, left: 8, right: 8),
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.obscureText
                ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: widget.textColor ?? Colors.black,
                  ),
                  onPressed: _toggleObscureText,
                )
                : widget.suffixIcon,
      ),
      validator: (_) {
        return widget.validator?.call();
      },
      onChanged: (value){
        widget.onChanged?.call(value);
      },
    );
  }
}
