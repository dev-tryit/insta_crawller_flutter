import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_crawller_flutter/_common/util/ExitUtil.dart';

class PageUtil {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> movePage(BuildContext context, Widget nextPage) async {
    await Navigator.of(context).push(_route(nextPage));
  }

  static Future<void> replacementPage(
      BuildContext context, Widget nextPage) async {
    await Navigator.of(context).pushReplacement(_route(nextPage));
  }

  static Future<void> removeUntilAndMovePage(
      BuildContext context, Widget nextPage,
      {Widget? untilPage}) async {
    await Navigator.of(context).pushAndRemoveUntil(
        _route(nextPage),
        untilPage != null
            ? ModalRoute.withName(makePagePath(untilPage))
            : (Route<dynamic> route) => false);
  }

  static Future<void> back(BuildContext context) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      await ExitUtil.exit(context);
    }
  }

  static Future<void> backUntil(BuildContext context, Widget untilPage) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context)
          .popUntil(ModalRoute.withName(makePagePath(untilPage)));
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

  static String makePagePath(dynamic page) {
    return "/" + page.className;
  }
}
