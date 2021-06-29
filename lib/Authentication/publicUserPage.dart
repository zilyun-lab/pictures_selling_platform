import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:selling_pictures_platform/Admin/MyUploadItems.dart';
import 'package:selling_pictures_platform/Admin/uploadItems.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class PublicUserPage extends StatelessWidget {
  final String uid;
  final String imageUrl;
  final String name;
  final String description;

  PublicUserPage({
    Key key,
    this.uid,
    this.imageUrl,
    this.description,
    this.name,
  }) : super(key: key);

  TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("e5e2df"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: HexColor("#E67928"),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                      bottomRight: Radius.circular(90),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.105,
                  left: MediaQuery.of(context).size.width * 0.04,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 65,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 30.0,
                                    ),
                                    child: Flexible(
                                      child: Center(
                                          child: DefaultTextStyle(
                                              style: TextStyle(
                                                  color: Colors.lightBlueAccent,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              child: new Text(name))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(uid)
                                          .collection("Review")
                                          .snapshots(),
                                      builder: (ctx, snap) {
                                        for (var i = 0;
                                            i < snap.data.docs.length;
                                            i++) {
                                          return Center(
                                            child: Text(
                                                "平均評価：${snap.data.docs[i]["starRating"] / 2 + snap.data.docs[i]["starRating"] / 2}"),
                                          );
                                        }
                                        return null;
                                      }),
                                  carouselSliderItems(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.08,
                  left: MediaQuery.of(context).size.width * 0.325,
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
                Container(
                  //color: Colors.black.withOpacity(0.7),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.36,
                )
              ],
            ),
            _tabSection(context)
          ],
        ),
      ),
    );
  }

  Widget carouselSliderItems() {
    return CarouselSlider(
      items: [
        SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  launch(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.TwitterURL));
                },
                child: EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.TwitterURL) !=
                        ""
                    ? FaIcon(
                        FontAwesomeIcons.twitterSquare,
                        color: HexColor("#E67928"),
                        size: 70,
                      )
                    : FaIcon(
                        FontAwesomeIcons.twitterSquare,
                        color: Colors.white54,
                        size: 70,
                      ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            launch(EcommerceApp.sharedPreferences
                .getString(EcommerceApp.FaceBookURL));
          },
          child: EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.FaceBookURL) !=
                  ""
              ? FaIcon(
                  FontAwesomeIcons.facebookSquare,
                  color: HexColor("#E67928"),
                  size: 70,
                )
              : FaIcon(
                  FontAwesomeIcons.facebookSquare,
                  color: Colors.white54,
                  size: 70,
                ),
        ),
        InkWell(
          onTap: () {
            launch(EcommerceApp.sharedPreferences
                .getString(EcommerceApp.InstagramURL));
          },
          child: EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.InstagramURL) ==
                  ""
              ? FaIcon(
                  FontAwesomeIcons.instagramSquare,
                  color: Colors.white54,
                  size: 70,
                )
              : FaIcon(
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
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              unselectedLabelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelColor: Colors.grey,
              labelColor: mainColor,
              tabs: [
                Tab(text: "出品作品"),
                Tab(text: "レビュー"),
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
                    return ListView.builder(
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
                                      DateFormat("yyyy年MM月dd日").format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(snap.data
                                                  .docs[index]["reviewDate"]
                                                  .toString()))),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                                subtitle: Text(snap.data.docs[index]["message"]
                                    .toString()),
                                title: RatingBar.builder(
                                  itemSize: 25,
                                  initialRating: snap.data.docs[index]
                                      ["starRating"],
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  })
            ]),
          ),
        ],
      ),
    );
  }
}
