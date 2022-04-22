import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/MySetting.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHComponent.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHService.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/page/auth/AuthPage.dart';
import 'package:insta_crawller_flutter/page/main/MainPage.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
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
    extends KDHState<LoadPage, LoadPageComponent, LoadPageService> {
  @override
  bool isPage() => true;

  @override
  List<WidgetToGetSize> makeWidgetListToGetSize() => [];

  @override
  LoadPageComponent makeComponent() => LoadPageComponent(this);

  @override
  LoadPageService makeService() => LoadPageService(this, c);

  @override
  Future<void> onLoad() async {}

  @override
  void mustRebuild() {
    widgetToBuild = () => Scaffold(body: c.body());
    rebuild();
  }

  @override
  Future<void> afterBuild() async {
    await s.moveNextPage();
  }
}

class LoadPageComponent extends KDHComponent<_LoadPageState> {
  LoadPageComponent(_LoadPageState state) : super(state);

  Widget body() {
    return Container(
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
    );
  }
}

class LoadPageService extends KDHService<_LoadPageState, LoadPageComponent> {
  LoadPageService(_LoadPageState state, LoadPageComponent c) : super(state, c);

  Future<void> moveNextPage() async {
    await Future.delayed(const Duration(seconds: 1));
    PageUtil.replacementPage(
        context, await AuthUtil().isLogin() ? MainPage() : AuthPage(nextPage:MainPage()));
  }
}
