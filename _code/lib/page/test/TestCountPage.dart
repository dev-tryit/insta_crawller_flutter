import 'package:flutter/material.dart';

class TestCountPage extends StatefulWidget {
  static const String staticClassName= "TestCountPage";
  final className = staticClassName;
  const TestCountPage({Key? key}) : super(key: key);

  @override
  _TestCountPageState createState() => _TestCountPageState();
}

class _TestCountPageState extends State<TestCountPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox.expand(
          child: TextButton(
            onPressed: () {
              count++;
              setState(() {});
            },
            child: Text(
              count.toString(),
              style: const TextStyle(fontSize: 70, color: Colors.red),
            ),
            style: TextButton.styleFrom(primary: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
