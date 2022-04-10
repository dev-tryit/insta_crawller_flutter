// import 'dart:async';
//
// import 'package:adaptive_dialog/adaptive_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:insta_crawller_flutter/MySetting.dart';
// import 'package:insta_crawller_flutter/_common/abstract/KDHComponent.dart';
// import 'package:insta_crawller_flutter/_common/abstract/KDHService.dart';
// import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
// import 'package:insta_crawller_flutter/_common/model/WidgetToGetSize.dart';
// import 'package:insta_crawller_flutter/_common/util/AnimationUtil.dart';
// import 'package:insta_crawller_flutter/_common/util/PlatformUtil.dart';
// import 'package:insta_crawller_flutter/_common/util/UrlUtil.dart';
// import 'package:insta_crawller_flutter/repository/RemovalConditionRepository.dart';
// import 'package:insta_crawller_flutter/repository/SettingRepository.dart';
// import 'package:insta_crawller_flutter/util/MyBottomSheetUtil.dart';
// import 'package:insta_crawller_flutter/util/MyColors.dart';
// import 'package:insta_crawller_flutter/util/MyComponents.dart';
// import 'package:insta_crawller_flutter/util/MyCrawller.dart';
// import 'package:insta_crawller_flutter/util/MyFonts.dart';
// import 'package:insta_crawller_flutter/util/MyImage.dart';
// import 'package:insta_crawller_flutter/widget/MyCard.dart';
// import 'package:insta_crawller_flutter/widget/MyRedButton.dart';
// import 'package:insta_crawller_flutter/widget/MyWhiteButton.dart';
// import 'package:insta_crawller_flutter/widget/SelectRemovalType.dart';
//
// class RequestRemovalPage extends StatefulWidget {
//   static const String staticClassName = "RequestRemovalPage";
//   final className = staticClassName;
//   Function showSettingDialog;
//   RequestRemovalPage(this.showSettingDialog, {Key? key}) : super(key: key);
//
//   @override
//   _RequestRemovalPageState createState() => _RequestRemovalPageState();
// }
//
// class _RequestRemovalPageState extends KDHState<RequestRemovalPage,
//     RequestRemovalPageComponent, RequestRemovalPageService> {
//   @override
//   bool isPage() => false;
//
//   @override
//   makeComponent() => RequestRemovalPageComponent(this);
//
//   @override
//   makeService() => RequestRemovalPageService(this, c);
//
//   @override
//   List<WidgetToGetSize> makeWidgetListToGetSize() => [];
//
//   @override
//   Future<void> onLoad() async {
//     await s.resetRemovalConditionList();
//   }
//
//   @override
//   void mustRebuild() {
//     widgetToBuild = () => c.body(s);
//     rebuild();
//   }
//
//   @override
//   Future<void> afterBuild() async {}
// }
//
// class RequestRemovalPageComponent
//     extends KDHComponent<_RequestRemovalPageState> {
//   RequestRemovalPageComponent(_RequestRemovalPageState state) : super(state);
//
//   Widget body(RequestRemovalPageService s) {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Column(
//         children: [
//           const SizedBox(height: 60),
//           MyCard(
//             title: "정리 조건",
//             rightButton: MyRedButton("생성하기",
//                 onPressed: () => showCreateItemBottomSheet(s)),
//             contents: s.removalConditionList
//                 .map((e) => RequestRemovalListTile(
//                       item: e,
//                       s: s,
//                       isPlusIcon: e.type != "exclude",
//                     ))
//                 .toList(),
//             bottomButton: MyWhiteButton("요청 정리하기", onPressed: s.removeRequests),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showCreateItemBottomSheet(RequestRemovalPageService s) {
//     final contentController = TextEditingController();
//     final typeController = SelectRemovalTypeController();
//
//     MyBottomSheetUtil().showInputBottomSheet(
//       context: context,
//       title: '정리 조건 생성하기',
//       children: [
//         SelectRemovalType(typeController: typeController),
//         const SizedBox(height: 10),
//         ListTile(
//           contentPadding: EdgeInsets.zero,
//           dense: true,
//           minLeadingWidth: 100,
//           leading: Text("내용",
//               style: MyFonts.gothicA1(color: MyColors.black, fontSize: 12.5)),
//           title: TextField(
//             controller: contentController,
//             decoration: const InputDecoration(isDense: true),
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//       buttonStr: "생성",
//       onAdd: (setErrorMessage) => s.addRemovalCondition(
//         contentController.text.trim(),
//         typeController.type,
//         typeController.typeDisplay,
//         setErrorMessage,
//       ),
//     );
//   }
// }
//
// class RequestRemovalPageService
//     extends KDHService<_RequestRemovalPageState, RequestRemovalPageComponent> {
//   List<RemovalCondition> removalConditionList = [];
//
//   RequestRemovalPageService(
//       _RequestRemovalPageState state, RequestRemovalPageComponent c)
//       : super(state, c);
//
//   Future<void> resetRemovalConditionList() async {
//     removalConditionList = await RemovalConditionRepository().getList();
//   }
//
//   Future<void> removeRequests() async {
//     if (PlatformUtil.isWeb()) {
//       await showOkAlertDialog(
//         context: context,
//         title: "알림",
//         message: "웹에서는 요청 정리를 할 수 없습니다. Windows 프로그램을 이용해주세요",
//         okLabel: "다운로드",
//       );
//       await UrlUtil().openUrl(
//           'https://github.com/dev-tryit/insta_crawller_flutter/raw/master/deploy/SumgoManager.zip');
//       return;
//     }
//
//     Setting? setting = await SettingRepository().getOne();
//     if (setting == null ||
//         (setting.sumgoId ?? "").isEmpty ||
//         (setting.sumgoPw ?? "").isEmpty) {
//       await showOkAlertDialog(
//         context: context,
//         title: "알림",
//         message: "${MySetting.appName} 설정이 필요합니다.",
//       );
//       state.widget.showSettingDialog();
//       return;
//     }
//
//     await MyComponents.showLoadingDialog(context);
//     final List<String> listToIncludeAlways = (await RemovalConditionRepository()
//             .getListByType(type: RemovalType.best.value))
//         .map((e) => e.content ?? "")
//         .toList();
//     final List<String> listToInclude = (await RemovalConditionRepository()
//             .getListByType(type: RemovalType.include.value))
//         .map((e) => e.content ?? "")
//         .toList();
//     final List<String> listToExclude = (await RemovalConditionRepository()
//             .getListByType(type: RemovalType.exclude.value))
//         .map((e) => e.content ?? "")
//         .toList();
//     await MyComponents.dismissLoadingDialog();
//
//     try {
//       await MyComponents.showLoadingDialog(context);
//       await MyCrawller(
//         listToIncludeAlways: listToIncludeAlways,
//         listToInclude: listToInclude,
//         listToExclude: listToExclude,
//       ).start(setting);
//     } finally {
//       await MyComponents.dismissLoadingDialog();
//     }
//   }
//
//   Future<void> addRemovalCondition(
//       String content,
//       String type,
//       String typeDisplay,
//       void Function(String errorMessage) setErrorMessage) async {
//     String? errorMessage =
//         RemovalCondition.getErrorMessageForAdd(content, type, typeDisplay);
//     if (errorMessage != null) {
//       setErrorMessage(errorMessage);
//       return;
//     }
//     setErrorMessage('');
//
//     var item = RemovalCondition(
//         content: content, type: type, typeDisplay: typeDisplay);
//
//     removalConditionList.add(item);
//     RemovalConditionRepository().add(removalCondition: item);
//
//     Navigator.pop(context);
//     rebuild();
//
//     MyComponents.snackBar(context, "생성되었습니다");
//   }
//
//   Future<void> deleteRemovalCondition(BuildContext context,
//       RemovalCondition item, RequestRemovalListTile myListTile) async {
//     final result = await showOkCancelAlertDialog(
//       context: context,
//       title: "알림",
//       message: "정말 삭제하시겠습니까?",
//       okLabel: "예",
//       cancelLabel: "아니오",
//     );
//     if (result == OkCancelResult.ok) {
//       if (myListTile.animateController != null) {
//         myListTile.animateController!.duration =
//             const Duration(milliseconds: 100);
//         await myListTile.animateController!.reverse(); //forward or reverse
//       }
//
//       removalConditionList.remove(item);
//       RemovalConditionRepository().delete(documentId: item.documentId ?? -1);
//
//       rebuild();
//
//       MyComponents.snackBar(context, "삭제되었습니다");
//     }
//   }
// }
//
// class RequestRemovalListTile extends StatelessWidget {
//   RemovalCondition item;
//   RequestRemovalPageService s;
//   AnimationController? animateController;
//   bool isPlusIcon;
//
//   RequestRemovalListTile(
//       {Key? key, required this.item, required this.s, this.isPlusIcon = true})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimationUtil.slideInLeft(
//       manualTrigger: true,
//       duration: const Duration(milliseconds: 0),
//       delay: const Duration(milliseconds: 0),
//       from: 15,
//       controller: (aController) => animateController = aController,
//       child: Slidable(
//         key: GlobalKey(), //1.반드시 키가 있어야함
//         child: ListTile(
//           leading: Padding(
//             padding: EdgeInsets.only(top: 6),
//             child: Image(
//                 image: (isPlusIcon ? MyImage.plusIcon : MyImage.minusIcon)),
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 5),
//           horizontalTitleGap: 6,
//           title: Text("[${item.typeDisplay ?? ""}] ${item.content ?? ""}",
//               style: MyFonts.gothicA1()),
//           dense: true,
//         ),
//         endActionPane: ActionPane(
//           //3. startActionPane: 오른쪽으로 드래그하면 나오는액션, endActionPane: 왼쪽
//           extentRatio: 0.2,
//           //각각 child의 크기
//           motion: const BehindMotion(),
//           //동작 애니메이션 설정 BehindMotion, DrawerMotion, ScrollMotion, StretchMotion
//           children: [
//             CustomSlidableAction(
//               onPressed: (c) => s.deleteRemovalCondition(context, item, this),
//               backgroundColor: const Color(0xFFFE4A49),
//               foregroundColor: Colors.white,
//               child: const Icon(Icons.delete),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
