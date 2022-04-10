import 'package:flutter/material.dart';

class TestTabPage extends StatelessWidget {
  static const String staticClassName= "TestTabPage";
  final className = staticClassName;
  const TestTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          children: <Widget>[
            const Spacer(),
            const Text("NumericFocusOrder(숫자 순서)"),
            FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                children: [
                  FocusTraversalOrder(
                    order: NumericFocusOrder(1.0),
                    child: TextButton(
                      child: const Text('1'),
                      onPressed: () {},
                    ),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(2.0),
                    child: TextButton(
                      child: const Text('2'),
                      onPressed: () {},
                    ),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(3.0),
                    child: TextButton(
                      child: const Text('3'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Text("LexicalFocusOrder(글자 순서), NumericFocusOrder와 혼용 불가"),
            FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                children: [
                  FocusTraversalOrder(
                    order: LexicalFocusOrder('a'),
                    child: TextButton(
                      child: const Text('a'),
                      onPressed: () {},
                    ),
                  ),
                  FocusTraversalOrder(
                    order: LexicalFocusOrder('A'),
                    child: TextButton(
                      child: const Text('A'),
                      onPressed: () {},
                    ),
                  ),
                  FocusTraversalOrder(
                    order: LexicalFocusOrder('b'),
                    child: TextButton(
                      child: const Text('b'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Text(
                "위젯 위치하는 순서대로 탭되는 WidgetOrderTraversalPolicy정책\n(NumericFocusOrder, NumericFocusOrder 무시됨)"),
            FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: Column(
                children: [
                  FocusTraversalOrder(
                    order: LexicalFocusOrder('a'),
                    child: TextButton(
                      child: const Text('a'),
                      onPressed: () {},
                    ),
                  ),
                  FocusTraversalOrder(
                    order: LexicalFocusOrder('A'),
                    child: TextButton(
                      child: const Text('A'),
                      onPressed: () {},
                    ),
                  ),
                  FocusTraversalOrder(
                    order: LexicalFocusOrder('b'),
                    child: TextButton(
                      child: const Text('b'),
                      onPressed: () {},
                    ),
                  ),
                  FocusTraversalOrder(
                    order: NumericFocusOrder(1.0),
                    child: TextButton(
                      child: const Text('1'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
