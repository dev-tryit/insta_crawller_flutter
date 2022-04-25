import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/page/PostListViewPage.dart';
import 'package:insta_crawller_flutter/service/InstaUserService.dart';
import 'package:insta_crawller_flutter/repository/InstaUserRepository.dart';
import 'package:insta_crawller_flutter/repository/PostUrlRepository.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyCrawller.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  static const String staticClassName = "TestPage";
  final className = staticClassName;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends KDHState<TestPage> {
  final idController = TextEditingController();
  final pwController = TextEditingController();

  @override
  Future<void> onLoad() async {}

  @override
  void mustRebuild() {
    widgetToBuild = () => InstaUserService.consumer(
          builder: (context, p, child) {
            p.loadInstaUser();
            idController.text = p.instaUser?.id ?? "";
            pwController.text = p.instaUser?.pw ?? "";
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
                        p.saveInstaUser(idController.text, pwController.text),
                  ),
                  SizedBox(height: 100),
                  MyComponents.buttonDefault(
                    child: const Text("브라우저 열기"),
                    onPressed: p.startBrowser,
                  ),
                  MyComponents.buttonDefault(
                    child: const Text("로그인하기"),
                    onPressed: () =>
                        p.login(idController.text, pwController.text),
                  ),
                  MyComponents.buttonDefault(
                    child: const Text("알림 설정 끄기"),
                    onPressed: p.turnOffAlarmDialog,
                  ),
                  MyComponents.buttonDefault(
                    child: const Text("유머 포스트 저장하기"),
                    onPressed: p.saveHumorPost,
                  ),
                  MyComponents.buttonDefault(
                    child: const Text("유머 포스트 리스트 확인하기"),
                    onPressed: p.goPostListViewPage,
                  ),
                  MyComponents.buttonDefault(
                    child: const Text("브라우저 중지"),
                    onPressed: p.stopBrowser,
                  ),
                ],
              ),
            );
          },
        );
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}
}
