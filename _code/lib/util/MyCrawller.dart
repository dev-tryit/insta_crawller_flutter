import 'package:insta_crawller_flutter/_common/util/LogUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PuppeteerUtil.dart';
import 'package:puppeteer/puppeteer.dart';


class MyCrawller {
  final PuppeteerUtil p;
  final Duration delay;
  final Duration timeout;

  MyCrawller()
      : this.p = PuppeteerUtil(),
        this.delay = const Duration(milliseconds: 100),
        this.timeout = Duration(seconds: 20);

  Future<void> start(String id, String pw) async {
    await p.openBrowser(
      () async {
        await _login(id, pw);
        await visitAccountAndGetPostLink();
        await saveInfoAboutPost();
      },
      headless: false,
    );
  }

  Future<void> _login(String? id, String? pw) async {
    const String loginPageUrl = "https://www.instagram.com/accounts/login/";
    for (int i = 0; i < 5; i++) {
      await p.goto(loginPageUrl);
      if (await _isLoginSuccess()) {
        LogUtil.info("로그인 성공");
        break;
      }

      LogUtil.info("로그인 필요함");
      await p.type('input[name="username"]', id ?? "", delay: delay);
      await p.type('input[name="password"]', pw ?? "", delay: delay);
      await p.clickAndWaitForNavigation('[type="submit"]', timeout: timeout);
    }
  }

  Future<bool> _isLoginSuccess() async {
    bool isLoginPage = await p.existTag('input[name="username"]');
    return !isLoginPage;
  }

  Future<void> visitAccountAndGetPostLink() async {
    //아래 계정 방문하기 기능 만들기
    List<String> accountList = ["time_enter", "jdowni7"];
    for (String account in accountList) {
      await p.goto("https://www.instagram.com/$account");
      //이 페이지가 account 페이지인지 확인하고 아니면 해당 페이지 내용 저장하고, 프로그램 종료
      //[role="tablist"] > a[aria-selected="true"]의 text에 게시물이 있으면 성공.

      //이 페이지에서 a[href^="/p"](/p를 포함하는 태그)인 태그는 이미지가 포함된 링크이다.
      //해당 링크 데이터베이스에서 기록.
    }
  }

  Future<void> saveInfoAboutPost() async {
    //Post 내용 저장.
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
}
