import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';

class MyMenu extends StatefulWidget {
  final PageController pageC;
  const MyMenu({Key? key, required this.pageC}) : super(key: key);

  @override
  _MyMenuState createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  int selectedPageNum = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: MyColors.lightBlue),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          menuItem(
            "키워드 분석",
            fixPageNum: 0,
          ),
          const SizedBox(width: 35),
          menuItem(
            "요청 정리",
            fixPageNum: 1,
          ),
        ],
      ),
    );
  }

  Widget menuItem(String text, {required int fixPageNum}) {
    return InkWell(
      onTap: () {
        selectedPageNum = fixPageNum;
        widget.pageC.jumpToPage(selectedPageNum);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 13,
          right: 13,
          top: 10,
          bottom: 11,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: fixPageNum == selectedPageNum
              ? MyColors.deepBlue
              : Colors.transparent,
        ),
        child: Text(
          text,
          style: MyFonts.gothicA1(
            color: MyColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
