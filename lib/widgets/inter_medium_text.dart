import 'package:flutter/material.dart';

class InterMediumText extends Text {

  InterMediumText(
      String text, {
        Key? key,
        Color color = Colors.black,
        double fontSize = 14.0,
        FontWeight fontWeight = FontWeight.w500,
        String fontFamily = 'Inter',
        TextAlign? textAlign,
        int? maxLines,
        TextOverflow? overflow,
        double? height,
        TextSpan? textSpan
      }) : super(
    text,
    key: key,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      height: height
    ),
  );
}
