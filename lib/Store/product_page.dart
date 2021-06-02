import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Authentication/publicUserPage.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Counters/cartitemcounter.dart';
import 'package:selling_pictures_platform/Orders/CheckOutPage.dart';

import 'package:selling_pictures_platform/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';

import 'like.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  List<DocumentSnapshot> documentList = [];
  @override
  void initState() {
    // TODO: implement initState
    // super.initState();
    showUser();
  }

  void showUser() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: widget.itemModel.postBy)
        .get();

    setState(() {
      documentList = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(
                8,
              ),
              width: MediaQuery.of(
                context,
              ).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Stack(
                            children: [
                              Center(
                                child: Image.network(
                                  widget.itemModel.thumbnailUrl,
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              Align(
                                alignment: Alignment(0.0, 1.0),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 115.0),
                                    child: Text(
                                      "LEEWAY",
                                      style: GoogleFonts.sortsMillGoudy(
                                        color: Colors.blueGrey.withOpacity(0.8),
                                        fontSize: 35,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "作品名",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          widget.itemModel.title,
                          style: boldTextStyle,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "作品説明",
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.itemModel.longDescription,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "金額",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "${widget.itemModel.price.toString()} 円",
                          style: boldTextStyle,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "在庫",
                          style: TextStyle(fontSize: 12),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(
                                "items",
                              )
                              .snapshots(),
                          builder: (context, dataSnapshot) {
                            return !dataSnapshot.hasData
                                ? SliverToBoxAdapter(
                                    child: Container(),
                                  )
                                : widget.itemModel.attribute == "Original"
                                    ? Text(
                                        "こちらは原画の為、１点限りとなります。",
                                        style: boldTextStyle,
                                      )
                                    : Text(
                                        "こちらは複製画の為、受注生産となります。",
                                        style: boldTextStyle,
                                      );
                          },
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: documentList.map((document) {
                            return InkWell(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                  builder: (c) => PublicUserPage(
                                    uid: document.data()["uid"],
                                    imageUrl: document.data()["url"],
                                    name: document.data()["name"],
                                    description: document.data()["description"],
                                  ),
                                );
                                Navigator.pushReplacement(context, route);
                              },
                              child: ListTile(
                                  leading: Container(
                                    height: 80,
                                    width: 80,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          document.data()["url"].toString()),
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${document.data()["name"]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${document.data()["description"]}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ) //["PostBy"]}\nshortInfo:${document.data()["shortInfo"]}'),
                                  ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => checkItemInLike(
                                widget.itemModel.shortInfo, context),
                            child: Container(
                              color: Colors.black,
                              width: MediaQuery.of(
                                    context,
                                  ).size.width *
                                  0.47,
                              height: 50,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 6.0),
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: null,
                                          builder: (context, snapshot) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 17,
                                              ),
                                              child: !EcommerceApp
                                                      .sharedPreferences
                                                      .getStringList(
                                                          EcommerceApp
                                                              .userLikeList)
                                                      .contains(widget
                                                          .itemModel.shortInfo)
                                                  ? Text(
                                                      "いいねに追加する",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      "いいねから外す",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection(
                                    "items",
                                  )
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return widget.itemModel.postBy ==
                                        EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp.userUID)
                                    ? InkWell(
                                        onTap: () {
                                          beforeDeleteDialog();
                                        },
                                        // onTap: () => checkItemInCart(
                                        //     widget.itemModel.shortInfo, context),
                                        child: Container(
                                          color: Colors.black,
                                          width: MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.47,
                                          height: 50,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 6.0),
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 45),
                                                    child: Text(
                                                      "削除する",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : widget.itemModel.attribute != "Original"
                                        ? InkWell(
                                            onTap: () {
                                              Route route = MaterialPageRoute(
                                                fullscreenDialog: true,
                                                builder: (c) => CheckOutPage(
                                                    imageURL: widget
                                                        .itemModel.thumbnailUrl,
                                                    shortInfo: widget
                                                        .itemModel.shortInfo,
                                                    price:
                                                        widget.itemModel.price,
                                                    postBy: widget
                                                        .itemModel.postBy),
                                              );
                                              Navigator.pushReplacement(
                                                context,
                                                route,
                                              );
                                            },
                                            // onTap: () => checkItemInCart(
                                            //     widget.itemModel.shortInfo, context),
                                            child: Container(
                                              color: Colors.black,
                                              width: MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.47,
                                              height: 50,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 6.0),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 45),
                                                        child: Text(
                                                          "購入する",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : widget.itemModel.Stock != 0
                                            ? InkWell(
                                                onTap: () {
                                                  Route route =
                                                      MaterialPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (c) =>
                                                        CheckOutPage(
                                                      imageURL: widget.itemModel
                                                          .thumbnailUrl,
                                                      shortInfo: widget
                                                          .itemModel.shortInfo,
                                                      price: widget
                                                          .itemModel.price,
                                                      postBy: widget
                                                          .itemModel.postBy,
                                                      attribute: widget
                                                          .itemModel.attribute,
                                                    ),
                                                  );
                                                  Navigator.pushReplacement(
                                                    context,
                                                    route,
                                                  );
                                                },
                                                // onTap: () => checkItemInCart(
                                                //     widget.itemModel.shortInfo, context),
                                                child: Container(
                                                  color: Colors.black,
                                                  width: MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.47,
                                                  height: 50,
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 6.0),
                                                            child: Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 45),
                                                            child: Text(
                                                              "購入する",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                color: Colors.black54,
                                                width: MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.47,
                                                height: 50,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 6.0),
                                                          child: Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 45),
                                                          child: Text(
                                                            "売り切れ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteItem() {
    FirebaseFirestore.instance
        .collection("items")
        .doc(widget.itemModel.id)
        .delete();
    FirebaseFirestore.instance
        .collection("users")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("MyUploadItems")
        .doc(widget.itemModel.id)
        .delete();
  }

  beforeDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            "最終確認",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Container(
              child:
                  Text("${widget.itemModel.shortInfo} を削除します。\n本当によろしいですか？")),
          actions: <Widget>[
            // ボタン領域
            FlatButton(
              child: Text("キャンセル"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("確認しました。"),
              onPressed: () {
                deleteItem();
                Route route = MaterialPageRoute(
                  // fullscreenDialog: true,
                  builder: (c) => StoreHome(),
                );
                Navigator.pushReplacement(
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

  afterDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            "削除完了",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Container(
              child: Text(
                  "${widget.itemModel.shortInfo} を削除しました。\n引き続きLEEWAYをお楽しみください。")),
          actions: <Widget>[
            // ボタン領域

            FlatButton(
              child: Text("確認しました。"),
              onPressed: () {
                Route route = MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (c) => StoreHome(),
                );
                Navigator.pushReplacement(
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

  disableCheckOutButton() {
    Container(
      color: Colors.black,
      width: MediaQuery.of(
            context,
          ).size.width *
          0.47,
      height: 50,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 45),
                child: Text(
                  "購入する",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkOutButton() {
    InkWell(
      onTap: () {
        //print(widget.itemModel.thumbnailUrl);
        Route route = MaterialPageRoute(
          fullscreenDialog: true,
          builder: (c) => CheckOutPage(
              imageURL: widget.itemModel.thumbnailUrl,
              shortInfo: widget.itemModel.shortInfo,
              price: widget.itemModel.price,
              postBy: widget.itemModel.postBy),
        );
        Navigator.pushReplacement(
          context,
          route,
        );
      },
      // onTap: () => checkItemInCart(
      //     widget.itemModel.shortInfo, context),
      child: Container(
        color: Colors.black,
        width: MediaQuery.of(
              context,
            ).size.width *
            0.47,
        height: 50,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 45),
                  child: Text(
                    "購入する",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
