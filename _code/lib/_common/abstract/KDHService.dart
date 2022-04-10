
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';

abstract class KDHService<STATE extends KDHState, COMPONENT> {
  final STATE state;
  final COMPONENT c;

  BuildContext get context => state.context;
  void rebuild({Function? afterBuild}) => state.rebuild(afterBuild: afterBuild);
  Size get screenSize => state.screenSize;
  Map<dynamic, WidgetToGetSize> get widgetMap => state.widgetMap;
  set widgetToBuild(Widget Function() widgetToBuild) => state.widgetToBuild = widgetToBuild;

  KDHService(this.state, this.c);
}