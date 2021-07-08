import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:selling_pictures_platform/Admin/test.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Authentication/publicUserPage.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Orders/CheckOutPage.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Orders/myOrders.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import '../main.dart';
import 'ARPage.dart';
import 'UpdateItem.dart';

class ProductPage extends StatefulWidget {
  final String id;

  ProductPage({
    this.id,
  });
  @override
  _ProductPageState createState() => _ProductPageState(
        this.id,
      );
}

class _ProductPageState extends State<ProductPage> {
  final String id;

  int quantityOfItems = 1;

  _ProductPageState(
    this.id,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemData();
  }

  Map<String, dynamic> il = {};

  void getItemData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("items")
        .doc(widget.id)
        .get();

    setState(() {
      il = snapshot.data();
    });
  }

  Map<String, dynamic> documentList;
  Future<String> getData(String field) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(il["postBy"])
        .get();
    Map<String, dynamic> record = docSnapshot.data();
    return record[field];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
          onTap: () async {
            await showModalBottomSheet(
              enableDrag: true,
              isDismissible: true,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
              backgroundColor: HexColor("#E67928"),
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "作品名",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        Text(
                          il["shortInfo"],
                          style: boldTextStyle,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "作品説明",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          il["longDescription"],
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "作品情報(縦x横)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: il["itemHeight"],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  TextSpan(
                                    text: 'mm',
                                  ),
                                ],
                              ),
                            ),
                            Text(" x ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: il["itemWidth"],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  TextSpan(
                                    text: 'mm',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "金額",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${il["price"].toString()} 円",
                          style: boldTextStyle,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "カテゴリー",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(
                                "items",
                              )
                              .snapshots(),
                          builder: (context, dataSnapshot) {
                            if (il["attribute"] == "Original") {
                              return Text(
                                "こちらは原画の為、１点限りとなります。",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              );
                            } else if (il["attribute"] == "Sticker") {
                              return Text(
                                "この商品はステッカーです",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              );
                            } else if (il["attribute"] == "PostCard") {
                              return Text(
                                "この商品はポストカードです",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              );
                            } else {
                              return Text(
                                "こちらは複製画の為、受注生産となります。",
                                style: boldTextStyle,
                              );
                            }
                          },
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "発送日時",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${il["shipsDate"]}",
                          style: boldTextStyle,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        userLink(il),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 8,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                il["postBy"] !=
                                        EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp.userUID)
                                    ? likeButtont(context, il)
                                    : itemEditButton(context, il, id),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection(
                                        "items",
                                      )
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return FirebaseAuth.instance.currentUser ==
                                            null
                                        ? checkOutByNewUser(context)
                                        : il["postBy"] ==
                                                EcommerceApp.sharedPreferences
                                                    .getString(
                                                        EcommerceApp.userUID)
                                            ? deleteItemButton(context, () {
                                                beforeDeleteDialog(
                                                    context, il, id);
                                              })
                                            : il["attribute"] != "Original"
                                                ? checkOutItemButton(
                                                    context, il, id)
                                                : il["Stock"] != 0
                                                    ? checkOutItemButton(
                                                        context, il, id)
                                                    : soldOutButton;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: buildFooter(context)),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: InkWell(
          onTap: () {
            print(getData("name"));
          },
          child: Text(
            il["shortInfo"],
            style: TextStyle(
              color: HexColor("#E67928"),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: HexColor("#E67928"),
          ),
          onPressed: () {
            Route route = MaterialPageRoute(
              builder: (c) => MainPage(),
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => MainPage(),
                ));
          },
        ),
      ),
      body: productPageBody(id),
    );
  }
}

beforeDeleteDialog(BuildContext context, Map il, String id) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(
          "最終確認",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content:
            Container(child: Text("${il["shortInfo"]} を削除します。\n本当によろしいですか？")),
        actions: <Widget>[
          ElevatedButton(
            child: Text("キャンセル"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("確認しました。"),
            onPressed: () {
              deleteItem(id);
              Route route = MaterialPageRoute(
                // fullscreenDialog: true,
                builder: (c) => MainPage(),
              );
              Navigator.push(
                context,
                route,
              );
            },
          ),
        ],
      );
    },
  );
}
