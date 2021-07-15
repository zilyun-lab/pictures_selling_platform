// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:http/http.dart';

// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/WidgetOfFirebase.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';

class AddAddress extends StatefulWidget {
  final String val;
  AddAddress({this.val});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  String selectedItem = "北海道";

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cLastName = TextEditingController();
  final cFirstName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cSecondAddress = TextEditingController();
  final cAddress = TextEditingController();
  final cCity = TextEditingController();
  final cPrefectures = TextEditingController();
  final cPostalCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("e5e2df"),
      key: scaffoldKey,
      appBar: MyAppBar(
        title: Text(
          "新しいお届け先を追加する",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      //print(selectedItem);

      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    label: "名字",
                    hint: "例) 田中",
                    controller: cLastName,
                  ),
                  MyTextField(
                    label: "名前",
                    hint: "例) 太郎",
                    controller: cFirstName,
                  ),
                  serachAddress(cPostalCode, cCity, cPrefectures),
                  MyTextField(
                    label: "都道府県",
                    hint: "例) 北海道",
                    controller: cPrefectures,
                  ),
                  MyTextField(
                    label: "市区町村",
                    hint: "例) 札幌市中央区",
                    controller: cCity,
                  ),
                  MyTextField(
                    label: "番地",
                    hint: "２番地１６",
                    controller: cAddress,
                  ),
                  textField(cSecondAddress, "任意の建物名",
                      "例) 北１条西2丁目　Leewayビル２階１２３号室", 500),
                  textField(
                    cPhoneNumber,
                    "電話番号",
                    "例) 09012345678",
                    11,
                  ),
                  mySizedBox(15),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          final model = AddressModel(
                            lastName: cLastName.text.trim(),
                            firstName: cFirstName.text.trim(),
                            postalCode: cPostalCode.text,
                            prefectures: cPrefectures.text,
                            //prefectures: cPrefectures.text.trim(),
                            city: cCity.text.trim(),
                            address: cAddress.text,
                            phoneNumber: cPhoneNumber.text,
                            secondAddress: cSecondAddress.text,
                          ).toJson();
                          // todo: firestoreに追加
                          setDataMultiple(
                            EcommerceApp.collectionUser,
                            EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userUID),
                            EcommerceApp.subCollectionAddress,
                            DateTime.now().millisecondsSinceEpoch.toString(),
                            model,
                          );

                          final snack =
                              SnackBar(content: Text("新規お届け先を追加しました"));
                          scaffoldKey.currentState.showSnackBar(snack);
                          FocusScope.of(context).requestFocus(FocusNode());
                          formKey.currentState.reset();
                          Navigator.pop(context);
                          // Route route = MaterialPageRoute(builder: (c) => Address());
                          // Navigator.pushReplacement(context, route);
                        }
                      },
                      icon: Icon(Icons.add_location_alt_outlined),
                      label: Text("追加する"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  MyTextField({Key key, this.hint, this.label, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        8,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(
            0.6,
          )),
        ),
        validator: (val) => val.isEmpty ? "$hintが未記入です" : null,
      ),
    );
  }
}

Widget serachAddress(TextEditingController PostalCode,
    TextEditingController City, TextEditingController prefecture) {
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(7),
            ],
            validator: (val) => val.isEmpty ? "未記入の項目があります" : null,
            maxLines: 1,
            controller: PostalCode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '郵便番号',
              labelStyle: TextStyle(color: Colors.black),
              suffixIcon: IconButton(
                highlightColor: Colors.transparent,
                icon: Container(width: 36.0, child: new Icon(Icons.clear)),
                onPressed: () {
                  PostalCode.clear();
                  City.clear();
                  prefecture.clear();
                },
                splashColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: HexColor("E67928"), //ボタンの背景色
        ),
        child: Text(
          '検索',
        ),
        onPressed: () async {
          var result = await get(Uri.parse(
              'https://zipcloud.ibsnet.co.jp/api/search?zipcode=${PostalCode.text}'));
          Map<String, dynamic> map = jsonDecode(result.body)['results'][0];
          prefecture.text = '${map['address1']}';
          City.text = '${map['address2']}${map['address3']}';
        },
      ),
    ],
  );
}

Widget textField(
    TextEditingController controller, String label, String hint, int length) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(length)],
      // keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        hintText: hint,
      ),
      validator: (val) => val.isEmpty ? null : null,
    ),
  );
}
