import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:insta_crawller_flutter/_common/util/MediaQueryUtil.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';

abstract class KDHState<TargetWidget extends StatefulWidget>
    extends State<TargetWidget> {
  Map<dynamic, WidgetToGetSize> widgetMap = {};
  Widget Function()? widgetToBuild;
  late Size screenSize;

  bool _whenBuildCalledFirst = true;
  List<WidgetToGetSize> _widgetListToGetSize = [];

  //호출순서 : super.initState->super.build->super.afterBuild->onLoad->mustRebuild->super.build

  List<WidgetToGetSize> makeWidgetListToGetSize() => [];


  void rebuild({Function? afterBuild}) {
    if (afterBuild != null) {
      //build 때, afterBuild 불리도록 요청.
      WidgetsBinding.instance?.addPostFrameCallback((_) => afterBuild());
    }

    //Flutter는 중간에 state를 제거해놓기도 한다. 추후에 build로 다시 생성하지만..
    //이 때, setState가 불리면, 에러가 발생한다. 따라서, mounted 여부 체크가 필요하다.
    if (!mounted) return;

    setState(() {});
  }

  @override
  void initState() {
    // LogUtil.debug("super.initState");
    super.initState();

    _widgetListToGetSize = makeWidgetListToGetSize();
  }

  /*
  [
    WidgetToGetSize("maxContainer", maxContainerToGetSize)
  ];
  */

  Widget loadingWidget() {
    return Scaffold(body: Center(child: MyComponents.loadingWidget()));
  }

  @override
  void didChangeDependencies() {
    if (_whenBuildCalledFirst) {
      _whenBuildCalledFirst = false;
      Future(() async {
        await _prepareRebuild();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQueryUtil.getScreenSize(context);

    bool existWidgetToBuild = widgetToBuild != null;
    if (existWidgetToBuild) {
      return widgetToBuild!();
    }

    Widget returnWidget = Stack(
      children: [
        ...(_widgetListToGetSize.isNotEmpty
            ? _widgetListToGetSize.map((w) => Opacity(
                  opacity: 0,
                  child: w.make(),
                ))
            : []),
        loadingWidget(),
      ],
    );

    return returnWidget;
  }

  Future<void> _prepareRebuild() async {
    // LogUtil.debug("super.prepareRebuild");
    if (_widgetListToGetSize.isNotEmpty) {
      _getSizeOfWidgetList();
    }

    await onLoad();

    //build할 때, afterBuild 불리도록 작업.
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterBuild());

    mustRebuild();
  }
  Future<void> onLoad();

  //widgetToBuild를 채우고, rebuild();
  void mustRebuild();

  Future<void> afterBuild();

  void _getSizeOfWidgetList() {
    widgetMap.clear();
    for (var e in _widgetListToGetSize) {
      e.calculateSize();
      widgetMap[e.key] = e;
    }
  }

  @override
  void dispose() {
    // LogUtil.debug("super.dispose");
    super.dispose();
  }
}
