// Flutter imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/check_box.dart';
import 'package:selling_pictures_platform/Widgets/custom_app_bar.dart';
import 'package:selling_pictures_platform/Widgets/loading_widget.dart';
import 'package:selling_pictures_platform/Widgets/order_card.dart';

String getOrderId = '';
String getNotifyID = '';
String getAdminOrderId = '';
String getAdminNotifyID = '';

class AdminOrderDetails extends StatelessWidget {
  final String orderID;
  final int totalPrice;
  final String speakingToID;
  final String speakingToName;

  const AdminOrderDetails(
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
              .collection('users')
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection('Notify')
              .doc(orderID)
              .snapshots(),
          builder: (context, snap) {
            return !snap.hasData
                ? Container()
                : !snap.data['cancelTransactionFinished'] &&
                        snap.data['isTransactionFinished'] == 'inComplete' &&
                        !snap.data['hold']
                    ? Container(
                        width: 125,
                        height: 125,
                        child: FloatingActionButton(
                          backgroundColor: mainColorOfLEEWAY,
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
                                        snap.data['buyerID'],
                                        orderID,
                                        speakingToName,
                                        EcommerceApp.sharedPreferences
                                            .getString(
                                                EcommerceApp.userName))));
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const Text(
                                  'メッセージ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                mySizedBox(5),
                                const Icon(
                                  Icons.message_outlined,
                                  size: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 125,
                        height: 125,
                        child: FloatingActionButton(
                          backgroundColor: Colors.grey,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => ChatPageViewOnly(
                                        EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp
                                                .sharedPreferences
                                                .getString(
                                                    EcommerceApp.userUID)),
                                        snap.data['buyerID'],
                                        orderID,
                                        speakingToName,
                                        EcommerceApp.sharedPreferences
                                            .getString(
                                                EcommerceApp.userName))));
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const Text(
                                  'メッセージ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                mySizedBox(5),
                                const Icon(
                                  Icons.message_outlined,
                                  size: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
          }),
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection('Notify')
              .doc(orderID)
              .get(),
          builder: (c, snapshot) {
            Map dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data.data();
            }
            return snapshot.hasData
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(EcommerceApp.sharedPreferences
                                      .getString(EcommerceApp.userUID))
                                  .collection('Notify')
                                  .doc(orderID)
                                  .snapshots(),
                              builder: (c, snap) {
                                return !snap.hasData
                                    ? Container()
                                    : () {
                                        if (snap.data[
                                            'cancelTransactionFinished'] != null) {
                                          return const Center(
                                            child: Text(
                                              'この注文はキャンセルされました。',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.redAccent,
                                                  fontSize: 22),
                                            ),
                                          );
                                        } else if (snap.data['hold']) {
                                          return const Center(
                                            child: Text(
                                              '保留中...',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  fontSize: 22),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }();
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'ご注文金額:${snapshot.data
                                        .data()['totalPrice']}円',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text('ご注文ID: $orderID'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              '注文時刻: ${DateFormat('yyyy年MM月dd日 - HH時mm分').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap['orderTime'])))}',
                              style:
                                  const TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                          const Divider(
                            height: 2,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection('items')
                                .where('shortInfo',
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
                                      child: circular_progress(),
                                    );
                            },
                          ),
                          const Divider(
                            height: 2,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .doc(dataMap['buyerID'])
                                .collection(EcommerceApp.subCollectionAddress)
                                .doc(dataMap[EcommerceApp.addressID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model: AddressModel.fromJson(
                                          snap.data.data()),
                                      orderID: orderID,
                                      postBy: dataMap['boughtFrom'],
                                      buyerID: dataMap['buyerID'],
                                      postByName: speakingToName)
                                  : Center(
                                      child: circular_progress(),
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: circular_progress(),
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

  const ShippingDetails(
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
  final TextEditingController _messageController = TextEditingController();

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
    final snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection('Notify')
        .doc(widget.orderID)
        .get();
    buyerIDFromFB = snapshot.data()['buyerID'];
    orderIDFromFB = snapshot.data()['id'];
    whoBought = snapshot.data()['boughtFrom'];
  }

  bool isShipped = false;
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    getOrderId = widget.orderID;
    getNotifyID = widget.notifyID;

    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection('Notify')
                .doc(getOrderId)
                .snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data.data();
              return !snapshot.hasData
                  ? Container()
                  : snapshot.data.data()['isBuyerDelivery'] == 'inComplete' &&
                          !data['hold'] &&
                          snapshot.data.data()['CancelRequestTo'] != true
                      ? isPressed == false
                          ? InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (c) {
                                      return AlertDialog(
                                        title: const Text('送り先情報を確認しますか？'),
                                        content: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          text: const TextSpan(
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '表示は5分間のみです。\n表示しますか？',
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        print(getOrderId);
                                                        print(buyerIDFromFB);
                                                      },
                                                      child: const Text('いいえ')),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isPressed = true;
                                                        });
                                                        Navigator.pop(context);
                                                        Timer(
                                                            const Duration(
                                                              seconds: 10,
                                                            ), () {
                                                          setState(() {
                                                            isPressed = false;
                                                          });
                                                        });
                                                      },
                                                      child: const Text('はい')),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  color: Colors.redAccent,
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: const Center(
                                    child: Text(
                                      '送り先住所を確認する',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'お届け先',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 5),
                                  width: screenWidth,
                                  child: Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: KeyText(msg: '氏名'),
                                          ),
                                          Text('${widget.model.lastName} ${widget.model.firstName}'),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: KeyText(msg: '郵便番号'),
                                          ),
                                          Text(widget.model.postalCode),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: KeyText(msg: '都道府県'),
                                          ),
                                          Text(widget.model.prefectures),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: KeyText(msg: '市区町村'),
                                          ),
                                          Text(widget.model.city),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child:
                                                KeyText(msg: '番地および\n任意の建物名'),
                                          ),
                                          Text(widget.model.address),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: KeyText(msg: '電話番号'),
                                          ),
                                          Text(widget.model.phoneNumber),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                      : Container();
            }),
        const SizedBox(
          height: 15,
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<DocumentSnapshot>(
          stream: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection('Notify')
              .doc(widget.orderID)
              .snapshots(),
          builder: (c, snapshot) {
            Map dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data.data();
            }
            return snapshot.hasData
                ? () {
                    if (dataMap['isBuyerDelivery'] == 'inComplete' &&
                        !dataMap['CancelRequestTo']) {
                      return SendShipsNotification();
                    } else if (dataMap['cancelTransactionFinished']) {
                      return CancelFinished(context);
                    } else if (dataMap['isTransactionFinished'] == 'Complete') {
                      return TransactionFinished(context);
                    } else if (dataMap['hold']) {
                      return HoldOrder(context);
                    } else if (dataMap['CancelRequestTo'] == true) {
                      return Container();
                    } else {
                      return WaitReserve(context);
                    }
                  }()
                : Container();
          },
        ),
        const SizedBox(
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
              Map d;
              if (snapshot.hasData) {
                d = snapshot.data.data();
              }
              return () {
                if (snapshot.data.data()['CancelRequestTo'] != true &&
                    d['hold'] != true) {
                  return SubmitCancel();
                } else if (d['hold'] != null) {
                  return Container();
                } else {
                  return snapshot.data['cancelTransactionFinished'] || d['hold']
                      ? Container()
                      : () {
                          if (!snapshot.data['firstCancelRequest']) {
                            return const Center(
                              child: Text(
                                'この取引のキャンセル申請を行いました。',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            );
                          } else if (d['hold'] != null) {
                            return Container();
                          } else {
                            return const Center(
                              child: Text(
                                'キャンセル申請が拒否されました。'
                                '\n再度話し合いましょう。',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            );
                          }
                        }();
                }
              }();
            })
      ],
    );
  }

  Widget SubmitCancel() {
    return Center(
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return NormalCheckBoxDialog(
                  'キャンセル申請',
                  '',
                  '確認',
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
        child: const Text(
          'この取引をキャンセルする',
          style: TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }

  dynamic completeTransactionAndNotifySellar(
      BuildContext context, String mOrderId, String cId) {
    var db = FirebaseFirestore.instance;
    db.collection('chat_room').doc(mOrderId).collection('chat').add({
      'user_name':
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      'myId': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      'message': '本日作品を発送しました。\n到着まで少々お待ちください。',
      'created_at': DateTime.now().millisecondsSinceEpoch.toString()
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(cId)
        .collection('chat')
        .add({
      'orderID': mOrderId,
      'user_name':
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      'myId': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      'message': '本日作品を発送しました。\n到着まで少々お待ちください。',
      'created_at': DateTime.now().millisecondsSinceEpoch.toString()
    });

    EcommerceApp.firestore
        .collection('users')
        .doc(cId)
        .collection('orders')
        .doc(mOrderId)
        .update(
      {
        'isDelivery': 'Complete',
      },
    );
    EcommerceApp.firestore
        .collection('users')
        .doc(cId)
        .collection('AllNotify')
        .doc(cId)
        .collection('Guide')
        .doc(mOrderId)
        .update(
      {
        'isBuyerDelivery': true,
      },
    );
    EcommerceApp.firestore
        .collection('users')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection('AllNotify')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection('Guide')
        .doc(mOrderId)
        .update(
      {
        'isBuyerDelivery': true,
      },
    );
    EcommerceApp.firestore
        .collection('users')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection('Notify')
        .doc(mOrderId)
        .update(
      {
        'isBuyerDelivery': 'Complete',
      },
    );

    EcommerceApp.firestore.collection('orders').doc(mOrderId).update(
      {
        'isBuyerDelivery': 'Complete',
      },
    );

    getOrderId = '';
    Navigator.pop(context);
    Fluttertoast.showToast(msg: '購入者に発送通知を送信しました。\n受け取り確認完了まで少々お待ちください。');
  }

  Widget SendShipsNotification() {
    return Padding(
      padding: const EdgeInsets.all(
        5,
      ),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Center(child: Text('発送通知')),
                  content: const Text('購入者に発送通知を送ります。\nよろしいですか？'),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0, primary: Colors.white),
                          child: const Text(
                            'キャンセル',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            completeTransactionAndNotifySellar(
                                context, widget.orderID, buyerIDFromFB);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0, primary: Colors.white),
                          child: const Text(
                            '送信する',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
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
          child: const Center(
            child: Text(
              '発送通知を送る。',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage(this.myId, this.speakingToId, this.orderId, this.speakingToName,
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor(
          'E67928',
        ),
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.speakingToId)
                .snapshots(),
            builder: (c, snap) {
              return !snap.hasData
                  ? Container()
                  : Text(snap.data.data()['name']);
            }),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.81,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chat_room')
                      .doc(widget.orderId)
                      .collection('chat')
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        final DocumentSnapshot document = snapshot.data.docs[index];

                        var isOwnMessage = false;
                        if (document['myId'] ==
                            EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userUID)) {
                          isOwnMessage = true;
                        }
                        return isOwnMessage
                            ? _ownMessage(document['message'],
                                document['user_name'], document['created_at'])
                            : _message(document['message'],
                                document['user_name'], document['created_at']);
                      },
                      itemCount: snapshot.data.docs.length,
                    );
                  },
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 3,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: mainColorOfLEEWAY, width: 3),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: _messageController,
                                  onSubmitted: _handleSubmit,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: 'メッセージの送信'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: IconButton(
                              icon: Icon(
                                Icons.send,
                                size: 30,
                                color: HexColor('#E67928'),
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
                color: HexColor('#E67928'),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(DateFormat('MM/dd - HH:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)))),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  Widget _message(String message, String userName, String date) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.speakingToId)
                .snapshots(),
            builder: (c, snap) {
              return !snap.hasData
                  ? Container(
                      width: 50,
                      height: 50,
                      child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.perm_identity),
                      ),
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(snap.data.data()['url']),
                      ),
                    );
            }),
        const SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(DateFormat('MM/dd - HH:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)))),
            const SizedBox(
              height: 10,
            ),
          ],
        )
      ],
    );
  }

  dynamic _handleSubmit(String message) {
    _messageController.text = '';
    var db = FirebaseFirestore.instance;
    db.collection('chat_room').doc(widget.orderId).collection('chat').add({
      'user_name':
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      'myId': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      'message': message,
      'created_at': DateTime.now().millisecondsSinceEpoch.toString()
    });

    db
        .collection('users')
        .doc(widget.speakingToId)
        .collection('orders')
        .doc(widget.orderId)
        .collection('chat_room')
        .doc(widget.orderId)
        .collection('chat')
        .add({
      'user_name':
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      'myId': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      'message': message,
      'created_at': DateTime.now().millisecondsSinceEpoch.toString()
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.speakingToId)
        .collection('chat')
        .add({
      'orderID': widget.orderId,
      'user_name':
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      'myId': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      'message': message,
      'created_at': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }
}

class ChatPageViewOnly extends StatefulWidget {
  const ChatPageViewOnly(this.myId, this.speakingToId, this.orderId,
      this.speakingToName, this.myName);

  final String myId;
  final String myName;
  final String speakingToId;
  final String speakingToName;
  final String orderId;

  @override
  ChatPageViewOnlyState createState() => ChatPageViewOnlyState();
}

class ChatPageViewOnlyState extends State<ChatPageViewOnly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor(
          'E67928',
        ),
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.speakingToId)
                .snapshots(),
            builder: (c, snap) {
              return !snap.hasData
                  ? Container()
                  : Text(snap.data.data()['name']);
            }),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.81,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chat_room')
                      .doc(widget.orderId)
                      .collection('chat')
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        final DocumentSnapshot document = snapshot.data.docs[index];

                        var isOwnMessage = false;
                        if (document['myId'] ==
                            EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userUID)) {
                          isOwnMessage = true;
                        }
                        return isOwnMessage
                            ? _ownMessage(document['message'],
                                document['user_name'], document['created_at'])
                            : _message(document['message'],
                                document['user_name'], document['created_at']);
                      },
                      itemCount: snapshot.data.docs.length,
                    );
                  },
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 3,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: mainColorOfLEEWAY, width: 3),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '取引完了のためチャットは利用できません。',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )),
                            ),
                          ),
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
                color: HexColor('#E67928'),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(DateFormat('MM/dd - HH:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)))),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  Widget _message(String message, String userName, String date) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.speakingToId)
                .snapshots(),
            builder: (c, snap) {
              return !snap.hasData
                  ? Container(
                      width: 50,
                      height: 50,
                      child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.perm_identity),
                      ),
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(snap.data.data()['url']),
                      ),
                    );
            }),
        const SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(DateFormat('MM/dd - HH:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)))),
            const SizedBox(
              height: 10,
            ),
          ],
        )
      ],
    );
  }
}
