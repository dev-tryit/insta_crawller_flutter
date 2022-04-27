import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class MainPage extends StatefulWidget {
  static const String staticClassName = "MainPage";
  final className = staticClassName;

  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends KDHState<MainPage> {
  @override
  Future<void> onLoad() async {}

  @override
  Future<void> mustRebuild() async {
    toBuild = () {
      return Scaffold(
        body: Container(
          color: MyTheme.mainColor,
          alignment: Alignment.center,
          child: Column(
            children: [
              appBar(),
              Divider(),
              Expanded(child: scrollView()),
            ],
          ),
        ),
      );
    };
    rebuild();
  }

  Widget appBar() {
    return Row(
      children: [
        Text("appBar"),
      ],
    );
  }

  Widget scrollView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          instaCardGroup(),
        ],
      ),
    );
  }

  Widget instaCardGroup() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.error),
                  Text("abc__"),
                  Icon(Icons.error),
                ],
              ),
              Container(
                height: 215,
                color: Colors.blue,
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
