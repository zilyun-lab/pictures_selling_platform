import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/Widgets/orderCard.dart';

import '../main.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key key, this.name, this.id}) : super(key: key);
  final String name;
  final String id;

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with AutomaticKeepAliveClientMixin<TransactionPage> {
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: HexColor("e5e2df"),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (c) => MainPage(),
              );
              Navigator.pushReplacement(context, route);
            },
            icon: Icon(
              Icons.home_outlined,
              size: 35,
            ),
          ),
          backgroundColor: HexColor("#E67928"),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            "取引履歴",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w100,
            ),
          ),
          bottom: new TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(
                text: "取引中",
              ),
              Tab(
                text: "取引完了",
              ),
            ],
            indicatorWeight: 3,
          ),
        ),
        body: TabBarView(children: [
          Transactioning(),
          transactioned(),
        ]),
      ),
    );
  }

  transactioned() {
    return StreamBuilder<QuerySnapshot>(
      stream: EcommerceApp.firestore
          .collection("users")
          .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
          .collection("Notify")
          .where("isTransactionFinished", isEqualTo: "Complete")
          .snapshots(),
      builder: (c, snapshot) {
        return !snapshot.hasData
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (c, index) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("items")
                        .where("shortInfo",
                            isEqualTo: snapshot.data.docs[index]["productIDs"])
                        .snapshots(),
                    builder: (c, snap) {
                      return snap.hasData
                          ? AdminOrderCard(
                              totalPrice: snapshot.data.docs[index]
                                  ["totalPrice"],
                              itemCount: snap.data.docs.length,
                              data: snap.data.docs,
                              orderID: snapshot.data.docs[index].id,
                              speakingToID: widget.id,
                              speakingToName: widget.name,
                            )
                          : Center(
                              child: circularProgress(),
                            );
                    },
                  );
                },
              );
      },
    );
  }

  Transactioning() {
    return StreamBuilder<QuerySnapshot>(
      stream: EcommerceApp.firestore
          .collection(EcommerceApp.collectionUser)
          .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
          .collection("Notify")
          .where("isTransactionFinished", isEqualTo: "inComplete")
          .snapshots(),
      builder: (c, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (c, index) {
                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("items")
                        .where("shortInfo",
                            isEqualTo: snapshot.data.docs[index]["productIDs"])
                        .get(),
                    builder: (c, snap) {
                      return snap.hasData
                          ? AdminOrderCard(
                              totalPrice: snapshot.data.docs[index]
                                  ["totalPrice"],
                              itemCount: snap.data.docs.length,
                              data: snap.data.docs,
                              orderID: snapshot.data.docs[index].id,
                              speakingToID: widget.id,
                              speakingToName: widget.name,
                            )
                          : Center(
                              child: circularProgress(),
                            );
                    },
                  );
                },
              )
            : Center(
                child: circularProgress(),
              );
      },
    );
  }
}
