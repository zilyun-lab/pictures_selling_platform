import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/CheckBox.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selling_pictures_platform/main.dart';

final mainColor = HexColor("E67928");

Widget infoTile({
  TextEditingController controller,
  String hintText,
  Widget trailing,
  String alert,
  TextInputType keyboard,
}) {
  return ListTile(
    trailing: trailing,
    title: TextFormField(
      keyboardType: keyboard,
      validator: (val) => controller.text.isEmpty ? alert : null,
      style: TextStyle(color: Colors.deepPurpleAccent),
      controller: controller,
      decoration: InputDecoration(
        // labelStyle: TextStyle(color: mainColor),
        border: InputBorder.none,
        labelText: hintText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    ),
  );
}

List<String> shipsDays = ["選択してください", "1~2日後", "2~3日後", "4~7日後"];

List<MapEntry<String, Color>> color1 = [
  MapEntry("レッド", Colors.redAccent),
  MapEntry(
    "ブルー",
    Colors.blueAccent,
  ),
  MapEntry(
    "グリーン",
    Colors.green,
  ),
  MapEntry(
    "イエロー",
    Colors.yellowAccent,
  ),
  MapEntry(
    "ホワイト",
    Colors.white,
  ),
  MapEntry(
    "ブラック",
    Colors.black,
  ),
  MapEntry(
    "パープル",
    Colors.deepPurple,
  ),
  MapEntry(
    "グレー",
    Colors.grey,
  ),
  MapEntry(
    "ピンク",
    Colors.pinkAccent,
  ),
  MapEntry(
    "オレンジ",
    Colors.deepOrangeAccent,
  ),
  MapEntry(
    "ブラウン",
    Colors.brown,
  ),
  MapEntry(
    "その他",
    Colors.black54,
  ),
];
List<MapEntry<String, Color>> color2 = [
  MapEntry("レッド", Colors.redAccent),
  MapEntry(
    "ブルー",
    Colors.blueAccent,
  ),
  MapEntry(
    "グリーン",
    Colors.green,
  ),
  MapEntry(
    "イエロー",
    Colors.yellowAccent,
  ),
  MapEntry(
    "ホワイト",
    Colors.white54,
  ),
  MapEntry(
    "ブラック",
    Colors.black,
  ),
  MapEntry(
    "パープル",
    Colors.deepPurple,
  ),
  MapEntry(
    "グレー",
    Colors.grey,
  ),
  MapEntry(
    "ピンク",
    Colors.pinkAccent,
  ),
  MapEntry(
    "オレンジ",
    Colors.deepOrangeAccent,
  ),
  MapEntry(
    "ブラウン",
    Colors.brown,
  ),
  MapEntry(
    "無し",
    Colors.black54,
  ),
];
List<String> frame = ["額縁の有無", "有り", "無し"];

class OriginalUploadPage extends StatefulWidget {
  @override
  _OriginalUploadPageState createState() => _OriginalUploadPageState();
}

class _OriginalUploadPageState extends State<OriginalUploadPage> {
  bool uploading = false;
  double val = 0;

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
  String selectedItem1 = "レッド";
  String selectedItem2 = "無し";
  String selectedItem3 = "選択してください";
  String selectedFrame = "額縁の有無";
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _widthtextEditingController = TextEditingController();
  TextEditingController _heighttextEditingController = TextEditingController();
  TextEditingController _descriptiontextEditingController =
      TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
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
            Route route = MaterialPageRoute(
              builder: (c) => MainPage(),
            );
            Navigator.pushReplacement(context, route);
          },
        ),
        title: Text(
          "出品ページ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 5),
              child: Text("作品名と作品説明"),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  infoTile(
                    hintText: "作品名",
                    controller: _shortInfoTextEditingController,
                    alert: "未記入の項目があります。",
                  ),
                  Divider(),
                  infoTile(
                    hintText: "作品について",
                    controller: _descriptiontextEditingController,
                    alert: "未記入の項目があります。",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 5),
              child: Text("作品情報"),
            ),
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
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: DropdownButtonFormField<String>(
                      validator: (val) => selectedFrame.trim() == "額縁の有無"
                          ? "額縁の有無を選択してください。"
                          : null,
                      dropdownColor: HexColor("#e5e2df"),
                      isExpanded: true,
                      value: selectedFrame,
                      onChanged: (String newValue) {
                        setState(() {
                          selectedFrame = newValue;
                        });
                      },
                      selectedItemBuilder: (context) {
                        return frame.map((String item) {
                          return Text(
                            item,
                            style: TextStyle(),
                          );
                        }).toList();
                      },
                      items: frame.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: ListTile(
                            title: Text(
                              item,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 5),
              child: Text("作品サイズ(縦 × 横)"),
            ),
            Container(
              color: Colors.white,
              child: Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              _heighttextEditingController.text.isEmpty
                                  ? "未記入の項目があります。"
                                  : null,
                          style: TextStyle(color: Colors.deepPurpleAccent),
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
                    Text("x"),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              _widthtextEditingController.text.isEmpty
                                  ? "未記入の項目があります。"
                                  : null,
                          style: TextStyle(color: Colors.deepPurpleAccent),
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("発送予定日"),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: DropdownButtonFormField<String>(
                  dropdownColor: HexColor("#e5e2df"),
                  isExpanded: true,
                  value: selectedItem3,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedItem3 = newValue;
                    });
                  },
                  selectedItemBuilder: (context) {
                    return shipsDays.map((item) {
                      return Text(
                        item,
                        style: TextStyle(color: Colors.black),
                      );
                    }).toList();
                  },
                  items: shipsDays.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: ListTile(
                        title: Text(
                          item,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("出品金額"),
            ),
            Container(
              color: Colors.white,
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
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    confirmItemOfOriginal();
                    print(_imagesURL);
                  }
                },
                child: Text("出品する"),
                style: ElevatedButton.styleFrom(primary: mainColor),
              ),
            ),
            SizedBox(
              height: 50,
            )
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
          print(_imagesURL);
        });
      });
    }
  }

  saveToFB() {
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
      "color1": selectedItem1.trim(),
      "color2": selectedItem2.trim(),
      "itemWidth": _widthtextEditingController.text,
      "itemHeight": _heighttextEditingController.text,
      "Frame": selectedFrame.trim(),
      "postName":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "shipsDate": selectedItem3.trim()
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
    setState(
      () {
        _descriptiontextEditingController.clear();
        _shortInfoTextEditingController.clear();
        _pricetextEditingController.clear();
      },
    );
  }
}

class Sticker extends StatefulWidget {
  @override
  _StickerState createState() => _StickerState();
}

class _StickerState extends State<Sticker>
    with AutomaticKeepAliveClientMixin<Sticker> {
  String selectedItem1 = "レッド";
  String selectedItem2 = "無し";
  String selectedItem3 = "選択してください";
  String selectedFrame = "額縁の有無";
  String holder = "";

  void getValue() {
    setState(() {
      holder = selectedItem1;
    });
  }

  bool get wantKeepAlive => true;
  File file;
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _widthtextEditingController = TextEditingController();
  TextEditingController _heighttextEditingController = TextEditingController();
  TextEditingController _descriptiontextEditingController =
      TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  TextEditingController _stockInfoTextEditingController =
      TextEditingController();
  String productID = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return displayUploadFormScreen();
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (con) {
        return SimpleDialog(
          title: Text(
            "商品画像",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                "写真を撮る",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                capturePhotoWithCamera();
              },
            ),
            SimpleDialogOption(
              child: Text(
                "アルバム",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                pickPhotoFromGallery();
              },
            ),
            SimpleDialogOption(
              child: Text(
                "キャンセル",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );

    setState(
      () {
        file = File(pickedFile.path);
      },
    );
  }

  pickPhotoFromGallery() async {
    // Navigator.pop(context);
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    setState(
      () {
        file = File(pickedFile.path);
      },
    );
  }

  displayUploadFormScreen() {
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
          },
        ),
        title: Text(
          "ステッカー出品ページ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: original(),
      ),
    );
  }

  original() {
    return ListView(
      children: [
        uploading
            ? Center(
                child: circularProgress(),
              )
            : Text(
                "",
              ),
        Container(
          height: 250,
          child: Container(
            child: InkWell(
              onTap: () {
                takeImage(context);
              },
              child: Center(
                child: Container(
                  decoration: file == null
                      ? null
                      : BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.scaleDown,
                            //fit: BoxFit.cover,
                          ),
                        ),
                  child: file == null
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            color: HexColor("E67928"),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: MediaQuery.of(context).size.width * 0.15,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 5),
          child: Text("作品名と作品説明"),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              infoTile(
                hintText: "作品名",
                controller: _shortInfoTextEditingController,
                alert: "未記入の項目があります。",
              ),
              Divider(),
              infoTile(
                hintText: "作品について",
                controller: _descriptiontextEditingController,
                alert: "未記入の項目があります。",
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 5),
          child: Text("作品情報"),
        ),
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
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("在庫数"),
        ),
        Container(
          color: Colors.white,
          child: infoTile(
            keyboard: TextInputType.number,
            hintText: "在庫数",
            controller: _stockInfoTextEditingController,
            alert: "未記入の項目があります。",
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 5),
          child: Text("作品サイズ(縦 × 横)"),
        ),
        Container(
          color: Colors.white,
          child: Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          _heighttextEditingController.text.isEmpty
                              ? "未記入の項目があります。"
                              : null,
                      style: TextStyle(color: Colors.deepPurpleAccent),
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
                Text("x"),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          _widthtextEditingController.text.isEmpty
                              ? "未記入の項目があります。"
                              : null,
                      style: TextStyle(color: Colors.deepPurpleAccent),
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
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("発送予定日"),
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: DropdownButtonFormField<String>(
              dropdownColor: HexColor("#e5e2df"),
              isExpanded: true,
              value: selectedItem3,
              onChanged: (String newValue) {
                setState(() {
                  selectedItem3 = newValue;
                });
              },
              selectedItemBuilder: (context) {
                return shipsDays.map((item) {
                  return Text(
                    item,
                    style: TextStyle(color: Colors.black),
                  );
                }).toList();
              },
              items: shipsDays.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: ListTile(
                    title: Text(
                      item,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("出品金額"),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            trailing: Text("円"),
            title: TextFormField(
              validator: (val) =>
                  int.parse(_pricetextEditingController.text) < 300
                      ? "ステッカーは300円からの出品となります。"
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
              if (_formKey.currentState.validate()) {
                confirmItemOfOriginal();
              }
            },
            child: Text("出品する"),
            style: ElevatedButton.styleFrom(primary: mainColor),
          ),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
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
              uploadImageAndSaveItemInfoOriginal();
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
        file = null;
        _descriptiontextEditingController.clear();
        _shortInfoTextEditingController.clear();
        _pricetextEditingController.clear();
      },
    );
  }

  uploadImageAndSaveItemInfoOriginal() async {
    setState(
      () {
        uploading = true;
      },
    );
    String imageDownLoadUrl = await uploadingItemImageOriginal(file);

    saveItemInfoOriginalToItems(imageDownLoadUrl);
    saveItemInfoOriginalToUsers(imageDownLoadUrl);
    Route route = MaterialPageRoute(builder: (c) => MainPage());
    Navigator.pushReplacement(context, route);
  }

  Future<String> uploadingItemImageOriginal(mFileImage) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask =
        storageReference.child("product_$productID.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfoOriginalToItems(String downloadUrl) {
    final itemRef =
        FirebaseFirestore.instance.collection("items").doc(productID);
    itemRef.set({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptiontextEditingController.text.trim(),
      "price": int.parse(_pricetextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "postBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "attribute": "Sticker",
      "Stock": int.parse(_stockInfoTextEditingController.text),
      "id": itemRef.id,
      "color1": selectedItem1.trim(),
      "color2": selectedItem2.trim(),
      "itemWidth": _widthtextEditingController.text,
      "itemHeight": _heighttextEditingController.text,
      "Frame": selectedFrame.trim(),
      "postName":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "shipsDate": selectedItem3.trim()
    });
  }

  saveItemInfoOriginalToUsers(String downloadUrl) {
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
      "thumbnailUrl": downloadUrl,
      "postBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "attribute": "Sticker",
      "Stock": int.parse(_stockInfoTextEditingController.text),
      "id": userItemRef.id,
      "isPayment": "inComplete",
      "isDelivery": "inComplete",
      "color1": selectedItem1.trim(),
      "color2": selectedItem2.trim(),
      "itemWidth": _widthtextEditingController.text,
      "itemHeight": _heighttextEditingController.text,
      "Frame": selectedFrame.trim(),
      "postName":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "shipsDate": selectedItem3.trim()
    });
    setState(() {
      file = null;
      uploading = false;
      productID = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptiontextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _pricetextEditingController.clear();
    });
  }
}

class PostCard extends StatefulWidget {
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with AutomaticKeepAliveClientMixin<PostCard> {
  String selectedItem1 = "レッド";
  String selectedItem2 = "無し";
  String selectedItem3 = "選択してください";
  String selectedFrame = "額縁の有無";
  String holder = "";

  void getValue() {
    setState(() {
      holder = selectedItem1;
    });
  }

  bool get wantKeepAlive => true;
  File file;
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _widthtextEditingController = TextEditingController();
  TextEditingController _heighttextEditingController = TextEditingController();
  TextEditingController _descriptiontextEditingController =
      TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  TextEditingController _stockInfoTextEditingController =
      TextEditingController();
  String productID = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return displayUploadFormScreen();
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (con) {
        return SimpleDialog(
          title: Text(
            "商品画像",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                "写真を撮る",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                capturePhotoWithCamera();
              },
            ),
            SimpleDialogOption(
              child: Text(
                "アルバム",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                pickPhotoFromGallery();
              },
            ),
            SimpleDialogOption(
              child: Text(
                "キャンセル",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );

    setState(
      () {
        file = File(pickedFile.path);
      },
    );
  }

  pickPhotoFromGallery() async {
    // Navigator.pop(context);
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    setState(
      () {
        file = File(pickedFile.path);
      },
    );
  }

  displayUploadFormScreen() {
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
            Route route = MaterialPageRoute(
              builder: (c) => MainPage(),
            );
            Navigator.pushReplacement(context, route);
          },
        ),
        title: Text(
          "ポストカード出品ページ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: original(),
      ),
    );
  }

  original() {
    return ListView(
      children: [
        uploading
            ? Center(
                child: circularProgress(),
              )
            : Text(
                "",
              ),
        Container(
          height: 250,
          child: Container(
            child: InkWell(
              onTap: () {
                takeImage(context);
              },
              child: Center(
                child: Container(
                  decoration: file == null
                      ? null
                      : BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.scaleDown,
                            //fit: BoxFit.cover,
                          ),
                        ),
                  child: file == null
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            color: HexColor("E67928"),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: MediaQuery.of(context).size.width * 0.15,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 5),
          child: Text("作品名と作品説明"),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              infoTile(
                hintText: "作品名",
                controller: _shortInfoTextEditingController,
                alert: "未記入の項目があります。",
              ),
              Divider(),
              infoTile(
                hintText: "作品について",
                controller: _descriptiontextEditingController,
                alert: "未記入の項目があります。",
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 5),
          child: Text("作品情報"),
        ),
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
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("在庫数"),
        ),
        Container(
          color: Colors.white,
          child: infoTile(
            keyboard: TextInputType.number,
            hintText: "在庫数",
            controller: _stockInfoTextEditingController,
            alert: "未記入の項目があります。",
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("発送予定日"),
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: DropdownButtonFormField<String>(
              dropdownColor: HexColor("#e5e2df"),
              isExpanded: true,
              value: selectedItem3,
              onChanged: (String newValue) {
                setState(() {
                  selectedItem3 = newValue;
                });
              },
              selectedItemBuilder: (context) {
                return shipsDays.map((item) {
                  return Text(
                    item,
                    style: TextStyle(color: Colors.black),
                  );
                }).toList();
              },
              items: shipsDays.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: ListTile(
                    title: Text(
                      item,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("出品金額"),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            trailing: Text("円"),
            title: TextFormField(
              validator: (val) =>
                  int.parse(_pricetextEditingController.text) < 300
                      ? "ポストカードは300円からの出品となります。"
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
              if (_formKey.currentState.validate()) {
                confirmItemOfOriginal();
              }
            },
            child: Text("出品する"),
            style: ElevatedButton.styleFrom(primary: mainColor),
          ),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
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
              uploadImageAndSaveItemInfoOriginal();
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
        file = null;
        _descriptiontextEditingController.clear();
        _shortInfoTextEditingController.clear();
        _pricetextEditingController.clear();
      },
    );
  }

  uploadImageAndSaveItemInfoOriginal() async {
    setState(
      () {
        uploading = true;
      },
    );
    String imageDownLoadUrl = await uploadingItemImageOriginal(file);

    saveItemInfoOriginalToItems(imageDownLoadUrl);
    saveItemInfoOriginalToUsers(imageDownLoadUrl);
    Route route = MaterialPageRoute(builder: (c) => MainPage());
    Navigator.pushReplacement(context, route);
  }

  Future<String> uploadingItemImageOriginal(mFileImage) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask =
        storageReference.child("product_$productID.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfoOriginalToItems(String downloadUrl) {
    final itemRef =
        FirebaseFirestore.instance.collection("items").doc(productID);
    itemRef.set({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptiontextEditingController.text.trim(),
      "price": int.parse(_pricetextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "postBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "attribute": "PostCard",
      "Stock": int.parse(_stockInfoTextEditingController.text),
      "id": itemRef.id,
      "color1": selectedItem1.trim(),
      "color2": selectedItem2.trim(),
      "postName":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "shipsDate": selectedItem3.trim(),
      "itemWidth": "100",
      "itemHeight": "148",
    });
  }

  saveItemInfoOriginalToUsers(String downloadUrl) {
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
      "thumbnailUrl": downloadUrl,
      "postBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "attribute": "PostCard",
      "Stock": int.parse(_stockInfoTextEditingController.text),
      "id": userItemRef.id,
      "isPayment": "inComplete",
      "isDelivery": "inComplete",
      "color1": selectedItem1.trim(),
      "color2": selectedItem2.trim(),
      "postName":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "shipsDate": selectedItem3.trim(),
      "itemWidth": "100",
      "itemHeight": "148",
    });
    setState(() {
      file = null;
      uploading = false;
      productID = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptiontextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _pricetextEditingController.clear();
    });
  }
}
