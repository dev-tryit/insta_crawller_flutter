import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/service/CrawllerService.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';

class TestPage extends StatefulWidget {
  static const String staticClassName = "TestPage";
  final String className = staticClassName;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends KDHState<TestPage> {
  final idController = TextEditingController();
  final pwController = TextEditingController();

  @override
  Future<void> mustRebuild() async {
    toBuild = () {
      return CrawllerService.consumer(
        builder: (context, service, child) {
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
                  onPressed: () => service.saveInstaUser(idController.text, pwController.text),
                ),
                SizedBox(height: 100),
                MyComponents.buttonDefault(
                  child: const Text("브라우저 열기"),
                  onPressed: service.startBrowser,
                ),
                MyComponents.buttonDefault(
                  child: const Text("로그인하기"),
                  onPressed: () => service.login(idController.text, pwController.text),
                ),
                MyComponents.buttonDefault(
                  child: const Text("알림 설정 끄기"),
                  onPressed: service.turnOffAlarmDialog,
                ),
                MyComponents.buttonDefault(
                  child: const Text("유머 포스트 저장하기"),
                  onPressed: service.saveHumorPost,
                ),
                MyComponents.buttonDefault(
                  child: const Text("유머 포스트 리스트 확인하기"),
                  onPressed: service.goPostListViewPage,
                ),
                MyComponents.buttonDefault(
                  child: const Text("브라우저 중지"),
                  onPressed: service.stopBrowser,
                ),
              ],
            ),
          );
        },
      );
    };
    rebuild(afterBuild: () async {
      CrawllerService service = CrawllerService.read(context);
      service.getInstaUser().then((instaUser) {
        idController.text = instaUser?.id ?? "";
        pwController.text = instaUser?.pw ?? "";
        service.notifyListeners();
      });

    });
  }
}
