import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  List<String> color1 = [
    "レッド",
    "ブルー",
    "グリーン",
    "イエロー",
    "ホワイト",
    "ブラック",
    "パープル",
    "グレー",
    "ピンク",
    "オレンジ",
    "ブラウン",
    "カラフル",
  ];
  List<String> color2 = [
    "レッド",
    "ブルー",
    "グリーン",
    "イエロー",
    "ホワイト",
    "ブラック",
    "パープル",
    "グレー",
    "ピンク",
    "オレンジ",
    "ブラウン",
    "無し",
  ];
  String selectedItem1 = "レッド";
  String selectedItem2 = "無し";
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
  String productID = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadFormScreen() : displayUploadFormScreen();
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
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: HexColor("e5e2df"),
          appBar: AppBar(
            bottom: new TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.crop_original,
                  ),
                  text: "原画を出品",
                ),
                Tab(
                  icon: Icon(
                    Icons.copy,
                  ),
                  text: "コピーを出品",
                ),
              ],
              indicatorColor: Colors.black,
              indicatorWeight: 2.5,
            ),
            backgroundColor: HexColor("E5E2E0"),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
              ),
              onPressed: () {
                clearFormInfo();
                Route route = MaterialPageRoute(
                  builder: (c) => StoreHome(),
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
          body: TabBarView(children: [
            original(),
            copy(),
          ]),
        ),
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
          height: 230,
          width: MediaQuery.of(
                context,
              ).size.width *
              0.8,
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
                    ? Icon(
                        Icons.add_a_photo_outlined,
                        size: MediaQuery.of(context).size.width * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 12,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            leading: Icon(
              Icons.category,
              color: Colors.black,
            ),
            title: Container(
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "作品名",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            leading: Icon(
              Icons.article,
              color: Colors.black,
            ),
            title: Container(
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptiontextEditingController,
                decoration: InputDecoration(
                  hintText: "作品について",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 86.0, right: 30),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedItem1,
            onChanged: (String newValue) {
              setState(() {
                selectedItem1 = newValue;
              });
            },
            selectedItemBuilder: (context) {
              return color1.map((String item) {
                return Text(
                  item,
                  style: TextStyle(color: Colors.black),
                );
              }).toList();
            },
            items: color1.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: item == selectedItem1
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : TextStyle(fontWeight: FontWeight.normal),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 86.0, right: 30, top: 30),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedItem2,
            onChanged: (String newValue) {
              setState(() {
                selectedItem2 = newValue;
              });
            },
            selectedItemBuilder: (context) {
              return color2.map((String item) {
                return Text(
                  item,
                  style: TextStyle(color: Colors.black),
                );
              }).toList();
            },
            items: color2.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: item == selectedItem2
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : TextStyle(fontWeight: FontWeight.normal),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: FaIcon(
                              FontAwesomeIcons.textHeight,
                              color: Colors.black,
                            ),
                          ),
                          title: Container(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.black),
                              controller: _heighttextEditingController,
                              decoration: InputDecoration(
                                hintText: "縦幅",
                                labelText: "縦幅",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text("mm"),
                    ],
                  ),
                ),
              ),
              Text("×"),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: FaIcon(
                              FontAwesomeIcons.textWidth,
                              color: Colors.black,
                            ),
                          ),
                          title: Container(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.black),
                              controller: _widthtextEditingController,
                              decoration: InputDecoration(
                                hintText: "横幅",
                                labelText: "横幅",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text("mm")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: FaIcon(
                FontAwesomeIcons.yenSign,
                color: Colors.black,
              ),
            ),
            title: Container(
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                controller: _pricetextEditingController,
                decoration: InputDecoration(
                  hintText: "出品金額",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () => confirmItemOfOriginal(),
            child: Text("出品する"),
            style: ElevatedButton.styleFrom(primary: Colors.black),
          ),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }

  copy() {
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
          height: 230,
          width: MediaQuery.of(
                context,
              ).size.width *
              0.8,
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
                          fit: BoxFit.fitHeight,
                          //fit: BoxFit.cover,
                        ),
                      ),
                child: file == null
                    ? Icon(
                        Icons.add_a_photo_outlined,
                        size: MediaQuery.of(context).size.width * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 12,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            leading: Icon(
              Icons.category,
              color: Colors.black,
            ),
            title: Container(
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "作品名",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            leading: Icon(
              Icons.article,
              color: Colors.black,
            ),
            title: Container(
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptiontextEditingController,
                decoration: InputDecoration(
                  hintText: "作品について",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 86.0, right: 30),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedItem1,
            onChanged: (String newValue) {
              setState(() {
                selectedItem1 = newValue;
              });
            },
            selectedItemBuilder: (context) {
              return color1.map((String item) {
                return Text(
                  item,
                  style: TextStyle(color: Colors.black),
                );
              }).toList();
            },
            items: color1.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: item == selectedItem1
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : TextStyle(fontWeight: FontWeight.normal),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 86.0, right: 30, top: 30),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedItem2,
            onChanged: (String newValue) {
              setState(() {
                selectedItem2 = newValue;
              });
            },
            selectedItemBuilder: (context) {
              return color2.map((String item) {
                return Text(
                  item,
                  style: TextStyle(color: Colors.black),
                );
              }).toList();
            },
            items: color2.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: item == selectedItem2
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : TextStyle(fontWeight: FontWeight.normal),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: FaIcon(
                FontAwesomeIcons.yenSign,
                color: Colors.black,
              ),
            ),
            title: Container(
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                controller: _pricetextEditingController,
                decoration: InputDecoration(
                  hintText: "出品金額",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () => confirmItemOfCopy(),
            child: Text("出品する"),
            style: ElevatedButton.styleFrom(primary: Colors.black),
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  confirmItemOfCopy() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
              Text(
                "出品に関する規約について",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Container(child: Text("悪いけど権利はぜーーーーーんぶ俺らのモンだから（笑）")),
          actions: <Widget>[
            // ボタン領域
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                uploadImageAndSaveItemInfoCopy();
              },
            ),
          ],
        );
      },
    );
  }

  confirmItemOfOriginal() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
              Text(
                "出品に関する規約について",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Container(
              child: Text("悪いけど権利はぜーーーーーんぶ俺らのモンだから（笑）\n原画は一枚のみの出品になります。")),
          actions: <Widget>[
            // ボタン領域
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                uploadImageAndSaveItemInfoOriginal();
              },
            ),
          ],
        );
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
    Route route = MaterialPageRoute(builder: (c) => StoreHome());
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
      "attribute": "Original",
      "Stock": 1,
      "id": itemRef.id,
      "color1": selectedItem1.trim(),
      "color2": selectedItem2.trim(),
      "itemWidth": _widthtextEditingController.text,
      "itemHeight": _heighttextEditingController.text
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
      "attribute": "Original",
      "Stock": 1,
      "id": userItemRef.id,
      "isPayment": "inComplete",
      "isDelivery": "inComplete",
      "color1": selectedItem1.trim(),
      "color2": selectedItem2.trim(),
      "itemWidth": _widthtextEditingController.text,
      "itemHeight": _heighttextEditingController.text
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

  uploadImageAndSaveItemInfoCopy() async {
    setState(
      () {
        uploading = true;
      },
    );
    String imageDownLoadUrl = await uploadingItemImageCopy(file);

    saveItemInfoCopyToItems(imageDownLoadUrl);
    saveItemInfoCopyToUsers(imageDownLoadUrl);
    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
  }

  Future<String> uploadingItemImageCopy(mFileImage) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask =
        storageReference.child("product_$productID.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfoCopyToItems(
    String downloadUrl,
  ) {
    final itemRef =
        FirebaseFirestore.instance.collection("items").doc(productID);
    itemRef.set(
      {
        "shortInfo": _shortInfoTextEditingController.text.trim(),
        "longDescription": _descriptiontextEditingController.text.trim(),
        "price": int.parse(_pricetextEditingController.text),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
        "postBy":
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        "attribute": "Copy",
        "id": itemRef.id,
        "color1": selectedItem1.trim(),
        "color2": selectedItem2.trim()
      },
    );

    setState(
      () {
        file = null;
        uploading = false;
        productID = DateTime.now().millisecondsSinceEpoch.toString();
        _descriptiontextEditingController.clear();
        _shortInfoTextEditingController.clear();
        _pricetextEditingController.clear();
      },
    );
  }

  saveItemInfoCopyToUsers(
    String downloadUrl,
  ) {
    final userItemRef = EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("MyUploadItems")
        .doc(productID);
    userItemRef.set(
      {
        "shortInfo": _shortInfoTextEditingController.text.trim(),
        "longDescription": _descriptiontextEditingController.text.trim(),
        "price": int.parse(_pricetextEditingController.text),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
        "postBy":
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        "attribute": "Copy",
        "id": userItemRef.id,
        "isPayment": "inComplete",
        "isDelivery": "inComplete",
        "color1": selectedItem1.trim(),
        "color2": selectedItem2.trim(),
      },
    );
    setState(
      () {
        file = null;
        uploading = false;
        productID = DateTime.now().millisecondsSinceEpoch.toString();
        _descriptiontextEditingController.clear();
        _shortInfoTextEditingController.clear();
        _pricetextEditingController.clear();
      },
    );
  }
}
