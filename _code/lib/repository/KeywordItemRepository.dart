import 'package:insta_crawller_flutter/_common/abstract/WithDocId.dart';
import 'package:insta_crawller_flutter/_common/util/firebase/FirebaseStoreUtilInterface.dart';

class KeywordItem extends WithDocId {
  static const String className = "KeywordItem";
  String? keyword;
  int? count;

  KeywordItem({required this.keyword, required this.count})
      : super(documentId: DateTime.now().microsecondsSinceEpoch);

  factory KeywordItem.fromJson(Map<String, dynamic> json) => fromMap(json);

  Map<String, dynamic> toJson() => toMap(this);

  static KeywordItem fromMap(Map<String, dynamic> map) {
    return KeywordItem(
      keyword: map['keyword'],
      count: map['count'],
    )
    ..documentId = map['documentId']
    ..email = map['email'];
  }

  static Map<String, dynamic> toMap(KeywordItem instance) {
    return {
      'documentId': instance.documentId,
      'email': instance.email,
      'keyword': instance.keyword,
      'count': instance.count,
    };
  }

  static String? getErrorMessageForAdd(String title, String keyword) {
    if (title.isEmpty) return '분류 이름을 입력해주세요';
    if (keyword.isEmpty) return '분류 기준 텍스트를 입력해주세요';
    return null;
  }
}

class KeywordItemRepository {
  static final KeywordItemRepository _singleton =
      KeywordItemRepository._internal();
  factory KeywordItemRepository() {
    return _singleton;
  }
  KeywordItemRepository._internal();

  final _ = FirebaseStoreUtilInterface.init<KeywordItem>(
    collectionName: KeywordItem.className,
    fromMap: KeywordItem.fromMap,
    toMap: KeywordItem.toMap,
  );

  Future<KeywordItem?> add({required KeywordItem keywordItem}) async {
    return await _.saveByDocumentId(instance: keywordItem);
  }

  Future<void> update(KeywordItem keywordItem) async {
    await _.saveByDocumentId(
      instance: keywordItem,
    );
  }

  Future<bool> existDocumentId({required int documentId}) async {
    return await _.exist(
      key: "documentId",
      value: documentId.toString(),
    );
  }

  Future<void> delete({required int documentId}) async {
    await _.deleteOne(documentId: documentId);
  }

  Future<KeywordItem?> getKeywordItem({required String keyword}) async {
    return await _.getOneByField(
      key: "keyword",
      value: keyword,
      onlyMyData:true,
    );
  }
}
