import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_crawller_flutter/_common/interface/Type.dart';
import 'package:insta_crawller_flutter/_common/util/LogUtil.dart';
import 'package:insta_crawller_flutter/page/MainPage.dart';
import 'package:insta_crawller_flutter/repository/PostUrlRepository.dart';
import 'package:provider/provider.dart';

class PostUrlService extends ChangeNotifier {
  BuildContext context;
  PostUrlService(this.context);

  static ChangeNotifierProvider get provider =>
      ChangeNotifierProvider<PostUrlService>(
          create: (context) => PostUrlService(context));
  static Widget consumer(
          {required ConsumerBuilderType<PostUrlService> builder}) =>
      Consumer<PostUrlService>(builder: builder);
  static PostUrlService read(BuildContext context) =>
      context.read<PostUrlService>();

  Future<List<PostUrl>> _getPostUrlList() async {
    return await PostUrlRepository.me.getList();
  }

  Future<List> getMediaUrlList() async {
    List mediaUrlList = [];
    List<PostUrl> postUrlList = await _getPostUrlList();
    for (var element in postUrlList) {
      mediaUrlList.addAll(element.mediaUrlList ?? []);
    }

    return mediaUrlList;
  }

  Future<void> setPostUrlList(MainPageComponent c) async {
    c.postUrlList = await _getPostUrlList();
    notifyListeners();
  }

  Future<void> deletePostUrl(MainPageComponent c, PostUrl postUrl) async {
    if (postUrl.documentId == null) {
      LogUtil.warn("해당 postUrl의 documentId가 없습니다.");
      return;
    }

    await PostUrlRepository.me.delete(documentId: postUrl.documentId!);
    notifyListeners();
  }
}
