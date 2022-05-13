import 'package:flutter/material.dart';

class KDHComponent<KDH_STATE extends State> {
  final KDH_STATE state;
  KDHComponent(this.state);
  BuildContext get context => state.context;
}