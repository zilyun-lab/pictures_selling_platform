import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Models/allList.dart';

import '../main.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  String query = "";
  String selectedItem1 = "レッド";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          title: searchWidget(),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (c) => MainPage(),
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => MainPage(),
                  ));
            },
          ),
          backgroundColor: HexColor("E67928"),
          centerTitle: true,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("items")
            .where("shortInfo", isGreaterThanOrEqualTo: query)
            .snapshots(),
        builder: (context, snap) {
          return snap.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snap.data.docs.length,
                  itemBuilder: (context, index) {
                    ItemModel model =
                        ItemModel.fromJson(snap.data.docs[index].data());
                    return SizedBox(
                      height: 75,
                      child: Card(
                        color: HexColor("e5e2df"),
                        child: ListTile(
                          onTap: () {
                            Route route = MaterialPageRoute(
                              builder: (c) => ProductPage(
                                id: model.id,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              route,
                            );
                          },
                          trailing: Text(
                            model.price.toString() + "円",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          title: Text(model.shortInfo),
                          subtitle: Text(model.longDescription),
                          leading: Image.network(
                            model.thumbnailUrl,
                            height: 75,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "お探しの作品が見つかりませんでした",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.2),
                blurRadius: 8.0,
                spreadRadius: 1.0,
                offset: Offset(5, 8))
          ],
          color: HexColor("F9DAC4"),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 15,
              ),
              child: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
            ),
            Flexible(
                child: Padding(
              padding: EdgeInsets.only(
                left: 8,
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    query = val;
                  });
                },
                decoration: InputDecoration.collapsed(hintText: "作品を探す"),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
