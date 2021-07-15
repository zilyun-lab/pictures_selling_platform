// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Admin/uploadItems.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/CheckBox.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/Widgets/orderCard.dart';
import 'package:selling_pictures_platform/main.dart';

String getOrderId = "";
String getNotifyID = "";
String getAdminOrderId = "";
String getAdminNotifyID = "";

class AdminOrderDetails extends StatelessWidget {
  final String orderID;
  final int totalPrice;
  final String speakingToID;
  final String speakingToName;

  AdminOrderDetails(
      {Key key,
      this.orderID,
      this.totalPrice,
      this.speakingToName,
      this.speakingToID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return Scaffold(
      floatingActionButton: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection("Notify")
              .doc(orderID)
              .snapshots(),
          builder: (context, snap) {
            return !snap.hasData
                ? Container()
                : !snap.data["cancelTransactionFinished"]
                    ? Container(
                        width: 125,
                        height: 125,
                        child: FloatingActionButton(
                          backgroundColor: mainColor,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => ChatPage(
                                        EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp
                                                .sharedPreferences
                                                .getString(
                                                    EcommerceApp.userUID)),
                                        speakingToID,
                                        orderID,
                                        speakingToName,
                                        EcommerceApp.sharedPreferences
                                            .getString(
                                                EcommerceApp.userName))));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Text(
                                  "メッセージ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                mySizedBox(5),
                                Icon(
                                  Icons.message_outlined,
                                  size: 50,
                                ),
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                        ),
                      )
                    : Container();
          }),
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection("Notify")
              .doc(orderID)
              .get(),
          builder: (c, snapshot) {
            Map dataMap;

            if (snapshot.hasData) {
              dataMap = snapshot.data.data();
            }
            return snapshot.hasData
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(EcommerceApp.sharedPreferences
                                      .getString(EcommerceApp.userUID))
                                  .collection("Notify")
                                  .doc(orderID)
                                  .snapshots(),
                              builder: (c, snap) {
                                return !snap.hasData
                                    ? Container()
                                    : snap.data["cancelTransactionFinished"]
                                        ? Center(
                                            child: Text(
                                              "この注文はキャンセルされました。",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.redAccent,
                                                  fontSize: 22),
                                            ),
                                          )
                                        : Container();
                              }),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "ご注文金額:" +
                                    snapshot.data
                                        .data()["totalPrice"]
                                        .toString() +
                                    "円",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("ご注文ID: " + getOrderId),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "注文時刻: " +
                                  DateFormat("yyyy年MM月dd日 - HH時mm分").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]))),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection("items")
                                .where("shortInfo",
                                    isEqualTo: dataMap[EcommerceApp.productID])
                                .get(),
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      totalPrice: totalPrice,
                                      itemCount: dataSnapshot.data.docs.length,
                                      data: dataSnapshot.data.docs,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .doc(dataMap["buyerID"])
                                .collection(EcommerceApp.subCollectionAddress)
                                .doc(dataMap[EcommerceApp.addressID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model: AddressModel.fromJson(
                                          snap.data.data()),
                                      orderID: orderID,
                                      postBy: dataMap["boughtFrom"],
                                      buyerID: dataMap["buyerID"],
                                      postByName: speakingToName)
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}

class ShippingDetails extends StatefulWidget {
  final AddressModel model;
  final ItemModel itemModel;
  final String orderID;
  final int proceeds;
  final String postBy;
  final String notifyID;
  final String buyerID;
  final String postByName;

  ShippingDetails(
      {Key key,
      this.model,
      this.itemModel,
      this.orderID,
      this.proceeds,
      this.postBy,
      this.notifyID,
      this.buyerID,
      this.postByName})
      : super(key: key);

  @override
  State<ShippingDetails> createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // todo: ここに処理を書く
    getData();
  }

  String buyerIDFromFB;
  String orderIDFromFB;
  String whoBought;
  void getData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection("Notify")
        .doc(widget.orderID)
        .get();
    buyerIDFromFB = snapshot.data()["buyerID"];
    orderIDFromFB = snapshot.data()["id"];
    whoBought = snapshot.data()["boughtFrom"];
  }

  bool isShipped = false;
  @override
  Widget build(BuildContext context) {
    getOrderId = widget.orderID;
    getNotifyID = widget.notifyID;

    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "お届け先",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 5),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "氏名"),
                  ),
                  Text(widget.model.lastName + " " + widget.model.firstName),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "郵便番号"),
                  ),
                  Text(widget.model.postalCode),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "都道府県"),
                  ),
                  Text(widget.model.prefectures),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "市区町村"),
                  ),
                  Text(widget.model.city),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "番地および\n任意の建物名"),
                  ),
                  Text(widget.model.address),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "電話番号"),
                  ),
                  Text(widget.model.phoneNumber),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<DocumentSnapshot>(
          stream: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection("Notify")
              .doc(widget.orderID)
              .snapshots(),
          builder: (c, snapshot) {
            Map dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data.data();
            }
            return snapshot.hasData
                ? dataMap["isBuyerDelivery"] == "inComplete" &&
                        !dataMap["cancelTransactionFinished"]
                    ? Padding(
                        padding: EdgeInsets.all(
                          5,
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Center(child: Text("発送通知")),
                                    content: Text("購入者に発送通知を送ります。\nよろしいですか？"),
                                    actions: [
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "キャンセル",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                primary: Colors.white),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              completeTransactionAndNotifySellar(
                                                  context,
                                                  orderIDFromFB,
                                                  buyerIDFromFB);
                                            },
                                            child: Text(
                                              "送信する",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                primary: Colors.white),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                    ],
                                  );
                                });

                            // print(proceeds);
                          },
                          child: Container(
                            color: Colors.black,
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Center(
                              child: Text(
                                "発送通知を送る。",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : dataMap["cancelTransactionFinished"]
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              color: Colors.grey,
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "この取引はキャンセルされました。",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              color: Colors.black,
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "購入者の受け取りをお待ちください。",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          )
                : Container();
          },
        ),
        SizedBox(
          height: 15,
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .doc(widget.buyerID)
                .collection(EcommerceApp.collectionOrders)
                .doc(widget.orderID)
                .snapshots(),
            builder: (c, snapshot) {
              return snapshot.hasData
                  ? snapshot.data.data()["CancelRequestTo"] != true
                      ? Center(
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return NormalCheckBoxDialog(
                                      "キャンセル申請",
                                      "",
                                      "確認",
                                      buyerIDFromFB,
                                      orderIDFromFB,
                                      widget.postBy,
                                      EcommerceApp.sharedPreferences
                                          .getString(EcommerceApp.userName),
                                      widget.postByName,
                                      whoBought,
                                    );
                                  });
                            },
                            child: Text(
                              "この取引をキャンセルする",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        )
                      : StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(EcommerceApp.sharedPreferences
                                  .getString(EcommerceApp.userUID))
                              .collection("Notify")
                              .doc(widget.orderID)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? snapshot.data["cancelTransactionFinished"]
                                    ? Container()
                                    : Center(
                                        child: Text(
                                          "この取引のキャンセル申請を行いました。",
                                          style: TextStyle(
                                              color: Colors.blueAccent),
                                        ),
                                      )
                                : Container();
                          })
                  : Container();
            })
      ],
    );
  }

  completeTransactionAndNotifySellar(
      BuildContext context, String mOrderId, String cId) {
    var db = FirebaseFirestore.instance;
    db.collection("chat_room").doc(mOrderId).collection("chat").add({
      "user_name":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "myId": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "message": "本日作品を発送しました。\n到着まで少々お待ちください。",
      "created_at": DateTime.now().millisecondsSinceEpoch.toString()
    });
    final order = EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(cId)
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .get();

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(cId)
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .update(
      {
        "isBuyerDelivery": "Complete",
      },
    );
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .update(
      {
        "isBuyerDelivery": "Complete",
      },
    );

    // EcommerceApp.firestore
    //     .collection(EcommerceApp.collectionUser)
    //     .doc(postBy)
    //     .collection("MyProceeds")
    //     .doc()
    //     .update(
    //   {
    //     "Proceeds": FieldValue.increment(proceeds),
    //   },
    // );

    getOrderId = "";
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "購入者に発送通知を送信しました。\n受け取り確認完了まで少々お待ちください。");
  }
}

class ChatPage extends StatefulWidget {
  ChatPage(this.myId, this.speakingToId, this.orderId, this.speakingToName,
      this.myName);

  final String myId;
  final String myName;
  final String speakingToId;
  final String speakingToName;
  final String orderId;

  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: HexColor(
          "E67928",
        ),
        title: new Text("チャットページ"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("chat_room")
                    .doc(widget.orderId)
                    .collection("chat")
                    .orderBy("created_at", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return new ListView.builder(
                    shrinkWrap: true,
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) {
                      DocumentSnapshot document = snapshot.data.docs[index];

                      bool isOwnMessage = false;
                      if (document['myId'] ==
                          EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.userUID)) {
                        isOwnMessage = true;
                      }
                      return isOwnMessage
                          ? _ownMessage(document['message'],
                              document['user_name'], document['created_at'])
                          : _message(document['message'], document['user_name'],
                              document['created_at']);
                    },
                    itemCount: snapshot.data.docs.length,
                  );
                },
              ),
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.81,
            ),
            new Divider(
              height: 1.0,
              thickness: 3,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              // margin: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: mainColor, width: 3),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new TextField(
                                  controller: _messageController,
                                  onSubmitted: _handleSubmit,
                                  decoration: new InputDecoration.collapsed(
                                      hintText: "メッセージの送信"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        new Container(
                          child: IconButton(
                              icon: Icon(
                                Icons.send,
                                size: 30,
                                color: HexColor("#E67928"),
                              ),
                              onPressed: () {
                                _handleSubmit(_messageController.text);
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ownMessage(String message, String userName, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: HexColor("#E67928"),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(DateFormat("MM/dd - HH:mm")
                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)))),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  Widget _message(String message, String userName, String date) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(DateFormat("MM/dd - HH:mm")
                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)))),
            SizedBox(
              height: 10,
            ),
          ],
        )
      ],
    );
  }

  _handleSubmit(String message) {
    _messageController.text = "";
    var db = FirebaseFirestore.instance;
    db.collection("chat_room").doc(widget.orderId).collection("chat").add({
      "user_name":
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      "myId": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      "message": message,
      "created_at": DateTime.now().millisecondsSinceEpoch.toString()
    });
  }
}
