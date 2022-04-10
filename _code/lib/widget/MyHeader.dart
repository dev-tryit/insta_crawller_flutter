import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/MySetting.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/util/MyImage.dart';
import 'package:insta_crawller_flutter/widget/MyMenu.dart';

class MyHeader extends StatelessWidget {
  final PageController pageC;
  final Function showSettingDialog;

  const MyHeader(this.pageC, this.showSettingDialog, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6 / 4,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          const Image(image: MyImage.backgroundTop, fit: BoxFit.fill),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 19),
              title(context),
              const Spacer(flex: 1),
              MyMenu(pageC: pageC),
              const Spacer(flex: 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget title(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Opacity(opacity: 0, child: Icon(Icons.logout)),
          Text(
            MySetting.appName,
            style: MyFonts.blackHanSans(
              fontSize: 28,
              color: MyColors.white,
            ),
          ),
          InkWell(
            onTap: () => showSettingDialog(),
            child: const Opacity(
              opacity: 1,
              child: Icon(
                Icons.settings,
                color: MyColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
