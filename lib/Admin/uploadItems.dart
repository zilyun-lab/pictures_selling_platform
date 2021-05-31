import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selling_pictures_platform/Admin/adminShiftOrders.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
//import 'package:selling_pictures_platform/DialogBox/errorDialog.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _descriptiontextEditingController =
      TextEditingController();
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productID = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    //return file == null ? displayAdminHomeScreen() : displayUploadFormScreen();
    return file == null ? displayUploadFormScreen() : displayUploadFormScreen();
  }

  // displayAdminHomeScreen() {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       leading: IconButton(
  //         icon: Icon(
  //           Icons.border_color,
  //           color: Colors.black,
  //         ),
  //         onPressed: () {
  //           Route route = MaterialPageRoute(
  //             builder: (c) => AdminShiftOrders(),
  //           );
  //           Navigator.pushReplacement(
  //             context,
  //             route,
  //           );
  //         },
  //       ),
  //       actions: [
  //         Padding(
  //           padding: const EdgeInsets.only(
  //             right: 15.0,
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               InkWell(
  //                 child: Text(
  //                   "ログアウト",
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   Route route = MaterialPageRoute(
  //                     builder: (c) => SplashScreen(),
  //                   );
  //                   Navigator.pushReplacement(
  //                     context,
  //                     route,
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: getAdminHomeScreenBody(),
  //   );
  // }

  // getAdminHomeScreenBody() {
  //   return Container(
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(
  //             Icons.shop_two,
  //             color: Colors.black,
  //             size: 200,
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(
  //               top: 20.0,
  //             ),
  //             child: ElevatedButton(
  //               onPressed: () => takeImage(context),
  //               child: Text(
  //                 "出品する",
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               style: ElevatedButton.styleFrom(
  //                 primary: Colors.white,
  //                 shape: const RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(
  //                       9,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
            backgroundColor: Colors.white,
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
            // actions: [
            //   Center(
            //     child: InkWell(
            //       onTap: uploading
            //           ? null
            //           : () => confirmItem(), //uploadImageAndSaveItemInfo(),
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 15.0),
            //         child: Text(
            //           "出品する",
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ],
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
                  hintText: "作品　略名",
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
              Icons.art_track,
              color: Colors.black,
            ),
            title: Container(
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titletextEditingController,
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
        // Divider(
        //   color: Colors.black,
        //   thickness: 3,
        // ),
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
                  hintText: "作品　略名",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Divider(
        //   color: Colors.black,
        //   thickness: 3,
        // ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            leading: Icon(
              Icons.art_track,
              color: Colors.black,
            ),
            title: Container(
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titletextEditingController,
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
        // Divider(
        //   color: Colors.black,
        //   thickness: 3,
        // ),
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
        // Divider(
        //   color: Colors.black,
        //   thickness: 3,
        // ),
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
        // Divider(
        //   color: Colors.black,
        //   thickness: 3,
        // ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () => confirmItemOfCopy(),
            child: Text("出品する"),
            style: ElevatedButton.styleFrom(primary: Colors.black),
          ),
        )
      ],
    );
  }

  // confirmItem() {
  //   showDialog(
  //     context: context,
  //     builder: (_) {
  //       return AlertDialog(
  //         title: Row(
  //           children: [
  //             Text(
  //               "*",
  //               style: TextStyle(color: Colors.red),
  //             ),
  //             Text(
  //               "出品に関する規約について",
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //         content: Container(child: Text("悪いけど権利はぜーーーーーんぶ俺らのモンだから（笑）")),
  //         actions: <Widget>[
  //           // ボタン領域
  //           FlatButton(
  //             child: Text("Cancel"),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //           FlatButton(
  //             child: Text("OK"),
  //             onPressed: () => uploadImageAndSaveItemInfo(),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () => uploadImageAndSaveItemInfoCopy(),
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
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () => uploadImageAndSaveItemInfoOriginal(),
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
        _titletextEditingController.clear();
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
    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
  }

  Future<String> uploadingItemImageOriginal(mFileImage) async {
    final Reference storageReference = FirebaseStorage.instance.ref().child(
          "Items",
        );
    UploadTask uploadTask = storageReference
        .child(
          "product_$productID.jpg",
        )
        .putFile(
          mFileImage,
        );
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfoOriginalToItems(
    String downloadUrl,
  ) {
    final itemRef = FirebaseFirestore.instance.collection("items");
    itemRef.doc(productID).set(
      {
        "shortInfo": _shortInfoTextEditingController.text.trim(),
        "longDescription": _descriptiontextEditingController.text.trim(),
        "price": int.parse(_pricetextEditingController.text),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
        "title": _titletextEditingController.text.trim(),
        "postBy":
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        "attribute": "Original",
        "Stock": 1,
        "id": DateTime.now().millisecondsSinceEpoch,
      },
    );
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("MyUploadItems")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(
      {
        "shortInfo": _shortInfoTextEditingController.text.trim(),
        "longDescription": _descriptiontextEditingController.text.trim(),
        "price": int.parse(_pricetextEditingController.text),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
        "title": _titletextEditingController.text.trim(),
        "postBy":
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        "attribute": "Original",
        "Stock": 1,
        "id": DateTime.now().millisecondsSinceEpoch,
      },
    );
    setState(
      () {
        file = null;
        uploading = false;
        productID = DateTime.now().millisecondsSinceEpoch.toString();
        _descriptiontextEditingController.clear();
        _titletextEditingController.clear();
        _shortInfoTextEditingController.clear();
        _pricetextEditingController.clear();
      },
    );
  }

  uploadImageAndSaveItemInfoCopy() async {
    setState(
      () {
        uploading = true;
      },
    );
    String imageDownLoadUrl = await uploadingItemImageCopy(file);

    saveItemInfoCopy(imageDownLoadUrl);
    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
  }

  Future<String> uploadingItemImageCopy(mFileImage) async {
    final Reference storageReference = FirebaseStorage.instance.ref().child(
          "Items",
        );
    UploadTask uploadTask = storageReference
        .child(
          "product_$productID.jpg",
        )
        .putFile(
          mFileImage,
        );
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfoCopy(
    String downloadUrl,
  ) {
    final itemRef = FirebaseFirestore.instance.collection("items");
    itemRef.doc(productID).set(
      {
        "shortInfo": _shortInfoTextEditingController.text.trim(),
        "longDescription": _descriptiontextEditingController.text.trim(),
        "price": int.parse(_pricetextEditingController.text),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
        "title": _titletextEditingController.text.trim(),
        "postBy":
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        "attribute": "Copy",
        "id": DateTime.now().millisecondsSinceEpoch,
      },
    );
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("MyUploadItems")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(
      {
        "shortInfo": _shortInfoTextEditingController.text.trim(),
        "longDescription": _descriptiontextEditingController.text.trim(),
        "price": int.parse(_pricetextEditingController.text),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
        "title": _titletextEditingController.text.trim(),
        "postBy":
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        "attribute": "Copy",
        "id": DateTime.now().millisecondsSinceEpoch,
      },
    );
    setState(
      () {
        file = null;
        uploading = false;
        productID = DateTime.now().millisecondsSinceEpoch.toString();
        _descriptiontextEditingController.clear();
        _titletextEditingController.clear();
        _shortInfoTextEditingController.clear();
        _pricetextEditingController.clear();
      },
    );
  }
}
