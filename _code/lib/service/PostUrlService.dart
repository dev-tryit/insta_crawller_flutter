import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_crawller_flutter/_common/interface/Type.dart';
import 'package:provider/provider.dart';

class PostUrlService extends ChangeNotifier {
  BuildContext context;
  PostUrlService(this.context);

  static ChangeNotifierProvider get provider =>
      ChangeNotifierProvider<PostUrlService>(
          create: (context) => PostUrlService(context));
  static Widget consumer({required ConsumerBuilderType<PostUrlService> builder}) => Consumer<PostUrlService>(builder: builder);
}
