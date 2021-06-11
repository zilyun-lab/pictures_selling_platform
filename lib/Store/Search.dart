import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_pictures_platform/Widgets/myDrawer.dart';

import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> docList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: MyAppBar(
          bottom: PreferredSize(
            child: searchWidget(),
            preferredSize: Size(56.0, 56.0),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
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
                        "検索した商品が見つかりませんでした",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
          },
        ),
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
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 8,
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
                  startSearching(val);
                },
                decoration: InputDecoration.collapsed(hintText: "検索する"),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async {
    docList = FirebaseFirestore.instance
        .collection("items")
        .where("shortInfo", isGreaterThanOrEqualTo: query)
        .get();
  }
}
