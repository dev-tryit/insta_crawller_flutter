import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHComponent.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHService.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';
import 'package:insta_crawller_flutter/_common/util/LogUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/_common/widget/EasyKeyboardListener.dart';
import 'package:insta_crawller_flutter/repository/SettingRepository.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';

// ...(!Setting.isRelease
//     ? [
//         Positioned(
//           bottom: 10,
//           right: 10,
//           child: FloatingActionButton(
//             backgroundColor: MyColors.red,
//             child: const Icon(Icons.bug_report),
//             onPressed: () => LogConsole.openLogConsole(context),
//           ),
//         )
//       ]
//     : []),
class SettingDialog extends StatefulWidget {
  static const String className = "SettingDialog";
  final Function showDebugWidget;
  const SettingDialog(this.showDebugWidget, {Key? key}) : super(key: key);

  @override
  _SettingDialogState createState() => _SettingDialogState();

  static void show(BuildContext context, Function showDebugWidget) {
    showDialog(context: context, builder: (context) => SettingDialog(showDebugWidget));
  }
}

class _SettingDialogState extends KDHState<SettingDialog,
    SettingDialogComponent, SettingDialogService> {
  @override
  bool isPage() => false;

  @override
  makeComponent() => SettingDialogComponent(this);

  @override
  makeService() => SettingDialogService(this, c);

  @override
  List<WidgetToGetSize> makeWidgetListToGetSize() => [];

  @override
  Future<void> onLoad() async {
    await s.onLoad();
  }

  @override
  void mustRebuild() {
    widgetToBuild = () => c.body(s);
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}
}

class SettingDialogComponent extends KDHComponent<_SettingDialogState> {
  static const String debugString = "hiddenDebug";
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final chromeUrlController = TextEditingController();

  SettingDialogComponent(_SettingDialogState state) : super(state);

  Widget body(SettingDialogService s) {
    return EasyKeyboardListener(
      onValue: (value) {
        if (value.contains(debugString)) {
          LogUtil.setDebugLevel();
          state.widget.showDebugWidget(true);
          MyComponents.snackBar(context, "디버그 도구가 활성화되었습니다.");
        }
      },
      inputLimit: debugString.length,
      child: Dialog(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 18, bottom: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title(s),
              const Divider(),
              const SizedBox(height: 20),
              textFieldWithLabel(label: "숨고 ID", controller: idController),
              const SizedBox(height: 30),
              textFieldWithLabel(
                  label: "숨고 PW", controller: pwController, obscureText: true),
              const SizedBox(height: 30),
              textFieldWithLabel(
                  label: "크롬 주소",
                  controller: chromeUrlController,
                  hintText: 'http://localhost:9222'),
              const SizedBox(height: 35),
              actions(s),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldWithLabel(
      {required String label,
      TextEditingController? controller,
      bool obscureText = false,
      String? hintText}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                  color: (hintText ?? "").isNotEmpty ? Colors.grey : null),
              isDense: true,
            ),
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget actions(SettingDialogService s) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          child: const Text("저장"),
          onPressed: s.saveSetting,
          style: ElevatedButton.styleFrom(primary: MyColors.red),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          child: const Text("취소"),
          onPressed: s.cancel,
          style: ElevatedButton.styleFrom(primary: MyColors.red),
        ),
      ],
    );
  }

  Widget title(SettingDialogService s) {
    return Row(
      children: [
        Text(
          "크롤링 설정하기",
          style: MyFonts.gothicA1(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        ElevatedButton(
          child: const Text("로그아웃"),
          onPressed: s.logout,
          style: ElevatedButton.styleFrom(primary: MyColors.lightBlue),
        ),
      ],
    );
  }
}

class SettingDialogService
    extends KDHService<_SettingDialogState, SettingDialogComponent> {
  Setting? setting;

  SettingDialogService(_SettingDialogState state, SettingDialogComponent c)
      : super(state, c);

  Future<void> onLoad() async {
    setting = await SettingRepository().getOne();
    c.idController.text = setting?.sumgoId ?? "";
    c.pwController.text = setting?.sumgoPw ?? "";
    c.chromeUrlController.text = setting?.crallwerUrl ?? "";
  }

  Future<void> saveSetting() async {
    setting = (setting ?? Setting(sumgoId: "",sumgoPw: "",crallwerUrl: ""))
      ..sumgoId = c.idController.text
      ..sumgoPw = c.pwController.text
      ..crallwerUrl = c.chromeUrlController.text;
    await SettingRepository().save(setting: setting!);
    PageUtil.back(context);
  }

  void cancel() {
    PageUtil.back(context);
  }

  void logout() {
    AuthUtil().logout(context: context);
  }
}
