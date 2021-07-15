// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import '../main.dart';

class UpdateItemInfo extends StatefulWidget {
  UpdateItemInfo({
    Key key,
    this.shortInfo,
    this.id,
    this.longDescription,
    this.price,
  }) : super(key: key);

  final String shortInfo;
  final String id;
  final String longDescription;
  final int price;

  @override
  State<UpdateItemInfo> createState() => _UpdateItemInfoState(
      this.shortInfo, this.id, this.longDescription, this.price);
}

class _UpdateItemInfoState extends State<UpdateItemInfo> {
  _UpdateItemInfoState(
      this.shortInfo, this.id, this.longDescription, this.price);
  String shortInfo;
  final String id;
  final String longDescription;
  final int price;

  SizedBox s = SizedBox(
    height: 20,
  );

  @override
  Widget build(BuildContext context) {
    TextEditingController _longDescriptionController =
        TextEditingController(text: widget.longDescription);

    TextEditingController _priceController =
        TextEditingController(text: widget.price.toString());
    TextEditingController _shortInfoController =
        TextEditingController(text: widget.shortInfo);

    return Scaffold(
      backgroundColor: HexColor("e5e2df"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _shortInfoController,
                decoration: InputDecoration(
                  hintText: "作品名",
                  labelText: "作品名",
                ),
              ),
            ),
            color: Colors.white,
          ),
          s,
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _longDescriptionController,
                decoration: InputDecoration(
                  hintText: "作品情報",
                  labelText: "作品情報",
                ),
              ),
            ),
            color: Colors.white,
          ),
          s,
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                controller: _priceController,
                decoration: InputDecoration(
                  hintText: "金額",
                  labelText: "金額",
                ),
              ),
            ),
            color: Colors.white,
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("items")
                  .doc(widget.id)
                  .update({
                "shortInfo": _shortInfoController.text.trim(),
                "longDescription": _longDescriptionController.text.trim(),
                "price": int.parse(_priceController.text.trim()),
              }).whenComplete(() {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => MainPage()));
              });
            },
            child: Text("更新する"),
          ),
        ],
      ),
    );
  }
}
