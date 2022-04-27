import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
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
              Expanded(child: scrollView()),
            ],
          ),
        ),
      );
    };
    rebuild();
  }

  Widget appBar() {
    return Padding(
      padding: const EdgeInsets.only(left:18),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Insta Manager",
                style: MyFonts.coiny(
                  fontSize: 28,
                  color: MyTheme.subColor,
                ),
              ),
              Spacer(),
              Icon(Icons.error),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget scrollView() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(12, (index) => instaCardGroup()),
      ),
    );
  }

  Widget instaCardGroup() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left:18, right: 31),
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
        Divider(endIndent: 94),
      ],
    );
  }
}
