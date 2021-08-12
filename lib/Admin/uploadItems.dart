// Dart imports:
import 'dart:io';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/CheckBox.dart';
import 'package:selling_pictures_platform/main.dart';

class OriginalUploadPage extends HookConsumerWidget {
  OriginalUploadPage({Key key}) : super(key: key);

  final selectedItem1 = useState("レッド");
  final selectedItem2 = useState("無し");
  final selectedItem3 = useState("選択してください");
  final selectedFrame = useState("額縁の有無");
  final _pricetextEditingController = useTextEditingController();
  final _widthtextEditingController = useTextEditingController();
  final _heighttextEditingController = useTextEditingController();
  final _descriptiontextEditingController = useTextEditingController();
  final _shortInfoTextEditingController = useTextEditingController();
  final uploading = useState(false);
  final val = useState(0.0);
  final _selectShipsDays = useState('');
  final _selectShipsPayment = useState('');
  final _selectFrame = useState('');
  CollectionReference imgRef;
  CollectionReference imgRefUser;
  Reference ref;

  List<String> _imagesURL = [];
  List<File> _image = [];
  final picker = ImagePicker();

  String productID = DateTime.now().millisecondsSinceEpoch.toString();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            clearFormInfo();

            Navigator.pop(context);
          },
        ),
        title: Text(
          "出品ページ(原画)",
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
            uploading.value
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
                          value: val.value,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        )
                      ],
                    ),
                  )
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
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: NeumorphicButton(
                                            style:
                                                NeumorphicStyle(color: bgColor),
                                            child:
                                                Center(child: Icon(Icons.add)),
                                            onPressed: () => !uploading.value
                                                ? chooseImage()
                                                : null),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: NeumorphicButton(
                                          style:
                                              NeumorphicStyle(color: bgColor),
                                          child: Center(child: Icon(Icons.add)),
                                        )))
                            : Neumorphic(
                                style: NeumorphicStyle(color: bgColor),
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(_image[index - 1]),
                                          fit: BoxFit.cover)),
                                ),
                              );
                      }),
                ),
                uploadTitle("作品名と作品説明"),
                Column(
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
                uploadTitle("作品情報"),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(border: InputBorder.none),
                        dropdownColor: HexColor("#e5e2df"),
                        isExpanded: true,
                        value: selectedItem1.value,
                        onChanged: (String newValue) {
                          selectedItem1.value = newValue;
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
                        decoration: InputDecoration(border: InputBorder.none),
                        dropdownColor: HexColor("#e5e2df"),
                        isExpanded: true,
                        value: selectedItem2.value,
                        onChanged: (String newValue) {
                          selectedItem2.value = newValue;
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
                uploadTitle("作品サイズ(縦 × 横)"),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
                          child: Neumorphic(
                            style: NeumorphicStyle(color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    _heighttextEditingController.text.isEmpty
                                        ? "未記入の項目があります。"
                                        : null,
                                style:
                                    TextStyle(color: Colors.deepPurpleAccent),
                                controller: _heighttextEditingController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "mm",
                                  hintText: "mm",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Neumorphic(
                          style: NeumorphicStyle(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("x"),
                          )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
                          child: Neumorphic(
                            style: NeumorphicStyle(color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    _widthtextEditingController.text.isEmpty
                                        ? "未記入の項目があります。"
                                        : null,
                                style:
                                    TextStyle(color: Colors.deepPurpleAccent),
                                controller: _widthtextEditingController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "mm",
                                  hintText: "mm",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                uploadTitle("額縁の有無"),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Neumorphic(
                    style: NeumorphicStyle(color: Colors.white),
                    child: RadioButtonGroup(
                      labels: isFrame,
                      onSelected: (String selected) {
                        _selectFrame.value = selected;

                        print(_selectFrame.value);
                      },
                    ),
                  ),
                ),
                uploadTitle("発送予定日"),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Neumorphic(
                    style: NeumorphicStyle(color: Colors.white),
                    child: RadioButtonGroup(
                      labels: shipsLabel,
                      onSelected: (String selected) {
                        _selectShipsDays.value = selected;

                        print(_selectShipsDays.value);
                      },
                    ),
                  ),
                ),
                uploadTitle("送料"),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Neumorphic(
                    style: NeumorphicStyle(color: Colors.white),
                    child: RadioButtonGroup(
                      labels: shipsPayment,
                      onSelected: (String selected) {
                        _selectShipsPayment.value = selected;
                      },
                    ),
                  ),
                ),
                uploadTitle("出品金額"),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Neumorphic(
                    style: NeumorphicStyle(color: Colors.white),
                    child: ListTile(
                      trailing: Text("円"),
                      title: TextFormField(
                        validator: (val) =>
                            int.parse(_pricetextEditingController.text) < 5000
                                ? "原画は5000円からの出品となります。"
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
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      print(_imagesURL);
                      uploadFile().whenComplete(() => print("アップロード"));

                      if (_formKey.currentState.validate()) {
                        confirmItemOfOriginal(context);
                        print(_imagesURL);
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
                    style: ElevatedButton.styleFrom(primary: mainColorOfLEEWAY),
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
      val.value = i / _image.length;

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
      "attribute": "Original",
      "Stock": 1,
      "id": userItemRef.id,
      "color1": selectedItem1.value.trim(),
      "color2": selectedItem2.value.trim(),
      "postName":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "shipsDate": _selectShipsDays,
      "itemWidth": _widthtextEditingController.text,
      "itemHeight": _heighttextEditingController.text,
      "shipsPayment": _selectShipsPayment,
      "Frame": selectedFrame.value.trim(),
    });
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("MyUploadItems")
        .doc(productID)
        .collection("itemImages")
        .add({'image': _imagesURL});
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
      "attribute": "Original",
      "Stock": 1,
      "id": itemRef.id,
      "color1": selectedItem1.value.trim(),
      "color2": selectedItem2.value.trim(),
      "itemWidth": _widthtextEditingController.text,
      "itemHeight": _heighttextEditingController.text,
      "Frame": selectedFrame.value.trim(),
      "postName":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "shipsDate": _selectShipsDays,
      "finalGetProceeds":
          (int.parse(_pricetextEditingController.text) * 0.7).toInt(),
      "shipsPayment": _selectShipsPayment
    });
    FirebaseFirestore.instance
        .collection("items")
        .doc(productID)
        .collection("itemImages")
        .doc(productID)
        .set({'images': _imagesURL});

    _imagesURL = [];
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    _image.add(File(pickedFile?.path));

    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _image.add(File(response.file.path));
    } else {
      print(response.file);
    }
  }

  confirmItemOfOriginal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return CheckBoxDialog(
            "出品に関する規約について",
            "利用規約の確認",
            "利用規約の確認の確認は行いましたか？\nまた規約に同意しますか？",
            "OK",
            () {
              uploadFile();
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
    _descriptiontextEditingController.clear();
    _shortInfoTextEditingController.clear();
    _pricetextEditingController.clear();
  }
}
