import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHComponent.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHService.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/page/PostListViewPage.dart';
import 'package:insta_crawller_flutter/repository/InstaUserRepository.dart';
import 'package:insta_crawller_flutter/repository/PostUrlRepository.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyCrawller.dart';

class PostListViewPage extends StatefulWidget {
  static const String staticClassName = "PostListViewPage";
  final className = staticClassName;

  @override
  _PostListViewPageState createState() => _PostListViewPageState();
}

class _PostListViewPageState
    extends KDHState<PostListViewPage, PostListViewPageComponent, PostListViewPageService> {
  @override
  bool isPage() => true;

  @override
  List<WidgetToGetSize> makeWidgetListToGetSize() => [];

  @override
  PostListViewPageComponent makeComponent() => PostListViewPageComponent(this);

  @override
  PostListViewPageService makeService() => PostListViewPageService(this, c);

  @override
  Future<void> onLoad() async {
    await s.loadPostUrlList();
  }

  @override
  void mustRebuild() {
    widgetToBuild = () => c.body(s);
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}
}

class PostListViewPageComponent extends KDHComponent<_PostListViewPageState> {
  PostListViewPageComponent(_PostListViewPageState state) : super(state);

  Widget body(PostListViewPageService s) {
    return Scaffold(
      body: ListView(
        children: s.mediaUrlList.map((e) => Image.network(e.toString())).toList(),
      )
    );
  }
}

class PostListViewPageService extends KDHService<_PostListViewPageState, PostListViewPageComponent> {
  List<PostUrl> postUrlList = [];
  List mediaUrlList = [];

  PostListViewPageService(_PostListViewPageState state, PostListViewPageComponent c) : super(state, c);

  Future<void> loadPostUrlList() async {
    postUrlList = await PostUrlRepository().getList();
    postUrlList.forEach((element) {
      mediaUrlList.addAll(element.mediaUrlList??[]);
    });
  }

}
