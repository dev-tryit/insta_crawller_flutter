import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class InstaAccountSettingPage extends StatelessWidget {
  static const String staticClassName = "InstaAccountSettingPage";
  final String className = staticClassName;

  const InstaAccountSettingPage({Key? key}) : super(key: key);

  static const TextStyle textStyle = TextStyle(color: MyTheme.mainColor );
  static const InputDecoration inputBoxDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.mainColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.mainColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.mainColor),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.mainColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.mainColor),
    ),
    errorStyle: TextStyle(color: MyTheme.mainColor),
  );

  @override
  Widget build(BuildContext context) {
    return MyComponents.scaffold(
      appBar: AppBar(
        title: Text("Set My Insta Account", style: MyFonts.coiny()),
        backgroundColor: MyTheme.subColor,
        foregroundColor: MyTheme.mainColor,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            MyComponents.inputBox(
              label: "Insta ID",
              textStyle: textStyle,
              decoration: inputBoxDecoration,
            ),
            const SizedBox(height: 25),
            MyComponents.inputBox(
              label: "Insta PW",
              textStyle: textStyle,
              obscureText: true,
              decoration: inputBoxDecoration,
            ),
          ],
        ),
      ),
    );
  }
}
