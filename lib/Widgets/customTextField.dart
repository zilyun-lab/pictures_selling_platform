import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white.withOpacity(0.3)],
          //colors: [HexColor("#f39800"), HexColor("#eb6101")],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black38.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: -9,
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
        //color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Colors.black.withOpacity(0.8),
          ),
          focusColor: Colors.white.withOpacity(0.5),
          hintText: hintText,
        ),
      ),
    );
  }
}
