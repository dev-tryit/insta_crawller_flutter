import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/service/PostUrlService.dart';

class PostListViewPage extends StatefulWidget {
  static const String staticClassName = "PostListViewPage";
  final className = staticClassName;

  @override
  _PostListViewPageState createState() => _PostListViewPageState();
}

class _PostListViewPageState extends KDHState<PostListViewPage> {
  @override
  Future<void> onLoad() async {
  }

  @override
  Future<void> mustRebuild() async {
    List mediaUrlList = await PostUrlService.read(context)
        .getMediaUrlList();
    toBuild = () => Scaffold(
            body: ListView(
          children: mediaUrlList
              .map((e) => Image.network(e.toString()))
              .toList(),
        ));
    rebuild();
  }
}
