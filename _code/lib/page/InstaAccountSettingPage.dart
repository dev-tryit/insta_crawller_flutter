import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHComponent.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/util/MediaQueryUtil.dart';
import 'package:insta_crawller_flutter/service/CrawllerService.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class InstaAccountSettingPage extends StatefulWidget {
  static const String staticClassName = "InstaAccountSettingPage";
  final String className = staticClassName;

  const InstaAccountSettingPage({Key? key}) : super(key: key);

  @override
  State<InstaAccountSettingPage> createState() =>
      _InstaAccountSettingPageState();
}

class InstaAccountSettingPageComponent
    extends KDHComponent<_InstaAccountSettingPageState> {
  InstaAccountSettingPageComponent(_InstaAccountSettingPageState state)
      : super(state);

  final TextStyle textStyle = const TextStyle(color: MyTheme.mainColor);
  final InputDecoration inputBoxDecoration = const InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.mainColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.mainColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.mainColor),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.mainColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.mainColor),
    ),
    errorStyle: TextStyle(color: MyTheme.mainColor),
  );

  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
}

class _InstaAccountSettingPageState extends KDHState<InstaAccountSettingPage> {
  late final CrawllerService s;
  late final InstaAccountSettingPageComponent c;

  @override
  Future<void> mustRebuild() async {
    c = InstaAccountSettingPageComponent(this);
    s = CrawllerService.read(context);

    toBuild = () {
      return CrawllerService.consumer(
        builder: (context, value, child) {
          var height = MediaQueryUtil.getKeyboardHeight(context);

          return MyComponents.scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Set My Insta Account", style: MyFonts.coiny()),
              backgroundColor: MyTheme.subColor,
              foregroundColor: MyTheme.mainColor,
              shadowColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  MyComponents.inputBox(
                    label: "Insta ID",
                    controller: c.idController,
                    textStyle: c.textStyle,
                    decoration: c.inputBoxDecoration,
                  ),
                  const SizedBox(height: 25),
                  MyComponents.inputBox(
                    label: "Insta PW",
                    controller: c.pwController,
                    textStyle: c.textStyle,
                    obscureText: true,
                    decoration: c.inputBoxDecoration,
                  ),
                  SizedBox(height: height),
                ],
              ),
            ),
            bottomSheet: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: height),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text("저장"),
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      primary: MyTheme.mainColor,
                      onPrimary: MyTheme.subColor,
                    ),
                    onPressed: () => s.saveInstaUser(c),
                  ),
                ),
              ),
            ),
          );
        },
      );
    };
    rebuild(afterBuild: () async {
      s.setInstaUser(c);
    });
  }
}
