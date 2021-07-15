// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Admin/test.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:selling_pictures_platform/Admin/MyUploadItems.dart';
import 'package:selling_pictures_platform/Admin/uploadItems.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/StarRatingModel.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import '../main.dart';

class PublicUserPage extends StatelessWidget {
  final String uid;
  final String imageUrl;
  final String name;
  final String description;
  final String FB;
  final String TW;
  final String IG;

  PublicUserPage({
    Key key,
    this.uid,
    this.imageUrl,
    this.description,
    this.name,
    this.FB,
    this.IG,
    this.TW,
  }) : super(key: key);
  Color moji = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColorOfLEEWAY,
      body: Stack(
        children: [
          Bubbles(),
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      top: 100,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 65,
                                  ),
                                  DefaultTextStyle(
                                      style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      child: new Text(name)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ChangeNotifierProvider<StarRatingModel>(
                                      create: (_) => StarRatingModel(id: uid)
                                        ..fetchItems(),
                                      child: Consumer<StarRatingModel>(
                                          builder: (context, model, child) {
                                        final items = model.items;
                                        final List star = [0.0];
                                        final total = items.map((e) {
                                          return star.add(e.starRating);
                                        }).toList();
                                        final sum = star != null
                                            ? star?.reduce((a, b) {
                                                return a +
                                                    b / (star.length - 1);
                                              })
                                            : 0;
                                        return Center(
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                                TextSpan(
                                                    text: '平均評価： ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    )),
                                                TextSpan(
                                                  text: '${sum.toString()}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25,
                                                      color:
                                                          HexColor("E67928")),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })),
                                  mySizedBox(10),
                                  carouselSliderItems(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: 50,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: 125,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 355,
                      ),
                    ),
                  ],
                ),
                mySizedBox(25),
                _tabSection(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget carouselSliderItems() {
    return CarouselSlider(
      items: [
        TW != ""
            ? InkWell(
                onTap: () {
                  launch(TW);
                },
                child: FaIcon(
                  FontAwesomeIcons.twitterSquare,
                  color: HexColor("#E67928"),
                  size: 70,
                ),
              )
            : FaIcon(
                FontAwesomeIcons.twitterSquare,
                color: Colors.grey,
                size: 70,
              ),
        FB != ""
            ? InkWell(
                onTap: () {
                  launch(FB);
                },
                child: FaIcon(
                  FontAwesomeIcons.facebookSquare,
                  color: HexColor("#E67928"),
                  size: 70,
                ),
              )
            : FaIcon(
                FontAwesomeIcons.facebookSquare,
                color: Colors.grey,
                size: 70,
              ),
        IG == ""
            ? FaIcon(
                FontAwesomeIcons.instagramSquare,
                color: Colors.grey,
                size: 70,
              )
            : InkWell(
                onTap: () {
                  launch(IG);
                },
                child: FaIcon(
                  FontAwesomeIcons.instagramSquare,
                  color: HexColor("#E67928"),
                  size: 70,
                ),
              ),
      ],
      options: CarouselOptions(
        height: 80,
        viewportFraction: 0.3,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
      ),
    );
  }

  Widget _tabSection(BuildContext context) {
    return Container(
      color: HexColor("e5e2df"),
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: TabBar(
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                unselectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelColor: Colors.grey,
                labelColor: mainColor,
                tabs: [
                  Tab(text: "出品作品"),
                  Tab(text: "レビュー"),
                  Tab(text: "プロフィール"),
                ],
              ),
            ),
            Container(
              //Add this to give height
              height: MediaQuery.of(context).size.height,
              child: TabBarView(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: EcommerceApp.firestore
                          .collection(EcommerceApp.collectionUser)
                          .doc(uid)
                          .collection("MyUploadItems")
                          .orderBy(
                            "publishedDate",
                            descending: true,
                          )
                          .snapshots(),
                      builder: (context, dataSnapshot) {
                        return !dataSnapshot.hasData
                            ? Center(
                                child: circularProgress(),
                              )
                            : GridView.builder(
                                itemCount: dataSnapshot.data.docs.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index) {
                                  ItemModel model = ItemModel.fromJson(
                                    dataSnapshot.data.docs[index].data(),
                                  );
                                  return sourceInfoForMain(
                                    model,
                                    context,
                                  );
                                },
                              );
                      },
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore
                        .collection(EcommerceApp.collectionUser)
                        .doc(uid)
                        .collection("Review")
                        .snapshots(),
                    builder: (context, snap) {
                      return !snap.hasData
                          ? Container()
                          : snap.data.docs.length == 0
                              ? Column(
                                  children: [
                                    mySizedBox(20),
                                    beginBuildingCart(
                                        context, "取引評価はありません。", "")
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: snap.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: ListTile(
                                          trailing: Text(
                                            "購入日: " +
                                                DateFormat("yyyy年MM月dd日")
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            int.parse(snap
                                                                .data
                                                                .docs[index][
                                                                    "reviewDate"]
                                                                .toString()))),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0),
                                          ),
                                          subtitle: Text(
                                            snap.data.docs[index]["message"]
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                          title: RatingBar.builder(
                                            itemSize: 25,
                                            initialRating: snap.data.docs[index]
                                                ["starRating"],
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                    }),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Container()
                          : ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "自己紹介",
                                          style: TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      mySizedBox(10),
                                      Center(
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              snapshot.data
                                                  .data()["description"],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white60,
                                              border: Border.all(),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        leading: Text("フォロワー数："),
                                        title: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(uid)
                                                .collection("Followers")
                                                .snapshots(),
                                            builder: (c, ss) {
                                              return !ss.hasData
                                                  ? Container()
                                                  : RichText(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: moji,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: ss.data.docs
                                                                .length
                                                                .toString(),
                                                          ),
                                                          TextSpan(
                                                            text: "人",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: moji,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                            }),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        leading: Text("出品数："),
                                        title: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(uid)
                                                .collection("MyUploadItems")
                                                .snapshots(),
                                            builder: (c, ss) {
                                              return !ss.hasData
                                                  ? Container()
                                                  : RichText(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: moji,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: ss.data.docs
                                                                .length
                                                                .toString(),
                                                          ),
                                                          TextSpan(
                                                            text: "点",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: moji,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                            }),
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                TW != ""
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 3, 8, 3),
                                        child: Container(
                                          child: ListTile(
                                            leading: FaIcon(
                                              FontAwesomeIcons.twitterSquare,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            onTap: () {
                                              launch(TW);
                                            },
                                            title: Text("Twitter"),
                                            trailing: Icon(
                                              Icons.chevron_right_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                          color: HexColor("#1DA1F2"),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 3, 8, 3),
                                        child: Container(
                                          color: Colors.grey,
                                          child: ListTile(
                                            leading: FaIcon(
                                              FontAwesomeIcons.twitterSquare,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            title: Text("Twitter"),
                                          ),
                                        ),
                                      ),
                                FB != ""
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 3, 8, 3),
                                        child: Container(
                                          child: ListTile(
                                            leading: FaIcon(
                                              FontAwesomeIcons.facebookSquare,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            onTap: () {
                                              launch(FB);
                                            },
                                            title: Text("FaceBook"),
                                            trailing: Icon(
                                              Icons.chevron_right_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                          color: HexColor("#3B5998"),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 3, 8, 3),
                                        child: Container(
                                          color: Colors.grey,
                                          child: ListTile(
                                            leading: FaIcon(
                                              FontAwesomeIcons.facebookSquare,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            title: Text("FaceBook"),
                                          ),
                                        ),
                                      ),
                                IG == ""
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 3, 8, 3),
                                        child: Container(
                                          color: Colors.grey,
                                          child: ListTile(
                                            leading: FaIcon(
                                              FontAwesomeIcons.instagramSquare,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            title: Text("Instagram"),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 3, 8, 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight,
                                              stops: [
                                                0.1,
                                                0.4,
                                                0.6,
                                                0.9,
                                              ],
                                              colors: [
                                                Colors.deepPurple,
                                                Colors.red,
                                                Colors.orange,
                                                Colors.amberAccent
                                              ],
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: FaIcon(
                                              FontAwesomeIcons.instagram,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            onTap: () {
                                              launch(IG);
                                            },
                                            title: Text("Instagram"),
                                            trailing: Icon(
                                              Icons.chevron_right_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            );
                    })
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
