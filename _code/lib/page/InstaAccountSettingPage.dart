import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class InstaAccountSettingPage extends StatelessWidget {
  static const String staticClassName = "InstaAccountSettingPage";
  final String className = staticClassName;

  const InstaAccountSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set My Insta Account", style: MyFonts.coiny()),
        backgroundColor: MyTheme.subColor,
        foregroundColor: MyTheme.mainColor,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyComponents.inputBox(label: "Insta ID"),
            MyComponents.inputBox(label: "Insta PW"),
          ],
        ),
      ),
    );
  }
}
