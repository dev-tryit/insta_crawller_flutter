
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';

abstract class KDHComponent<State extends KDHState> {
  final State state;
  void rebuild({Function? afterBuild}) => state.rebuild(afterBuild: afterBuild);
  BuildContext get context => state.context;
  KDHComponent(this.state);
}