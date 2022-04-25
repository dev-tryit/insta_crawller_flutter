import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/page/PostListViewPage.dart';
import 'package:insta_crawller_flutter/repository/InstaUserRepository.dart';
import 'package:insta_crawller_flutter/repository/PostUrlRepository.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyCrawller.dart';

class TestPage extends StatefulWidget {
  static const String staticClassName = "TestPage";
  final className = staticClassName;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends KDHState<TestPage> {
  late TestPageService s;
  final idController = TextEditingController();
  final pwController = TextEditingController();

  @override
  Future<void> onLoad() async {
    s = TestPageService(this);
    await s.loadInstaUser();
  }

  @override
  void mustRebuild() {
    widgetToBuild = () {
      idController.text = s.instaUser?.id ?? "";
      pwController.text = s.instaUser?.pw ?? "";
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
              onPressed: () =>
                  s.saveInstaUser(idController.text, pwController.text),
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
              child: const Text("유머 포스트 리스트 확인하기"),
              onPressed: s.goPostListViewPage,
            ),
            MyComponents.buttonDefault(
              child: const Text("브라우저 중지"),
              onPressed: s.stopBrowser,
            ),
          ],
        ),
      );
    };
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}
}

class TestPageService {
  InstaUser? instaUser;
  final crawller = MyCrawller();
  _TestPageState state;
  BuildContext get context => state.context;
  void rebuild() => state.setState(() {});

  TestPageService(this.state);

  Future<void> loadInstaUser() async {
    instaUser = await InstaUserRepository().getOne();
  }

  Future<void> saveInstaUser(String id, String pw) async {
    instaUser = InstaUser(id: id, pw: pw);
    try {
      await InstaUserRepository().save(instaUser: instaUser!);
      MyComponents.snackBar(context, "저장 성공하였습니다.");
    } catch (e) {
      MyComponents.snackBar(context, "저장 실패하였습니다.");
    }
  }

  void saveHumorPost() async {
    String instaUserId = "inssa_unni_";
    List<String> postUrlList = await crawller.getPostUrlList(instaUserId);

    for (String postUrl in postUrlList) {
      if (await PostUrlRepository().getOneByUrl(postUrl) != null) continue;

      List<String> mediaStrList =
          await crawller.getMediaStrListOf(postUrl: postUrl);
      var postUrlObj = PostUrl(
          instaUserId: instaUserId, url: postUrl, mediaUrlList: mediaStrList);
      await PostUrlRepository().save(postUrl: postUrlObj);
    }
  }

  void goPostListViewPage() async {
    PageUtil.movePage(context, PostListViewPage());
  }

  void startBrowser() {
    crawller.startBrowser();
  }

  void stopBrowser() {
    crawller.stopBrowser();
  }

  void login() {
    crawller.login(state.idController.text, state.pwController.text);
  }

  void turnOffAlarmDialog() {
    crawller.turnOffAlarmDialog();
  }
}
