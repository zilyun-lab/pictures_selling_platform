// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/CheckBox.dart';
import '../main.dart';

final mainColor = HexColor("E67928");
String selectedItem1 = "レッド";
String selectedItem2 = "無し";
String selectedItem3 = "選択してください";
String selectedFrame = "額縁の有無";
TextEditingController _pricetextEditingController = TextEditingController();
TextEditingController _descriptiontextEditingController =
    TextEditingController();
TextEditingController _stockInfoTextEditingController = TextEditingController();
TextEditingController _shortInfoTextEditingController = TextEditingController();

class PostCard extends StatefulWidget {
  @override
  _OriginalUploadPageState createState() => _OriginalUploadPageState();
}

class _OriginalUploadPageState extends State<PostCard> {
  bool uploading = false;
  double val = 0;
  String _selectShipsDays = '';
  String _selectShipsPayment = '';

  @override
  void initState() {
    super.initState();
  }

  CollectionReference imgRef;
  CollectionReference imgRefUser;
  Reference ref;

  List<String> _imagesURL = [];
  List<File> _image = [];
  final picker = ImagePicker();

  String productID = DateTime.now().millisecondsSinceEpoch.toString();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("e5e2df"),
      appBar: AppBar(
        backgroundColor: HexColor("E5E2E0"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            clearFormInfo();

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (c) => MainPage(),
                ));
          },
        ),
        title: Text(
          "出品ページ（ポストカード）",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
            ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: _image.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Center(
                                child: _image.length <= 4
                                    ? IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () =>
                                            !uploading ? chooseImage() : null)
                                    : IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.add),
                                      ),
                              )
                            : Container(
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image[index - 1]),
                                        fit: BoxFit.cover)),
                              );
                      }),
                ),
                uploadTitle("作品名と作品説明", 8.0),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      infoTiles(
                        hintText: "作品名",
                        controller: _shortInfoTextEditingController,
                        alert: "未記入の項目があります。",
                      ),
                      Divider(),
                      infoTiles(
                        hintText: "作品について",
                        controller: _descriptiontextEditingController,
                        alert: "未記入の項目があります。",
                      ),
                    ],
                  ),
                ),
                uploadTitle("作品情報", 8.0),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: DropdownButtonFormField<String>(
                          dropdownColor: HexColor("#e5e2df"),
                          isExpanded: true,
                          value: selectedItem1,
                          onChanged: (String newValue) {
                            setState(() {
                              selectedItem1 = newValue;
                            });
                          },
                          selectedItemBuilder: (context) {
                            return color1.map((item) {
                              return Text(
                                item.key,
                                style: TextStyle(color: item.value),
                              );
                            }).toList();
                          },
                          items: color1.map((item) {
                            return DropdownMenuItem(
                              value: item.key,
                              child: ListTile(
                                title: Text(
                                  item.key,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Icon(
                                  Icons.waves,
                                  color: item.value,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: DropdownButtonFormField<String>(
                          dropdownColor: HexColor("#e5e2df"),
                          isExpanded: true,
                          value: selectedItem2,
                          onChanged: (String newValue) {
                            setState(() {
                              selectedItem2 = newValue;
                            });
                          },
                          selectedItemBuilder: (context) {
                            return color2.map((item) {
                              return Text(
                                item.key,
                                style: TextStyle(color: item.value),
                              );
                            }).toList();
                          },
                          items: color2.map((item) {
                            return DropdownMenuItem(
                              value: item.key,
                              child: ListTile(
                                title: Text(
                                  item.key,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Icon(
                                  Icons.waves,
                                  color: item.value,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("在庫数"),
                ),
                Container(
                  color: Colors.white,
                  child: infoTiles(
                    keyboard: TextInputType.number,
                    hintText: "在庫数",
                    controller: _stockInfoTextEditingController,
                    alert: "未記入の項目があります。",
                  ),
                ),
                uploadTitle("発送予定日", 8.0),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        RadioButtonGroup(
                          labels: shipsLabel,
                          onSelected: (String selected) {
                            setState(() {
                              _selectShipsDays = selected;
                            });
                            print(_selectShipsDays);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                uploadTitle("送料", 8.0),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        RadioButtonGroup(
                          labels: shipsPayment,
                          onSelected: (String selected) {
                            setState(() {
                              _selectShipsPayment = selected;
                            });
                            print(_selectShipsPayment);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                uploadTitle("出品金額", 8.0),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    trailing: Text("円"),
                    title: TextFormField(
                      validator: (val) =>
                          int.parse(_pricetextEditingController.text) < 500
                              ? "ポストカードは500円からの出品となります。"
                              : null,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                      controller: _pricetextEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "出品金額",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      uploadFile();
                      if (_formKey.currentState.validate()) {
                        confirmItemOfOriginal();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "出品する",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: mainColor),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      final Reference storageReference =
          FirebaseStorage.instance.ref().child("Items");
      ref = storageReference.child("product_$i$productID.jpg");
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _imagesURL.add(value);
          i++;
        });
      });
    }
  }

  saveToFB() {
    final userItemRef = EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("MyUploadItems")
        .doc(productID);
    userItemRef.set({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptiontextEditingController.text.trim(),
      "price": int.parse(_pricetextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": _imagesURL[0],
      "postBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "attribute": "PostCard",
      "Stock": int.parse(_stockInfoTextEditingController.text),
      "id": userItemRef.id,
      "color1": selectedItem1.trim(),
      "color2": selectedItem2.trim(),
      "postName":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "itemHeight": "148",
      "itemWidth": "100",
      "shipsPayment": _selectShipsPayment,
      "shipsDate": _selectShipsDays,
      "finalGetProceeds":
          (int.parse(_pricetextEditingController.text) * 0.85).toInt(),
    });
    final itemRef =
        FirebaseFirestore.instance.collection("items").doc(productID);
    itemRef.set({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptiontextEditingController.text.trim(),
      "price": int.parse(_pricetextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      'thumbnailUrl': _imagesURL[0],
      "postBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "attribute": "PostCard",
      "Stock": int.parse(_stockInfoTextEditingController.text),
      "id": itemRef.id,
      "color1": selectedItem1.trim(),
      "color2": selectedItem2.trim(),
      "postName":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "itemHeight": "148",
      "itemWidth": "100",
      "finalGetProceeds":
          (int.parse(_pricetextEditingController.text) * 0.85).toInt(),
      "shipsPayment": _selectShipsPayment,
      "shipsDate": _selectShipsDays,
    });
    FirebaseFirestore.instance
        .collection("items")
        .doc(productID)
        .collection("itemImages")
        .doc(productID)
        .set({'images': _imagesURL});
    setState(() {
      _imagesURL = [];
    });
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  confirmItemOfOriginal() {
    showDialog(
      context: context,
      builder: (_) {
        return CheckBoxDialog(
            "出品に関する規約について",
            "利用規約の確認",
            "利用規約の確認の確認は行いましたか？\nまた規約に同意しますか？",
            "OK",
            () {
              saveToFB();
              Route route = MaterialPageRoute(
                builder: (c) => MainPage(),
              );
              Navigator.pushReplacement(context, route);
            },
            "キャンセル",
            () {
              Navigator.pop(context);
            });
      },
    );
  }

  clearFormInfo() {
    setState(
      () {
        _descriptiontextEditingController.clear();
        _shortInfoTextEditingController.clear();
        _pricetextEditingController.clear();
      },
    );
  }
}
