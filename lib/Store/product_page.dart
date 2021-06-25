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
import '../main.dart';
import 'ARPage.dart';

class ProductPage extends StatefulWidget {
  final String shortInfo;
  final String thumbnailURL;
  final String longDescription;
  final int price;
  final int Stock;
  final String attribute;
  final String postBy;
  final String id;
  final String postName;
  final String shipsDate;
  final String width;
  final String height;
  ProductPage({
    this.thumbnailURL,
    this.shortInfo,
    this.longDescription,
    this.price,
    this.Stock,
    this.attribute,
    this.postBy,
    this.id,
    this.postName,
    this.shipsDate,
    this.height,
    this.width,
  });
  @override
  _ProductPageState createState() => _ProductPageState(
      this.thumbnailURL,
      this.shortInfo,
      this.longDescription,
      this.price,
      this.attribute,
      this.postBy,
      this.Stock,
      this.id,
      this.postName,
      this.shipsDate,
      this.height,
      this.width);
}

class _ProductPageState extends State<ProductPage> {
  final String thumbnailURL;
  final String shortInfo;
  final String longDescription;
  final int price;
  final int Stock;
  final String attribute;
  final String postBy;
  final String id;
  final String postName;
  final String shipsDate;
  final String width;
  final String height;

  //ArCoreController arCoreController;

  int quantityOfItems = 1;
  List<DocumentSnapshot> documentList = [];

  _ProductPageState(
      this.thumbnailURL,
      this.shortInfo,
      this.longDescription,
      this.price,
      this.attribute,
      this.postBy,
      this.Stock,
      this.id,
      this.postName,
      this.shipsDate,
      this.width,
      this.height);
  @override
  void initState() {
    // TODO: implement initState
    // super.initState();
    showUser();
  }

  void showUser() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: postBy)
        .get();

    setState(() {
      documentList = snapshot.docs;
    });
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
                          shortInfo,
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
                          longDescription,
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
                                    text: height,
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
                                    text: width,
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
                          "${price.toString()} 円",
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
                            if (attribute == "Original") {
                              return Text(
                                "こちらは原画の為、１点限りとなります。",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              );
                            } else if (attribute == "Sticker") {
                              return Text(
                                "この商品はステッカーです",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              );
                            } else if (attribute == "PostCard") {
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
                          "$shipsDate",
                          style: boldTextStyle,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(
                            12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  color: HexColor("#481DE2"),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: documentList.map((document) {
                                        return InkWell(
                                          onTap: () {
                                            CheckOutPage(
                                              userName: document.data()["name"],
                                            );
                                            Route route = MaterialPageRoute(
                                              builder: (c) => PublicUserPage(
                                                uid: document.data()["uid"],
                                                imageUrl:
                                                    document.data()["url"],
                                                name: document.data()["name"],
                                                description: document
                                                    .data()["description"],
                                              ),
                                            );
                                            Navigator.pushReplacement(
                                                context, route);
                                          },
                                          child: ListTile(
                                            leading: Container(
                                              height: 80,
                                              width: 80,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    document
                                                        .data()["url"]
                                                        .toString()),
                                              ),
                                            ),
                                            title: Text(
                                              '${document.data()["name"]}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 10.0,
                                              ),
                                              child: Text(
                                                '${document.data()["description"]}',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: BubbleBorder(
                                                  width: 1,
                                                  radius: 10,
                                                ),
                                              ),
                                            ), //["PostBy"]}\nshortInfo:${document.data()["shortInfo"]}'),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
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
                                  onTap: () =>
                                      checkItemInLike(shortInfo, context),
                                  child: Container(
                                    color: Colors.black,
                                    width: MediaQuery.of(
                                          context,
                                        ).size.width *
                                        0.46,
                                    height: 50,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () => checkItemInLike(
                                                  shortInfo, context),
                                              icon: Icon(
                                                Icons.favorite,
                                                color: Colors.white,
                                              ),
                                              label: StreamBuilder<
                                                      QuerySnapshot>(
                                                  stream: null,
                                                  builder: (context, snapshot) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 0.5,
                                                      ),
                                                      child: !EcommerceApp
                                                              .sharedPreferences
                                                              .getStringList(
                                                                  EcommerceApp
                                                                      .userLikeList)
                                                              .contains(
                                                                  shortInfo)
                                                          ? Text(
                                                              "いいねに追加",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : Text(
                                                              "いいねから外す",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                    );
                                                  }),
                                            ),
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
                                    return FirebaseAuth.instance.currentUser ==
                                            null
                                        ? InkWell(
                                            onTap: () {
                                              Route route = MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (c) => Login());
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
                                                  0.46,
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
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 45),
                                                        child: Text(
                                                          "ログインして購入",
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
                                        : postBy ==
                                                EcommerceApp.sharedPreferences
                                                    .getString(
                                                        EcommerceApp.userUID)
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
                                                      0.46,
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
                                                              Icons.delete,
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
                                                              "削除する",
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
                                            : attribute != "Original"
                                                ? InkWell(
                                                    onTap: () {
                                                      Route route =
                                                          MaterialPageRoute(
                                                        fullscreenDialog: true,
                                                        builder: (c) =>
                                                            CheckOutPage(
                                                                id: id,
                                                                imageURL:
                                                                    thumbnailURL,
                                                                shortInfo:
                                                                    shortInfo,
                                                                price: price,
                                                                postBy: postBy),
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
                                                          0.46,
                                                      height: 50,
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            6.0),
                                                                child: Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            45),
                                                                child: Text(
                                                                  "購入する",
                                                                  style:
                                                                      TextStyle(
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
                                                : Stock != 0
                                                    ? InkWell(
                                                        onTap: () {
                                                          Route route =
                                                              MaterialPageRoute(
                                                            fullscreenDialog:
                                                                true,
                                                            builder: (c) =>
                                                                CheckOutPage(
                                                              imageURL:
                                                                  thumbnailURL,
                                                              shortInfo:
                                                                  shortInfo,
                                                              price: price,
                                                              postBy: postBy,
                                                              attribute:
                                                                  attribute,
                                                              userName:
                                                                  postName,
                                                            ),
                                                          );
                                                          Navigator
                                                              .pushReplacement(
                                                            context,
                                                            route,
                                                          );
                                                        },
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
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            6.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            45),
                                                                    child: Text(
                                                                      "購入する",
                                                                      style:
                                                                          TextStyle(
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
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          4.5),
                                                                  child: Icon(
                                                                    Icons.check,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          40),
                                                                  child: Text(
                                                                    "売り切れ",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
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
        title: Text(
          shortInfo,
          style: TextStyle(
            color: HexColor("#E67928"),
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
      body: Center(
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .doc(id)
                  .collection("itemImages")
                  .doc(id)
                  .snapshots(),
              builder: (context, snapshot) {
                final imgList = snapshot.data.data()["images"].length;
                return CarouselSlider.builder(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    aspectRatio: 1.0,
                    autoPlayInterval: Duration(seconds: 3),
                    enableInfiniteScroll: false,
                    // autoPlay: true,
                  ),
                  itemCount: imgList,
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    return Image.network(
                      snapshot.data.data()["images"][index].toString(),
                      fit: BoxFit.scaleDown,
                      height: MediaQuery.of(context).size.height,
                    );
                  },
                );
              })),
    );
  }

  deleteItem() {
    FirebaseFirestore.instance.collection("items").doc(id).delete();
    FirebaseFirestore.instance
        .collection("users")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("MyUploadItems")
        .doc(id)
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
          content: Container(child: Text("$shortInfo を削除します。\n本当によろしいですか？")),
          actions: <Widget>[
            // ボタン領域
            ElevatedButton(
              child: Text("キャンセル"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("確認しました。"),
              onPressed: () {
                deleteItem();
                Route route = MaterialPageRoute(
                  // fullscreenDialog: true,
                  builder: (c) => MainPage(),
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
              child: Text("$shortInfo を削除しました。\n引き続きLEEWAYをお楽しみください。")),
          actions: <Widget>[
            // ボタン領域

            ElevatedButton(
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

  Widget buildFooter(BuildContext context) {
    final visual = Container(
      child: Icon(
        Icons.keyboard_arrow_up_outlined,
        color: Colors.white,
      ),
      height: 50,
      decoration: BoxDecoration(
          color: HexColor("#E67928"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
    return visual;
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
              imageURL: thumbnailURL,
              shortInfo: shortInfo,
              price: price,
              postBy: postBy),
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

class BubbleBorder extends ShapeBorder {
  BubbleBorder({
    @required this.width,
    @required this.radius,
  });

  final double width;
  final double radius;

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(width);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(
      rect.deflate(width / 2.0),
      textDirection: textDirection,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    final r = radius;
    final rs = radius / 2;
    final w = rect.size.width;
    final h = rect.size.height;

    return Path()
      ..addPath(
        Path()
          ..moveTo(r, 0)
          ..lineTo(w - r, 0)
          ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
          ..lineTo(w, h - rs)
          ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
          ..lineTo(r, h)
          ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))
          ..lineTo(0, h / 2)
          ..relativeLineTo(-12, -12)
          ..lineTo(0, h / 2 - 10)
          ..lineTo(0, r)
          ..arcToPoint(Offset(r, 0), radius: Radius.circular(r)),
        Offset(rect.left, rect.top),
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black;
    canvas.drawPath(
      getOuterPath(
        rect.deflate(width / 2.0),
        textDirection: textDirection,
      ),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}

const boldTextStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);

class StripeTransactionResponse {
  StripeTransactionResponse({
    @required this.message,
    @required this.success,
  });

  String message;
  bool success;
}
