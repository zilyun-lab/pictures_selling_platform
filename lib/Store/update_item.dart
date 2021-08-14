// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import '../main.dart';

class UpdateItemInfo extends StatefulWidget {
  const UpdateItemInfo(
      {Key key,
      this.shortInfo,
      this.id,
      this.longDescription,
      this.price,
      this.attribute})
      : super(key: key);

  final String shortInfo;
  final String id;
  final String longDescription;
  final int price;
  final String attribute;

  @override
  State<UpdateItemInfo> createState() => _UpdateItemInfoState(
      shortInfo, id, longDescription, price);
}

class _UpdateItemInfoState extends State<UpdateItemInfo> {
  _UpdateItemInfoState(
      this.shortInfo, this.id, this.longDescription, this.price);
  String shortInfo;
  final String id;
  final String longDescription;
  final int price;

  SizedBox s = const SizedBox(
    height: 20,
  );

  @override
  Widget build(BuildContext context) {
    final _longDescriptionController =
        TextEditingController(text: widget.longDescription);

    final _priceController =
        TextEditingController(text: widget.price.toString());
    final _shortInfoController =
        TextEditingController(text: widget.shortInfo);

    return Scaffold(
      backgroundColor: HexColor('e5e2df'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _shortInfoController,
                decoration: const InputDecoration(
                  hintText: '作品名',
                  labelText: '作品名',
                ),
              ),
            ),
          ),
          s,
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _longDescriptionController,
                decoration: const InputDecoration(
                  hintText: '作品情報',
                  labelText: '作品情報',
                ),
              ),
            ),
          ),
          s,
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                controller: _priceController,
                decoration: const InputDecoration(
                  hintText: '金額',
                  labelText: '金額',
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('items')
                  .doc(widget.id)
                  .update({
                'shortInfo': _shortInfoController.text.trim(),
                'longDescription': _longDescriptionController.text.trim(),
                'price': int.parse(_priceController.text.trim()),
                'finalGetProceeds': widget.attribute == 'PostCard' ||
                        widget.attribute == 'Sticker'
                    ? (int.parse(_priceController.text.trim()) * 0.85).toInt()
                    : (int.parse(_priceController.text.trim()) * 0.7).toInt(),
              }).whenComplete(() {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => MainPage()));
              });
            },
            child: const Text('更新する'),
          ),
        ],
      ),
    );
  }
}
