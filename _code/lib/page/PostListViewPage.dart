import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/repository/PostUrlRepository.dart';

class PostListViewPage extends StatefulWidget {
  static const String staticClassName = "PostListViewPage";
  final className = staticClassName;

  @override
  _PostListViewPageState createState() => _PostListViewPageState();
}

class _PostListViewPageState
    extends KDHState<PostListViewPage> {
  late PostListViewPageService s;

  @override
  Future<void> onLoad() async {
    s = PostListViewPageService(this);
    await s.loadPostUrlList();
  }

  @override
  Future<void> mustRebuild() async {
    toBuild = () => Scaffold(
        body: ListView(
          children: s.mediaUrlList.map((e) => Image.network(e.toString()))
              .toList(),
        )
    );
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}
}

class PostListViewPageService {
  List<PostUrl> postUrlList = [];
  List mediaUrlList = [];
  _PostListViewPageState state;

  PostListViewPageService(this.state);

  Future<void> loadPostUrlList() async {
    postUrlList = await PostUrlRepository().getList();
    postUrlList.forEach((element) {
      mediaUrlList.addAll(element.mediaUrlList ?? []);
    });
  }

}
