import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_crawller_flutter/MySetting.dart';
import 'package:insta_crawller_flutter/_common/util/ExitUtil.dart';
import 'package:page_transition/page_transition.dart';

class PageUtil {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> go(BuildContext context, Widget nextPage,
      {PageTransitionType? pageTransitionType,
      Duration? duration,
      Duration? reverseDuration}) async {
    await Navigator.of(context).push(_route(
      nextPage,
      pageTransitionType: pageTransitionType,
      duration: duration,
      reverseDuration: reverseDuration,
    ));
  }

  static Future<void> goReplacement(BuildContext context, Widget nextPage,
      {PageTransitionType? pageTransitionType,
      Duration? duration,
      Duration? reverseDuration}) async {
    await Navigator.of(context).pushReplacement(_route(
      nextPage,
      pageTransitionType: pageTransitionType,
      duration: duration,
      reverseDuration: reverseDuration,
    ));
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
      Navigator.of(context)
          .popUntil(ModalRoute.withName(makePagePath(untilPage)));
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

  static PageRoute _route(Widget nextPage,
      {PageTransitionType? pageTransitionType=MySetting.defaultPageTransitionType,
      Duration? duration,
      Duration? reverseDuration}) {
    // return MaterialPageRoute(
    //   builder: (context) => nextPage,
    //   settings: RouteSettings(
    //     name: makePagePath(nextPage),
    //   ),
    // );
    if (pageTransitionType != null) {
      return PageTransition(
        type: pageTransitionType,
        child: nextPage,
        duration: duration ?? const Duration(milliseconds: 300),
        reverseDuration: reverseDuration ?? const Duration(milliseconds: 300),
        settings: RouteSettings(
          name: makePagePath(nextPage),
        ),
      );
    } else {
      return PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) => nextPage,
        settings: RouteSettings(
          name: makePagePath(nextPage),
        ),
      );
    }
  }

  static String makePagePath(Widget page) {
    return "/" + (page as dynamic).className;
  }
}
