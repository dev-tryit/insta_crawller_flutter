import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';

class MyCard extends StatelessWidget {
  ScrollController scrollController;
  String title;
  List<Widget> contents;
  Widget? rightButton;
  Widget? bottomButton;
  bool useScroll;
  double? contentHeight;

  MyCard({
    Key? key,
    required this.title,
    required this.contents,
    this.rightButton,
    this.bottomButton,
    this.useScroll = true,
    this.contentHeight,
    ScrollController? scrollController,
  })  : this.scrollController = scrollController ?? ScrollController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List bottomButtonList = [];
    if (bottomButton != null) bottomButtonList.add(bottomButton);

    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...contents,
        ...bottomButtonList,
      ],
    );

    if (useScroll) {
      child = SingleChildScrollView(
        controller: scrollController,
        child: child,
      );
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          width: 0.5,
          color: MyColors.black,
        ),
      ),
      shadowColor: MyColors.black,
      elevation: 7,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 14, right: 14, top: 24, bottom: 30),
        child: FractionallySizedBox(
          widthFactor: 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cardTitle(title),
              const SizedBox(height: 10),
              contentHeight != null
                  ? SizedBox(
                      height: contentHeight,
                      child: child,
                    )
                  : child,
            ],
          ),
        ),
      ),
    );
  }

  Widget cardTitle(String title) {
    List buttonList = [];
    if (rightButton != null) {
      buttonList.add(rightButton);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: MyFonts.gothicA1(
            color: MyColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        ...buttonList,
      ],
    );
  }
}
