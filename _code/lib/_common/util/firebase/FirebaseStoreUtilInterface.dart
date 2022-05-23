import 'package:insta_crawller_flutter/_common/abstract/WithDocId.dart';
import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';
import 'package:insta_crawller_flutter/_common/util/LogUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PlatformUtil.dart';
import 'package:insta_crawller_flutter/_common/util/firebase/firebase/FirebaseStoreUtil.dart';
import 'package:insta_crawller_flutter/_common/util/firebase/firedart/FiredartStoreUtil.dart';

abstract class FirebaseStoreUtilInterface<Type extends WithDocId> {
  String collectionName;
  Type Function(Map<String, dynamic> map) fromMap;
  Map<String, dynamic> Function(Type instance) toMap;

  FirebaseStoreUtilInterface(
      {required this.collectionName,
      required this.fromMap,
      required this.toMap});

  static FirebaseStoreUtilInterface<Type> init<Type extends WithDocId>(
      {required String collectionName,
      required Type Function(Map<String, dynamic>) fromMap,
      required Map<String, dynamic> Function(Type instance) toMap}) {
    if (PlatformUtil.isComputer()) {
      return FiredartStoreUtil<Type>(
          collectionName: collectionName, fromMap: fromMap, toMap: toMap);
    } else {
      return FirebaseStoreUtil<Type>(
          collectionName: collectionName, fromMap: fromMap, toMap: toMap);
    }
  }

  cRef();

  dRef({int? documentId});

  Future<Map<String, dynamic>> dRefToMap(dRef);

  Map<String, dynamic> dSnapshotToMap(dSnapshot);

  Future<List> cRefToList();

  Future<List> queryToList(query);

  Future<List<Type>> _convertListFromDocs(List docs,
      {bool useSort = true, bool descending = false}) async {
    List<Type> typeList = List.from(docs
        .map((e) => _applyInstance(dSnapshotToMap(e)))
        .where((e) => e != null)
        .toList());

    if (useSort) {
      typeList.sort((a, b) => (((a.documentId ?? 0) < (b.documentId ?? 0))
          ? (descending ? 1 : 0)
          : (descending ? 0 : 1)));
    }

    return typeList;
  }

  Type? _applyInstance(Map<String, dynamic>? map) =>
      (map == null || map.isEmpty) ? null : fromMap(map);

  Future<Type?> save({required Type instance, int? newDocumentId}) async {
    var ref = dRef(documentId: newDocumentId ?? instance.documentId);
    await ref.set(toMap(instance));
    return _applyInstance(await dRefToMap(ref));
  }

  Future<Type?> getOne({required int documentId}) async {
    Type? nullableType =
        _applyInstance(await dRefToMap(dRef(documentId: documentId)));
    if (nullableType != null && (nullableType.deleted ?? false)) {
      return null;
    }

    return nullableType;
  }

  Future<bool> exist({required String key, required String value}) async {
    var data = await getOneByField(key: key, value: value);
    return data != null;
  }

  Future<List<Type>> getListByField({
    String? key,
    String? value,
    bool onlyMyData = false,
    bool useSort = true,
    bool descending = false,
  }) async {
    if ((key != null && value == null) || (key == null && value != null)) {
      LogUtil.error("getList 둘 중에 1개가 비어 있습니다.");
      return [];
    }

    dynamic query = cRef();
    if (key != null && value != null) {
      query = query.where(key, isEqualTo: value);
    }

    if (onlyMyData) {
      // LogUtil.debug("AuthUtil.me.email : ${AuthUtil.me.email}");
      query = query.where("email", isEqualTo: AuthUtil.me.email ?? "");
    }

    List<Type> convertedList = (await _convertListFromDocs(
      await queryToList(query),
      useSort: useSort,
      descending: descending,
    ));

    return convertedList.where((e) => !(e.deleted ?? false)).toList();
  }

  Future<Type?> getOneByField(
      {String? key,
      String? value,
      bool onlyMyData = false,
      bool useSort = true,
      bool descending = false}) async {
    List<Type?> list = await getListByField(
        key: key,
        value: value,
        onlyMyData: onlyMyData,
        useSort: useSort,
        descending: descending);
    return list.isNotEmpty ? list.first : null;
  }

  Future<void> deleteOne(
      {required int documentId, bool deleteByChecking = true}) async {
    if (deleteByChecking) {
      Type? instance = await getOne(documentId: documentId);
      if (instance != null) {
        instance.deleted = true;
        await save(instance: instance);
      }
    } else {
      await dRef(documentId: documentId).delete();
    }
  }

  Future<void> deleteListByField(
      {required String key,
      required String value,
      bool deleteByChecking = true}) async {
    //TODO: 동작 되는지 나중에 확인 필요.
    List list = await queryToList(cRef().where(key, isEqualTo: value));

    List<Future> futureList = [];
    for (var documentSnapshot in list) {
      if (deleteByChecking) {
        futureList.add(deleteOne(
            documentId: documentSnapshot.reference.id, deleteByChecking: true));
      } else {
        futureList.add(documentSnapshot.reference.delete());
      }
    }
    await Future.wait(futureList);
  }
}
