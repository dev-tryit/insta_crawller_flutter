import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/MySetting.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHComponent.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHService.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:insta_crawller_flutter/_common/util/LogUtil.dart';
import 'package:insta_crawller_flutter/_common/widget/EasyFade.dart';
import 'package:insta_crawller_flutter/state/auth/AuthState.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';

class MainPage extends StatefulWidget {
  static const String staticClassName= "MainPage";
  final className = staticClassName;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState
    extends KDHState<MainPage, MainPageComponent, MainPageService> {
  @override
  bool isPage() => true;

  @override
  List<WidgetToGetSize> makeWidgetListToGetSize() => [];

  @override
  MainPageComponent makeComponent() => MainPageComponent(this);

  @override
  MainPageService makeService() => MainPageService(this, c);

  @override
  Future<void> onLoad() async {}

  @override
  void mustRebuild() {
    widgetToBuild = () => c.body(s);
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}
}

class MainPageComponent extends KDHComponent<_MainPageState> {
  MainPageComponent(_MainPageState state) : super(state);

  Widget body(MainPageService s) {
    return Scaffold(
      body: Column(
        children: [
          MyComponents.buttonDefault(child: const Text("브라우저 열기"), onPressed: (){

          }),
        ],
      ),
    );
  }
}

class MainPageService extends KDHService<_MainPageState, MainPageComponent> {
  MainPageService(_MainPageState state, MainPageComponent c):
        super(state, c);
}
