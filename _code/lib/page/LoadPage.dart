import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/MySetting.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHComponent.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHService.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/page/auth/AuthPage.dart';
import 'package:insta_crawller_flutter/page/main/MainLayout.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';

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
      color: MyColors.deepBlue,
      alignment: Alignment.center,
      child: Text(
        MySetting.appName,
        style: MyFonts.blackHanSans(
          fontSize: 35,
          color: MyColors.white,
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
        context, await AuthUtil().isLogin() ? MainLayout() : AuthPage());
  }
}
