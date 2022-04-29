import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyTheme.dart';

class NavigationPage extends StatefulWidget {
  static const String staticClassName = "NavigationPage";
  final className = staticClassName;

  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends KDHState<NavigationPage> {

  List<String> menuStrList = [
    "Collect Posts",
    "Set My Insta Account",
    "Set Target Insta Account",
    "View BookMarked Post",
    "Move Auto Like & Follow Page",
  ];

  @override
  Future<void> mustRebuild() async {
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
                    children: menuStrList
                        .map((menuStr) => Text(
                      menuStr,
                      style: MyFonts.coiny(
                        fontSize: 20,
                        height: 2.4,
                        color: MyTheme.subColor,
                      ),
                    ))
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
                    style: MyFonts.coiny(fontSize: 12, color: MyTheme.subColor),
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
      onTap: context.pop,
    );
  }
}