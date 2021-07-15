// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Counters/Likeitemcounter.dart';
import 'package:selling_pictures_platform/Models/GetLikeItemsModel.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';

class LikePage extends StatefulWidget {
  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  final mainColor = HexColor("E67928");
  double totalAmount;
  int gridCount = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // totalAmount = 0;
    // Provider.of<TotalAmount>(
    //   context,
    //   listen: false,
    // ).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor,
        body: ChangeNotifierProvider<GetLikeItemsModel>(
          create: (_) => GetLikeItemsModel()..fetchItems(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: mySizedBox(MediaQuery.of(context).size.height * 0.04),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: mainColorOfLEEWAY,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 8, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "いいね",
                          style: GoogleFonts.kosugi(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              child: Card(
                                child: Icon(
                                  Icons.crop_square,
                                  size: 40,
                                  color: mainColorOfLEEWAY,
                                ),
                                color: Colors.white,
                              ),
                              onTap: () {
                                setState(() {
                                  gridCount = 1;
                                });
                              },
                            ),
                            InkWell(
                              child: Card(
                                child: Icon(
                                  Icons.grid_view_outlined,
                                  size: 40,
                                  color: mainColorOfLEEWAY,
                                ),
                                color: Colors.white,
                              ),
                              onTap: () {
                                setState(() {
                                  gridCount = 2;
                                });
                              },
                            ),
                            InkWell(
                              child: Card(
                                color: Colors.white,
                                child: Icon(
                                  Icons.grid_3x3_outlined,
                                  size: 40,
                                  color: mainColorOfLEEWAY,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  gridCount = 3;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Consumer<GetLikeItemsModel>(
                builder: (context, model, child) {
                  final items = model.items;
                  if (items.length == 0) {
                    return SliverToBoxAdapter(child: Container());
                  } else {
                    if (gridCount == 2) {
                      return SliverGrid.count(
                        crossAxisCount: gridCount,
                        children: items
                            .map((item) =>
                                sourceInfoForMainOfLikex2(item, context))
                            .toList(),
                      );
                    } else if (gridCount == 1) {
                      return SliverGrid.count(
                        crossAxisCount: gridCount,
                        children: items
                            .map((item) =>
                                sourceInfoForMainOfLikex1(item, context))
                            .toList(),
                      );
                    } else {
                      return SliverGrid.count(
                        crossAxisCount: gridCount,
                        children: items
                            .map((item) =>
                                sourceInfoForMainOfLikex3(item, context))
                            .toList(),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ));
  }
}
