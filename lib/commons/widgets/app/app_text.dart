import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../style/colors.dart';
import '../../style/font_sizes.dart';

class AppText extends Text {
  AppText.base(
      super.text, {
        super.key,
        double? fontSize = FontSizes.medium,
        Color? color = UIColors.textColor,
        FontWeight? fontWeight,
        super.maxLines,
        super.textAlign,
        TextOverflow? textOverflow = TextOverflow.ellipsis,
      }) : super(
    /// can use tr() if you use multiple language
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),
    overflow: textOverflow,
  );

  AppText.regular(
      super.text, {
        super.key,
        double? fontSize = FontSizes.small,
        Color? color = UIColors.textColor,
        FontWeight? fontWeight = FontWeight.w400,
        super.maxLines,
        super.textAlign,
        TextOverflow? textOverflow = TextOverflow.ellipsis,
        TextDecoration? decoration,
      }) : super(
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),
    overflow: textOverflow,
  );

  AppText.medium(
      super.text, {
        super.key,
        double? fontSize = FontSizes.medium,
        Color? color = UIColors.textColor,
        FontWeight? fontWeight = FontWeight.w500,
        super.maxLines,
        super.textAlign,
        TextOverflow? textOverflow = TextOverflow.ellipsis,
        Map<String, String>? namedArgs,
      }) : super(
    /// can use tr() if you use multiple language
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),
    overflow: textOverflow,
  );

  AppText.semiBold(
      super.text, {
        super.key,
        double? fontSize = FontSizes.medium,
        Color? color = UIColors.textColor,
        FontWeight? fontWeight = FontWeight.w600,
        super.maxLines,
        super.textAlign,
        TextOverflow? textOverflow = TextOverflow.ellipsis,
        Map<String, String>? namedArgs,
      }) : super(
    /// can use tr() if you use multiple language
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),
    overflow: textOverflow,
  );

  AppText.bold(
      super.text, {
        super.key,
        double? fontSize = FontSizes.medium,
        Color? color = UIColors.textColor,
        FontWeight? fontWeight = FontWeight.w700,
        super.maxLines,
        TextOverflow? textOverflow = TextOverflow.ellipsis,
        super.textAlign,
      }) : super(
    /// can use tr() if you use multiple language
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),
    overflow: textOverflow,
  );
}
