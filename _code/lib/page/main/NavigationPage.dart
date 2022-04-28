import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class NavigationPage extends StatelessWidget {
  static const String staticClassName = "NavigationPage";
  final className = staticClassName;

  const NavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyTheme.mainColor,
        alignment: Alignment.center,
        child: Text(
          "NavigationPage",
          textAlign: TextAlign.center,
          style: MyFonts.coiny(
            fontSize: 35,
            height: 1.1,
            color: MyTheme.subColor,
          ),
        ),
      ),
    );
  }
}
