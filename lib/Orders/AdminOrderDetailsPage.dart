import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Admin/uploadItems.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/Widgets/orderCard.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
      floatingActionButton: Container(
        width: 125,
        height: 125,
        child: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => ChatPage(
                        EcommerceApp.sharedPreferences.getString(EcommerceApp
                            .sharedPreferences
                            .getString(EcommerceApp.userUID)),
                        speakingToID,
                        orderID,
                        speakingToName,
                        EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.userName))));
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  "メッセージ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Icon(
                  Icons.message_outlined,
                  size: 50,
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0))),
        ),
      ),
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
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
                                    )
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

  ShippingDetails(
      {Key key,
      this.model,
      this.itemModel,
      this.orderID,
      this.proceeds,
      this.postBy,
      this.notifyID,
      this.buyerID})
      : super(key: key);

  @override
  State<ShippingDetails> createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  TextEditingController _messageController = TextEditingController();

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
              .doc(widget.buyerID)
              .collection(EcommerceApp.collectionOrders)
              .doc(widget.orderID)
              .snapshots(),
          builder: (c, snapshot) {
            Map dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data.data();
            }
            return isShipped == false
                ? Padding(
                    padding: EdgeInsets.all(
                      5,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isShipped = true;
                        });
                        completeTransactionAndNotifySellar(
                            context, getOrderId, widget.buyerID);
                        // print(proceeds);
                      },
                      child: Container(
                        color: Colors.black,
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Center(
                          child: Text(
                            "商品を発送しました。",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
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
                  );
          },
        ),
        SizedBox(
          height: 15,
        ),
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
        "isDelivery": "Complete",
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
    // Route route = MaterialPageRoute(builder: (c) => MainPage());
    // Navigator.pushReplacement(context, route);
    // Fluttertoast.showToast(msg: "取引が完了しました。\n引き続きLEEWAYをお楽しみください。");
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
      backgroundColor: Colors.white.withOpacity(0.7),
      appBar: new AppBar(
        title: new Text("チャットページ"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
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
            new Divider(height: 1.0),
            Container(
              margin: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: new TextField(
                      controller: _messageController,
                      onSubmitted: _handleSubmit,
                      decoration:
                          new InputDecoration.collapsed(hintText: "メッセージの送信"),
                    ),
                  ),
                  new Container(
                    child: new IconButton(
                        icon: new Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          _handleSubmit(_messageController.text);
                        }),
                  ),
                ],
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: TextStyle(color: HexColor("#E67928")),
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
