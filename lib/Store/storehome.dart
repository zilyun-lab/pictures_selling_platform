import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:selling_pictures_platform/Admin/uploadItems.dart';
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

class _StoreHomeState extends State<StoreHome>
    with SingleTickerProviderStateMixin {
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
  TabController _tabcontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAd();
    _tabcontroller = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      //key: _scaffoldKey,

      backgroundColor: HexColor("e5e2df"),

      body: Container(
        color: HexColor("e5e2df"),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: 10,
                color: mainColor,
              ),
            ),
            SliverPersistentHeader(
              delegate: SearchBoxDelegate(),
              pinned: false,
            ),
            SliverToBoxAdapter(
              child: Container(
                color: HexColor("E67928"),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
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
                                      // child: AdWidget(
                                      //   ad: BannerAd(
                                      //     adUnitId:
                                      //         "ca-app-pub-3940256099942544/2934735716",
                                      //     size: AdSize.banner,
                                      //     request: AdRequest(),
                                      //     listener: BannerAdListener(),
                                      //   )..load(),
                                      // ),
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
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
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
              child: DefaultTabController(
                length: 4,
                child: SingleChildScrollView(
                  child: TabBar(
                    isScrollable: true,
                    enableFeedback: false,
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    unselectedLabelColor: Colors.grey,
                    labelColor: mainColor,
                    tabs: <Widget>[
                      Tab(text: "すべて"),
                      Tab(text: "原画作品"),
                      Tab(text: "複製作品"),
                      Tab(text: "ステッカー"),
                      Tab(text: "ポストカード"),
                    ],
                    controller: _tabcontroller,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabcontroller,
                children: [
                  ChangeNotifierProvider<ItemGridModel>(
                    create: (_) => ItemGridModel()..fetchItems(),
                    child: Consumer<ItemGridModel>(
                      builder: (context, model, child) {
                        final items = model.items;
                        return GridView.count(
                          crossAxisCount: 2,
                          children: items
                              .map(
                                (item) => Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Route route = MaterialPageRoute(
                                            builder: (c) => ProductPage(
                                              finalGetProceeds:
                                                  item.finalGetProceeds,
                                              width: item.itemWidth,
                                              height: item.itemHeight,
                                              shipsDate: item.shipsDate,
                                              postName: item.postName,
                                              thumbnailURL: item.thumbnailUrl,
                                              shortInfo: item.shortInfo,
                                              longDescription:
                                                  item.longDescription,
                                              price: item.price,
                                              attribute: item.attribute,
                                              postBy: item.postBy,
                                              Stock: item.Stock,
                                              id: item.id,
                                            ),
                                          );
                                          Navigator.push(
                                            context,
                                            route,
                                          );
                                        },
                                        splashColor: Colors.black,
                                        child: Column(
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
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                  ),
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                // color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              width: 100,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            child: new Text(
                                                                item.shortInfo),
                                                          ),
                                                          DefaultTextStyle(
                                                            style: new TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    mainColor),
                                                            overflow:
                                                                TextOverflow
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
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                  ChangeNotifierProvider<ItemGridModel>(
                    create: (_) => ItemGridModel()..fetchOriginalItems(),
                    child: Consumer<ItemGridModel>(
                      builder: (context, model, child) {
                        final items = model.items;
                        return GridView.count(
                          crossAxisCount: 2,
                          children: items
                              .map(
                                (item) => Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Route route = MaterialPageRoute(
                                            builder: (c) => ProductPage(
                                              finalGetProceeds:
                                                  item.finalGetProceeds,
                                              width: item.itemWidth,
                                              height: item.itemHeight,
                                              shipsDate: item.shipsDate,
                                              postName: item.postName,
                                              thumbnailURL: item.thumbnailUrl,
                                              shortInfo: item.shortInfo,
                                              longDescription:
                                                  item.longDescription,
                                              price: item.price,
                                              attribute: item.attribute,
                                              postBy: item.postBy,
                                              Stock: item.Stock,
                                              id: item.id,
                                            ),
                                          );
                                          Navigator.push(
                                            context,
                                            route,
                                          );
                                        },
                                        splashColor: Colors.black,
                                        child: Column(
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
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                  ),
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                // color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            child: new Text(
                                                                item.shortInfo),
                                                          ),
                                                          DefaultTextStyle(
                                                            style: new TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    mainColor),
                                                            overflow:
                                                                TextOverflow
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
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                  ChangeNotifierProvider<ItemGridModel>(
                    create: (_) => ItemGridModel()..fetchCopyItems(),
                    child: Consumer<ItemGridModel>(
                      builder: (context, model, child) {
                        final items = model.items;
                        return GridView.count(
                          crossAxisCount: 2,
                          children: items
                              .map(
                                (item) => Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Route route = MaterialPageRoute(
                                            builder: (c) => ProductPage(
                                              finalGetProceeds:
                                                  item.finalGetProceeds,
                                              width: item.itemWidth,
                                              height: item.itemHeight,
                                              shipsDate: item.shipsDate,
                                              postName: item.postName,
                                              thumbnailURL: item.thumbnailUrl,
                                              shortInfo: item.shortInfo,
                                              longDescription:
                                                  item.longDescription,
                                              price: item.price,
                                              attribute: item.attribute,
                                              postBy: item.postBy,
                                              Stock: item.Stock,
                                              id: item.id,
                                            ),
                                          );
                                          Navigator.push(
                                            context,
                                            route,
                                          );
                                        },
                                        splashColor: Colors.black,
                                        child: Column(
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
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                  ),
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                // color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            child: new Text(
                                                                item.shortInfo),
                                                          ),
                                                          DefaultTextStyle(
                                                            style: new TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    mainColor),
                                                            overflow:
                                                                TextOverflow
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
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                  ChangeNotifierProvider<ItemGridModel>(
                    create: (_) => ItemGridModel()..fetchStickerItems(),
                    child: Consumer<ItemGridModel>(
                      builder: (context, model, child) {
                        final items = model.items;
                        return GridView.count(
                          crossAxisCount: 2,
                          children: items
                              .map(
                                (item) => Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Route route = MaterialPageRoute(
                                            builder: (c) => ProductPage(
                                              finalGetProceeds:
                                                  item.finalGetProceeds,
                                              width: item.itemWidth,
                                              height: item.itemHeight,
                                              shipsDate: item.shipsDate,
                                              postName: item.postName,
                                              thumbnailURL: item.thumbnailUrl,
                                              shortInfo: item.shortInfo,
                                              longDescription:
                                                  item.longDescription,
                                              price: item.price,
                                              attribute: item.attribute,
                                              postBy: item.postBy,
                                              Stock: item.Stock,
                                              id: item.id,
                                            ),
                                          );
                                          Navigator.push(
                                            context,
                                            route,
                                          );
                                        },
                                        splashColor: Colors.black,
                                        child: Column(
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
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                  ),
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                // color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            child: new Text(
                                                                item.shortInfo),
                                                          ),
                                                          DefaultTextStyle(
                                                            style: new TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    mainColor),
                                                            overflow:
                                                                TextOverflow
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
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                  ChangeNotifierProvider<ItemGridModel>(
                    create: (_) => ItemGridModel()..fetchPostCardItems(),
                    child: Consumer<ItemGridModel>(
                      builder: (context, model, child) {
                        final items = model.items;
                        return GridView.count(
                          crossAxisCount: 2,
                          children: items
                              .map(
                                (item) => Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Route route = MaterialPageRoute(
                                            builder: (c) => ProductPage(
                                              finalGetProceeds:
                                                  item.finalGetProceeds,
                                              width: item.itemWidth,
                                              height: item.itemHeight,
                                              shipsDate: item.shipsDate,
                                              postName: item.postName,
                                              thumbnailURL: item.thumbnailUrl,
                                              shortInfo: item.shortInfo,
                                              longDescription:
                                                  item.longDescription,
                                              price: item.price,
                                              attribute: item.attribute,
                                              postBy: item.postBy,
                                              Stock: item.Stock,
                                              id: item.id,
                                            ),
                                          );
                                          Navigator.push(
                                            context,
                                            route,
                                          );
                                        },
                                        splashColor: Colors.black,
                                        child: Column(
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
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                  ),
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                // color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            child: new Text(
                                                                item.shortInfo),
                                                          ),
                                                          DefaultTextStyle(
                                                            style: new TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    mainColor),
                                                            overflow:
                                                                TextOverflow
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
                                ),
                              )
                              .toList(),
                        );
                      },
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
