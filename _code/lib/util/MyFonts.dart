import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFonts {
  static Future<void> init() async {
    blackHanSans();
    gothicA1();
    // GoogleFonts.config.allowRuntimeFetching = false; //false이면 asset에서 갖고옴.
  }

  static TextStyle blackHanSans({
    TextStyle? textStyle,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.blackHanSans(
      textStyle: textStyle,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle gothicA1({
    TextStyle? textStyle,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.gothicA1(
      textStyle: textStyle,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
