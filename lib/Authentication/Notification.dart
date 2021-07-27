import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:selling_pictures_platform/Admin/Copy.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Orders/AdminOrderDetailsPage.dart';
import 'package:selling_pictures_platform/Orders/OrderDetailsPage.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';

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
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
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
                            ? Container()
                            : ListView.builder(
                                itemCount: snap.data.docs.length,
                                itemBuilder: (c, index) {
                                  final tag = snap.data.docs[index]["Tag"];
                                  return tag == "Admin"
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              color: bgColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                title: Text(snap.data
                                                    .docs[index]["message"]),
                                                subtitle: Text(DateFormat(
                                                        "yyyy年M月d日 HH時mm分")
                                                    .format(snap.data
                                                        .docs[index]["date"]
                                                        .toDate())
                                                    .toString()),
                                                leading: Container(
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        "images/isColor_Vertical.png"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : StreamBuilder<
                                              DocumentSnapshot<
                                                  Map<String, dynamic>>>(
                                          stream: FirebaseFirestore.instance
                                              .collection("orders")
                                              .doc(snap.data.docs[index]
                                                  ["orderID"])
                                              .snapshots(),
                                          builder: (c, ss) {
                                            return !ss.hasData
                                                ? Container()
                                                : () {
                                                    if (tag == "Transaction") {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Neumorphic(
                                                          style:
                                                              NeumorphicStyle(
                                                            color: bgColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: ListTile(
                                                                subtitle: Text(DateFormat(
                                                                        "yyyy年M月d日 HH時mm分")
                                                                    .format(snap
                                                                        .data
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            "date"]
                                                                        .toDate())
                                                                    .toString()),
                                                                leading: Image
                                                                    .network(
                                                                  ss.data
                                                                      .data()[
                                                                          "imageURL"]
                                                                      .toString(),
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                ),
                                                                title: ss.data.data()["sellerID"] != EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) &&
                                                                        ss.data.data()["buyerID"] ==
                                                                            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)
                                                                    ? Text("${ss.data.data()["boughtFrom"]} 様との 「${ss.data.data()["productIDs"]}」の取引が完了しました。")
                                                                    : Text("${ss.data.data()["orderByName"]} 様との 「${ss.data.data()["productIDs"]}」の取引が完了しました。")),
                                                          ),
                                                        ),
                                                      );
                                                    } else if (tag ==
                                                        "Cancel") {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Neumorphic(
                                                          style:
                                                              NeumorphicStyle(
                                                            color: bgColor,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: ListTile(
                                                                subtitle: Text(DateFormat(
                                                                        "yyyy年M月d日 HH時mm分")
                                                                    .format(snap
                                                                        .data
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            "date"]
                                                                        .toDate())
                                                                    .toString()),
                                                                leading: Image
                                                                    .network(
                                                                  ss.data
                                                                      .data()[
                                                                          "imageURL"]
                                                                      .toString(),
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                ),
                                                                title: ss.data.data()["sellerID"] != EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) &&
                                                                        ss.data.data()["buyerID"] ==
                                                                            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)
                                                                    ? Text("${ss.data.data()["boughtFrom"]} 様との 「${ss.data.data()["productIDs"]}」の取引キャンセルが成立しました。")
                                                                    : Text("${ss.data.data()["orderByName"]} 様との 「${ss.data.data()["productIDs"]}」の取引キャンセルが成立しました。")),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }();
                                          });
                                });
                      }),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("orders")
                        .snapshots(),
                    builder: (c, snap) {
                      return !snap.hasData
                          ? Container()
                          : ListView.builder(
                              itemCount: snap.data.docs.length,
                              itemBuilder: (c, index) {
                                return (() {
                                  if (snap.data.docs[index]["buyerID"] ==
                                      EcommerceApp.sharedPreferences
                                          .getString(EcommerceApp.userUID)) {
                                    //todo:自分が買った時
                                    return (() {
                                      if (snap.data.docs[index]
                                                  ["isBuyerDelivery"] ==
                                              "inComplete" &&
                                          snap.data.docs[index]["sellerID"] !=
                                              EcommerceApp.sharedPreferences
                                                  .getString(
                                                      EcommerceApp.userUID)) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Neumorphic(
                                              style: NeumorphicStyle(
                                                color: bgColor,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                  trailing: Icon(
                                                    Icons
                                                        .arrow_forward_ios_outlined,
                                                    color: HexColor("e67928"),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (c) =>
                                                                OrderDetails(
                                                                  orderID: snap
                                                                          .data
                                                                          .docs[
                                                                      index]["id"],
                                                                  totalPrice: snap
                                                                          .data
                                                                          .docs[index]
                                                                      [
                                                                      "totalPrice"],
                                                                )));
                                                  },
                                                  title: Text(
                                                      "支払いが完了しました。\n販売者の発送をお待ち下さい！"),
                                                  leading: Image.network(
                                                    snap.data
                                                        .docs[index]["imageURL"]
                                                        .toString(),
                                                    height: 50,
                                                    width: 75,
                                                    fit: BoxFit.scaleDown,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (snap.data.docs[index]
                                                  ["isTransactionFinished"] ==
                                              "inComplete" &&
                                          snap.data.docs[index]
                                                  ["isBuyerDelivery"] ==
                                              "Complete") {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              color: bgColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                trailing: Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  color: HexColor("e67928"),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (c) =>
                                                                  OrderDetails(
                                                                    orderID: snap
                                                                            .data
                                                                            .docs[
                                                                        index]["id"],
                                                                    totalPrice: snap
                                                                            .data
                                                                            .docs[index]
                                                                        [
                                                                        "totalPrice"],
                                                                  )));
                                                },
                                                title: Text(
                                                    "作品が発送されました。\n作品が届きましたら販売者の評価をしましょう！"),
                                                leading: Image.network(
                                                  snap.data
                                                      .docs[index]["imageURL"]
                                                      .toString(),
                                                  height: 50,
                                                  width: 75,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (snap.data.docs[index]
                                              ["isTransactionFinished"] ==
                                          "Complete") {
                                        return Container();
                                      }
                                    })();
                                  } else {
                                    //todo:自分が売った時
                                    return (() {
                                      if (snap.data.docs[index]
                                              ["isBuyerDelivery"] ==
                                          "inComplete") {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              color: bgColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                trailing: Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  color: HexColor("e67928"),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (c) =>
                                                              AdminOrderDetails(
                                                                orderID: snap
                                                                        .data
                                                                        .docs[
                                                                    index]["id"],
                                                                totalPrice: snap
                                                                            .data
                                                                            .docs[
                                                                        index][
                                                                    "totalPrice"],
                                                              )));
                                                },
                                                title: Text(
                                                    "作品が購入されました。\n商品の発送を行いましょう！"),
                                                leading: Image.network(
                                                  snap.data
                                                      .docs[index]["imageURL"]
                                                      .toString(),
                                                  height: 50,
                                                  width: 75,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (snap.data.docs[index]
                                                  ["isTransactionFinished"] ==
                                              "inComplete" &&
                                          snap.data.docs[index]
                                                  ["isBuyerDelivery"] ==
                                              "Complete") {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Neumorphic(
                                              style: NeumorphicStyle(
                                                  color: bgColor),
                                              child: ListTile(
                                                trailing: Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  color: HexColor("e67928"),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (c) =>
                                                              AdminOrderDetails(
                                                                orderID: snap
                                                                        .data
                                                                        .docs[
                                                                    index]["id"],
                                                                totalPrice: snap
                                                                            .data
                                                                            .docs[
                                                                        index][
                                                                    "totalPrice"],
                                                              )));
                                                },
                                                title: Text(
                                                    "作品を発送しました。\n購入者の評価を待ちましょう！"),
                                                leading: Image.network(
                                                  snap.data
                                                      .docs[index]["imageURL"]
                                                      .toString(),
                                                  height: 50,
                                                  width: 75,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (snap.data.docs[index]
                                              ["isTransactionFinished"] ==
                                          "Complete") {
                                        return Container();
                                      }
                                    })();
                                  }
                                })();
                              });
                    },
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.userUID))
                          .collection("chat")
                          .orderBy("created_at", descending: true)
                          .snapshots(),
                      builder: (c, snap) {
                        return !snap.hasData
                            ? Container()
                            : ListView.builder(
                                itemCount: snap.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return !snap.hasData
                                      ? Container()
                                      : StreamBuilder<
                                              DocumentSnapshot<
                                                  Map<String, dynamic>>>(
                                          stream: FirebaseFirestore.instance
                                              .collection("orders")
                                              .doc(snap.data.docs[index]
                                                  ["orderID"])
                                              .snapshots(),
                                          builder: (context, ss) {
                                            return !snap.hasData
                                                ? Container()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Neumorphic(
                                                      style: NeumorphicStyle(
                                                        color: bgColor,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ListTile(
                                                          trailing: Icon(
                                                            Icons
                                                                .arrow_forward_ios_outlined,
                                                            color: HexColor(
                                                                "e67928"),
                                                          ),
                                                          onTap: () {
                                                            ss.data.data()[
                                                                        "buyerID"] ==
                                                                    EcommerceApp
                                                                        .sharedPreferences
                                                                        .getString(
                                                                            EcommerceApp.userUID)
                                                                ? Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (c) => OrderDetails(
                                                                              totalPrice: ss.data.data()["totalPrice"],
                                                                              orderID: snap.data.docs[index]["orderID"],
                                                                            )))
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (c) => AdminOrderDetails(
                                                                              totalPrice: ss.data.data()["totalPrice"],
                                                                              orderID: snap.data.docs[index]["orderID"],
                                                                            )));
                                                          },
                                                          leading:
                                                              Image.network(
                                                            ss.data
                                                                .data()[
                                                                    "imageURL"]
                                                                .toString(),
                                                            height: 50,
                                                            width: 75,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                          ),
                                                          title: Text(
                                                            "${snap.data.docs[index]["user_name"]} 様より ${ss.data.data()["productIDs"]} にてメッセージが届いています。",
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          ),
                                                          subtitle: Text(DateFormat(
                                                                  "yyyy年MM月dd日 - HH時mm分")
                                                              .format(DateTime.fromMillisecondsSinceEpoch(
                                                                  int.parse(snap
                                                                          .data
                                                                          .docs[index]
                                                                      [
                                                                      "created_at"])))),
                                                        ),
                                                      ),
                                                    ),
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
