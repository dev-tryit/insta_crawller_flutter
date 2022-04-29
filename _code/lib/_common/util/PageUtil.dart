import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_crawller_flutter/_common/util/ExitUtil.dart';

class PageUtil {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> go(BuildContext context, Widget nextPage) async {
    await Navigator.of(context).push(_route(nextPage));
  }

  static Future<void> goReplacement(
      BuildContext context, Widget nextPage) async {
    await Navigator.of(context).pushReplacement(_route(nextPage));
  }

  static Future<void> back(BuildContext context) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      await ExitUtil.exit(context);
    }
  }

  static Future<void> backUntil(BuildContext context,
      {required Widget untilPage}) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil(ModalRoute.withName(makePagePath(untilPage)));
    } else {
      await ExitUtil.exit(context);
    }
  }

  static Future<void> backAll(BuildContext context) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
    } else {
      await ExitUtil.exit(context);
    }
  }

  static MaterialPageRoute _route(Widget nextPage) {
    return MaterialPageRoute(
      builder: (context) => nextPage,
      settings: RouteSettings(
        name: makePagePath(nextPage),
      ),
    );
  }

  static String makePagePath(Widget page) {
    return "/" + page.className();
  }
}

extension WidgetWithClassName on Widget {
  String className(){
    throw UnimplementedError("위젯은 라우팅하기 위해서 className()을 재정의해야합니다. 해당 위젯은 : ${this.toString()}");
  }
}
