import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ExitUtil {
  static Future<void> exit(BuildContext context, {String? exitedPagePath}) async {
    if (kIsWeb) {
      // window.close();//웹 종료. 크롬은 탭을 종료시키는게 불가능하다.

      //대응코드1
      context.go(exitedPagePath ?? "/ExitedPageForWep");

      //대응코드2
      //Web은 exit가 안되서, 맨 첫화면으로 이동시키는 코드를 만들었따.
      // var uri = Uri.parse(window.location.href);
      // window.location.href = "${uri.scheme}://${uri.host}:${uri.port}";
    } else {
      // exit(0); //비정상 종료이므로 왠만하면 쓰지말자
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
}