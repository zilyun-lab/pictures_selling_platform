// Flutter imports:
// Package imports:
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Admin/test.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/star_rating_model.dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicUserPage extends StatefulWidget {
  final String uid;
  final String imageUrl;
  final String name;
  final String description;
  final String FB;
  final String TW;
  final String IG;

  const({
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
  _PublicUserPageState createState() => _PublicUserPageState();
}

class _PublicUserPageState extends State<PublicUserPage> {
  Color moji = Colors.black;
  String _verticalGroupValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
                        child: Neumorphic(
                          child: Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 65,
                                    ),
                                    DefaultTextStyle(
                                        style: const TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        child: Text(widget.name)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ChangeNotifierProvider<StarRatingModel>(
                                        create: (_) =>
                                            StarRatingModel(id: widget.uid)
                                              ..fetchItems(),
                                        child: Consumer<StarRatingModel>(
                                            builder: (context, model, child) {
                                          final items = model.items;
                                          final star = [0.0];
                                          final total = items.map((e) {
                                            return star.add(e.starRating);
                                          }).toList();
                                          final sum = star != null
                                              ? star?.reduce((a, b) {
                                                  return (((a +
                                                                  b /
                                                                      (star.length -
                                                                          1)) *
                                                              10)
                                                          .round()) /
                                                      10;
                                                })
                                              : 0;
                                          return Center(
                                            child: RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  const TextSpan(
                                                      text: '平均評価： ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      )),
                                                  TextSpan(
                                                    text: sum.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25,
                                                        color:
                                                            HexColor('E67928')),
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
                    ),
                    Positioned.fill(
                      top: 25,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              color: bgColor,
                              boxShape: const NeumorphicBoxShape.circle(),
                              depth: 19,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      widget.imageUrl,
                                    ),
                                  )),
                            ),
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
        widget.TW != ''
            ? InkWell(
                onTap: () {
                  launch(widget.TW);
                },
                child: FaIcon(
                  FontAwesomeIcons.twitterSquare,
                  color: HexColor('#E67928'),
                  size: 70,
                ),
              )
            : const FaIcon(
                FontAwesomeIcons.twitterSquare,
                color: Colors.grey,
                size: 70,
              ),
        widget.FB != ''
            ? InkWell(
                onTap: () {
                  launch(widget.FB);
                },
                child: FaIcon(
                  FontAwesomeIcons.facebookSquare,
                  color: HexColor('#E67928'),
                  size: 70,
                ),
              )
            : const FaIcon(
                FontAwesomeIcons.facebookSquare,
                color: Colors.grey,
                size: 70,
              ),
        widget.IG == ''
            ? const FaIcon(
                FontAwesomeIcons.instagramSquare,
                color: Colors.grey,
                size: 70,
              )
            : InkWell(
                onTap: () {
                  launch(widget.IG);
                },
                child: FaIcon(
                  FontAwesomeIcons.instagramSquare,
                  color: HexColor('#E67928'),
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
      color: bgColor,
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: TabBar(
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelColor: Colors.grey,
                labelColor: mainColorOfLEEWAY,
                tabs: [
                  const Tab(text: '出品作品'),
                  const Tab(text: 'レビュー'),
                  const Tab(text: 'プロフィール'),
                ],
              ),
            ),
            Container(
              //Add this to give height
              height: MediaQuery.of(context).size.height,
              child: TabBarView(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: EcommerceApp.firestore
                          .collection(EcommerceApp.collectionUser)
                          .doc(widget.uid)
                          .collection('MyUploadItems')
                          .orderBy(
                            'publishedDate',
                            descending: true,
                          )
                          .snapshots(),
                      builder: (context, dataSnapshot) {
                        if (!dataSnapshot.hasData) {
                          return Center(
                                child: circular_progress(),
                              );
                        } else {
                          return GridView.builder(
                                itemCount: dataSnapshot.data.docs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index) {
                                  final model = ItemModel.fromJson(
                                    dataSnapshot.data.docs[index].data(),
                                  );
                                  return sourceInfoForMain(
                                    model,
                                    context,
                                  );
                                },
                              );
                        }
                      },
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore
                        .collection(EcommerceApp.collectionUser)
                        .doc(widget.uid)
                        .collection('Review')
                        .snapshots(),
                    builder: (context, snap) {
                      return !snap.hasData
                          ? Container()
                          : snap.data.docs.isEmpty
                              ? Column(
                                  children: [
                                    mySizedBox(20),
                                     beginBuildingCart(
                                        context, '取引評価はありません。', '')
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: snap.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Neumorphic(
                                          style:
                                              NeumorphicStyle(color: bgColor),
                                          child: ListTile(
                                            trailing: Text(
                                              '購入日: ${DateFormat('yyyy年MM月dd日')
                                                      .format(DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              int.parse(snap
                                                                  .data
                                                                  .docs[index][
                                                                      'reviewDate']
                                                                  .toString())))}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                            ),
                                            subtitle: Text(
                                              snap.data.docs[index]['message']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
                                            ),
                                            title: RatingBar.builder(
                                              itemSize: 25,
                                              initialRating: snap.data
                                                  .docs[index]['starRating'],
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: const EdgeInsets.symmetric(
                                                  horizontal: 2),
                                              itemBuilder: (context, _) => const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                    }),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Container()
                          : ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          '自己紹介',
                                          style: TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      mySizedBox(10),
                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white60,
                                              border: Border.all(),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(15))),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              snapshot.data
                                                  .data()['description'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        leading: const Text('フォロワー数：'),
                                        title: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(widget.uid)
                                                .collection('Followers')
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
                                                            text: '人',
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
                                        leading: const Text('出品数：'),
                                        title: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(widget.uid)
                                                .collection('MyUploadItems')
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
                                                            text: '点',
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
                                ),
                                widget.TW != ''
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Container(
                                          color: HexColor('#1DA1F2'),
                                          child: ListTile(
                                            leading: const FaIcon(
                                              FontAwesomeIcons.twitterSquare,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            onTap: () {
                                              launch(widget.TW);
                                            },
                                            title: const Text('Twitter'),
                                            trailing: const Icon(
                                              Icons.chevron_right_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Container(
                                          color: Colors.grey,
                                          child: const ListTile(
                                            leading: FaIcon(
                                              FontAwesomeIcons.twitterSquare,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            title: Text('Twitter'),
                                          ),
                                        ),
                                      ),
                                widget.FB != ''
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Container(
                                          color: HexColor('#3B5998'),
                                          child: ListTile(
                                            leading: const FaIcon(
                                              FontAwesomeIcons.facebookSquare,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            onTap: () {
                                              launch(widget.FB);
                                            },
                                            title: const Text('FaceBook'),
                                            trailing: const Icon(
                                              Icons.chevron_right_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Container(
                                          color: Colors.grey,
                                          child: const ListTile(
                                            leading: FaIcon(
                                              FontAwesomeIcons.facebookSquare,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            title: Text('FaceBook'),
                                          ),
                                        ),
                                      ),
                                widget.IG == ''
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Container(
                                          color: Colors.grey,
                                          child: const ListTile(
                                            leading: FaIcon(
                                              FontAwesomeIcons.instagramSquare,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            title: Text('Instagram'),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Container(
                                          decoration: const BoxDecoration(
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
                                            leading: const FaIcon(
                                              FontAwesomeIcons.instagram,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            onTap: () {
                                              launch(widget.IG);
                                            },
                                            title: const Text('Instagram'),
                                            trailing: const Icon(
                                              Icons.chevron_right_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (c) {
                                            return AlertDialog(
                                              title: const Center(
                                                child: Text(
                                                  '通報',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              content: RadioButtonGroup(
                                                labels: reportTitle,
                                                onSelected: (String selected) {
                                                  setState(() {
                                                    _verticalGroupValue =
                                                        selected;
                                                  });
                                                  print(_verticalGroupValue);
                                                },
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .transparent),
                                                          child: const Text('キャンセル'),
                                                        ),
                                                      ),
                                                    ),
                                                    _verticalGroupValue == ''
                                                        ? Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        primary:
                                                                            Colors.transparent),
                                                                child: const Text(
                                                                  '送信する',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'report')
                                                                      .doc()
                                                                      .set({
                                                                    'reportFrom': EcommerceApp
                                                                        .sharedPreferences
                                                                        .getString(
                                                                            EcommerceApp.userUID),
                                                                    'date':
                                                                        DateTime
                                                                            .now(),
                                                                    'reportTo':
                                                                        widget
                                                                            .uid,
                                                                    'why':
                                                                        _verticalGroupValue,
                                                                    'Tag':
                                                                        'UserReport'
                                                                  });
                                                                },
                                                                child: const Text(
                                                                  '送信',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: const Center(
                                      child: Text(
                                        'このユーザーを通報する',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 15),
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
