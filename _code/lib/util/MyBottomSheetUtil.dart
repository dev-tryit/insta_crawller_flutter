import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:insta_crawller_flutter/util/MyColors.dart';
import 'package:insta_crawller_flutter/util/MyFonts.dart';
import 'package:insta_crawller_flutter/widget/MyRedButton.dart';

// typedef AddFunctionWithSetErrorMessage = void Function(
//     void Function(String errorMessage) setErrorMessage);
typedef void AddFunctionWithSetErrorMessage(
    void setErrorMessage(String errorMessage));

class MyBottomSheetUtil {
  void showInputBottomSheet(
      {required BuildContext context,
      required String title,
      required List<Widget> children,
      required AddFunctionWithSetErrorMessage onAdd,
      required String buttonStr}) {
    showBottomSheet(
      context: context,
      child: InputBottomSheet(
        title: title,
        children: children,
        onAdd: onAdd,
        buttonStr: buttonStr,
      ),
    );
  }

  void showBottomSheet(
      {required BuildContext context, required Widget child}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(15),
        child: Material(child: child), //Material이 있어야, 하위에서 InkWell이 제대로 작동함
      ),
    );
  }
}

class InputBottomSheet extends StatefulWidget {
  String title;
  String buttonStr;
  List<Widget> children;
  AddFunctionWithSetErrorMessage onAdd;
  InputBottomSheet(
      {Key? key,
      required this.title,
      required this.children,
      required this.onAdd,
      required this.buttonStr})
      : super(key: key);

  @override
  _InputBottomSheetState createState() => _InputBottomSheetState();
}

class _InputBottomSheetState extends State<InputBottomSheet> {
  String errorMessage = "";

  void setErrorMessage(String errorMessage) {
    this.errorMessage = errorMessage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.title,
                  style: MyFonts.gothicA1(
                      color: MyColors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              Expanded(
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.right,
                  style: MyFonts.gothicA1(
                    color: MyColors.red,
                    fontSize: 9,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              MyRedButton(
                widget.buttonStr,
                useShadow: false,
                onPressed: () => widget.onAdd(setErrorMessage),
              ),
            ],
          ),
        ),
        const Divider(),
        ...widget.children,
      ],
    );
  }
}
