import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Address/addAddress.dart';
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Counters/changeAddresss.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:selling_pictures_platform/Orders/myOrders.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/WidgetOfFirebase.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../main.dart';
import 'TransactionPage.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key key, this.id, this.il, this.V});

  final int V;
  final String id;
  final Map il;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

enum RadioValue { FIRST, SECOND, THIRD }

class _CheckOutPageState extends State<CheckOutPage> {
  var gValue = 0;
  final shipsPayment = 1200;
  TextEditingController _cardNumberEditingController = TextEditingController();
  TextEditingController _expMonthEditingController = TextEditingController();
  TextEditingController _expYearEditingController = TextEditingController();
  TextEditingController _cvcNumberEditingController = TextEditingController();

  String _email;

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    fetchUserData();
  }

  void fetchUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(widget.il["postBy"])
        .get();
    _email = snapshot.data()['email'];
  }

  String cvc = "";
  String month = "";
  String year = "";
  String cNumber = "";
  bool cNumberbool = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("e5e2df"),
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.27,
        leading: TextButton(
          child: Text(
            "キャンセル",
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontSize: 15.0,
            ),
          ),
          onPressed: () {
            // Route route = MaterialPageRoute(builder: (c) => MainPage());
            // Navigator.pushReplacement(context, route);
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: InkWell(
          onTap: () {
            print(widget.il["postName"]);
            print(widget.il["finalGetProceeds"]);
          },
          child: Text(
            "購入画面",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 75,
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.network(
                              widget.il["thumbnailUrl"],
                              //width: 100,
                              height: 100,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        "作品名：" + widget.il["shortInfo"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(
                              "users",
                            )
                            .where("uid", isEqualTo: widget.il["postBy"])
                            .snapshots(),
                        builder: (context, dataSnapshot) {
                          return dataSnapshot.data == null
                              ? Container()
                              : Text(
                                  "作者名：" +
                                      dataSnapshot.data.docs[0]["name"]
                                          .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                        },
                      ),
                      trailing: Text(
                        "¥ " + widget.il["price"].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                        //textAlign: TextAlign.right,
                      ),
                    )
                  ],
                )),
            mySizedBox(40),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  "支払い方法",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
                trailing: Text("クレジットカード"),
              ),
            ),
            mySizedBox(40),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Divider(),
                  ListTile(
                    leading: Text(
                      "支払い金額",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    trailing: Text(
                      "¥ " + "${widget.il["price"]}",
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
                  Route route = MaterialPageRoute(builder: (c) => AddAddress());
                  Navigator.push(context, route);
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
                            : ExpansionTile(
                                collapsedBackgroundColor: Colors.white,
                                leading: Icon(Icons.location_on_outlined),
                                title: Text("マイアドレス"),
                                children: [
                                  ListView.builder(
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
                                  ),
                                ],
                              );
                  },
                );
              },
            ),
            mySizedBox(20),
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
                                      width: MediaQuery.of(context).size.width *
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
                                              return AlertDialog(
                                                title: Center(
                                                  child: Text(
                                                    "決済画面",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Expanded(
                                                      child: Form(
                                                    key: formKey,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: TextFormField(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                cNumber = value;
                                                                cNumberbool =
                                                                    !cNumberbool;
                                                              });
                                                            },
                                                            inputFormatters: [
                                                              LengthLimitingTextInputFormatter(
                                                                  16),
                                                            ],
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            validator:
                                                                (String value) {
                                                              return value.isEmpty ||
                                                                      value.length >=
                                                                          16
                                                                  ? '正しいカードナンバーを入力して下さい'
                                                                  : null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "カードナンバー",
                                                              icon: Icon(Icons
                                                                  .credit_card),
                                                              hintText:
                                                                  "カードナンバー",
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            controller:
                                                                _cardNumberEditingController,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child:
                                                                    TextFormField(
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      month =
                                                                          value;
                                                                    });
                                                                  },
                                                                  validator:
                                                                      (String
                                                                          value) {
                                                                    return value
                                                                            .isEmpty
                                                                        ? '正しいカード有効期限を入力して下さい'
                                                                        : null;
                                                                  },
                                                                  inputFormatters: [
                                                                    LengthLimitingTextInputFormatter(
                                                                        2),
                                                                  ],
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        "MM",
                                                                    hintText:
                                                                        "MM",
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  controller:
                                                                      _expMonthEditingController,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child:
                                                                    TextFormField(
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      year =
                                                                          value;
                                                                    });
                                                                  },
                                                                  validator:
                                                                      (String
                                                                          value) {
                                                                    return value
                                                                            .isEmpty
                                                                        ? '正しいカード有効期限を入力して下さい'
                                                                        : null;
                                                                  },
                                                                  inputFormatters: [
                                                                    LengthLimitingTextInputFormatter(
                                                                        2),
                                                                  ],
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        "YY",
                                                                    hintText:
                                                                        "YY",
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  controller:
                                                                      _expYearEditingController,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: TextFormField(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                cvc = value;
                                                              });
                                                            },
                                                            validator:
                                                                (String value) {
                                                              return value.isEmpty ||
                                                                      value.length >=
                                                                          3
                                                                  ? '正しいセキュリティーコードを入力して下さい'
                                                                  : null;
                                                            },
                                                            inputFormatters: [
                                                              LengthLimitingTextInputFormatter(
                                                                  3),
                                                            ],
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "セキュリティーコード",
                                                              hintText: "CVC",
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            controller:
                                                                _cvcNumberEditingController,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                ),
                                                actions: <Widget>[
                                                  // ボタン領域
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15.0),
                                                          child: ElevatedButton(
                                                            child:
                                                                Text(" キャンセル "),
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 15.0),
                                                          child: cNumber !=
                                                                      "" &&
                                                                  month != "" &&
                                                                  year != "" &&
                                                                  cvc != ""
                                                              ? ElevatedButton(
                                                                  child: Text(
                                                                      "   購入する   "),
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) {
                                                                        return CupertinoAlertDialog(
                                                                          title:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "購入確認",
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          content:
                                                                              Container(
                                                                            child:
                                                                                Text(
                                                                              "${widget.il["shortInfo"]} を購入します。\nよろしいですか？",
                                                                            ),
                                                                          ),
                                                                          actions: <
                                                                              Widget>[
                                                                            // ボタン領域
                                                                            ElevatedButton(
                                                                              child: Text("キャンセル"),
                                                                              onPressed: () => Navigator.pop(context),
                                                                            ),
                                                                            formKey.currentState.validate()
                                                                                ? ElevatedButton(
                                                                                    child: Text(
                                                                                      "購入する",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      final creditCard = CreditCard(number: _cardNumberEditingController.text.toString(), expMonth: int.parse(_expMonthEditingController.text), expYear: int.parse(_expYearEditingController.text), cvc: _cvcNumberEditingController.text.toString());
                                                                                      StripeService(price: widget.il["price"]).payViaExistingCard(creditCard);
                                                                                      widget.il["attribute"] == "Original"
                                                                                          ? FirebaseFirestore.instance.collection("items").doc(widget.id).update({
                                                                                              "Stock": 0,
                                                                                            })
                                                                                          : FirebaseFirestore.instance.collection("items").doc(widget.id).update({
                                                                                              // "Stock": widget.stock - 1,
                                                                                              "Stock": FieldValue.increment(-1),
                                                                                            });
                                                                                      final ref = EcommerceApp.firestore.collection(EcommerceApp.collectionUser).doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) + DateTime.now().millisecondsSinceEpoch.toString());
                                                                                      ref.set(
                                                                                        {
                                                                                          "id": ref.id,
                                                                                          "imageURL": widget.il["imageURL"],
                                                                                          EcommerceApp.addressID: snapshot.data.docs[index].id,
                                                                                          "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
                                                                                          EcommerceApp.productID: widget.il["shortInfo"],
                                                                                          EcommerceApp.paymentDetails: "クレジットカード",
                                                                                          EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                          EcommerceApp.isSuccess: true,
                                                                                          "boughtFrom": widget.il["postBy"],
                                                                                          "totalPrice": widget.il["price"],
                                                                                          "isTransactionFinished": "inComplete",
                                                                                          "isDelivery": "inComplete",
                                                                                          "itemPrice": widget.il["price"],
                                                                                          "postName": widget.il["postName"],
                                                                                          "email": EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail),
                                                                                          "CancelRequest": false,
                                                                                          "CancelRequestTo": false,
                                                                                          "cancelTransactionFinished": false,
                                                                                          "itemID": widget.id
                                                                                        },
                                                                                      ).whenComplete(
                                                                                        () => {
                                                                                          finishedCheckOut(),
                                                                                        },
                                                                                      );
                                                                                      EcommerceApp.firestore.collection(EcommerceApp.collectionUser).doc(widget.il["postBy"]).collection("Notify").doc(ref.id).set({
                                                                                        "id": ref.id,
                                                                                        "imageURL": widget.il["imageURL"],
                                                                                        EcommerceApp.addressID: snapshot.data.docs[index].id,
                                                                                        "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                                                                                        EcommerceApp.productID: widget.il["shortInfo"],
                                                                                        EcommerceApp.paymentDetails: "代金引換",
                                                                                        EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                        EcommerceApp.isSuccess: true,
                                                                                        "boughtFrom": widget.il["postName"],
                                                                                        "totalPrice": widget.il["price"],
                                                                                        "NotifyMessage": "${EcommerceApp.sharedPreferences.getString(
                                                                                          EcommerceApp.userName,
                                                                                        )} さんが${widget.il["shortInfo"]}を購入しました。\n取引完了まで少々お待ちください。\nまた、売上金は取引完了後に付与されます。",
                                                                                        "isTransactionFinished": "inComplete",
                                                                                        "isBuyerDelivery": "inComplete",
                                                                                        "itemPrice": widget.il["price"],
                                                                                        "buyerID": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
                                                                                        "email": _email,
                                                                                        "finalGetProceeds": widget.il["finalGetProceeds"],
                                                                                        "CancelRequest": false,
                                                                                        "CancelRequestTo": false,
                                                                                        "cancelTransactionFinished": false,
                                                                                        "itemID": widget.id
                                                                                      });
                                                                                    },
                                                                                  )
                                                                                : ElevatedButton(
                                                                                    onPressed: () {},
                                                                                    child: Text("購入する"),
                                                                                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                                                                                  ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                )
                                                              : ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                      "　購入する　"),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary:
                                                                              Colors.grey),
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          "決済する",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                  },
                );
              },
            ),
            mySizedBox(20)
          ],
        ),
      ),
    );
  }

  Future notifyToSeller(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(widget.il["postBy"])
        .collection("Notify")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data["orderTime"])
        .set(data);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    final ref = EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data["orderTime"]);
    await ref.set(data).whenComplete(
          () => {
            finishedCheckOut(),
          },
        );
  }

  finishedCheckOut() {
    TransactionPage(
      name: widget.il["postName"],
      id: widget.il["postBy"],
    );

    Fluttertoast.showToast(msg: "注文を承りました");
    Route route = MaterialPageRoute(
        builder: (c) => MyOrders(
              finalGetProceeds: widget.il["finalGetProceeds"],
              name: widget.il["postName"],
              id: widget.il["postBy"],
            ));
    Navigator.pushReplacement(context, route);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Center(
            child: Text(
              "注文を承りました。",
            ),
          ),
          content: Text(
              "よろしければ「${widget.il["shortInfo"]}」の作者である\n「${widget.il["postName"]}」さんをフォローして応援しませんか？"),
          actions: [
            ElevatedButton(
              child: Text("フォローしない"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("フォローする"),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.il["postBy"])
                    .collection("Followers")
                    .doc(EcommerceApp.sharedPreferences
                        .getString(EcommerceApp.userUID))
                    .set({"isFollow": true});
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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

class StripeTransactionResponse {
  StripeTransactionResponse({
    @required this.message,
    @required this.success,
  });

  String message;
  bool success;
}

class StripeService {
  final int price;

  StripeService({this.price});

  /// pay via new card
  Future<StripeTransactionResponse> payViaNewCard() async {
    initialize();
    // create payment method
    final paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    );
    // StripePayment.createSourceWithParams(options);
    final paymentIntent = await createPaymentIntent();
    final confirmResult =
        await confirmPaymentIntent(paymentIntent, paymentMethod);
    return handlePaymentResult(confirmResult);
  }

  /// pay via existing card
  Future<StripeTransactionResponse> payViaExistingCard(
      CreditCard creditCard) async {
    initialize();
    final paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(card: creditCard),
    );
    final paymentIntent = await createPaymentIntent();
    final confirmResult =
        await confirmPaymentIntent(paymentIntent, paymentMethod);
    return handlePaymentResult(confirmResult);
  }

  /// initialize stripe
  void initialize() {
    const publishableKey =
        'pk_test_51IsmpSBqhjcHw6SAXESFpB4deZcO28ciMAhsejnDQU2TLBX8eu3ud6LLIzIaOXFCZqn3BulpEhCgCS8r0f3a4Iqq004HizK3Hh';
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: publishableKey,
        merchantId: 'Test',
        androidPayMode: 'test',
      ),
    );
  }

  /// create payment intent
  Future<dynamic> createPaymentIntent() async {
    final paymentEndpoint = Uri.https('api.stripe.com', 'v1/payment_intents');
    const secretKey =
        'sk_test_51IsmpSBqhjcHw6SABgmvRZtCE8hhxMmR3DpZpK4EwiUbIoRyRKuLqb7L1WLkWKA14u6bcgAH7wdcfEMiln3nu3Ow00Rt8BE0xe';

    final headers = <String, String>{
      'Authorization': 'Bearer $secretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, dynamic>{
      'amount': price.toString(),
      'currency': 'jpy',
      'payment_method_types[]': 'card',
      "description": "ユーザーID：${EcommerceApp.sharedPreferences.getString(
        EcommerceApp.userUID,
      )}",
    };

    final response = await http.post(
      paymentEndpoint,
      headers: headers,
      body: body,
    );

    final paymentIntent = jsonDecode(response.body);
    return paymentIntent;
  }

  /// confirm payment intent
  Future<PaymentIntentResult> confirmPaymentIntent(
      dynamic paymentIntent, PaymentMethod paymentMethod) async {
    //print(paymentIntent);
    final confirmResult = await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ),
    );
    return confirmResult;
  }

  /// handle payment intent result
  StripeTransactionResponse handlePaymentResult(
      PaymentIntentResult confirmResult) {
    //print("完了");

    if (confirmResult.status == 'succeeded') {
      return StripeTransactionResponse(
        message: 'Transaction successful',
        success: true,
      );
    } else {
      return StripeTransactionResponse(
        message: 'Transaction failed',
        success: true,
      );
    }
  }
}
