import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selling_pictures_platform/Admin/Copy.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Orders/AdminOrderDetailsPage.dart';
import 'package:selling_pictures_platform/Orders/OrderDetailsPage.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key key}) : super(key: key);

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  final db = FirebaseFirestore.instance
      .collection("users")
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .collection("AllNotify")
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("e5e2df"),
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TabBar(
              isScrollable: true,
              enableFeedback: false,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              unselectedLabelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelColor: Colors.grey,
              labelColor: mainColor,
              tabs: <Widget>[
                Tab(text: "運営"),
                Tab(text: "ガイド"),
                Tab(text: "チャット"),
              ],
              controller: _tabController,
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Container(
              color: HexColor("e5e2df"),
              child: TabBarView(
                controller: _tabController,
                children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: db
                          .collection("From Admin")
                          .orderBy(
                            "date",
                            descending: true,
                          )
                          .snapshots(),
                      builder: (c, snap) {
                        return !snap.hasData
                            ? Container(
                                color: Colors.red,
                              )
                            : ListView.builder(
                                itemBuilder: (c, index) {
                                  return ListTile(
                                    title:
                                        Text(snap.data.docs[index]["message"]),
                                    subtitle: Text(
                                        DateFormat("yyyy年M月d日 HH時mm分")
                                            .format(snap
                                                .data.docs[index]["date"]
                                                .toDate())
                                            .toString()),
                                    leading: Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage(
                                            "images/isColor_Vertical.png"),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: snap.data.docs.length,
                              );
                      }),
                  Text(""),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.userUID))
                          .collection("chat")
                          .orderBy("created_at", descending: false)
                          .snapshots(),
                      builder: (c, snap) {
                        return !snap.hasData
                            ? Container()
                            : ListView.builder(
                                itemCount: snap.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("orders")
                                          .doc(snap.data.docs[index]["orderID"])
                                          .snapshots(),
                                      builder: (context, ss) {
                                        return !snap.hasData
                                            ? Container()
                                            : ListTile(
                                                onTap: () {
                                                  ss.data.data()["buyerID"] ==
                                                          EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID)
                                                      ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (c) =>
                                                                  OrderDetails(
                                                                    totalPrice: ss
                                                                            .data
                                                                            .data()[
                                                                        "totalPrice"],
                                                                    orderID: snap
                                                                            .data
                                                                            .docs[index]
                                                                        [
                                                                        "orderID"],
                                                                  )))
                                                      : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (c) =>
                                                                  AdminOrderDetails(
                                                                    totalPrice: ss
                                                                            .data
                                                                            .data()[
                                                                        "totalPrice"],
                                                                    orderID: snap
                                                                            .data
                                                                            .docs[index]
                                                                        [
                                                                        "orderID"],
                                                                  )));
                                                },
                                                leading: Image.network(
                                                  ss.data
                                                      .data()["imageURL"]
                                                      .toString(),
                                                  height: 50,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                                title: Text(
                                                  "${snap.data.docs[index]["user_name"]} 様より ${ss.data.data()["productIDs"]} にてメッセージが届いています。",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                subtitle: Text(DateFormat(
                                                        "yyyy年MM月dd日 - HH時mm分")
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            int.parse(snap.data
                                                                    .docs[index]
                                                                [
                                                                "created_at"])))),
                                              );
                                      });
                                },
                              );
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
