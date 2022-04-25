import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class MainPage extends StatefulWidget {
  static const String staticClassName = "MainPage";
  final className = staticClassName;

  static const pagePath = "/$staticClassName";
  
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends KDHState<MainPage> {
  @override
  Future<void> onLoad() async {}

  @override
  Future<void> mustRebuild() async {
    toBuild = () => Scaffold(
            body: Container(
          width: 350,
          color: MyTheme.mainColor,
          alignment: Alignment.center,
          child: Text(
            "MainPage",
            textAlign: TextAlign.center,
            style: MyFonts.coiny(
              fontSize: 35,
              height: 1.1,
              color: MyTheme.subColor,
            ),
          ),
        ));

    rebuild();
  }
}
