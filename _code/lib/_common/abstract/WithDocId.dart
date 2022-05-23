import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';

abstract class WithDocId {
  int? documentId;
  String? email;
  bool? deleted;

  WithDocId({this.documentId}) {
    email = AuthUtil.me.email;
    deleted = false;
  }

  @override
  bool operator ==(dynamic other) => documentId == other.documentId;
}
