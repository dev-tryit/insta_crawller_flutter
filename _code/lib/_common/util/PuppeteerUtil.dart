import 'package:puppeteer/puppeteer.dart';
import 'package:insta_crawller_flutter/_common/util/LogUtil.dart';

class PuppeteerUtil {
  late Browser browser;
  late Page tab;

  final defaultTimeout = Duration(seconds: 10);

  //데스크탑 모드가 아닌 경우에는, 다른 컴퓨터에 켜져있는 pupueteer를 이용할 수 있다.

  Future<void> openBrowser(Future<void> Function() function,
      {int width = 1920,
      int height = 1600,
      bool headless = true, String? browserUrl}) async {
    bool isConnect = (browserUrl??"").isNotEmpty;
    LogUtil.debug("openBrowser isConnect : $isConnect");

    if (isConnect) {
      //크롬 바로가기 만들고, 거기에 "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222형태로 쓰면 됨.
      //이때, 크롬을 다 껏다가 해야함.
      browser = await puppeteer.connect(browserUrl: browserUrl!);
    } else {
      browser = await puppeteer.launch(
        headless: headless,
        args: [
          '--no-sandbox',
          '--window-size=$width,$height',
        ],
        defaultViewport: DeviceViewport(
          width: width,
          height: height,
        ),
      );
    }
    tab = await browser.newPage();
    tab.defaultTimeout = defaultTimeout;
    await setPageZoom();

    //process
    await function();

    //close
    try {
      await tab.close();
      if (!isConnect) await browser.close();
    } catch (e) {}
  }

  Future<Response> reload() async {
    return await tab.reload();
  }
  Future<void> goto(String url) async {
    await tab.goto(url, wait: Until.networkIdle, timeout: defaultTimeout);
  }

  Future<String> html({ElementHandle? tag}) async {
    if (tag == null) {
      return await tab.content ?? "";
    } else {
      return await evaluate(r'el => el.textContent', args: [tag]);
    }
  }

  Future<dynamic> evaluate(String pageFunction, {List? args}) async {
    return await tab.evaluate(pageFunction, args: args);
  }

  Future<void> type(String selector, String content, {Duration? delay}) async {
    await tab.type(selector, content, delay: delay);
  }

  Future<bool> existTag(String selector) async {
    return await evaluate("Boolean(document.querySelector('$selector'))");
  }

  Future<void> wait(double millseconds) async {
    await evaluate('''async () => {
      await new Promise(function(resolve) { 
            setTimeout(resolve, $millseconds)
      });
  }''');
  }

  Future<ElementHandle> $(String selector, {ElementHandle? tag}) async {
    // querySelector를 나타냄.
    if (tag != null) {
      return await tag.$(selector);
    } else {
      return await tab.$(selector);
    }
  }

  Future<List<ElementHandle>> $$(String selector, {ElementHandle? tag}) async {
    // querySelectorAll를 나타냄.
    if (tag != null) {
      return await tag.$$(selector);
    } else {
      return await tab.$$(selector);
    }
  }

  Future<bool> waitForSelector(String selector,
      {bool? visible,
      bool? hidden,
      Duration timeout = const Duration(seconds: 5)}) async {
    try {
      await tab.waitForSelector(selector,
          visible: visible, hidden: hidden, timeout: timeout);
      return true;
    } catch (e) {
      LogUtil.info("$selector 가 없습니다.");
      return false;
    }
  }

  Future<void> click(String selector, {ElementHandle? tag}) async {
    try {
      if (tag == null) {
        await waitForSelector(selector);
      }
      var tagToClick = await $(selector, tag: tag);
      await tagToClick.click();
    } catch (e) {}
  }

  Future<Response?> clickAndWaitForNavigation(String selector,
      {Duration? timeout, Until? wait}) async {
    try {
      return await tab.clickAndWaitForNavigation(selector,
          timeout: timeout, wait: wait);
    } catch (e) {
      return null;
    }
  }

  Future<Response?> waitForNavigation({Duration? timeout, Until? wait}) async {
    try {
      return await tab.waitForNavigation(timeout: timeout, wait: wait);
    } catch (e) {
      return null;
    }
  }

  Future<bool> include(String selector, String text) async {
    return await evaluate(
        "(document.querySelector('$selector')?.innerText ?? '').includes('$text')");
  }

  Future<void> autoScroll({int millisecondInterval = 1000}) async {
    await evaluate('''async () => {
        await new Promise((resolve, reject) => {
            var totalHeight = 0;
            var distance = 100;
            var timer = setInterval(() => {
                var scrollHeight = document.body.scrollHeight;
                window.scrollBy(0, distance);
                totalHeight += distance;

                if(totalHeight >= scrollHeight){
                    clearInterval(timer);
                    resolve();
                }
            }, $millisecondInterval);
        });
    }''');
  }

  Future<void> setPageZoom({int zoom=1}) async {

  }
}
