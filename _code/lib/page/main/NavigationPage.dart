import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class ButtonState {
  String label;
  void Function() onPressed;

  ButtonState(this.label, this.onPressed);
}

class NavigationPage extends StatefulWidget {
  static const String staticClassName = "NavigationPage";
  final String className = staticClassName;

  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends KDHState<NavigationPage> {
  late List<ButtonState> buttonStateList;

  @override
  Future<void> mustRebuild() async {
    List<ButtonState> buttonStateList = [
      ButtonState("Collect Posts", () {

      }),
      ButtonState("Set My Insta Account", () {

      }),
      ButtonState("Set Target Insta Account", () {

      }),
      ButtonState("View BookMarked Post", () {

      }),
      ButtonState("Move Auto Like & Follow Page", () {

      }),
    ];
    toBuild = () => Scaffold(
          body: SizedBox.expand(
            child: Container(
                color: MyTheme.mainColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    closeButton(),
                    Spacer(flex: 2),
                    Container(
                      padding: EdgeInsets.only(left: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: buttonStateList
                            .map(
                              (buttonState) => InkWell(
                                child: Text(
                                  buttonState.label,
                                  style: MyFonts.coiny(
                                    fontSize: 17,
                                    height: 2.4,
                                    color: MyTheme.subColor,
                                  ),
                                ),
                                onTap: buttonState.onPressed,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Spacer(flex: 1),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Setting",
                        style: MyFonts.coiny(
                            fontSize: 12, color: MyTheme.subColor),
                      ),
                    ),
                    Spacer(flex: 2),
                  ],
                )),
          ),
        );
    rebuild();
  }

  Widget closeButton() {
    return InkWell(
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        child: Icon(Icons.close, color: MyTheme.subColor),
      ),
      onTap: () => PageUtil.back(context),
    );
  }
}
