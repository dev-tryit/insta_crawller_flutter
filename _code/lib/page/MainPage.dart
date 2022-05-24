import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:emojis/emoji.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/extension/RandomExtension.dart';
import 'package:insta_crawller_flutter/_common/util/FileUtil.dart';
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

class _MainPageState extends KDHState<MainPage> {
  late final PostUrlService s;

  @override
  Future<void> mustFinishLoad() async {
    s = PostUrlService.read(context);

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
    await s.resetPostUrlList();
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
      builder: (context, value, child) => value.postUrlList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 34),
              child: ListView(
                children: value.postUrlList
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
                      final dialog = FileUploadDialog(this);
                      dialog.open(postUrl);
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
                          await s.deletePostUrl(postUrl);
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
                  itemWidth: 300.0,
                  itemCount: mediaUrlList.length,
                  itemBuilder: (BuildContext context, int i) {
                    var mediaUrl = mediaUrlList[i];

                    return InkWell(
                      onTap: () {
                        InteractionUtil.zoomImage(
                            context,
                            mediaUrlList
                                .map((e) => GalleryItem(path: e))
                                .toList(),
                            i,
                            false);
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.network(
                            mediaUrl,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return Text("이미지 로드 실패");
                            },
                          ),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                InteractionUtil.showAlertDialog(
                                  BackButtonBehavior.close,
                                  content: const Text("정말 삭제하시겠습니까?"),
                                  confirmLabel: "확인",
                                  cancelLabel: "취소",
                                  cancel: () {},
                                  backgroundReturn: () {},
                                  confirm: () async {
                                    s.deleteMediaUrlOf(postUrl, mediaUrl);
                                  },
                                );
                              }),
                        ],
                      ),
                    );
                  },
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

class FileUploadDialog extends StatefulWidget {
  File? selectedThumbnailFile;
  final _MainPageState _mainPageState;
  FileUploadDialog(this._mainPageState, {Key? key}) : super(key: key);

  @override
  State<FileUploadDialog> createState() => _FileUploadDialogState();

  void open(PostUrl postUrl) {
    final context = _mainPageState.context;

    CrawllerService crawller = CrawllerService.read(context);
    //TODO: 제목 작성 기능.
    //TODO: 1. 배경색 선택,
    //TODO: 2. 글자색 선택,
    //TODO: 3. 글꼴 선택
    //TODO: 이미지 첨부

    InteractionUtil.showAlertDialog(
      BackButtonBehavior.close,
      content: this,
      confirmLabel: "확인",
      cancelLabel: "취소",
      cancel: () {},
      backgroundReturn: () {},
      confirm: () async {
        try {
          await crawller.uploadPostUrl(context, postUrl, selectedThumbnailFile);
          await _mainPageState.s.deletePostUrl(postUrl);
          BotToast.showText(text: '해당 항목이 업로드되었습니다.');
        }
        catch(e){
          BotToast.showText(text: '에러가 발생하였습니다. : ${e.toString()}');
        }
      },
    );
  }
}

class _FileUploadDialogState extends State<FileUploadDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("업로드하기"),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: Text(FileUtil.getFileName(widget.selectedThumbnailFile?.path ?? "첨부된 파일이 없습니다"), style: TextStyle(fontSize: 11))),
            const SizedBox(width: 10),
            ElevatedButton(
              child: const Text("이미지 첨부"),
              onPressed: () async {
                widget.selectedThumbnailFile = await selectThumbnail();
                setState(() {});
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<File?> selectThumbnail() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result?.files.single.path != null) {
      return File(result!.files.single.path ?? "");
    }
    return null;
  }
}

/*

 */
