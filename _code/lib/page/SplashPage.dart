import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/page/MainPage.dart';
import 'package:insta_crawller_flutter/page/auth/AuthPage.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class SplashPage extends StatefulWidget {
  static const String staticClassName = "SplashPage";
  final String className = staticClassName;

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends KDHState<SplashPage> {
  @override
  Future<void> mustFinishLoad() async {
    toBuild = () => loadingWidget();

    finishLoad(afterBuild: () async {
      await Future.delayed(const Duration(seconds: 1));
      PageUtil.goReplacement(
          context, !(await AuthUtil.me.isLogin()) ? AuthPage(nextPage: MainPage()) : MainPage());
    });
  }

  @override
  Widget loadingWidget() {
    return MyComponents.scaffold(
        body: Container(
      color: MyTheme.mainColor,
      alignment: Alignment.center,
      child: Text(
        "Insta\nManager",
        textAlign: TextAlign.center,
        style: MyFonts.coiny(
          fontSize: 35,
          height: 1.1,
          color: MyTheme.subColor,
        ),
      ),
    ));
  }
}
