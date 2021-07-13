import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/HomeItemsModel(provider).dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/searchBox.dart';

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
      //key: //_scaffoldKey,
      backgroundColor: mainColor,
      body: Container(
        color: mainColor,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: SearchBoxDelegate(),
              pinned: false,
            ),
            SliverToBoxAdapter(
              child: mainSlider(),
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
                  child: Container(
                    color: HexColor("e5e2df"),
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
            ),
            SliverFillRemaining(
              child: Container(
                color: HexColor("e5e2df"),
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
                                  (item) => item.Stock == 0
                                      ? Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Stack(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  color: Colors.white,
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  ),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Route route =
                                                            MaterialPageRoute(
                                                          builder: (c) =>
                                                              ProductPage(
                                                            id: item.id,
                                                          ),
                                                        );
                                                        Navigator.push(
                                                          context,
                                                          route,
                                                        );
                                                      },
                                                      splashColor: Colors.black,
                                                      child: gridItems(
                                                          item.thumbnailUrl,
                                                          item.shortInfo,
                                                          item.price
                                                              .toString())),
                                                ),
                                                Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.464,
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        "SOLD OUT",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    color: Colors.redAccent
                                                        .withOpacity(0.85),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Card(
                                              elevation: 0,
                                              color: Colors.white,
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: InkWell(
                                                  onTap: () {
                                                    Route route =
                                                        MaterialPageRoute(
                                                      builder: (c) =>
                                                          ProductPage(
                                                        id: item.id,
                                                      ),
                                                    );
                                                    Navigator.push(
                                                      context,
                                                      route,
                                                    );
                                                  },
                                                  splashColor: Colors.black,
                                                  child: gridItems(
                                                      item.thumbnailUrl,
                                                      item.shortInfo,
                                                      item.price.toString())),
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
                                  (item) => item.Stock == 0
                                      ? Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Stack(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  color: Colors.white,
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  ),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Route route =
                                                            MaterialPageRoute(
                                                          builder: (c) =>
                                                              ProductPage(
                                                            id: item.id,
                                                          ),
                                                        );
                                                        Navigator.push(
                                                          context,
                                                          route,
                                                        );
                                                      },
                                                      splashColor: Colors.black,
                                                      child: gridItems(
                                                          item.thumbnailUrl,
                                                          item.shortInfo,
                                                          item.price
                                                              .toString())),
                                                ),
                                                Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.464,
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        "SOLD OUT",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    color: Colors.redAccent
                                                        .withOpacity(0.85),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Card(
                                              elevation: 0,
                                              color: Colors.white,
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: InkWell(
                                                  onTap: () {
                                                    Route route =
                                                        MaterialPageRoute(
                                                      builder: (c) =>
                                                          ProductPage(
                                                        id: item.id,
                                                      ),
                                                    );
                                                    Navigator.push(
                                                      context,
                                                      route,
                                                    );
                                                  },
                                                  splashColor: Colors.black,
                                                  child: gridItems(
                                                      item.thumbnailUrl,
                                                      item.shortInfo,
                                                      item.price.toString())),
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
                                  (item) => item.Stock == 0
                                      ? Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Stack(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  color: Colors.white,
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  ),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Route route =
                                                            MaterialPageRoute(
                                                          builder: (c) =>
                                                              ProductPage(
                                                            id: item.id,
                                                          ),
                                                        );
                                                        Navigator.push(
                                                          context,
                                                          route,
                                                        );
                                                      },
                                                      splashColor: Colors.black,
                                                      child: gridItems(
                                                          item.thumbnailUrl,
                                                          item.shortInfo,
                                                          item.price
                                                              .toString())),
                                                ),
                                                Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.464,
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        "SOLD OUT",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    color: Colors.redAccent
                                                        .withOpacity(0.85),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Card(
                                              elevation: 0,
                                              color: Colors.white,
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: InkWell(
                                                  onTap: () {
                                                    Route route =
                                                        MaterialPageRoute(
                                                      builder: (c) =>
                                                          ProductPage(
                                                        id: item.id,
                                                      ),
                                                    );
                                                    Navigator.push(
                                                      context,
                                                      route,
                                                    );
                                                  },
                                                  splashColor: Colors.black,
                                                  child: gridItems(
                                                      item.thumbnailUrl,
                                                      item.shortInfo,
                                                      item.price.toString())),
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
                                  (item) => item.Stock == 0
                                      ? Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Stack(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  color: Colors.white,
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  ),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Route route =
                                                            MaterialPageRoute(
                                                          builder: (c) =>
                                                              ProductPage(
                                                            id: item.id,
                                                          ),
                                                        );
                                                        Navigator.push(
                                                          context,
                                                          route,
                                                        );
                                                      },
                                                      splashColor: Colors.black,
                                                      child: gridItems(
                                                          item.thumbnailUrl,
                                                          item.shortInfo,
                                                          item.price
                                                              .toString())),
                                                ),
                                                Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.464,
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        "SOLD OUT",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    color: Colors.redAccent
                                                        .withOpacity(0.85),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Card(
                                              elevation: 0,
                                              color: Colors.white,
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: InkWell(
                                                  onTap: () {
                                                    Route route =
                                                        MaterialPageRoute(
                                                      builder: (c) =>
                                                          ProductPage(
                                                        id: item.id,
                                                      ),
                                                    );
                                                    Navigator.push(
                                                      context,
                                                      route,
                                                    );
                                                  },
                                                  splashColor: Colors.black,
                                                  child: gridItems(
                                                      item.thumbnailUrl,
                                                      item.shortInfo,
                                                      item.price.toString())),
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
                                  (item) => item.Stock == 0
                                      ? Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Stack(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  color: Colors.white,
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  ),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Route route =
                                                            MaterialPageRoute(
                                                          builder: (c) =>
                                                              ProductPage(
                                                            id: item.id,
                                                          ),
                                                        );
                                                        Navigator.push(
                                                          context,
                                                          route,
                                                        );
                                                      },
                                                      splashColor: Colors.black,
                                                      child: gridItems(
                                                          item.thumbnailUrl,
                                                          item.shortInfo,
                                                          item.price
                                                              .toString())),
                                                ),
                                                Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.464,
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        "SOLD OUT",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    color: Colors.redAccent
                                                        .withOpacity(0.85),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Card(
                                              elevation: 0,
                                              color: Colors.white,
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: InkWell(
                                                  onTap: () {
                                                    Route route =
                                                        MaterialPageRoute(
                                                      builder: (c) =>
                                                          ProductPage(
                                                        id: item.id,
                                                      ),
                                                    );
                                                    Navigator.push(
                                                      context,
                                                      route,
                                                    );
                                                  },
                                                  splashColor: Colors.black,
                                                  child: gridItems(
                                                      item.thumbnailUrl,
                                                      item.shortInfo,
                                                      item.price.toString())),
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
            ),
          ],
        ),
      ),
    );
  }

  mainTabChild(ItemGridModel model) {
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
                            id: item.id,
                          ),
                        );
                        Navigator.push(
                          context,
                          route,
                        );
                      },
                      splashColor: Colors.black,
                      child: gridItems(item.thumbnailUrl, item.shortInfo,
                          item.price.toString())),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  gridItems(String url, String title, String price) {
    return Column(
      children: [
        Center(
          child: Container(
            //todo:保留
            height: MediaQuery.of(context).size.height * 0.15,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: 100,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            // color: Colors.white,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 5, right: 13.0, left: 13.0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: new TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: mainColorOfLEEWAY,
                          ),
                          children: [
                            TextSpan(
                              text: price.toString(),
                            ),
                            TextSpan(
                              text: "円",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: mainColorOfLEEWAY,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text(
                    "詳しく見る",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  mainSlider() {
    return Container(
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
          items: storeItems.map(
            (i) {
              return Builder(
                builder: (BuildContext context) {
                  return i.key == ""
                      ? Container(
                          // color: Colors.red,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
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
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
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
    );
  }
}
