import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHComponent.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHService.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:insta_crawller_flutter/_common/util/AnimationUtil.dart';
import 'package:insta_crawller_flutter/repository/AnalysisItemRepository.dart';
import 'package:insta_crawller_flutter/util/MyBottomSheetUtil.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyImage.dart';
import 'package:insta_crawller_flutter/widget/MyCard.dart';
import 'package:insta_crawller_flutter/widget/MyChart.dart';
import 'package:insta_crawller_flutter/widget/MyRedButton.dart';

class KeywordAnalysisPage extends StatefulWidget {
  static const String staticClassName= "KeywordAnalysisPage";
  final className = staticClassName;
  const KeywordAnalysisPage({Key? key}) : super(key: key);

  @override
  _KeywordAnalysisPageState createState() => _KeywordAnalysisPageState();
}

class _KeywordAnalysisPageState extends KDHState<KeywordAnalysisPage,
    KeywordAnalysisPageComponent, KeywordAnalysisPageService> {
  @override
  bool isPage() => false;

  @override
  makeComponent() => KeywordAnalysisPageComponent(this);

  @override
  makeService() => KeywordAnalysisPageService(this, c);

  @override
  List<WidgetToGetSize> makeWidgetListToGetSize() => [];

  @override
  Future<void> onLoad() async {
    await s.resetAnalysisItemList();
  }

  @override
  void mustRebuild() {
    widgetToBuild = () => c.body(s);
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}
}

class KeywordAnalysisPageComponent
    extends KDHComponent<_KeywordAnalysisPageState> {
  final scrollController = ScrollController();

  KeywordAnalysisPageComponent(_KeywordAnalysisPageState state) : super(state);

  Widget body(KeywordAnalysisPageService s) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 60),
          MyCard(
            scrollController: scrollController,
            title: "키워드 분류",
            rightButton: MyRedButton("생성하기",
                onPressed: () => showCreateItemBottomSheet(s)),
            contentHeight: 200,
            contents: s.analysisItemList
                .map((e) => KeywrodAnalysisListTile(
                      item: e,
                      s: s,
                    ))
                .toList(),
          ),
          ...(s.analysisItemList.map((e) => MyCard(
                title: e.title ?? "",
                useScroll: false,
                contents: [MyChart(e)],
              ))).toList(),
        ],
      ),
    );
  }

  void showCreateItemBottomSheet(KeywordAnalysisPageService s) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController keywordController = TextEditingController();

    MyBottomSheetUtil().showInputBottomSheet(
      context: context,
      title: '키워드 분류 생성하기',
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 100,
          leading: Text("분류 이름",
              style: MyFonts.gothicA1(color: MyColors.black, fontSize: 12.5)),
          title: TextField(
            controller: titleController,
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 100,
          leading: Text("분류 기준 텍스트",
              style: MyFonts.gothicA1(color: MyColors.black, fontSize: 12.5)),
          title: TextField(
            controller: keywordController,
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        const SizedBox(height: 10),
      ],
      buttonStr: "생성",
      onAdd: (setErrorMessage) => s.addAnalysisItem(
        titleController.text.trim(),
        keywordController.text.trim(),
        setErrorMessage,
        scrollController,
      ),
    );
  }
}

class KeywordAnalysisPageService extends KDHService<_KeywordAnalysisPageState,
    KeywordAnalysisPageComponent> {
  List<AnalysisItem> analysisItemList = [];

  KeywordAnalysisPageService(
      _KeywordAnalysisPageState state, KeywordAnalysisPageComponent c)
      : super(state, c);

  Future<void> resetAnalysisItemList() async {
    analysisItemList = await AnalysisItemRepository().getList();
  }

  void addAnalysisItem(
      String title,
      String keyword,
      void Function(String errorMessage) setErrorMessage,
      ScrollController scrollController) async {
    String? errorMessage = AnalysisItem.getErrorMessageForAdd(title, keyword);
    if (errorMessage != null) {
      setErrorMessage(errorMessage);
      return;
    }
    setErrorMessage('');

    List<String> keywordList =
        keyword.split(",").map((str) => str.trim()).toList();
    var item = AnalysisItem(
        title: title.replaceAll("분류", ""), keywordList: keywordList);

    analysisItemList.add(item);
    AnalysisItemRepository().add(analysisItem: item);

    Navigator.pop(context);
    rebuild(afterBuild: () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });

    MyComponents.snackBar(context, "생성되었습니다");
  }

  Future<void> deleteAnalysisItem(BuildContext context, AnalysisItem item,
      KeywrodAnalysisListTile myListTile) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: "알림",
      message: "정말 삭제하시겠습니까?",
      okLabel: "예",
      cancelLabel: "아니오",
    );
    if (result == OkCancelResult.ok) {
      if (myListTile.animateController != null) {
        myListTile.animateController!.duration =
            const Duration(milliseconds: 100);
        await myListTile.animateController!.reverse(); //forward or reverse
      }

      analysisItemList.remove(item);
      AnalysisItemRepository().delete(documentId: item.documentId ?? -1);

      rebuild();

      MyComponents.snackBar(context, "삭제되었습니다");
    }
  }
}

class KeywrodAnalysisListTile extends StatelessWidget {
  AnalysisItem item;
  KeywordAnalysisPageService s;
  AnimationController? animateController;
  KeywrodAnalysisListTile({Key? key, required this.item, required this.s})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = item.title ?? "";
    String subtitle = (item.keywordList ?? []).join(",  ".trim());

    return AnimationUtil.slideInLeft(
      manualTrigger: true,
      duration: const Duration(milliseconds: 0),
      delay: const Duration(milliseconds: 0),
      from: 15,
      controller: (aController) => animateController = aController,
      child: Slidable(
        key: GlobalKey(), //1.반드시 키가 있어야함
        child: ListTile(
          //2. 슬라이드할 대상 설정
          leading: const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Image(image: MyImage.boxIcon),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          horizontalTitleGap: 6,
          title: Text("$title 분류", style: MyFonts.gothicA1()),
          subtitle: Text(subtitle,
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
              style: MyFonts.gothicA1(fontSize: 9)),
          dense: true,
        ),
        endActionPane: ActionPane(
          //3. startActionPane: 오른쪽으로 드래그하면 나오는액션, endActionPane: 왼쪽
          extentRatio: 0.2, //각각 child의 크기
          motion:
              const BehindMotion(), //동작 애니메이션 설정 BehindMotion, DrawerMotion, ScrollMotion, StretchMotion
          children: [
            CustomSlidableAction(
              onPressed: (c) => s.deleteAnalysisItem(context, item, this),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
