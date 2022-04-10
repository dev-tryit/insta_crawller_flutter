import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';

class MyRedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool useShadow;

  const MyRedButton(this.text,
      {Key? key, required this.onPressed, this.useShadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: MyFonts.gothicA1(
          color: MyColors.white,
          fontSize: 12.5,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shadowColor: useShadow ? MyColors.black : null,
        elevation: useShadow ? 7 : null,
        padding:
            const EdgeInsets.only(left: 23, right: 23, top: 14, bottom: 14),
        primary: MyColors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
