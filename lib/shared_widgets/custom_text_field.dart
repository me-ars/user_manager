import 'package:flutter/material.dart';

import '../core/theme/app_palete.dart';

class CustomTextField extends StatefulWidget {
  final double height;
  final double width;
  final TextEditingController controller;
  final String labelText;
  final int maxLength;
  final bool isPassword;

  const CustomTextField(
      {super.key,
      required this.height,
      required this.width,
      required this.controller,
      required this.labelText,
      required this.maxLength,
      required this.isPassword});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

bool _isPassVisible = false;

class _CustomTextFieldState extends State<CustomTextField> {
  _changePasswordVisibility() {
    setState(() {
      _isPassVisible = !_isPassVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextField(
        obscureText: widget.isPassword && !_isPassVisible,
        maxLength: widget.maxLength,
        cursorColor: AppPalette.primaryTextColor,
        controller: widget.controller,
        decoration: InputDecoration(
          counterText: "",
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    _changePasswordVisibility();
                  },
                  icon: Icon(_isPassVisible
                      ? Icons.remove_red_eye_outlined
                      : Icons.remove_red_eye))
              : null,
          labelStyle: const TextStyle(color: AppPalette.primaryTextColor),
          labelText: widget.labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: AppPalette.appPrimaryColor),

          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: AppPalette.primaryTextColor),
          ),
        ),
      ),
    );
  }
}
