import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/page/auth/AuthPage.dart';
import 'package:insta_crawller_flutter/page/TestPage.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class LoadPage extends StatefulWidget {
  static const String staticClassName= "LoadPage";
  final className = staticClassName;
  const LoadPage({Key? key}) : super(key: key);

  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState
    extends KDHState<LoadPage> {
  late LoadPageService s;
  @override
  Future<void> onLoad() async {
    s = LoadPageService(this);
  }

  @override
  void mustRebuild() {
    widgetToBuild = () => Scaffold(body: Container(
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
    rebuild();
  }

  @override
  Future<void> afterBuild() async {
    await s.moveNextPage();
  }
}

class LoadPageService {
  _LoadPageState state;
  BuildContext get context => state.context;
  void rebuild() => state.setState(() {});

  LoadPageService(this.state);

  Future<void> moveNextPage() async {
    await Future.delayed(const Duration(seconds: 1));
    PageUtil.replacementPage(
        context, await AuthUtil().isLogin() ? TestPage() : AuthPage(nextPage:TestPage()));
  }
}
