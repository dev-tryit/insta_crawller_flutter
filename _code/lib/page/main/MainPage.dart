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
import 'package:insta_crawller_flutter/repository/InstaUserRepository.dart';
import 'package:insta_crawller_flutter/repository/PostUrlRepository.dart';
import 'package:insta_crawller_flutter/state/auth/AuthState.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyCrawller.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';

class MainPage extends StatefulWidget {
  static const String staticClassName = "MainPage";
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
  Future<void> onLoad() async {
    await s.loadInstaUser();
  }

  @override
  void mustRebuild() {
    widgetToBuild = () => c.body(s);
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}
}

class MainPageComponent extends KDHComponent<_MainPageState> {
  final idController = TextEditingController();
  final pwController = TextEditingController();

  MainPageComponent(_MainPageState state) : super(state);

  Widget body(MainPageService s) {
    idController.text = s.instaUser?.id??"";
    pwController.text = s.instaUser?.pw??"";
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: idController,
            decoration: InputDecoration(isDense: true, labelText: "ID"),
          ),
          TextField(
            controller: pwController,
            decoration: InputDecoration(isDense: true, labelText: "PW"),
            obscureText: true,
          ),
          MyComponents.buttonDefault(
            child: const Text("저장"),
            onPressed: ()=>s.saveInstaUser(idController.text, pwController.text),
          ),
          SizedBox(height: 100),
          MyComponents.buttonDefault(
            child: const Text("브라우저 열기"),
            onPressed: s.startBrowser,
          ),
          MyComponents.buttonDefault(
            child: const Text("로그인하기"),
            onPressed: s.login,
          ),
          MyComponents.buttonDefault(
            child: const Text("알림 설정 끄기"),
            onPressed: s.turnOffAlarmDialog,
          ),
          MyComponents.buttonDefault(
            child: const Text("유머 포스트 저장하기"),
            onPressed: s.saveHumorPost,
          ),
          MyComponents.buttonDefault(
            child: const Text("브라우저 중지"),
            onPressed: s.stopBrowser,
          ),
        ],
      ),
    );
  }
}

class MainPageService extends KDHService<_MainPageState, MainPageComponent> {
  InstaUser? instaUser;
  final crawller = MyCrawller();

  MainPageService(_MainPageState state, MainPageComponent c) : super(state, c);

  Future<void> loadInstaUser() async {
    instaUser = await InstaUserRepository().getOne();
  }

  Future<void> saveInstaUser(String id, String pw) async {
    instaUser = InstaUser(id: id, pw: pw);
    try {
      await InstaUserRepository().save(instaUser: instaUser!);
      MyComponents.snackBar(context, "저장 성공하였습니다.");
    }
    catch(e){
      MyComponents.snackBar(context, "저장 실패하였습니다.");
    }
  }

  void saveHumorPost() async {
    String instaUserId = "inssa_unni_";
    List<String> postUrlList = await crawller.getPostUrlList(instaUserId);

    for(String postUrl in postUrlList) {
      if(await PostUrlRepository().getOneByUrl(postUrl) != null) continue;

      List<String> mediaStrList = await crawller.getMediaStrListOf(postUrl: postUrl);
      var postUrlObj = PostUrl(instaUserId: instaUserId, url: postUrl, mediaUrlList: mediaStrList);
      await PostUrlRepository().save(postUrl: postUrlObj);
    }
  }

  void startBrowser() {
    crawller.startBrowser();
  }
  void stopBrowser() {
    crawller.stopBrowser();
  }

  void login() {
    crawller.login(c.idController.text, c.pwController.text);
  }

  void turnOffAlarmDialog() {
    crawller.turnOffAlarmDialog();
  }

}
