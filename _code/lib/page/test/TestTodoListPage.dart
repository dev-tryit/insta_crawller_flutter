import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';

class Todo {
  static const className = "Todo";

  String? documentId;
  String? content;
  bool? checked;

  Todo({this.content, this.checked = false});

  Todo.fromMap(Map<String, dynamic> json)
      : documentId = json['documentId'],
        content = json['content'],
        checked = json['checked'];

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'content': content,
      'checked': checked,
    };
  }
}

class TestTodoListPage extends StatefulWidget {
  static const String staticClassName= "TestTodoListPage";
  final className = staticClassName;
  const TestTodoListPage({Key? key}) : super(key: key);

  @override
  _TestTodoListPageState createState() => _TestTodoListPageState();
}

class _TestTodoListPageState extends State<TestTodoListPage> {
  bool isLoaded = false;
  List<Todo> todoList = [
    // Todo("아침 산책", true),
    // Todo("오늘의 뉴스 읽기", false),
    // Todo("샌드위치 사먹기", false),
    // Todo("플루터 공부하기", false)
  ];

  @override
  void initState() {
    onLoad();
  }

  void onLoad() async {
    if (isLoaded) return;

    todoList = await getTodoList();

    isLoaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    List<ListTile> listTileList = makeListTileList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: showInputBottomBox,
        child: Icon(Icons.add_circle),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "2022년 1월 1일",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "토요일",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 25),
            Text(
              "할 일 ${todoList.where((e) => !(e.checked ?? false)).length}개 남음",
              style: TextStyle(
                  color: Colors.greenAccent, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            ...listTileList
          ],
        ),
      ),
    );
  }

  List<ListTile> makeListTileList() {
    List<ListTile> list = [];
    for (Todo todo in todoList) {
      list.add(ListTile(
        leading: InkWell(
          onTap: () async {
            todo.checked = !(todo.checked ?? false);
            await FirebaseFirestore.instance
                .collection(Todo.className)
                .doc(todo.documentId)
                .set(todo.toMap());
            setState(() {});
          },
          child: Icon(
            Icons.check_box_outlined,
            color:
                todo.checked ?? false ? Colors.greenAccent : Colors.grey[300],
          ),
        ),
        title: Text(todo.content ?? "",
            style: TextStyle(
                color:
                    todo.checked ?? false ? Colors.grey[500] : Colors.black)),
      ));
    }
    return list;
  }

  void showInputBottomBox() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => InputBottomBox(this),
    );
  }

  Future<List<Todo>> getTodoList() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Todo.className)
        .orderBy(FieldPath.documentId)
        .get();
    return querySnapshot.docs
        .map((queryDocumentSnapshot) =>
            Todo.fromMap(queryDocumentSnapshot.data() as Map<String, dynamic>))
        .toList();
  }
}

class MyListTile extends StatefulWidget {
  const MyListTile({Key? key}) : super(key: key);

  @override
  _MyListTileState createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class InputBottomBox extends StatefulWidget {
  _TestTodoListPageState testTodoListState;

  InputBottomBox(this.testTodoListState, {Key? key}) : super(key: key);

  @override
  _InputBottomBoxState createState() => _InputBottomBoxState();
}

class _InputBottomBoxState extends State<InputBottomBox> {
  String errorMessage = "";
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
            child: Row(
              children: [
                Text('할일 추가하기',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                const Spacer(),
                Text(errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 12)),
                const SizedBox(width: 10),
                ElevatedButton(
                  child: Text("생성"),
                  onPressed: createTodo,
                  style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            minLeadingWidth: 100,
            leading: Text("할일",
                style: TextStyle(color: Colors.black, fontSize: 12.5)),
            title: TextField(
              controller: contentController,
              decoration: const InputDecoration(isDense: true),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> createTodo() async {
    String content = contentController.text.trim();
    if (content.isEmpty) {
      errorMessage = "할 일을 작성해주세요";
      setState(() {});
      return;
    }

    await saveTodo(Todo(content: content));
  }

  Future<void> saveTodo(Todo todo) async {
    String documentId = DateTime.now().microsecondsSinceEpoch.toString();

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(Todo.className).doc(documentId);
    todo.documentId = documentId;

    await documentReference.set(todo.toMap());
    widget.testTodoListState.todoList.add(todo);

    Navigator.of(context).pop();
    widget.testTodoListState.setState(() {});

    showMessage("할 일을 추가하였습니다");
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
