import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/Widgets/myDrawer.dart';
import 'package:selling_pictures_platform/Widgets/orderCard.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String getOrderId = "";
String getNotifyID = "";

class OrderDetails extends StatelessWidget {
  final String orderID;

  OrderDetails({
    Key key,
    this.orderID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
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
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatusBanner(
                              status: dataMap[EcommerceApp.isSuccess],
                            ),
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
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
                              ),
                            ),
                            Divider(
                              height: 2.0,
                            ),
                            FutureBuilder<QuerySnapshot>(
                              future: EcommerceApp.firestore
                                  .collection("items")
                                  .where("shortInfo",
                                      isEqualTo:
                                          dataMap[EcommerceApp.productID])
                                  .get(),
                              builder: (c, dataSnapshot) {
                                return dataSnapshot.hasData
                                    ? OrderCard(
                                        itemCount:
                                            dataSnapshot.data.docs.length,
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
                                        postBy: dataMap["boughtFrom"],
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
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "完了" : msg = "UnSuccessful";

    return Container(
      color: Colors.white,
      height: 40.0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                SystemNavigator.pop();
              },
              child: Center(
                child: Container(),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              "注文受付" + msg,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 5.0,
            ),
            CircleAvatar(
              radius: 8.0,
              backgroundColor: Colors.grey,
              child: Center(
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;
  final ItemModel itemModel;
  final String orderID;
  final int proceeds;
  final String postBy;
  final String notifyID;

  ShippingDetails({
    Key key,
    this.model,
    this.itemModel,
    this.orderID,
    this.proceeds,
    this.postBy,
    this.notifyID,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    getNotifyID = notifyID;

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
                  Text(model.lastName + " " + model.firstName),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "郵便番号"),
                  ),
                  Text(model.postalCode),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "都道府県"),
                  ),
                  Text(model.prefectures),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "市区町村"),
                  ),
                  Text(model.city),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "番地および\n任意の建物名"),
                  ),
                  Text(model.address),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: KeyText(msg: "電話番号"),
                  ),
                  Text(model.phoneNumber),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        StreamBuilder<DocumentSnapshot>(
          stream: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection(EcommerceApp.collectionOrders)
              .doc(orderID)
              .snapshots(),
          builder: (c, snapshot) {
            Map dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data.data();
            }
            return dataMap["isPayment"] != "inComplete"
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        completeTransactionAndNotifySellar(context, getOrderId);
                        // print(proceeds);
                      },
                      child: Container(
                        color: Colors.black,
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Center(
                          child: Text(
                            "商品を確認・受け取りました",
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
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        completePaymentAndNotifyToSellar();
                      },
                      child: Container(
                        color: Colors.black,
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Center(
                          child: Text(
                            "作品料金：${dataMap["totalPrice"]}円の支払いを完了しました。",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
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

  completePaymentAndNotifyToSellar() {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(orderID)
        .update({
      "isPayment": "complete",
    });
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(postBy)
        .collection("Notify")
        .doc(orderID)
        .update(
      {
        "isBuyerPayment": "Complete",
      },
    );
  }

  completeTransactionAndNotifySellar(BuildContext context, String mOrderId) {
    final order = EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .get();

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .update(
      {
        "isTransactionFinished": "Complete",
        "isDelivery": "Complete",
      },
    );
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(postBy)
        .collection("Notify")
        .doc(orderID)
        .update(
      {
        "isTransactionFinished": "Complete",
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
    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: "取引が完了しました。\n引き続きLEEWAYをお楽しみください。");
  }
}
