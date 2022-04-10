import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';

abstract class WithDocId {
  int? documentId;
  String? email;

  WithDocId({this.documentId}){
    email = AuthUtil().email;
  }
  
  @override
  bool operator ==(dynamic other) => documentId == other.documentId;
}
