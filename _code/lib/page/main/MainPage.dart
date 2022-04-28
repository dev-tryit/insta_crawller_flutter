import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/extension/RandomExtension.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyImage.dart';
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
      padding: const EdgeInsets.only(left: 18, top: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Insta Manager",
                style: MyFonts.coiny(
                  fontSize: 28,
                  height: 1.0,
                  color: MyTheme.subColor,
                ),
              ),
              Spacer(),
              InkWell(
                child: Image(
                  width: 16,
                  height: 20,
                  image: MyImage.notesIcon,
                  fit: BoxFit.contain,
                ),
                onTap: () {
                  print("InkWell onTap");
                },
              ),
              SizedBox(width: 26),
            ],
          ),
          Divider(thickness: 1.3, color: MyTheme.subColor),
        ],
      ),
    );
  }

  Widget scrollView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top:34),
        child: Column(
          children: List.generate(12, (index) => instaCardGroup()),
        ),
      ),
    );
  }

  Widget instaCardGroup() {
    String emojiChar = Emoji.byGroup(EmojiGroup.smileysEmotion).toList().getRandomElement().char;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 18, right: 24),
          child: Column(
            children: [
              Row(
                children: [
                  Text(emojiChar),
                  SizedBox(width: 5),
                  Text("abc__"),
                  SizedBox(width: 5),
                  InkWell(
                    child: Image(
                      width: 18,
                      height: 18,
                      image: MyImage.downloadsIcon,
                      fit: BoxFit.fill,
                    ),
                    onTap: (){
                      print("downloadsIcon click");
                    },
                  )
                ],
              ),
              SizedBox(height: 8),
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
