import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/MySetting.dart';
import 'package:insta_crawller_flutter/_common/config/MyCustomScrollBehavior.dart';
import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';
import 'package:insta_crawller_flutter/_common/util/DesktopUtil.dart';
import 'package:insta_crawller_flutter/_common/util/ErrorUtil.dart';
import 'package:insta_crawller_flutter/_common/util/InteractionUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PlatformUtil.dart';
import 'package:insta_crawller_flutter/page/SplashPage.dart';
import 'package:insta_crawller_flutter/service/CrawllerService.dart';
import 'package:insta_crawller_flutter/service/PostUrlService.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyStoreUtil.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

const width = 600.0;
const height = 900.0;

Future<void> main() async {
  ErrorUtil.catchError(() async {
    if (!PlatformUtil.isComputer()) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    await MyFonts.init();
    await MyStoreUtil.init();
    await AuthUtil.me.init();

    if (PlatformUtil.isComputer()) {
      DesktopUtil.setDesktopSetting(
          size: const Size(width, height),
          minimumSize: const Size(width, height),
          maximumSize: const Size(width, height),
          title: MySetting.appName);
    }
    runApp(MultiProvider(
      providers: [
        PostUrlService.provider,
        CrawllerService.provider,
      ],
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MySetting.appName,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        brightness: Brightness.light,
        canvasColor: Colors.white,
        // primaryColor: Colors.lightBlue[800],
        // Define the default font family.
        // fontFamily: 'Georgia',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        // textTheme: const TextTheme(d
        //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        // ),
      ),
      builder: (context, child) {
        // // 1. FittedBox??? ????????? ????????? ?????? ????????? ????????? ??????.
        // // 2. FittedBox + SizedBox??? ????????????,
        // // Sizedbox??? ?????? ????????? ????????????,
        // // FittedBox??? ?????? ????????? ????????? ???????????? ??????, ??????(??????,??????)??? ????????????.
        // child = FittedBox(
        //   alignment: Alignment.center,
        //   child: Container(
        //     width: width,
        //     height: height,
        //     decoration: BoxDecoration(
        //       border: Border.all(color: Colors.black, width: 1),
        //     ),
        //     child: child!,
        //   ),
        // );
        child = InteractionUtil.builder()(context, child);
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      home: SplashPage(),
    );
  }
}
