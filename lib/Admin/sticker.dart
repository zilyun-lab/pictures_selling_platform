// Dart imports:
import 'dart:io';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_picker/image_picker.dart';
// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/check_box.dart';

import '../main.dart';

final mainColor = HexColor('E67928');
String selectedItem1 = 'レッド';
String selectedItem2 = '無し';
String selectedItem3 = '選択してください';
String selectedFrame = '額縁の有無';
TextEditingController _pricetextEditingController = TextEditingController();

TextEditingController _widthtextEditingController = TextEditingController();
TextEditingController _heighttextEditingController = TextEditingController();
TextEditingController _descriptiontextEditingController =
    TextEditingController();
TextEditingController _stockInfoTextEditingController = TextEditingController();
TextEditingController _shortInfoTextEditingController = TextEditingController();

class sticker extends StatefulWidget {
  @override
  _OriginalUploadPageState createState() => _OriginalUploadPageState();
}

class _OriginalUploadPageState extends State<sticker> {
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
  final List<File> _image = [];
  final picker = ImagePicker();

  String productID = DateTime.now().millisecondsSinceEpoch.toString();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('e5e2df'),
      appBar: AppBar(
        backgroundColor: HexColor('E5E2E0'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            clearFormInfo();

            Navigator.pop(context);
          },
        ),
        title: const Text(
          '出品ページ（ステッカー）',
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
                        child: const Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
            ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: _image.length + 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Center(
                                child: _image.length <= 4
                                    ? IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () =>
                                            !uploading ? chooseImage() : null)
                                    : IconButton(
                                        icon: const Icon(Icons.add), onPressed: () {  },
                                      ),
                              )
                            : Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image[index - 1]),
                                        fit: BoxFit.cover)),
                              );
                      }),
                ),
                uploadTitle('作品名と作品説明'),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      infoTiles(
                        hintText: '作品名',
                        controller: _shortInfoTextEditingController,
                        alert: '未記入の項目があります。',
                      ),
                      const Divider(),
                      infoTiles(
                        hintText: '作品について',
                        controller: _descriptiontextEditingController,
                        alert: '未記入の項目があります。',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                uploadTitle('作品情報'),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: DropdownButtonFormField<String>(
                          dropdownColor: HexColor('#e5e2df'),
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
                                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                          dropdownColor: HexColor('#e5e2df'),
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
                                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                uploadTitle('作品サイズ(縦 × 横)'),
                Container(
                  color: Colors.white,
                  child: Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                                  _heighttextEditingController.text.isEmpty
                                      ? '未記入の項目があります。'
                                      : null,
                              style: const TextStyle(color: Colors.deepPurpleAccent),
                              controller: _heighttextEditingController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'mm',
                                hintText: 'mm',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text('x'),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                                  _widthtextEditingController.text.isEmpty
                                      ? '未記入の項目があります。'
                                      : null,
                              style: const TextStyle(color: Colors.deepPurpleAccent),
                              controller: _widthtextEditingController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'mm',
                                hintText: 'mm',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('在庫数'),
                ),
                Container(
                  color: Colors.white,
                  child: infoTiles(
                    keyboard: TextInputType.number,
                    hintText: '在庫数',
                    controller: _stockInfoTextEditingController,
                    alert: '未記入の項目があります。',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                uploadTitle('発送予定日'),
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
                const SizedBox(
                  height: 20,
                ),
                uploadTitle('送料'),
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
                const SizedBox(
                  height: 20,
                ),
                uploadTitle('出品金額'),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    trailing: const Text('円'),
                    title: TextFormField(
                      validator: (val) =>
                          int.parse(_pricetextEditingController.text) < 500
                              ? 'ステッカーは500円からの出品となります。'
                              : null,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      controller: _pricetextEditingController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '出品金額',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      uploadFile();
                      if (_formKey.currentState.validate()) {
                        confirmItemOfOriginal();
                        print(_imagesURL);
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: mainColor),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '出品する',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
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
    var i = 1;

    for (final img in _image) {
      setState(() {
        val = i / _image.length;
      });
      final storageReference =
          FirebaseStorage.instance.ref().child('Items');
      ref = storageReference.child('product_$i$productID.jpg');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _imagesURL.add(value);
          i++;
        });
      });
    }
  }

  dynamic saveToFB() {
    final userItemRef = EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection('MyUploadItems')
        .doc(productID);
    userItemRef.set({
      'shortInfo': _shortInfoTextEditingController.text.trim(),
      'longDescription': _descriptiontextEditingController.text.trim(),
      'price': int.parse(_pricetextEditingController.text),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': _imagesURL[0],
      'postBy': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      'attribute': 'Sticker',
      'Stock': int.parse(_stockInfoTextEditingController.text),
      'id': userItemRef.id,
      'color1': selectedItem1.trim(),
      'color2': selectedItem2.trim(),
      'postName':
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      'itemWidth': _widthtextEditingController.text,
      'itemHeight': _heighttextEditingController.text,
      'shipsPayment': _selectShipsPayment,
      'shipsDate': _selectShipsDays,
      'finalGetProceeds':
          (int.parse(_pricetextEditingController.text) * 0.85).toInt(),
    });
    final itemRef =
        FirebaseFirestore.instance.collection('items').doc(productID);
    itemRef.set({
      'shortInfo': _shortInfoTextEditingController.text.trim(),
      'longDescription': _descriptiontextEditingController.text.trim(),
      'price': int.parse(_pricetextEditingController.text),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': _imagesURL[0],
      'postBy': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      'attribute': 'Sticker',
      'Stock': int.parse(_stockInfoTextEditingController.text),
      'id': itemRef.id,
      'color1': selectedItem1.trim(),
      'color2': selectedItem2.trim(),
      'postName':
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      'itemWidth': _widthtextEditingController.text,
      'itemHeight': _heighttextEditingController.text,
      'finalGetProceeds':
          (int.parse(_pricetextEditingController.text) * 0.85).toInt(),
      'shipsPayment': _selectShipsPayment,
      'shipsDate': _selectShipsDays,
    });
    FirebaseFirestore.instance
        .collection('items')
        .doc(productID)
        .collection('itemImages')
        .doc(productID)
        .set({'images': _imagesURL});
    setState(() {
      _imagesURL = [];
    });
  }

  dynamic chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) await retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final response = await picker.getLostData();
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

  dynamic confirmItemOfOriginal() {
    showDialog(
      context: context,
      builder: (_) {
        return CheckBoxDialog(
            '出品に関する規約について',
            '利用規約の確認',
            '利用規約の確認の確認は行いましたか？\nまた規約に同意しますか？',
            'OK',
            () {
              uploadFile();
              saveToFB();
              final Route route = MaterialPageRoute(
                builder: (c) => MainPage(),
              );
              Navigator.pushReplacement(context, route);
            },
            'キャンセル',
            () {
              Navigator.pop(context);
            });
      },
    );
  }

  dynamic clearFormInfo() {
    setState(
      () {
        _descriptiontextEditingController.clear();
        _shortInfoTextEditingController.clear();
        _pricetextEditingController.clear();
      },
    );
  }
}
