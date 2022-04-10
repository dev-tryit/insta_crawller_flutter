import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/page/test/TestTodoListPage.dart';

class User {
  String id;
  String pw;

  User(this.id, this.pw);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        pw = json['pw'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pw': pw,
    };
  }
}

class TestLoginPage extends StatefulWidget {
  static const String staticClassName= "TestLoginPage";
  final className = staticClassName;
  @override
  _TestLoginPageState createState() => _TestLoginPageState();
}

class _TestLoginPageState extends State<TestLoginPage> {
  final idController = TextEditingController();
  final pwController = TextEditingController();

  String? id;
  String? pw;

  @override
  void initState() {
    Future((){
      bool isLogin = FirebaseAuth.instance.currentUser != null;
      print("isLogin : $isLogin");
      if(isLogin) {
        goPage(context, TestTodoListPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 페이지'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '아이디를 입력해주세요',
                ),
                keyboardType: TextInputType.number, // 숫자 입력만
                onChanged: (value) {
                  id = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: pwController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '비밀번호를 입력해주세요',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  pw = value;
                },
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    String email = idController.text.trim();
                    String pw = pwController.text.trim();

                    if (email.isEmpty || pw.isEmpty) {
                      showMessage(context, "아이디 및 비밀번호를 입력해주세요");
                      return;
                    }

                    if (email.isEmpty || !EmailValidator.validate(email)) {
                      showMessage(context, "이메일 형식이 잘못되었습니다. 다시 입력해주세요.");
                      return;
                    }

                    await login(User(email, pw));
                  },
                  child: Text('로그인하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(User user) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user.id, password: user.pw);
      showMessage(context, "로그인 완료되었습니다");
      goPage(context, TestTodoListPage());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showMessage(context, "해당 유저가 없습니다.");
      } else if (e.code == 'invalid-email') {
        showMessage(context, "이메일이 형식이 잘못되었습니다");
      } else if (e.code == 'wrong-password') {
        showMessage(context, "비밀번호가 틀렸습니다");
      } else if (e.code == 'too-many-requests') {
        showMessage(context, "잠시 후에 다시 시도해주세요");
      } else if (e.code == 'network-request-failed') {
        showMessage(context, "네트워크 요청이 실패하였습니다");
      } else if (e.code == 'internal-error') {
        showMessage(context, "에러가 발생하였습니다");
      } else {
        showMessage(context, "에러가 발생하였습니다 ${e.code}");
      }
    }
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),

    ));
  }

  void goPage(BuildContext context, Widget child) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => child,
      ),
    );
  }
}
