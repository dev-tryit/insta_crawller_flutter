import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class DialogUtil {
  static TransitionBuilder botToastBuilder() {
    return BotToastInit();
  }

  static void toastInfo(BuildContext context, String text,
      {int durationMilliseocnds = 1500}) {
    BotToast.showText(text: text);
  }

  static void toastError(BuildContext context, String? text,
      {int durationMilliseocnds = 1500}) {
    BotToast.showText(text: text ?? "에러가 발생하였습니다");
  }

  static CancelFunc showLoadingDialog() {
    return BotToast.showLoading();
  }

  static void dismissLoadingDialog() {
    BotToast.closeAllLoading();
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
