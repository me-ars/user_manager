import 'package:flutter/material.dart';
import '../core/theme/app_palete.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final String buttonText;
  final Function onTap;

  const CustomButton(
      {super.key,
        required this.height,
        required this.width,
        required this.buttonText,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: AppPalette.appPrimaryColor,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(textAlign: TextAlign.center,
            buttonText,
            style: const TextStyle(

                fontSize: 18,
                color: AppPalette.whiteColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
