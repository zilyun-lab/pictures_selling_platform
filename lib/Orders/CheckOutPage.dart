import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Address/addAddress.dart';
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Counters/SizePriceChanger.dart';
import 'package:selling_pictures_platform/Counters/changeAddresss.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Orders/myOrders.dart';
import 'package:selling_pictures_platform/Orders/placeOrderPayment.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/Widgets/wideButton.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({
    Key key,
    this.model,
    this.shortInfo,
    this.imageURL,
    this.price,
    this.postBy,
    this.value,
    this.currentIndex,
    this.addressId,
    this.V,
    this.attribute,
  });

  final shortInfo;
  final imageURL;
  final price;
  final postBy;
  final int value;
  final int currentIndex;
  final String addressId;
  final V;
  final AddressModel model;
  final String attribute;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

enum RadioValue { FIRST, SECOND, THIRD }

class _CheckOutPageState extends State<CheckOutPage> {
  var gValue = 0;
  final shipsPayment = 1200;

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    String _type = 'サイズ料金';
    String _payment = '中';
    void _handleRadioButton(String payment) => setState(() {
          _payment = payment;
        });
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("e5e2df"),
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width * 0.27,
          leading: TextButton(
            child: Text(
              "キャンセル",
              style: TextStyle(
                color: Colors.black.withOpacity(0.8), //文字の色を白にする
                //fontWeight: FontWeight.bold, //文字を太字する
                fontSize: 15.0, //文字のサイズを調整する
              ),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "購入画面",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, left: 3, bottom: 3),
                          child: Row(
                            children: [
                              Image.network(
                                widget.imageURL,
                                //width: 100,
                                height: 100,
                                fit: BoxFit.scaleDown,
                              ),
                              Container(
                                height: 90,
                                //width: MediaQuery.of(context).size.width * 0.8,
                                //color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 3.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "作品：" + widget.shortInfo,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection(
                                              "users",
                                            )
                                            .where("uid",
                                                isEqualTo: widget.postBy)
                                            .snapshots(),
                                        builder: (context, dataSnapshot) {
                                          return Text(
                                            "作者名：" +
                                                dataSnapshot
                                                    .data.docs[0]["name"]
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 5),
                                child: Container(
                                  color: Colors.deepPurpleAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "送料別途",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 5),
                                child: Text(
                                  "¥ " + widget.price.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                  //textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                child: widget.attribute == "Original"
                    ? null
                    : Column(
                        children: [
                          RadioListTile(
                            secondary: Text("−500円"),
                            title: Text('サイズ 小'),
                            subtitle: Text('100×150のサイズです'),
                            value: -500,
                            groupValue: gValue,
                            onChanged: (value) => _onRadioSelected(value),
                          ),
                          Divider(),
                          RadioListTile(
                            secondary: Text("+0円"),
                            title: Text('サイズ 中'),
                            value: 0,
                            subtitle: Text('150×225のサイズです'),
                            groupValue: gValue,
                            onChanged: (value) => _onRadioSelected(value),
                          ),
                          Divider(),
                          RadioListTile(
                            secondary: Text("+500円"),
                            title: Text('サイズ 大'),
                            subtitle: Text('300×450のサイズです'),
                            value: 500,
                            groupValue: gValue,
                            onChanged: (value) => _onRadioSelected(value),
                          ),
                        ],
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  leading: Text(
                    "支払い方法",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  trailing: Text("代引き"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      leading: Text(
                        "送料",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      trailing: Text(
                        "¥ " + shipsPayment.toString() + " (一律)",
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text(
                        "サイズ料金",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      trailing: gValue != 0
                          ? Text(
                              "¥ " + gValue.toString() + " (オプション有り)",
                            )
                          : Text(
                              "¥ " + gValue.toString() + " (オプション無し)",
                            ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text(
                        "支払い金額",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      trailing: Text(
                        "¥ " + "${widget.price + shipsPayment + gValue}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => AddAddress());
                    Navigator.pushReplacement(context, route);
                  },
                  leading: Icon(Icons.add),
                  title: Text("新規お届け先を追加"),
                ),
              ),
              Consumer<AddressChanger>(
                builder: (context, address, c) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore
                        .collection(EcommerceApp.collectionUser)
                        .doc(EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.userUID))
                        .collection(EcommerceApp.subCollectionAddress)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: circularProgress(),
                            )
                          : snapshot.data.docs.length == 0
                              ? Container()
                              // ? noAddressCard()
                              : ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    BuyStepButton(
                                      currentIndex: address.counter,
                                      value: index,
                                      model: AddressModel.fromJson(
                                        snapshot.data.docs[index].data(),
                                      ),
                                      addressId: snapshot.data.docs[index].id,
                                    );
                                    return AddressCard(
                                      currentIndex: address.counter,
                                      value: index,
                                      model: AddressModel.fromJson(
                                        snapshot.data.docs[index].data(),
                                      ),
                                      addressId: snapshot.data.docs[index].id,
                                    );
                                  },
                                );
                    },
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<AddressChanger>(
                builder: (context, address, c) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore
                        .collection(EcommerceApp.collectionUser)
                        .doc(EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.userUID))
                        .collection(EcommerceApp.subCollectionAddress)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: circularProgress(),
                            )
                          : snapshot.data.docs.length == 0
                              ? Container()
                              // ? noAddressCard()
                              : ListView.builder(
                                  itemCount: 1,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height: 45,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.redAccent,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return CupertinoAlertDialog(
                                                  title: Center(
                                                    child: Text(
                                                      "購入確認",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  content: Container(
                                                    child: Text(
                                                      "${widget.shortInfo} を購入します。\nよろしいですか？",
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    // ボタン領域
                                                    FlatButton(
                                                      child: Text("キャンセル"),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                    FlatButton(
                                                      child: Text(
                                                        "購入する",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        writeOrderDetailsForUser(
                                                          {
                                                            EcommerceApp
                                                                    .addressID:
                                                                snapshot
                                                                    .data
                                                                    .docs[index]
                                                                    .id,
                                                            "orderBy": EcommerceApp
                                                                .sharedPreferences
                                                                .getString(
                                                                    EcommerceApp
                                                                        .userUID),
                                                            EcommerceApp
                                                                    .productID:
                                                                widget
                                                                    .shortInfo,
                                                            EcommerceApp
                                                                    .paymentDetails:
                                                                "代金引換",
                                                            EcommerceApp
                                                                    .orderTime:
                                                                DateTime.now()
                                                                    .millisecondsSinceEpoch
                                                                    .toString(),
                                                            EcommerceApp
                                                                    .isSuccess:
                                                                true,
                                                            "boughtFrom":
                                                                widget.postBy,
                                                            "totalPrice": widget
                                                                    .price +
                                                                shipsPayment +
                                                                gValue
                                                          },
                                                        );
                                                        notifyToSeller(
                                                          {
                                                            EcommerceApp
                                                                    .addressID:
                                                                snapshot
                                                                    .data
                                                                    .docs[index]
                                                                    .id,
                                                            "orderBy": EcommerceApp
                                                                .sharedPreferences
                                                                .getString(
                                                                    EcommerceApp
                                                                        .userName),
                                                            EcommerceApp
                                                                    .productID:
                                                                widget
                                                                    .shortInfo,
                                                            EcommerceApp
                                                                    .paymentDetails:
                                                                "代金引換",
                                                            EcommerceApp
                                                                    .orderTime:
                                                                DateTime.now()
                                                                    .millisecondsSinceEpoch
                                                                    .toString(),
                                                            EcommerceApp
                                                                    .isSuccess:
                                                                true,
                                                            "boughtFrom":
                                                                widget.postBy,
                                                            "totalPrice":
                                                                widget.price,
                                                            "NotifyMessage":
                                                                "${EcommerceApp.sharedPreferences.getString(
                                                              EcommerceApp
                                                                  .userName,
                                                            )} さんが${widget.shortInfo}を購入しました。\n取引完了まで少々お待ちください。\nまた、売上金は取引完了後に付与されます。"
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            "購入する",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    );
                                    // BuyStepButton(
                                    //   currentIndex: address.counter,
                                    //   value: index,
                                    //   model: AddressModel.fromJson(
                                    //     snapshot.data.docs[index].data(),
                                    //   ),
                                    //   addressId: snapshot.data.docs[index].id,
                                    // );
                                  },
                                );
                    },
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onRadioSelected(value) {
    setState(() {
      gValue = value;
    });
  }

  Future notifyToSeller(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(widget.postBy)
        .collection("Notify")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data["orderTime"])
        .set(data);
    // .whenComplete(
    //   () => {
    //     finishedPayment(),
    //   },
    // );
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data["orderTime"])
        .set(data)
        .whenComplete(
          () => {
            finishedPayment(),
          },
        );
  }

  finishedPayment() {
    Fluttertoast.showToast(msg: "注文を承りました");
    Route route = MaterialPageRoute(builder: (c) => MyOrders());
    Navigator.pushReplacement(context, route);
  }
}

class BuyStepButton extends StatefulWidget {
  const BuyStepButton({
    Key key,
    this.value,
    this.addressId,
    this.currentIndex,
    this.model,
  }) : super(
          key: key,
        );

  final AddressModel model;
  final String addressId;
  final int currentIndex;
  final int value;

  @override
  _BuyStepButtonState createState() => _BuyStepButtonState();
}

class _BuyStepButtonState extends State<BuyStepButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 45,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.redAccent),
          onPressed: () {
            print(widget.addressId);
          },
          child: Text(
            "購入する",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}