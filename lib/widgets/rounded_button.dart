import 'package:flutter/material.dart';
import 'package:ipg_flutter/widgets/inter_medium_text.dart';

import '../resources/colors.dart';

class RoundedButton extends ElevatedButton {
  RoundedButton({
    super.key,
    required String text,
    required VoidCallback super.onPressed,
    Color textColor = Colors.white,
    double fontSize = 16.0,
    double borderRadius = 30.0,
    double height = 60.0,
    Color? backgroundColor,
    String? leadingIcon,
    Color? circularProgressBarColor,
    bool isLoading = false,
  }) : super(
         style: ElevatedButton.styleFrom(
           minimumSize: Size(double.maxFinite, height),
           backgroundColor: backgroundColor ?? AppColors.elfGreen,
           // Button background color
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(
               borderRadius,
             ), // Rounded corners
           ),
         ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             if (leadingIcon != null)
               Image.asset(leadingIcon, width: 20, height: 20),
             if (leadingIcon != null) const SizedBox(width: 4),
             isLoading
                 ? SizedBox(
                   height: 20,
                   width: 20,
                   child: CircularProgressIndicator(
                     color: circularProgressBarColor ?? AppColors.white,
                   ),
                 )
                 : InterMediumText(text, color: textColor, fontSize: fontSize),
           ],
         ),
       );
}
