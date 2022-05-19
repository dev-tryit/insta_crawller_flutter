import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_crawller_flutter/_common/interface/Type.dart';
import 'package:insta_crawller_flutter/_common/util/LogUtil.dart';
import 'package:insta_crawller_flutter/repository/PostUrlRepository.dart';
import 'package:provider/provider.dart';

class PostUrlService extends ChangeNotifier {
  List<PostUrl> postUrlList = [];

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

  Future<void> setPostUrlList() async {
    postUrlList = await _getPostUrlList();
    notifyListeners();
  }

  Future<void> deletePostUrl(PostUrl postUrl) async {
    if (postUrl.documentId == null) {
      LogUtil.warn("해당 postUrl의 documentId가 없습니다.");
      return;
    }

    postUrlList.remove(postUrl);

    PostUrlRepository.me
        .delete(documentId: postUrl.documentId!)
        .then((value) => notifyListeners());
  }

  Future<void> savePostUrl(PostUrl postUrl) async {
    PostUrlRepository.me
        .save(postUrl: postUrl)
        .then((value) => notifyListeners());
  }
}
