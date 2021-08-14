// Flutter imports:
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/custom_app_bar.dart';
import 'package:selling_pictures_platform/Widgets/loading_widget.dart';
import 'package:selling_pictures_platform/Widgets/order_card.dart';
import 'package:selling_pictures_platform/main.dart';

String getOrderId = '';
String getNotifyID = '';
String getAdminOrderId = '';
String getAdminNotifyID = '';

class OrderDetails extends StatelessWidget {
  final String orderID;
  final int totalPrice;
  final String speakingToID;
  final String speakingToName;
  final int finalGetProceeds;

  const OrderDetails(
      {Key key,
      this.orderID,
      this.totalPrice,
      this.speakingToName,
      this.speakingToID,
      this.finalGetProceeds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return Scaffold(
      floatingActionButton: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection('orders')
              .doc(orderID)
              .snapshots(),
          builder: (c, snap) {
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
                                        snap.data['boughtFrom'],
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
                                const SizedBox(
                                  height: 5,
                                ),
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
                                        snap.data['boughtFrom'],
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
                                const SizedBox(
                                  height: 5,
                                ),
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
              .collection(EcommerceApp.collectionOrders)
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
                                  .collection('orders')
                                  .doc(orderID)
                                  .snapshots(),
                              builder: (c, snap) {
                                return !snap.hasData
                                    ? Container()
                                    : () {
                                        if (snap.data[
                                            'cancelTransactionFinished']) {
                                          return const Center(
                                            child: Text(
                                              'この注文はキャンセルされました。',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.redAccent,
                                                  fontSize: 22),
                                            ),
                                          );
                                        } else if (snap.data['hold'] != null) {
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text('ご注文ID: $getOrderId'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    final data =
                                        ClipboardData(text: getOrderId);
                                    await Clipboard.setData(data);
                                    print(data.text);
                                  },
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              '注文時刻: ${DateFormat('yyyy年MM月dd日 - HH時mm分').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap['orderTime'])))}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
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
                          ), const Divider(
                            height: 2,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .doc(EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID))
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
                                      id: speakingToID,
                                    )
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
  final String id;
  final AddressModel model;
  final ItemModel itemModel;
  final String orderID;
  final int proceeds;
  final String postBy;
  final String notifyID;
  final double finalGetProceeds;

  const ShippingDetails(
      {Key key,
      this.model,
      this.itemModel,
      this.orderID,
      this.proceeds,
      this.postBy,
      this.notifyID,
      this.finalGetProceeds,
      this.id})
      : super(key: key);

  @override
  State<ShippingDetails> createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  final TextEditingController _messageController = TextEditingController();

  double getReviewCount = 0;

  TextEditingController reviewTextController = TextEditingController();

  final double earn = 0;

  int proceed;
  String itemID;

  void fetchGetProceeds() async {
    final snapshot = await FirebaseFirestore
        .instance
        .collection('orders')
        .doc(widget.orderID)
        .get();
    proceed = snapshot.data()['totalPrice'];
    print(proceed);
  }

  void fetchItemData() async {
    final snap = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection('orders')
        .doc(widget.orderID)
        .get();
    itemID = snap.data()['itemID'];
  }

  Future<Map<String, dynamic>> getOrderData() async {
    final snap = await FirebaseFirestore
        .instance
        .collection('orders')
        .doc(widget.orderID)
        .get();
    return snap.data();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGetProceeds();
    fetchItemData();
    getOrderData();

    print(widget.orderID);
    print(widget.postBy);
    print(widget.orderID);
  }

  @override
  Widget build(BuildContext context) {
    getOrderId = widget.orderID;
    getNotifyID = widget.notifyID;

    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
            width: screenWidth,
            child: Table(
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: KeyText(msg: '氏名'),
                    ),
                    Text('${widget.model.lastName} ${widget.model.firstName}'),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: KeyText(msg: '郵便番号'),
                    ),
                    Text(widget.model.postalCode),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: KeyText(msg: '都道府県'),
                    ),
                    Text(widget.model.prefectures),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: KeyText(msg: '市区町村'),
                    ),
                    Text(widget.model.city),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: KeyText(msg: '番地および\n任意の建物名'),
                    ),
                    Text(widget.model.address),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: KeyText(msg: '電話番号'),
                    ),
                    Text(widget.model.phoneNumber),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .doc(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .doc(widget.orderID)
                .snapshots(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data();
              }
              return snapshot.hasData
                  ? () {
                      if (dataMap['cancelTransactionFinished'] == true) {
                        return CancelFinished(c);
                      } else if (dataMap['hold'] == true) {
                        return HoldOrder(c);
                      } else if (dataMap['isDelivery'] == 'inComplete') {
                        return WaitShips(c);
                      } else if (dataMap['isTransactionFinished'] ==
                          'Complete') {
                        return TransactionFinished(c);
                      } else {
                        return ReviewAlert();
                      }
                    }()
                  : Container();
            },
          ),
          const SizedBox(
            height: 15,
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.collectionOrders)
                  .doc(widget.orderID)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.hasData) {
                  return () {
                    if (snap.data.data()['CancelRequestTo'] &&
                        !snap.data.data()['cancelTransactionFinished'] &&
                        !snap.data.data()['firstCancelRequest']) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(children: <Widget>[
                            const Expanded(
                                child: Divider(
                              thickness: 5,
                              color: Colors.black,
                            )),
                            const Text('　  作者よりキャンセル申請が届いています 　 '),
                            const Expanded(
                                child: Divider(
                              thickness: 5,
                              color: Colors.black,
                            )),
                          ]),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: Column(
                              children: [
                                FutureBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                    future: FirebaseFirestore.instance
                                        .collection('cancelReport')
                                        .doc(widget.orderID)
                                        .get(),
                                    builder: (context, data) {
                                      return !data.hasData
                                          ? Container()
                                          : Text(
                                              '申請理由：' + data.data['reason'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            );
                                    })
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    print(itemID);
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text('キャンセル申請に同意しますか？'),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            elevation: 0,
                                                            primary:
                                                                Colors.white),
                                                    child: const Text(
                                                      'キャンセル',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID))
                                                          .collection(
                                                              'AllNotify')
                                                          .doc(EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID))
                                                          .collection('Guide')
                                                          .doc(widget.orderID)
                                                          .update({
                                                        'CancelRequest': true,
                                                        'cancelTransactionFinished':
                                                            true,
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(widget.postBy)
                                                          .collection(
                                                              'AllNotify')
                                                          .doc(widget.postBy)
                                                          .collection('Guide')
                                                          .doc(widget.orderID)
                                                          .update({
                                                        'CancelRequest': true,
                                                        'cancelTransactionFinished':
                                                            true,
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID))
                                                          .collection('orders')
                                                          .doc(widget.orderID)
                                                          .update({
                                                        'CancelRequest': true,
                                                        'cancelTransactionFinished':
                                                            true,
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID))
                                                          .collection(
                                                              'AllNotify')
                                                          .doc(EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID))
                                                          .collection(
                                                              'From Admin')
                                                          .doc(widget.orderID)
                                                          .set({
                                                        'Tag': 'Cancel',
                                                        'date': DateTime.now(),
                                                        'orderID':
                                                            widget.orderID,
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(widget.postBy)
                                                          .collection(
                                                              'AllNotify')
                                                          .doc(widget.postBy)
                                                          .collection(
                                                              'From Admin')
                                                          .doc(widget.orderID)
                                                          .set({
                                                        'Tag': 'Cancel',
                                                        'date': DateTime.now(),
                                                        'orderID':
                                                            widget.orderID,
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(widget.postBy)
                                                          .collection('Notify')
                                                          .doc(widget.orderID)
                                                          .update({
                                                        'CancelRequest': true,
                                                        'cancelTransactionFinished':
                                                            true,
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('items')
                                                          .doc(itemID)
                                                          .update({
                                                        'Stock': FieldValue
                                                            .increment(1)
                                                      }).whenComplete(() async {
                                                        await Fluttertoast.showToast(
                                                          msg:
                                                              'キャンセル申請に同意し、取引をキャンセルしました。',
                                                          backgroundColor:
                                                              HexColor(
                                                                  '#E67928'),
                                                        );
                                                        await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (c) =>
                                                                    MainPage()));
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            elevation: 0,
                                                            primary:
                                                                Colors.white),
                                                    child: const Text(
                                                      '同意する',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    color: Colors.redAccent,
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: const Center(
                                      child: Text(
                                        '同意する',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp.userUID))
                                        .collection('orders')
                                        .doc(snap.data.data()['id'])
                                        .update({
                                      'CancelRequestTo': false,
                                      'firstCancelRequest': true,
                                    });
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snap.data.data()['boughtFrom'])
                                        .collection('Notify')
                                        .doc(snap.data.data()['id'])
                                        .update({
                                      'CancelRequestTo': false,
                                      'firstCancelRequest': true,
                                    });
                                  },
                                  child: Container(
                                    color: Colors.redAccent,
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: const Center(
                                      child: Text(
                                        '同意しない',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snap.data.data()['CancelRequestTo'] &&
                        !snap.data.data()['cancelTransactionFinished'] &&
                        snap.data.data()['firstCancelRequest'] &&
                        !snap.data.data()['hold']) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(children: <Widget>[
                            const Expanded(
                                child: Divider(
                              thickness: 5,
                              color: Colors.black,
                            )),
                            const Text('　  作者よりキャンセル申請が届いています(2回目) 　 '),
                            const Expanded(
                                child: Divider(
                              thickness: 5,
                              color: Colors.black,
                            )),
                          ]),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: Column(
                              children: [
                                FutureBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                    future: FirebaseFirestore.instance
                                        .collection('cancelReport')
                                        .doc(widget.orderID)
                                        .get(),
                                    builder: (context, data) {
                                      return !data.hasData
                                          ? Container()
                                          : Text(
                                              '申請理由：' +
                                                  data.data.data()['reason'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            );
                                    })
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    print(itemID);
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text('キャンセル申請に同意しますか？'),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            elevation: 0,
                                                            primary:
                                                                Colors.white),
                                                    child: const Text(
                                                      'キャンセル',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID))
                                                          .collection(
                                                              'AllNotify')
                                                          .doc(EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID))
                                                          .collection('Guide')
                                                          .doc(widget.orderID)
                                                          .update({
                                                        'CancelRequest': true,
                                                        'cancelTransactionFinished':
                                                            true,
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(widget.postBy)
                                                          .collection(
                                                              'AllNotify')
                                                          .doc(widget.postBy)
                                                          .collection('Guide')
                                                          .doc(widget.orderID)
                                                          .update({
                                                        'CancelRequest': true,
                                                        'cancelTransactionFinished':
                                                            true,
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID))
                                                          .collection('orders')
                                                          .doc(widget.orderID)
                                                          .update({
                                                        'CancelRequest': true,
                                                        'cancelTransactionFinished':
                                                            true,
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID))
                                                          .collection(
                                                              'AllNotify')
                                                          .doc(EcommerceApp
                                                              .sharedPreferences
                                                              .getString(
                                                                  EcommerceApp
                                                                      .userUID))
                                                          .collection(
                                                              'From Admin')
                                                          .doc(widget.orderID)
                                                          .set({
                                                        'Tag': 'Cancel',
                                                        'date': DateTime.now(),
                                                        'orderID':
                                                            widget.orderID,
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(widget.postBy)
                                                          .collection(
                                                              'AllNotify')
                                                          .doc(widget.postBy)
                                                          .collection(
                                                              'From Admin')
                                                          .doc(widget.orderID)
                                                          .set({
                                                        'Tag': 'Cancel',
                                                        'date': DateTime.now(),
                                                        'orderID':
                                                            widget.orderID,
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(widget.postBy)
                                                          .collection('Notify')
                                                          .doc(widget.orderID)
                                                          .update({
                                                        'CancelRequest': true,
                                                        'cancelTransactionFinished':
                                                            true,
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('items')
                                                          .doc(itemID)
                                                          .update({
                                                        'Stock': FieldValue
                                                            .increment(1)
                                                      }).whenComplete(() async {
                                                        await Fluttertoast.showToast(
                                                          msg:
                                                              'キャンセル申請に同意し、取引をキャンセルしました。',
                                                          backgroundColor:
                                                              HexColor(
                                                                  '#E67928'),
                                                        );
                                                        await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (c) =>
                                                                    MainPage()));
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            elevation: 0,
                                                            primary:
                                                                Colors.white),
                                                    child: const Text(
                                                      '同意する',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    color: Colors.redAccent,
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: const Center(
                                      child: Text(
                                        '同意する',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp.userUID))
                                        .collection('orders')
                                        .doc(snap.data.data()['id'])
                                        .update({
                                      'hold': true,
                                      'secondCancelRequest': true,
                                    });
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snap.data.data()['boughtFrom'])
                                        .collection('Notify')
                                        .doc(snap.data.data()['id'])
                                        .update({
                                      'hold': true,
                                      'secondCancelRequest': true,
                                    });
                                    //todo:キャンセルメール
                                    FirebaseFirestore.instance
                                        .collection('cancelReport')
                                        .doc(widget.orderID)
                                        .set({
                                      'cancelRequestName':
                                          snap.data.data()['postName'],
                                      'orderID': widget.orderID,
                                      'Tag': 'cancelBlock'
                                    });
                                  },
                                  child: Container(
                                    color: Colors.redAccent,
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: const Center(
                                      child: Text(
                                        '同意しない',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }();
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }

  Widget ReviewAlert() {
    return Padding(
      padding: const EdgeInsets.all(
        5,
      ),
      child: InkWell(
        onTap: () {
          return showDialog(
            context: context,
            builder: (_) {
              return SimpleDialog(
                title: Center(
                  child: Text(
                    '受け取り確認・評価',
                  ),
                ),
                children: [
                  Center(
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        getReviewCount = rating;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: reviewTextController,
                            decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                                hintText: '作者に何かメッセージを送ってみましょう！',
                                border: InputBorder.none),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: HexColor('3e1300'), width: 3)),
                        height: 80,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('キャンセル')),
                      ElevatedButton(
                          onPressed: () {
                            completeTransactionAndNotifySellar(
                                context, getOrderId);
                            saveReviewCount();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => MainPage()));
                          },
                          child: Text('送信する')),
                    ],
                  ),
                ],
              );
            },
          );

          // print(proceeds);
        },
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: const Center(
            child: Text(
              '受け取り確認へ進む',
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

  dynamic saveReviewCount() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.postBy)
        .collection('Review')
        .doc(widget.orderID)
        .set(
      {
        'message': reviewTextController.text.trim(),
        'starRating': getReviewCount,
        'reviewBy':
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        'reviewDate': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }

  dynamic completeTransactionAndNotifySellar(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .update(
      {
        'isTransactionFinished': 'Complete',
      },
    );
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(widget.postBy)
        .collection('Notify')
        .doc(widget.orderID)
        .update(
      {
        'isTransactionFinished': 'Complete',
        'isBuyerDelivery': 'Complete',
      },
    );
    EcommerceApp.firestore.collection('orders').doc(widget.orderID).update(
      {
        'isTransactionFinished': 'Complete',
        'isBuyerDelivery': 'Complete',
      },
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection('AllNotify')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection('From Admin')
        .doc()
        .set(
      {
        'date': DateTime.now(),
        'Tag': 'Transaction',
        'orderID': widget.orderID,
      },
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.postBy)
        .collection('AllNotify')
        .doc(widget.postBy)
        .collection('From Admin')
        .doc()
        .set(
      {
        'date': DateTime.now(),
        'Tag': 'Transaction',
        'orderID': widget.orderID,
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
        'isTransactionFinished': true,
      },
    );
    EcommerceApp.firestore
        .collection('users')
        .doc(widget.postBy)
        .collection('AllNotify')
        .doc(widget.postBy)
        .collection('Guide')
        .doc(mOrderId)
        .update(
      {
        'isTransactionFinished': true,
      },
    );

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(widget.postBy)
        .collection('MyProceeds')
        .doc(widget.postBy)
        .update(
      {
        'Proceeds': DateTime.now().millisecondsSinceEpoch < 1648738799999
            ? FieldValue.increment((proceed * 0.85).toInt())
            : FieldValue.increment((proceed * 0.7).toInt())
      },
    );

    getOrderId = '';
    final Route route = MaterialPageRoute(builder: (c) => MainPage());
    Navigator.push(context, route);
    Fluttertoast.showToast(msg: '取引が完了しました。\n引き続きLEEWAYをお楽しみください。');
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
  _ChatPageState createState() => _ChatPageState();
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
                                  onSubmitted: _myHandleSubmit,
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
                                _myHandleSubmit(_messageController.text);
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

  dynamic _myHandleSubmit(String message) {
    _messageController.text = '';
    // var db = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
    //     .collection('orders')
    //     .doc(widget.orderId);
    // db.collection('chat_room').doc(widget.orderId).collection('chat').add({
    //   'user_name':
    //       EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
    //   'myId': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
    //   'message': message,
    //   'created_at': DateTime.now().millisecondsSinceEpoch.toString()
    // });
    final db2 = FirebaseFirestore.instance;
    db2.collection('chat_room').doc(widget.orderId).collection('chat').add({
      'user_name':
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
      'myId': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      'message': message,
      'created_at': DateTime.now().millisecondsSinceEpoch.toString()
    });

    final db3 = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.speakingToId)
        .collection('Notify')
        .doc(widget.orderId);
    db3.collection('chat_room').doc(widget.orderId).collection('chat').add({
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
                      padding: new EdgeInsets.all(8),
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
