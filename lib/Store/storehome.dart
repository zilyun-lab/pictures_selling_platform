import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Models/HomeItemsModel(provider).dart';
import 'package:selling_pictures_platform/Orders/placeOrderPayment.dart';
import 'package:selling_pictures_platform/Store/like.dart';
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

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CarouselController _buttonCarouselController = CarouselController();
  final mainColor = HexColor("E67928");
  @override
  Widget build(
    BuildContext context,
  ) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        //key: _scaffoldKey,
        // backgroundColor: HexColor("E5E2E0"),
        backgroundColor: Colors.white,
        appBar: MyAppBar(),
        body: ChangeNotifierProvider<ItemGridModel>(
          create: (_) => ItemGridModel()..fetchItems(),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(delegate: SearchBoxDelegate()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlayInterval: Duration(seconds: 3),
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
                  padding: const EdgeInsets.all(5.0),
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
                                    color: Colors.black.withOpacity(0.6)),
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
                            color: mainColor,
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
                                ? Container(child: Text("aaa"))
                                : CarouselSlider.builder(
                                    carouselController:
                                        _buttonCarouselController,
                                    itemCount: dataSnapshot.data.docs.length,
                                    options: CarouselOptions(
                                      viewportFraction: 0.3,
                                      height: 99,
                                      enableInfiniteScroll: false,
                                      enlargeCenterPage: true,

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
                                            builder: (c) => ProductPage(
                                              thumbnailURL: model.thumbnailUrl,
                                              shortInfo: model.shortInfo,
                                              longDescription:
                                                  model.longDescription,
                                              price: model.price,
                                              attribute: model.attribute,
                                              postBy: model.postBy,
                                              Stock: model.Stock,
                                              id: model.id,
                                            ),
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
              Consumer<ItemGridModel>(
                builder: (context, model, child) {
                  final items = model.items;
                  return SliverGrid.count(
                    crossAxisCount: 3,
                    children: items
                        .map((item) => Card(
                              color: HexColor("e5e2df"),
                              child: InkWell(
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                    builder: (c) => ProductPage(
                                      thumbnailURL: item.thumbnailUrl,
                                      shortInfo: item.shortInfo,
                                      longDescription: item.longDescription,
                                      price: item.price,
                                      attribute: item.attribute,
                                      postBy: item.postBy,
                                      Stock: item.Stock,
                                      id: item.id,
                                    ),
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
                                                item.thumbnailUrl,
                                                fit: BoxFit.scaleDown,
                                                width: 100,
                                                height: 111.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 65.0),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, right: 8),
                                              child: Container(
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "¥" +
                                                        (item.price).toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  beginBuildingCart() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      child: Card(
        color: HexColor("E67928").withOpacity(0.8),
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon,
                color: Colors.black,
              ),
              Text("まだいいねしていません"),
              Text("何かいいねしてみませんか？"),
            ],
          ),
        ),
      ),
    );
  }
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
          builder: (c) => ProductPage(
            thumbnailURL: model.thumbnailUrl,
            shortInfo: model.shortInfo,
            longDescription: model.longDescription,
            price: model.price,
            attribute: model.attribute,
            postBy: model.postBy,
            Stock: model.Stock,
            id: model.id,
          ),
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
      ? removeItemFromLike(shortInfoAsID, context)
      : addItemToLike(shortInfoAsID, context);
  Route route = MaterialPageRoute(
    builder: (c) => LikePage(),
  );
  Navigator.pushReplacement(context, route);
}

Future<bool> onLikeButtonTapped(
    bool isLiked, String shortInfoAsID, BuildContext context) async {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userLikeList)
          .contains(shortInfoAsID)
      ? removeItemFromLike(shortInfoAsID, context)
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

removeItemFromLike(
  String shortInfoAsID,
  BuildContext context,
) {
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
      Provider.of<LikeItemCounter>(context, listen: true).displayResult();

      //totalAmount = 0;
    },
  );
}
