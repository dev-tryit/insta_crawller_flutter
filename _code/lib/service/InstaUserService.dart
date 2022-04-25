import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_crawller_flutter/_common/interface/Type.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/page/PostListViewPage.dart';
import 'package:insta_crawller_flutter/service/PostUrlService.dart';
import 'package:insta_crawller_flutter/repository/InstaUserRepository.dart';
import 'package:insta_crawller_flutter/repository/PostUrlRepository.dart';
import 'package:insta_crawller_flutter/util/MyComponents.dart';
import 'package:insta_crawller_flutter/util/MyCrawller.dart';
import 'package:provider/provider.dart';

class InstaUserService extends ChangeNotifier {
  InstaUser? instaUser;
  final MyCrawller crawller;

  BuildContext context;
  InstaUserService(this.context) : crawller = MyCrawller();

  static ChangeNotifierProvider get provider =>
      ChangeNotifierProvider<InstaUserService>(
          create: (context) => InstaUserService(context));
  static Widget consumer(
          {required ConsumerBuilderType<InstaUserService> builder}) =>
      Consumer<InstaUserService>(builder: builder);

  Future<void> loadInstaUser() async {
    instaUser = await InstaUserRepository().getOne();
  }

  Future<void> saveInstaUser(String id, String pw) async {
    instaUser = InstaUser(id: id, pw: pw);
    try {
      await InstaUserRepository().save(instaUser: instaUser!);
      MyComponents.snackBar(context, "저장 성공하였습니다.");
    } catch (e) {
      MyComponents.snackBar(context, "저장 실패하였습니다.");
    }
  }

  void saveHumorPost() async {
    String instaUserId = "inssa_unni_";
    List<String> postUrlList = await crawller.getPostUrlList(instaUserId);

    for (String postUrl in postUrlList) {
      if (await PostUrlRepository().getOneByUrl(postUrl) != null) continue;

      List<String> mediaStrList =
          await crawller.getMediaStrListOf(postUrl: postUrl);
      var postUrlObj = PostUrl(
          instaUserId: instaUserId, url: postUrl, mediaUrlList: mediaStrList);
      await PostUrlRepository().save(postUrl: postUrlObj);
    }
  }

  void goPostListViewPage() async {
    PageUtil.movePage(context, PostListViewPage());
  }

  void startBrowser() {
    crawller.startBrowser();
  }

  void stopBrowser() {
    crawller.stopBrowser();
  }

  void login(String id, String pw) {
    crawller.login(id, pw);
  }

  void turnOffAlarmDialog() {
    crawller.turnOffAlarmDialog();
  }
}