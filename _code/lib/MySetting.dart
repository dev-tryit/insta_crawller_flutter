import 'dart:ui';

class MySetting {
  static const bool isRelease = false;

  //Lang
  static const Locale defaultLocale = Locale('ko', 'kr');

  // DateTime
  static const int timeZoneOffset = 9;

  // App
  static const String appName = "Insta Manager";

  // 중복 클릭 방지 시간
  static int milliSecondsForPreventingMultipleClicks = 300;

// static String appVersion = "";
//
// static String appBuildNumber = "";
}
