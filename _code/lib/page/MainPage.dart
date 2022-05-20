import 'package:bot_toast/bot_toast.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHComponent.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/extension/RandomExtension.dart';
import 'package:insta_crawller_flutter/_common/util/InteractionUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/page/NavigationPage.dart';
import 'package:insta_crawller_flutter/repository/PostUrlRepository.dart';
import 'package:insta_crawller_flutter/service/CrawllerService.dart';
import 'package:insta_crawller_flutter/service/PostUrlService.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyImage.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class MainPage extends StatefulWidget {
  static const String staticClassName = "MainPage";
  final String className = staticClassName;

  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class MainPageComponent extends KDHComponent<_MainPageState> {
  List<PostUrl> postUrlList = [];

  MainPageComponent(_MainPageState state) : super(state);
}

class _MainPageState extends KDHState<MainPage> {
  late final PostUrlService s;
  late final CrawllerService crawller;
  late final MainPageComponent c;

  @override
  Future<void> mustFinishLoad() async {
    c = MainPageComponent(this);
    s = PostUrlService.read(context);
    crawller = CrawllerService.read(context);

    toBuild = () {
      return MyComponents.scaffold(
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
    await s.setPostUrlList(c);
    finishLoad();
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
                onTap: moveNavigationPage,
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
    return PostUrlService.consumer(
      builder: (context, value, child) => c.postUrlList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 34),
              child: ListView(
                children: c.postUrlList
                    .map((postUrl) => instaCardGroup(postUrl))
                    .toList(),
              ),
            )
          : Center(
              child: Text(
                "There are no Posts collected",
                style: MyFonts.coiny(
                  color: MyTheme.subColor,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
    );
  }

  Widget instaCardGroup(PostUrl postUrl) {
    List mediaUrlList = (postUrl.mediaUrlList ?? []);
    String emojiChar = Emoji.byGroup(EmojiGroup.smileysEmotion)
        .toList()
        .getRandomElement()
        .char;
    print("instaCardGroup mediaUrlList:$mediaUrlList");

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
                  Text(postUrl.instaUserId ?? ""),
                  SizedBox(width: 5),
                  InkWell(
                    child: Icon(Icons.ios_share,
                        color: MyTheme.subColor, size: 18),
                    onTap: () {
                      InteractionUtil.showAlertDialog(
                        BackButtonBehavior.close,
                        content: const Text("정말 업로드하시겠습니까?"),
                        confirmLabel: "확인",
                        cancelLabel: "취소",
                        cancel: () {},
                        backgroundReturn: () {},
                        confirm: () async {
                          await crawller.uploadPostUrl(c, postUrl);
                          BotToast.showText(text: '해당 항목이 업로드되었습니다.');
                        },
                      );
                    },
                  ),
                  InkWell(
                    child:
                        Icon(Icons.delete, color: MyTheme.subColor, size: 18),
                    onTap: () {
                      InteractionUtil.showAlertDialog(
                        BackButtonBehavior.close,
                        content: const Text("정말 삭제하시겠습니까?"),
                        confirmLabel: "확인",
                        cancelLabel: "취소",
                        cancel: () {},
                        backgroundReturn: () {},
                        confirm: () async {
                          await s.deletePostUrl(c, postUrl);
                          BotToast.showText(text: '해당 항목이 삭제되었습니다.');
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                height: 215,
                child: Swiper(
                  itemCount: mediaUrlList.length,
                  itemBuilder: (BuildContext context, int i) {
                    String mediaUrl = mediaUrlList[i];
                    return Image.network(
                      mediaUrl,
                      fit: BoxFit.fill,
                    );
                  },
                  itemWidth: 300.0,
                  layout: SwiperLayout.STACK,
                ),
              ),
            ],
          ),
        ),
        Divider(endIndent: 94),
      ],
    );
  }

  void moveNavigationPage() {
    PageUtil.go(context, NavigationPage());
  }
}
