import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DialogUtil {
  static TransitionBuilder easyLoadingBuilder() {
    return EasyLoading.init();
  }

  static void toastInfo(BuildContext context, String text,
      {int durationMilliseocnds = 1500}) {
    EasyLoading.instance
      ..displayDuration = Duration(milliseconds: durationMilliseocnds)
      ..loadingStyle = EasyLoadingStyle.custom
      ..progressColor = Colors.white
      ..indicatorColor = Colors.white
      ..backgroundColor = Colors.blue
      ..textColor = Colors.white
      ..toastPosition = EasyLoadingToastPosition.center
      ..fontSize = 16
      ..radius = 25
      ..boxShadow = [
        const BoxShadow(color: Colors.transparent, spreadRadius: 1)
      ] //테두리 색
      ..dismissOnTap = false
      ..userInteractions = true;

    EasyLoading.showToast(text);
  }

  static void toastError(BuildContext context, String? text,
      {int durationMilliseocnds = 1500}) {
    EasyLoading.instance
      ..displayDuration = Duration(milliseconds: durationMilliseocnds)
      ..loadingStyle = EasyLoadingStyle.custom
      ..progressColor = Colors.white
      ..indicatorColor = Colors.white
      ..backgroundColor = Colors.red
      ..textColor = Colors.white
      ..toastPosition = EasyLoadingToastPosition.center
      ..fontSize = 16
      ..radius = 25
      ..boxShadow = [
        const BoxShadow(color: Colors.transparent, spreadRadius: 1)
      ] //테두리 색
      ..dismissOnTap = false
      ..userInteractions = true;

    EasyLoading.showToast(text ?? "에러가 발생하였습니다");
  }

  static Future<void> showLoadingDialog(BuildContext context) async {
    EasyLoading.instance
      // ..displayDuration = const Duration(milliseconds: 2000)
      ..radius = 8
      ..loadingStyle = EasyLoadingStyle.dark
      ..dismissOnTap = false
      ..userInteractions = false;

    await EasyLoading.show(
      status: "조금만 기다려주세요",
      maskType: EasyLoadingMaskType.black,
    );
  }

  static Future<void> dismissLoadingDialog() async {
    return await EasyLoading.dismiss();
  }

  static void snackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  static void modalDialog(BuildContext context, {required Widget page}) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return page;
      },
    );
  }

  static void transparentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            margin:
                const EdgeInsets.only(top: 32, bottom: 32, left: 24, right: 24),
            width: double.infinity,
            height: double.infinity,
            child: Text("content"),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text("test"),
            ),
          ],
        );
      },
    );
  }
}
