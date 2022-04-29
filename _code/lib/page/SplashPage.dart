import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';
import 'package:insta_crawller_flutter/page/auth/AuthPage.dart';
import 'package:insta_crawller_flutter/page/main/MainPage.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class SplashPage extends StatefulWidget {
  static const String staticClassName = "LoadPage";
  final className = staticClassName;

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends KDHState<SplashPage> {

  @override
  Future<void> mustRebuild() async {
    toBuild = () => loadingWidget();

    rebuild(afterBuild: () async {
      await Future.delayed(const Duration(seconds: 1));
      context.go("/", extra: {
        "pageName": !(await AuthUtil.me.isLogin())
            ? AuthPage.staticClassName
            : MainPage.staticClassName
      });
    });
  }

  @override
  Widget loadingWidget() {
    return Scaffold(
        body: Container(
      width: 350,
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
