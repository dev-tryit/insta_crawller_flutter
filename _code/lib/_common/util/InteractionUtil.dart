import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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

  static void zoomImage(BuildContext context, List<GalleryItem> galleryItems,
      int index, bool verticalGallery) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: verticalGallery ? Axis.vertical : Axis.horizontal,
        ),
      ),
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

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    Key? key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;
  final PhotoViewController controller = PhotoViewController();

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            print("onPointerSignal : $pointerSignal");
            controller.scale = (controller.scale ?? 0) -
                pointerSignal.scrollDelta.dy*0.0035;
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.galleryItems.length,
                loadingBuilder: widget.loadingBuilder,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                scrollDirection: widget.scrollDirection,
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Image ${currentIndex + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    decoration: null,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 5,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    PageUtil.back(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    GalleryItem item = widget.galleryItems[index];
    String id = item.id;
    String path = item.path;

    ImageProvider imageProvider;
    if (item.isUrl) {
      imageProvider = NetworkImage(path);
    } else {
      imageProvider = AssetImage(path);
    }

    return PhotoViewGalleryPageOptions(
      imageProvider: imageProvider,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: id),
      controller: controller,
    );
  }
}

class GalleryItem {
  GalleryItem({
    required this.path,
  })  : id = path,
        isUrl = path.contains("http");

  final String id;
  final String path;
  final bool isUrl;
}
