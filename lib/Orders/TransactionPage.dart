// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
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
      length: 3,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          centerTitle: true,
          title: Text(
            "取引履歴",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w100,
            ),
          ),
          bottom: new TabBar(
            labelColor: mainColorOfLEEWAY,
            tabs: [
              Tab(
                text: "取引中",
              ),
              Tab(
                text: "取引完了",
              ),
              Tab(
                text: "取引キャンセル",
              ),
            ],
            indicatorWeight: 3,
          ),
        ),
        body: TabBarView(children: [
          Transactioning(),
          transactioned(),
          canceled(),
        ]),
      ),
    );
  }

  canceled() {
    return StreamBuilder<QuerySnapshot>(
      stream: EcommerceApp.firestore
          .collection("users")
          .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
          .collection("Notify")
          .where("cancelTransactionFinished", isEqualTo: true)
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
