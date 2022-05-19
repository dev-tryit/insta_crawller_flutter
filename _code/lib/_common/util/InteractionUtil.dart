import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class InteractionUtil {
  static TransitionBuilder builder() {
    return BotToastInit();
  }

  static void success(BuildContext context, String text,
      {int durationMilliseocnds = 1500}) {
    BotToast.showText(text: text);
  }

  static void error(BuildContext context, String? text,
      {int durationMilliseocnds = 1500}) {
    BotToast.showText(text: text ?? "에러가 발생하였습니다");
  }

  static CancelFunc loading() {
    return BotToast.showLoading();
  }

  static void closeLoading() {
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

  static void showAlertDialog(BackButtonBehavior backButtonBehavior,
      {required Widget content,
      required String confirmLabel,
      required String cancelLabel,
      VoidCallback? cancel,
      VoidCallback? confirm,
      VoidCallback? backgroundReturn}) {
    BotToast.showAnimationWidget(
        clickClose: false,
        allowClick: false,
        onlyOne: true,
        crossPage: true,
        backButtonBehavior: backButtonBehavior,
        wrapToastAnimation: (controller, cancel, child) => Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    cancel();
                    backgroundReturn?.call();
                  },
                  //The DecoratedBox here is very important,he will fill the entire parent component
                  child: AnimatedBuilder(
                    builder: (_, child) => Opacity(
                      opacity: controller.value,
                      child: child,
                    ),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black26),
                      child: SizedBox.expand(),
                    ),
                    animation: controller,
                  ),
                ),
                CustomOffsetAnimation(
                  controller: controller,
                  child: child,
                )
              ],
            ),
        toastBuilder: (cancelFunc) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              title: content,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    cancelFunc();
                    cancel?.call();
                  },
                  child: Text(
                    cancelLabel,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      cancelFunc();
                      confirm?.call();
                    },
                    child: Text(
                      confirmLabel,
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
        animationDuration: const Duration(milliseconds: 200));
  }
}

class CustomOffsetAnimation extends StatefulWidget {
  final AnimationController controller;
  final Widget child;

  const CustomOffsetAnimation(
      {Key? key, required this.controller, required this.child})
      : super(key: key);

  @override
  _CustomOffsetAnimationState createState() => _CustomOffsetAnimationState();
}

class _CustomOffsetAnimationState extends State<CustomOffsetAnimation> {
  late Tween<double> tweenScale;

  late Animation<double> animation;

  @override
  void initState() {
    tweenScale = Tween<double>(begin: 0.3, end: 1.0);
    animation =
        CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: widget.controller,
      builder: (BuildContext context, Widget? child) {
        return ClipRect(
          child: Transform.scale(
            scale: tweenScale.evaluate(animation),
            child: Opacity(
              child: child,
              opacity: animation.value,
            ),
          ),
        );
      },
    );
  }
}
