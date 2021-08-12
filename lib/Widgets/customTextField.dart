// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  //todo:isObsecureは隠す（htmlのhiddenと同じ）
  bool isObsecure = true;

  //todo:以下の{key}等で指定したthisが別.dartで読んだ際の引数で指定することで発火する
  //todo:使い回しが可能に唸る
  CustomTextField(
      {Key key, this.controller, this.data, this.hintText, this.isObsecure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Neumorphic(
          style: NeumorphicStyle(
              depth: NeumorphicTheme.embossDepth(context),
              boxShape: NeumorphicBoxShape.stadium(),
              color: bgColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autofocus: true,
              controller: controller,
              obscureText: isObsecure,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  data,
                  color: mainColorOfLEEWAY,
                ),
                focusColor: Colors.white,
                hintText: (hintText),
                hintStyle: TextStyle(color: HexColor("#f8f8ff")),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
