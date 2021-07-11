import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
import 'package:url_launcher/url_launcher.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("e5e2df"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 235,
                    decoration: BoxDecoration(
                      color: HexColor("#E67928"),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(90),
                        bottomRight: Radius.circular(90),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 100,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width * 0.8,
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
                                  create: (_) =>
                                      StarRatingModel(id: uid)..fetchItems(),
                                  child: Consumer<StarRatingModel>(
                                      builder: (context, model, child) {
                                    final items = model.items;
                                    final List star = [0.0];
                                    final total = items.map((e) {
                                      return star.add(e.starRating);
                                    }).toList();
                                    final sum = star != null
                                        ? star?.reduce((a, b) {
                                            return a + b / (star.length - 1);
                                          })
                                        : 0;
                                    return Center(
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                                text: '平均評価： ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                )),
                                            TextSpan(
                                              text: '${sum.toString()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: HexColor("E67928")),
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
                  top: 60,
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
                    width: 100,
                    height: 350,
                  ),
                ),
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
                    return !snap.hasData
                        ? beginBuildingCart(context, "取引評価はありません。", "")
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
                                          DateFormat("yyyy年MM月dd日").format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      int.parse(snap
                                                          .data
                                                          .docs[index]
                                                              ["reviewDate"]
                                                          .toString()))),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16.0),
                                    ),
                                    subtitle: Text(snap
                                        .data.docs[index]["message"]
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
                                        size: 8,
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
