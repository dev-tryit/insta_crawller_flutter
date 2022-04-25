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

class _PostListViewPageState extends KDHState<PostListViewPage> {
  List<PostUrl> postUrlList = [];
  List mediaUrlList = [];

  @override
  Future<void> onLoad() async {
    postUrlList = await PostUrlRepository.me.getList();
    postUrlList.forEach((element) {
      mediaUrlList.addAll(element.mediaUrlList ?? []);
    });
  }

  @override
  Future<void> mustRebuild() async {
    toBuild = () => Scaffold(
            body: ListView(
          children:
              mediaUrlList.map((e) => Image.network(e.toString())).toList(),
        ));
    rebuild();
  }
}
