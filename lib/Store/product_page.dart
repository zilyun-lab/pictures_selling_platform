import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import '../main.dart';

class ProductPage extends StatefulWidget {
  final String id;

  ProductPage({
    this.id,
  });
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;

  _ProductPageState();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemData();
  }

  Map<String, dynamic> il = {};

  void getItemData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("items")
        .doc(widget.id)
        .get();

    setState(() {
      il = snapshot.data();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
          onTap: () async {
            await showModalBottomSheet(
              enableDrag: true,
              isDismissible: true,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
              backgroundColor: HexColor("#E67928"),
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "作品名",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        Text(
                          il["shortInfo"] ?? "",
                          style: boldTextStyle,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "作品説明",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          il["longDescription"],
                          style: boldTextStyle,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "作品情報(縦x横)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: il["itemHeight"],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  TextSpan(
                                    text: 'mm',
                                  ),
                                ],
                              ),
                            ),
                            Text(" x ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: il["itemWidth"],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  TextSpan(
                                    text: 'mm',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "金額",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: il["price"].toString(),
                              ),
                              TextSpan(
                                text: "円",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "カテゴリー",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        (() {
                          if (il["attribute"] == "Original") {
                            return Text(
                              "こちらは原画の為、１点限りとなります。",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            );
                          } else if (il["attribute"] == "Sticker") {
                            return Text(
                              "ステッカー",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            );
                          } else if (il["attribute"] == "PostCard") {
                            return Text(
                              "ポストカード",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return Text(
                              "複製画",
                              style: boldTextStyle,
                            );
                          }
                        }()),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "発送日時",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${il["shipsDate"]}",
                          style: boldTextStyle,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "在庫",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        il["Stock"] == null
                            ? Text(
                                "こちらの商品は受注生産でございます。",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                              )
                            : RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: il["Stock"].toString(),
                                    ),
                                    TextSpan(
                                      text: " 点",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "発送日時",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${il["shipsDate"]}",
                          style: boldTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        userLink(il),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 8,
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 65,
                                  height: 60,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.grey),
                                    onPressed: () => Navigator.pop(context),
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection(
                                              "items",
                                            )
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          return !snapshot.hasData
                                              ? Container()
                                              : il["postBy"] ==
                                                      EcommerceApp
                                                          .sharedPreferences
                                                          .getString(
                                                              EcommerceApp
                                                                  .userUID)
                                                  ? itemEditButton(
                                                      context, il, widget.id)
                                                  : il["attribute"] !=
                                                          "Original"
                                                      ? checkOutItemButton(
                                                          context,
                                                          il,
                                                          widget.id)
                                                      : il["Stock"] != 0
                                                          ? checkOutItemButton(
                                                              context,
                                                              il,
                                                              widget.id)
                                                          : soldOutButton(
                                                              context);
                                        },
                                      ),
                                      il["postBy"] !=
                                              EcommerceApp.sharedPreferences
                                                  .getString(
                                                      EcommerceApp.userUID)
                                          ? il["Stock"] == 0
                                              ? Container()
                                              : likeButton(context, il)
                                          : deleteItemButton(context, () {
                                              beforeDeleteDialog(
                                                  context, il, widget.id);
                                            }),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        mySizedBox(30),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: buildFooter(context)),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: InkWell(
          onTap: () {
            print(EcommerceApp.sharedPreferences
                .getStringList(EcommerceApp.userLikeList));
          },
          child: Text(
            il["shortInfo"] ?? "",
            style: TextStyle(
              color: HexColor("#E67928"),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: HexColor("#E67928"),
          ),
          onPressed: () {
            // Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => MainPage(),
                ));
          },
        ),
      ),
      body: Center(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .doc(widget.id)
                  .collection("itemImages")
                  .doc(widget.id)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                return snapshot.data == null
                    ? Container()
                    : CarouselSlider.builder(
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          aspectRatio: 1.0,
                          autoPlayInterval: Duration(seconds: 3),
                          enableInfiniteScroll: false,
                          // autoPlay: true,
                        ),
                        itemCount: snapshot.data.data()["images"].length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          return Stack(
                            children: [
                              Center(
                                child: Image.network(
                                  snapshot.data
                                      .data()["images"][index]
                                      .toString(),
                                  fit: BoxFit.scaleDown,
                                  height: MediaQuery.of(context).size.height,
                                ),
                              ),
                              Center(
                                child: Text(
                                  "LEEWAY",
                                  style: GoogleFonts.notoSerif(
                                      fontWeight: FontWeight.w100,
                                      color: Colors.grey.withOpacity(0.6),
                                      fontSize: 50),
                                ),
                              )
                            ],
                          );
                        },
                      );
              })),
    );
  }
}
