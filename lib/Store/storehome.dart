import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:selling_pictures_platform/Admin/uploadItems.dart';
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Orders/placeOrderPayment.dart';

import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/searchBox.dart';
import '../Widgets/loadingWidget.dart';

import '../Models/item.dart';

import 'like.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CarouselController _buttonCarouselController = CarouselController();

  @override
  Widget build(
    BuildContext context,
  ) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        //key: _scaffoldKey,
        backgroundColor: Colors.white,
        //backgroundColor: HexColor("cbc5c0"),
        // backgroundColor: HexColor("b6aea1"),
        // floatingActionButton: Container(
        //   width: 100,
        //   height: 100,
        //   child: FloatingActionButton(
        //     backgroundColor: HexColor("E5694E"),
        //     onPressed: () {
        //       // print(EcommerceApp.sharedPreferences
        //       //     .getStringList(EcommerceApp.userLikeList)
        //       //     .sublist(1));
        //       Route route = MaterialPageRoute(
        //         builder: (c) => UploadPage(),
        //       );
        //       Navigator.pushReplacement(context, route);
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(12.0),
        //       child: Column(
        //         children: [
        //           Text("出品"),
        //           Icon(
        //             Icons.camera_alt_outlined,
        //             size: 50,
        //           ),
        //         ],
        //       ),
        //     ),
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(50.0))),
        //   ),
        // ),
        appBar: MyAppBar(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(delegate: SearchBoxDelegate()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 100,
                    autoPlay: true,
                  ),
                  items: [
                    "images/painter1.png",
                    "images/painter2.png",
                    "images/painter4.png",
                    "images/painter5.png"
                  ].map(
                    (i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(
                                i,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  color: Colors.black12,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          children: [
                            Text(
                              EcommerceApp.sharedPreferences
                                  .getString(EcommerceApp.userName),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.withOpacity(
                                  0.9,
                                ),
                              ),
                            ),
                            Text(
                              " さんがいいねした作品",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Divider(
                          thickness: 2,
                          color: Colors.black54,
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: EcommerceApp.firestore
                            .collection("items")
                            .where(
                              "shortInfo",
                              whereIn: EcommerceApp.sharedPreferences
                                  .getStringList(EcommerceApp.userLikeList),
                            )
                            .snapshots(),
                        builder: (context, dataSnapshot) {
                          return !dataSnapshot.hasData
                              ? Container(
                                  child: circularProgress(),
                                )
                              : CarouselSlider.builder(
                                  carouselController: _buttonCarouselController,
                                  itemCount: dataSnapshot.data.docs.length,
                                  options: CarouselOptions(
                                    viewportFraction: 0.3,
                                    height: 99,
                                    enableInfiniteScroll: false,

                                    //autoPlay: true,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index, _) {
                                    ItemModel model = ItemModel.fromJson(
                                      dataSnapshot.data.docs[index].data(),
                                    );
                                    return InkWell(
                                      onTap: () {
                                        Route route = MaterialPageRoute(
                                          builder: (c) =>
                                              ProductPage(itemModel: model),
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          route,
                                        );
                                      },
                                      child: Card(
                                          child: Image.network(
                                        model.thumbnailUrl,
                                        height: 125,
                                        width: 125,
                                        fit: BoxFit.scaleDown,
                                      )),
                                    );
                                  },
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: StreamBuilder<QuerySnapshot>(
            //     stream: EcommerceApp.firestore
            //         .collection("items")
            //         .where(
            //           "shortInfo",
            //           whereIn: EcommerceApp.sharedPreferences
            //               .getStringList(EcommerceApp.userLikeList),
            //         )
            //         .snapshots(),
            //     builder: (context, dataSnapshot) {
            //       return !dataSnapshot.hasData
            //           ? Container(
            //               child: circularProgress(),
            //             )
            //           : CarouselSlider.builder(
            //               carouselController: _buttonCarouselController,
            //               itemCount: dataSnapshot.data.docs.length,
            //               options: CarouselOptions(
            //                 viewportFraction: 0.3,
            //                 height: 99,
            //                 enableInfiniteScroll: false,
            //
            //                 //autoPlay: true,
            //               ),
            //               itemBuilder: (BuildContext context, int index, _) {
            //                 ItemModel model = ItemModel.fromJson(
            //                   dataSnapshot.data.docs[index].data(),
            //                 );
            //                 return InkWell(
            //                   onTap: () {
            //                     Route route = MaterialPageRoute(
            //                       builder: (c) => ProductPage(itemModel: model),
            //                     );
            //                     Navigator.pushReplacement(
            //                       context,
            //                       route,
            //                     );
            //                   },
            //                   child: Card(
            //                       child: Image.network(
            //                     model.thumbnailUrl,
            //                     height: 125,
            //                     width: 125,
            //                     fit: BoxFit.scaleDown,
            //                   )),
            //                 );
            //               },
            //             );
            //     },
            //   ),
            // ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 12.0),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         EcommerceApp.sharedPreferences
                      //             .getString(EcommerceApp.userName),
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.pinkAccent.withOpacity(
                      //             0.9,
                      //           ),
                      //         ),
                      //       ),
                      //       Text(
                      //         " さんがいいねした作品",
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.black54,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   //width: 100,
                      //   height: 120,
                      //   child: StreamBuilder<QuerySnapshot>(
                      //     stream: EcommerceApp.firestore
                      //         .collection("items")
                      //         .where(
                      //           "shortInfo",
                      //           whereIn: EcommerceApp.sharedPreferences
                      //               .getStringList(EcommerceApp.userLikeList),
                      //         )
                      //         .snapshots(),
                      //     builder: (context, dataSnapshot) {
                      //       return !dataSnapshot.hasData
                      //           ? Container(
                      //               child: circularProgress(),
                      //             )
                      //           : PageView.builder(
                      //               controller:
                      //                   PageController(viewportFraction: 0.5),
                      //               itemCount: dataSnapshot.data.docs.length,
                      //               itemBuilder: (context, index) {
                      //                 ItemModel model = ItemModel.fromJson(
                      //                   dataSnapshot.data.docs[index].data(),
                      //                 );
                      //                 //return sourceInfoOnlyImage(model, context);
                      //                 return sourceInfoForMain(
                      //                   model,
                      //                   context,
                      //                 );
                      //               },
                      //             );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(
                      "items",
                    )
                    .orderBy(
                      "publishedDate",
                      descending: true,
                    )
                    .snapshots(),
                builder: (context, dataSnapshot) {
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Container(),
                        )
                      : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                dataSnapshot.data.docs[index].data(),
                              );
                              return sourceInfoForMain(model, context);
                            },
                            childCount: dataSnapshot.data.docs.length,
                          ),
                        );
                })
          ],
        ),
      ),
    );
  }
}

Widget sourceInfoOnlyImage(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  Color iconColor = Colors.grey;
  PaymentPage(
    postBy: model.postBy,
  );

  return Card(
    child: InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (c) => ProductPage(itemModel: model),
        );
        Navigator.pushReplacement(
          context,
          route,
        );
      },
      splashColor: Colors.black,
      child: Center(
        child: Image.network(
          model.thumbnailUrl,
          fit: BoxFit.scaleDown,
          width: 100,
          height: 100,
        ),
      ),
    ),
  );
}

Widget sourceInfoForMain(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  Color iconColor = Colors.grey;
  PaymentPage(
    postBy: model.postBy,
  );

  return Card(
    color: HexColor("e5e2df"),
    child: InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (c) => ProductPage(itemModel: model),
        );
        Navigator.pushReplacement(
          context,
          route,
        );
      },
      splashColor: Colors.black,
      child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: SizedBox(
                  child: Container(
                    child: Image.network(
                      model.thumbnailUrl,
                      fit: BoxFit.scaleDown,
                      width: 100,
                      height: 111.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 65.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8),
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "¥" + (model.price).toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    // child: Align(
                    //   alignment: Alignment(-1, 1.0),
                    //   child: Text("¥" + (model.price).toString()),
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

//todo:以下商品ページ
Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  Color iconColor = Colors.grey;
  PaymentPage(
    postBy: model.postBy,
  );

  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
        builder: (c) => ProductPage(itemModel: model),
      );
      Navigator.pushReplacement(
        context,
        route,
      );
    },
    splashColor: Colors.black,
    child: Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Image.network(
                        model.thumbnailUrl,
                        width: 140,
                        height: 140,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Align(
                            alignment: Alignment(-1, 1.0),
                            child: Text("¥" + (model.price).toString())),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction == null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.add_shopping_cart,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                checkItemInCart(model.shortInfo, context);
                              },
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              removeCartFunction();
                              Route route = MaterialPageRoute(
                                builder: (_) => StoreHome(),
                              );
                              Navigator.pushReplacement(
                                context,
                                route,
                              );
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.black,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.black, String imgPath}) {
  return Container(
    height: 150,
    width: width * .34,
    margin: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: Offset(
            0,
            5,
          ),
          blurRadius: 10,
          color: Colors.grey[200],
        )
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(
          20,
        ),
      ),
      child: Column(
        children: [
          Image.network(
            imgPath,
            height: 150,
            width: width * .34,
            fit: BoxFit.fill,
          ),
        ],
      ),
    ),
  );
}

void checkItemInCart(
  String shortInfoAsID,
  BuildContext context,
) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "マイカートに追加済みです")
      : addItemToCart(shortInfoAsID, context);
}

void checkItemInLike(String shortInfoAsID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userLikeList)
          .contains(shortInfoAsID)
      ? removeItemFromLike(shortInfoAsID)
      : addItemToLike(shortInfoAsID, context);
  Route route = MaterialPageRoute(
    builder: (c) => StoreHome(),
  );
  Navigator.pushReplacement(context, route);
}

Future<bool> onLikeButtonTapped(
    bool isLiked, String shortInfoAsID, BuildContext context) async {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userLikeList)
          .contains(shortInfoAsID)
      ? removeItemFromLike(shortInfoAsID)
      : addItemToLike(shortInfoAsID, context);
  return !isLiked;
}

addItemToCart(
  String shortInfoAsID,
  BuildContext context,
) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(shortInfoAsID);
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update({EcommerceApp.userCartList: tempCartList}).then(
    (v) {
      Fluttertoast.showToast(msg: "マイカートに追加しました");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    },
  );
}

addItemToLike(
  String shortInfoAsID,
  BuildContext context,
) {
  List tempLikeList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userLikeList);
  tempLikeList.add(shortInfoAsID);
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update({EcommerceApp.userLikeList: tempLikeList}).then(
    (v) {
      Fluttertoast.showToast(msg: "いいねしました");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userLikeList, tempLikeList);
      Provider.of<LikeItemCounter>(context, listen: false).displayResult();
    },
  );
}

removeItemFromLike(String shortInfoAsID) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userLikeList);
  tempCartList.remove(shortInfoAsID);
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update(
    {EcommerceApp.userLikeList: tempCartList},
  ).then(
    (v) {
      Fluttertoast.showToast(msg: "マイいいねから削除しました");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userLikeList, tempCartList.cast());
      //Provider.of<CartItemCounter>(context, listen: true).displayResult();

      //totalAmount = 0;
    },
  );
}
