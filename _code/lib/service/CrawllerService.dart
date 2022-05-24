import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/interface/Type.dart';
import 'package:insta_crawller_flutter/_common/model/KDHResult.dart';
import 'package:insta_crawller_flutter/_common/model/exception/CommonException.dart';
import 'package:insta_crawller_flutter/_common/util/FileUtil.dart';
import 'package:insta_crawller_flutter/_common/util/InteractionUtil.dart';
import 'package:insta_crawller_flutter/_common/util/LogUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PuppeteerUtil.dart';
import 'package:insta_crawller_flutter/page/InstaAccountSettingPage.dart';
import 'package:insta_crawller_flutter/page/NavigationPage.dart';
import 'package:insta_crawller_flutter/repository/InstaUserRepository.dart';
import 'package:insta_crawller_flutter/repository/PostUrlRepository.dart';
import 'package:insta_crawller_flutter/service/PostUrlService.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:puppeteer/puppeteer.dart';

class CrawllerService extends ChangeNotifier {
  File? thumbnailFile;

  final PuppeteerUtil p;
  final Duration delay;
  final Duration timeout;

  CrawllerService()
      : p = PuppeteerUtil(),
        delay = const Duration(milliseconds: 15),
        timeout = Duration(seconds: 20);

  static ChangeNotifierProvider get provider =>
      ChangeNotifierProvider<CrawllerService>(create: (_) => CrawllerService());

  static Widget consumer(
          {required ConsumerBuilderType<CrawllerService> builder}) =>
      Consumer<CrawllerService>(builder: builder);

  static CrawllerService read(BuildContext context) =>
      context.read<CrawllerService>();

  Future<InstaUser?> _getInstaUser() async {
    return await InstaUserRepository.me.getOne();
  }

  void saveHumorPost(NavigationPageComponent c) async {
    var context = c.context;
    PostUrlService service = PostUrlService.read(context);

    await p.startBrowser(headless: false, width: 1280, height: 1024);

    InstaUser? instaUser = await _login(context);
    if (instaUser != null) {
      List targetIdList = instaUser.accountIdList ?? [];
      targetIdList.shuffle();
      for (var instaUserId in targetIdList) {
        LogUtil.debug("instaUser.accountIdList 중 instaUserId 탐색중입니다.");
        List<String> postUrlList = await getPostUrlList(instaUserId);

        if (postUrlList.isNotEmpty) {
          for (String postUrlStr in postUrlList) {
            PostUrl postUrl =
                await PostUrlRepository.me.getOneByUrl(postUrlStr) ??
                    PostUrl(
                      instaUserId: instaUserId,
                      url: postUrlStr,
                      mediaUrlList:
                          await getMediaStrListOf(postUrl: postUrlStr),
                    );
            service.addPostUrl(postUrl);
          }
        } else {
          LogUtil.debug("Posts가 없습니다.");
        }
      }
    }

    await p.stopBrowser();
  }

  Future<void> setInstaUser(InstaAccountSettingPageComponent c) async {
    InstaUser? instaUser = await _getInstaUser();
    if (instaUser != null) {
      c.idController.text = instaUser.id ?? "";
      c.pwController.text = instaUser.pw ?? "";
      c.accountIdList = List.of((instaUser.accountIdList ?? []).cast<String>());
    }
    notifyListeners();
  }

  Future<void> saveInstaUser(InstaAccountSettingPageComponent c) async {
    try {
      var id = c.idController.text;
      var pw = c.pwController.text;
      var accountIdList = c.accountIdList;

      InstaUser instaUser = (await _getInstaUser()
            ?..id = id
            ..pw = pw
            ..accountIdList = accountIdList) ??
          InstaUser(id: id, pw: pw, accountIdList: accountIdList);

      await InstaUserRepository.me.save(instaUser: instaUser);
      InteractionUtil.success(c.context, "저장 성공하였습니다.");
      PageUtil.back(c.context);
    } catch (e) {
      InteractionUtil.error(c.context, "저장 실패하였습니다. :$e");
    }
  }

  void goPostListViewPage() async {
    // PageUtil.go(context, PostListViewPage());
  }

  Future<InstaUser?> _login(BuildContext context) async {
    Future<bool> _isLoginSuccess() async {
      bool isLoginPage = await p.existTag('input[name="username"]');
      return !isLoginPage;
    }

    InstaUser? instaUser = await _getInstaUser();
    if (instaUser == null) {
      InteractionUtil.error(context, "Need to set my insta account");
      return null;
    }

    var id = instaUser.id;
    var pw = instaUser.pw;

    const String loginPageUrl = "https://www.instagram.com/accounts/login/";
    for (int i = 0; i < 5; i++) {
      await p.goto(loginPageUrl);
      if (await _isLoginSuccess()) {
        LogUtil.debug("[$id] 로그인 성공하였습니다.");
        break;
      }

      LogUtil.debug("[$id] 로그인에 실패하였습니다.");
      await p.type('input[name="username"]', id ?? "", delay: delay);
      await p.type('input[name="password"]', pw ?? "", delay: delay);
      await p.clickAndWaitForNavigation('[type="submit"]', timeout: timeout);

      if (await p.existTag('#slfErrorAlert')) {
        LogUtil.debug(
            "[$id] 로그인에 실패하였습니다. 원인 : ${await p.text(await p.$('#slfErrorAlert'))}");
        break;
      }
    }

    Future<void> _turnOffAlarmDialog() async {
      bool existAlarmDialog = await p.existTag(
          'img[src="/static/images/ico/xxhdpi_launcher.png/99cf3909d459.png"]');
      LogUtil.debug("turnOffAlarmDialog existAlarmDialog : $existAlarmDialog");
      if (existAlarmDialog) {
        await p.click('[role="dialog"] button:nth-child(2)');
      }
    }

    await _turnOffAlarmDialog();

    return instaUser;
  }

  Future<void> saveInfoAboutPost() async {
    //Post 내용 저장.
  }

  Future<List<String>> getPostUrlList(String targetId) async {
    await p.goto("https://www.instagram.com/$targetId");
    if (!await isTargetIdPage(targetId)) return [];

    return (await Future.wait((await p.$$('a[href^="/p"]')).map(
            (elementHandle) => p.getAttr(tag: elementHandle, attr: "href"))))
        .map((e) => "https://www.instagram.com$e")
        .toList();
  }

  Future<bool> isTargetIdPage(String targetId) async {
    const String selector = '[role="tablist"] > a[aria-selected="true"]';

    bool valid = await p.existTag(selector);

    String contents = await p.text(await p.$(selector));
    LogUtil.debug("해당 TargetId($targetId)의 contents : $contents");

    valid = contents.contains("게시물") || contents.contains("Posts");
    LogUtil.debug("해당 TargetId($targetId)로 이동에 ${valid ? "성공" : "실패"}하였습니다.");

    return valid;
  }

  Future<List<String>> getMediaStrListOf({required String postUrl}) async {
    await p.goto("https://sssinstagram.com/ko");
    await p.type('#main_page_text', postUrl, delay: delay);
    await p.click('#submit');

    //응답 올때까지 기다리기
    await p.waitForSelector('#response');
    return await Future.wait(
      (await p.$$(
              '#response > .graph-sidecar-wrapper  div.download-wrapper > a:nth-child(1)'))
          .map(
        (el) => p.getAttr(tag: el, attr: 'href'),
      ),
    );
  }

//
// Future<void> _deleteRequest(ElementHandle tag) async {
//   await p.click('.quote-btn.del', tag: tag);
//   await p.click('.swal2-confirm.btn');
// }
//
// Future<void> _sendRequests(ElementHandle tag) async {
//   //요청보러들어가기
//   await tag.click();
//   await p.waitForNavigation();
//
//   //불러오기
//   await p.click('.quote-tmpl-icon.arrow');
//   await p.click('.item-list .item-short:nth-child(1)');
//   await p.click('.action-btn-wrap');
//   await p.click('.swal2-confirm.btn');
//
//   //견적보내기
//   await p.waitForSelector('.file-wrap .delete');
//   await p.evaluate(
//       "document.querySelector('.btn.btn-primary.btn-block').click();");
// }
//
// Future<void> _deleteAndSendRequests() async {
//   LogUtil.info("_deleteAndSendRequests 시작");
//
//   Future<bool> refreshAndExitIfShould() async {
//     await p.goto('https://soomgo.com/requests/received');
//     await p.reload();
//     await p.autoScroll();
//     bool existSelector =
//         await p.waitForSelector('.request-list > li > .request-item');
//     if (!existSelector) {
//       return true;
//     }
//     return false;
//   }
//
//   Future<List<ElementHandle>> getTagList() async =>
//       await p.$$('.request-list > li > .request-item');
//
//   Map<String, int> keywordMap = {};
//   while (true) {
//     if (await refreshAndExitIfShould()) break;
//     List<ElementHandle> tagList = await getTagList();
//     if (tagList.isEmpty) break;
//
//     var tag = tagList[0];
//     var messageTag = await p.$('.quote > span.message', tag: tag);
//     String message = await p.html(tag: messageTag);
//
//     Future<Map<String, int>> countKeyword(String message) async {
//       Map<String, int> keywordMap = {};
//       for (var eachWord in message.trim().split(",")) {
//         eachWord = eachWord.trim();
//         if (!keywordMap.containsKey(eachWord)) {
//           keywordMap[eachWord] = 0;
//         }
//         keywordMap[eachWord] = keywordMap[eachWord]! + 1;
//       }
//       LogUtil.info("keywordMap: $keywordMap");
//       return keywordMap;
//     }
//
//     keywordMap.addAll(await countKeyword(message));
//
//     await decideMethod(
//       message,
//       () async => await _sendRequests(tag),
//       () async => await _deleteRequest(tag),
//     );
//   }
//
//   Future<void> saveFirestore(Map<String, int> keywordMap) async {
//     for (var entry in keywordMap.entries) {
//       String eachWord = entry.key;
//       int count = entry.value;
//
//       KeywordItem? keywordItem =
//           await KeywordItemRepository().getKeywordItem(keyword: eachWord);
//       if (keywordItem == null) {
//         await KeywordItemRepository().add(
//           keywordItem: KeywordItem(
//             keyword: eachWord,
//             count: count,
//           ),
//         );
//       } else {
//         await KeywordItemRepository().update(
//           keywordItem
//             ..keyword = eachWord
//             ..count = ((keywordItem.count ?? 0) + count),
//         );
//       }
//     }
//   }
//
//   await saveFirestore(keywordMap);
// }
//
// Future<void> decideMethod(String message, Future<void> Function() send,
//     Future<void> Function() delete) async {
//
//   //아래 키워드가 있으면 바로 메시지 보낸다.
//   for (String toIncludeAlways in listToIncludeAlways) {
//     if (message.toLowerCase().contains(toIncludeAlways.toLowerCase())) {
//       await send();
//       return;
//     }
//   }
//
//   //아래 조건이 모두 포함되면 메시지를 보낸다.
//   List<String> listToIncludeForOr =
//       listToInclude.where((element) => element.contains("||")).toList();
//   List<String> listToIncludeForAnd =
//       listToInclude.where((element) => !element.contains("||")).toList();
//
//   //아래 조건에 해당하는게 없다면, 제거 대상.
//   bool isValid = true;
//   for (String toIncludeForAnd in listToIncludeForAnd) {
//     if (!message.toLowerCase().contains(toIncludeForAnd.toLowerCase())) {
//       LogUtil.info(
//           "condition1 message:$message, toIncludeForAnd:$toIncludeForAnd");
//       isValid = false;
//       break;
//     }
//   }
//   //아래 조건에 해당하는게 없다면, 제거 대상.
//   //1개 조건에 대해 A||B||C일 때, 메시지가 A or B or C에 해당하는게 없다면, 제거 대상
//   for (String toIncludeForOr in listToIncludeForOr) {
//     List<String> orStrList = toIncludeForOr.split("||").toList();
//     bool existOr = orStrList
//         .where(
//             (orStr) => message.toLowerCase().contains(orStr.toLowerCase()))
//         .isNotEmpty;
//     if (!existOr) {
//       LogUtil.info("condition2 message:$message, orStrList:$orStrList");
//       isValid = false;
//       break;
//     }
//   }
//   //이 키워드가 있으면, 제거대상
//   for (String toExclude in listToExclude) {
//     if (message.toLowerCase().contains(toExclude.toLowerCase())) {
//       LogUtil.info("condition3 message:$message, toExclude:$toExclude");
//       isValid = false;
//       break;
//     }
//   }
//
//   if (isValid) {
//     LogUtil.info("decideMethod send message:$message");
//     await send();
//   } else {
//     LogUtil.info("decideMethod delete message:$message");
//     await delete();
//   }
// }

  void goInstaAccountSettingPage(NavigationPageComponent c) async {
    var context = c.context;
    await PageUtil.back(context);
    await PageUtil.go(
      context,
      InstaAccountSettingPage(),
      pageTransitionBuilder: (nextPage) => PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 130),
        reverseDuration: const Duration(milliseconds: 130),
        child: nextPage,
      ),
    );
  }

  Future<KDHResult> uploadPostUrl(BuildContext context, PostUrl postUrl,
      File? selectedThumbnailFile) async {
    KDHResult result = KDHResult.success;

    try {
      await p.startBrowser(headless: false, width: 1280, height: 1024);

      InstaUser? instaUser = await _login(context);
      result = instaUser == null ? KDHResult.fail : KDHResult.success;
      result.checkFailAndThrowException(errorMsg: "_login error");

      Future<List<File>> _getFileList() async {
        List<File> fileList = [];
        for (String mediaUrl in (postUrl.mediaUrlList ?? []).cast<String>()) {
          try {
            File file = await FileUtil.downloadFile(mediaUrl);
            fileList.add(file);
          } catch (ignored) {}
        }

        return fileList;
      }

      await p.goto("https://www.instagram.com/");
      List<File> fileList = await _getFileList();
      result = fileList.isEmpty ? KDHResult.fail : KDHResult.success;
      result.checkFailAndThrowException(errorMsg: "_getFileList error");
      if (selectedThumbnailFile != null) {
        fileList.insert(0, selectedThumbnailFile);
      }

      Future<KDHResult> _openUploadDialog() async {
        const selector = '[aria-label="새로운 게시물"]';
        if (!await p.existTag(selector)) {
          return KDHResult.fail;
        }

        await (await p.parent(await p.parent(await p.$(selector)))).click();
        return KDHResult.success;
      }

      result = await _openUploadDialog();
      result.checkFailAndThrowException(errorMsg: "_openUploadDialog error");

      Future<KDHResult> _uploadFiles() async {
        Future<ElementHandle?> getUploadButton() async {
          List<ElementHandle> tempList = await p.$$('button');
          for (ElementHandle element in tempList) {
            String elementStr = await p.text(element);
            if (elementStr.contains("컴퓨터에서")) {
              return element;
            }
          }
          return null;
        }

        ElementHandle? uploadButton = await getUploadButton();
        if (uploadButton == null) {
          return KDHResult.fail;
        }
        await p.waitForFileChooser(uploadButton, acceptFiles: fileList);
        return KDHResult.success;
      }

      result = await _uploadFiles();
      result.checkFailAndThrowException(errorMsg: "_uploadFiles error");

      Future<KDHResult> _nextStep(String selector, String targetText) async {
        ElementHandle? targetTag;
        List<ElementHandle> tempList = await p.$$(selector);
        for (ElementHandle tempElement in tempList) {
          String elementStr = await p.text(tempElement);
          if (elementStr.contains(targetText)) {
            targetTag = tempElement;
            break;
          }
        }

        if (targetTag == null) {
          return KDHResult.fail;
        }

        await targetTag.click();
        return KDHResult.success;
      }

      await p.wait(1500);
      result = await _nextStep('[aria-label="자르기"] button', "다음");
      result.checkFailAndThrowException(
          errorMsg: '_nextStep[aria-label="자르기"] error');

      await p.wait(1500);
      result = await _nextStep('[aria-label="편집"] button', "다음");
      result.checkFailAndThrowException(
          errorMsg: '_nextStep[aria-label="편집"] error');

      await p.typeClick('[aria-label="문구 입력..."]',
          "#사람 #명언 #북스타그램 #데일리 #럽스타그램 #감성글 #독서 #좋은글 #직장인 #감성 #연애 #책추천 #인간관계 #고민 #힐링 #책 #책스타그램 #서점 #책선물 #베스트셀러 #위로글 #자존감 #위로글귀 #공감 #일상 #동기부여 #자기계발 #글 #글스타그램 #20대 #30대 #꿀잼영상 #유머영상 #유머동영상 #유머모음 #유머피드 #유머릴스 #유머그램 #꿀잼피드 #꿀잼릴스 #좋아요 #좋아요댓글 #선팔 #맞팔 #ㅋㅋㅋ #ㅋㅋㅋㅋㅋ #먹스타그램 #먹스타 #뭐해 #환영 #꿀잼 #소통 #개그 #웃음 #웃짤 #웃긴사진 #재미 #재밌는 #웃긴 #맞팔 #지55 #유머저장소 #선팔 #맞팔 #좋반 #좋아요 #좋아요반사 #맞팔해요 #좋테 #좋튀");

      await p.wait(1500);
      result = await _nextStep('[aria-label="새 게시물 만들기"] button', "공유하기");
      result.checkFailAndThrowException(
          errorMsg: '_nextStep[aria-label="새 게시물 만들기"] error');

      await p.goto("https://www.instagram.com/");
    } on CommonException catch (e) {
      rethrow;
    } finally {
      await p.stopBrowser();
    }

    return result;
  }
}
