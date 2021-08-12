import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:selling_pictures_platform/Admin/Copy.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/AllProviders.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Orders/AdminOrderDetailsPage.dart';
import 'package:selling_pictures_platform/Orders/OrderDetailsPage.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';

class UserNotification extends HookConsumerWidget {
  const UserNotification({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = FirebaseFirestore.instance
        .collection("users")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("AllNotify")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID));
    final _tabController = useTabController(initialLength: 3);
    var orderIDForP = useState("");
    final orderP = ref.watch(orderWithIDStreamProvider(orderIDForP.value));
    final chatP = ref.watch(chatStreamProvider);
    final ordersProvider = ref.watch(ordersStreamProvider);
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
                  ordersProvider.when(
                    data: (items) {
                      return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (c, index) {
                            final item = items[index];
                            return (() {
                              if (item.buyerID ==
                                  EcommerceApp.sharedPreferences
                                      .getString(EcommerceApp.userUID)) {
                                //todo:自分が買った時
                                return (() {
                                  if (item.isBuyerDelivery == "inComplete" &&
                                      item.sellerID !=
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
                                            padding: const EdgeInsets.all(8.0),
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
                                                              orderID: item.id,
                                                              totalPrice: item
                                                                  .totalPrice,
                                                            )));
                                              },
                                              title: Text(
                                                  "支払いが完了しました。\n販売者の発送をお待ち下さい！"),
                                              leading: Image.network(
                                                item.imageURL.toString(),
                                                height: 50,
                                                width: 75,
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (item.isTransactionFinished ==
                                          "inComplete" &&
                                      item.isBuyerDelivery == "Complete") {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          color: bgColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            trailing: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: HexColor("e67928"),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (c) =>
                                                          OrderDetails(
                                                            orderID: item.id,
                                                            totalPrice:
                                                                item.totalPrice,
                                                          )));
                                            },
                                            title: Text(
                                                "作品が発送されました。\n作品が届きましたら販売者の評価をしましょう！"),
                                            leading: Image.network(
                                              item.imageURL.toString(),
                                              height: 50,
                                              width: 75,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (item.isTransactionFinished ==
                                      "Complete") {
                                    return Container();
                                  }
                                })();
                              } else {
                                //todo:自分が売った時
                                return (() {
                                  if (item.isBuyerDelivery == "inComplete") {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          color: bgColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            trailing: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: HexColor("e67928"),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (c) =>
                                                          AdminOrderDetails(
                                                            orderID: item.id,
                                                            totalPrice:
                                                                item.totalPrice,
                                                          )));
                                            },
                                            title: Text(
                                                "作品が購入されました。\n商品の発送を行いましょう！"),
                                            leading: Image.network(
                                              item.imageURL.toString(),
                                              height: 50,
                                              width: 75,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (item.isTransactionFinished ==
                                          "inComplete" &&
                                      item.isBuyerDelivery == "Complete") {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Neumorphic(
                                          style:
                                              NeumorphicStyle(color: bgColor),
                                          child: ListTile(
                                            trailing: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: HexColor("e67928"),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (c) =>
                                                          AdminOrderDetails(
                                                            orderID: item.id,
                                                            totalPrice:
                                                                item.totalPrice,
                                                          )));
                                            },
                                            title: Text(
                                                "作品を発送しました。\n購入者の評価を待ちましょう！"),
                                            leading: Image.network(
                                              item.imageURL.toString(),
                                              height: 50,
                                              width: 75,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (item.isTransactionFinished ==
                                      "Complete") {
                                    return Container();
                                  }
                                })();
                              }
                            })();
                          });
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => Text('Error: $error'),
                  ),
                  chatP.when(
                    data: (cItems) {
                      return ListView.builder(
                        itemCount: cItems.length,
                        itemBuilder: (BuildContext context, int idx) {
                          final chatItem = cItems[idx];
                          orderIDForP.value = chatItem.orderID;
                          return orderP.when(
                            data: (items) {
                              final item = items[idx];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                    color: bgColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      trailing: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: HexColor("e67928"),
                                      ),
                                      onTap: () {
                                        item.buyerID ==
                                                EcommerceApp.sharedPreferences
                                                    .getString(
                                                        EcommerceApp.userUID)
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (c) =>
                                                        OrderDetails(
                                                          totalPrice:
                                                              item.totalPrice,
                                                          orderID:
                                                              chatItem.orderID,
                                                        )))
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (c) =>
                                                        AdminOrderDetails(
                                                          totalPrice:
                                                              item.totalPrice,
                                                          orderID:
                                                              chatItem.orderID,
                                                        )));
                                      },
                                      leading: Image.network(
                                        item.imageURL,
                                        height: 50,
                                        width: 75,
                                        fit: BoxFit.scaleDown,
                                      ),
                                      title: Text(
                                        "${chatItem.user_name} 様より ${item.productIDs} にてメッセージが届いています。",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      subtitle: Text(DateFormat(
                                              "yyyy年MM月dd日 - HH時mm分")
                                          .format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  int.parse(
                                                      chatItem.created_at)))),
                                    ),
                                  ),
                                ),
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stack) => Text('Error: $error'),
                          );
                        },
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => Text('Error: $error'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
