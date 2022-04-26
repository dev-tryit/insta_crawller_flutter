import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class LoadPage extends StatefulWidget {
  static const String staticClassName = "LoadPage";
  final className = staticClassName;
  static const String pagePath = "/";
  const LoadPage({Key? key}) : super(key: key);

  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends KDHState<LoadPage> {
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
            "Insta\nManager",
            textAlign: TextAlign.center,
            style: MyFonts.coiny(
              fontSize: 35,
              height: 1.1,
              color: MyTheme.subColor,
            ),
          ),
        ));

    rebuild(afterBuild: () async {
      await Future.delayed(const Duration(seconds: 1));
      context.go("/", extra: {
        "isLogin": await AuthUtil.me.isLogin(),
      });
    });
  }
}
