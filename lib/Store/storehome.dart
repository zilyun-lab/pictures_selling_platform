import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/HomeItemsModel(provider).dart';
import 'package:selling_pictures_platform/Store/like.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Counters/Likeitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Widgets/searchBox.dart';
import '../LEEWAY.dart';
import '../Models/item.dart';
import '../main.dart';
import 'BSTransaction.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  void initAd() {
    BannerAd bannerAd = BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/2934735716",
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();
    //items.add(bannerAd);
  }

  List<MapEntry<String, Widget>> items = [
    MapEntry("images/painter1.png", BSTransaction()),
    MapEntry("images/painter2.png", LEEWAY()),
    MapEntry("", null),
    MapEntry("images/painter4.png", MainPage()),
    MapEntry("images/painter5.png", MainPage()),
    MapEntry("", null),
  ];
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CarouselController _buttonCarouselController = CarouselController();
  final mainColor = HexColor("E67928");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAd();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      //key: _scaffoldKey,

      backgroundColor: Colors.white,

      body: ChangeNotifierProvider<ItemGridModel>(
        create: (_) => ItemGridModel()..fetchItems(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                HexColor("E67928"),
                HexColor("E67928"),
                Colors.white,
              ],
            ),
          ),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(delegate: SearchBoxDelegate()),
              SliverToBoxAdapter(
                child: Container(
                  color: HexColor("E67928"),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 15),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        autoPlayInterval: Duration(seconds: 3),
                        height: 100,
                        autoPlay: true,
                      ),
                      items: items.map(
                        (i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return i.key == ""
                                  ? Container(
                                      // color: Colors.red,
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: ClipRRect(
                                        child: AdWidget(
                                          ad: BannerAd(
                                            adUnitId:
                                                "ca-app-pub-3940256099942544/2934735716",
                                            size: AdSize.banner,
                                            request: AdRequest(),
                                            listener: BannerAdListener(),
                                          )..load(),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Route route = MaterialPageRoute(
                                          builder: (c) => i.value,
                                        );
                                        Navigator.push(
                                          context,
                                          route,
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.asset(
                                            i.key,
                                            fit: BoxFit.cover,
                                          ),
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
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  "新着作品",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )),
              Consumer<ItemGridModel>(
                builder: (context, model, child) {
                  final items = model.items;
                  return SliverGrid.count(
                    crossAxisCount: 2,
                    children: items
                        .map((item) => Container(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //   // borderRadius: BorderRadius.circular(24),
                                  //   border: Border.all(
                                  //       color: Colors.black, width: 3),
                                  // ),
                                  // elevation: 10,
                                  // color: HexColor("#E67928"),
                                  // clipBehavior: Clip.antiAlias,
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(24),
                                  // ),
                                  child: InkWell(
                                    onTap: () {
                                      Route route = MaterialPageRoute(
                                        builder: (c) => ProductPage(
                                          width: item.itemWidth,
                                          height: item.itemHeight,
                                          shipsDate: item.shipsDate,
                                          postName: item.postName,
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
                                              child: Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    item.thumbnailUrl,
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 120,
                                                  ),
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                // color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Column(
                                                    children: [
                                                      DefaultTextStyle(
                                                        style: new TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        child: new Text(
                                                            item.shortInfo),
                                                      ),
                                                      DefaultTextStyle(
                                                        style: new TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        child: new Text(
                                                          item.price
                                                                  .toString() +
                                                              "円",
                                                        ),
                                                      ),
                                                    ],
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                      height: 108,
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
