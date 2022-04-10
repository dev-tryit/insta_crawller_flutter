import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestSignUpPage extends StatefulWidget {
  static const String staticClassName= "TestSignUpPage";
  final className = staticClassName;
  const TestSignUpPage({Key? key}) : super(key: key);

  @override
  _TestSignUpPageState createState() => _TestSignUpPageState();
}

class _TestSignUpPageState extends State<TestSignUpPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final pwConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title(),
            const SizedBox(height: 40),
            inputBox("이메일", controller: emailController),
            const SizedBox(height: 20),
            inputBox("비밀번호", controller: pwController, obscureText: true),
            const SizedBox(height: 20),
            inputBox("비밀번호 확인",
                controller: pwConfirmController, obscureText: true),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onRegisterButtonPressed,
                child: const Text("완료"),
                style: TextButton.styleFrom(
                  shape: const ContinuousRectangleBorder(),
                  padding: const EdgeInsets.all(22),
                  primary: Colors.black,
                  side: const BorderSide(width: 1.0, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onRegisterButtonPressed() async {
    String email = emailController.text;
    String pw = pwController.text;
    String pwConfirm = pwConfirmController.text;

    if (email.isEmpty || !EmailValidator.validate(email)) {
      showMessage(context, "이메일 형식이 잘못되었습니다. 다시 입력해주세요.");
      return;
    }

    if (pw.length <= 8) {
      showMessage(context, "비밀번호가 8글자 이하여서, 다시 입력해주세요.");
      return;
    }

    if (pw != pwConfirm) {
      showMessage(context, "비밀번호 확인이 다릅니다. 다시 입력해주세요.");
      return;
    }

    await saveMyAccount(email, pw);
  }

  Future<void> saveMyAccount(String email, String pw) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pw);
      showMessage(context, "회원가입 완료되었습니다");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showMessage(context, "비밀번호 형식이 안전하지 않습니다");
      } else if (e.code == 'email-already-in-use') {
        showMessage(context, "이미 ID가 있습니다");
      } else if (e.code == 'invalid-email') {
        showMessage(context, "이메일이 형식이 잘못되었습니다");
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
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Widget title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("회원가입", style: TextStyle(fontSize: 20)),
        SizedBox(width: 10),
        Text("/", style: TextStyle(fontSize: 20, color: Colors.grey[400])),
        SizedBox(width: 10),
        Text("로그인", style: TextStyle(fontSize: 20, color: Colors.grey[400]))
      ],
    );
  }

  Widget inputBox(String label,
      {TextEditingController? controller, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            hintText: "$label 입력해주세요",
            hintStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(top: 1.5),
          ),
        ),
      ],
    );
  }
}
