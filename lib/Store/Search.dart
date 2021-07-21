// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_pictures_platform/Admin/Copy.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import '../main.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct>
    with SingleTickerProviderStateMixin {
  String query = "";
  String colorQuery = "";
  double priceQuery = 0.0;
  String selectedItem1 = "レッド";
  String _labelText = "";

  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TabBar(
              tabs: <Widget>[
                Text("作品名検索"),
                Text("金額検索"),
                Text("カラー検索"),
              ],
              controller: _tabController,
              isScrollable: true,
              enableFeedback: false,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              unselectedLabelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelColor: Colors.white,
              labelColor: Colors.black,
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Container(
                child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: searchWidget()),
                        ],
                      ),
                      StreamBuilder<QuerySnapshot>(
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
                                    ItemModel model = ItemModel.fromJson(
                                        snap.data.docs[index].data());
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      searchPriceWidget(),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("items")
                            .where("price", isLessThanOrEqualTo: priceQuery)
                            .snapshots(),
                        builder: (context, snap) {
                          return snap.hasData
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snap.data.docs.length,
                                  itemBuilder: (context, index) {
                                    ItemModel model = ItemModel.fromJson(
                                        snap.data.docs[index].data());
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      searchColorWidget(),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("items")
                            .where("color1", isEqualTo: colorQuery)
                            .snapshots(),
                        builder: (context, snap) {
                          return snap.hasData
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snap.data.docs.length,
                                  itemBuilder: (context, index) {
                                    ItemModel model = ItemModel.fromJson(
                                        snap.data.docs[index].data());
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                    ],
                  ),
                )
              ],
            )),
          )
        ],
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

  Widget searchPriceWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 15, 0, 8),
          child: Text(
            "金額：$_labelText",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
          label: _labelText,
          value: priceQuery,
          min: 0,
          max: 50000,
          divisions: 1000,
          activeColor: mainColorOfLEEWAY,
          inactiveColor: Colors.blueAccent,
          onChanged: (double value) {
            setState(() {
              priceQuery = value.roundToDouble();
              _labelText = '$priceQuery 円';
            });
          },
        ),
      ],
    );
  }

  Widget searchColorWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 15, 0, 8),
          child: Text(
            "選択カラー：$selectedItem1",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<String>(
            dropdownColor: HexColor("#e5e2df"),
            isExpanded: true,
            value: selectedItem1,
            onChanged: (String newValue) {
              setState(() {
                selectedItem1 = newValue;
                colorQuery = newValue;
              });
            },
            selectedItemBuilder: (context) {
              return color1.map((item) {
                return Text(
                  item.key,
                  style: TextStyle(color: item.value),
                );
              }).toList();
            },
            items: color1.map((item) {
              return DropdownMenuItem(
                value: item.key,
                child: ListTile(
                  title: Text(
                    item.key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    Icons.waves,
                    color: item.value,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
