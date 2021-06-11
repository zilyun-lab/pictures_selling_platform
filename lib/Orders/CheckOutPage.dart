import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

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
import 'package:stripe_payment/stripe_payment.dart';

import 'OrderDetailsPage.dart';

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
  TextEditingController _cardNumberEditingController = TextEditingController();
  TextEditingController _expMonthEditingController = TextEditingController();
  TextEditingController _expYearEditingController = TextEditingController();
  TextEditingController _cvcNumberEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //ShippingDetails(proceeds: int.parse(widget.price));
    //ShippingDetails(proceeds: int.parse(widget.price + shipsPayment + gValue));

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
                color: Colors.black.withOpacity(0.8),

                fontSize: 15.0,
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
                  trailing: Text("クレジットカード"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   color: Colors.white,
              //   child: _buildContent(),
              // ),
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
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Expanded(
                                                        // child:
                                                        // _buildPayViaNewCardButton(
                                                        //     context),

                                                        child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: TextFormField(
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
                                                            child:
                                                                ElevatedButton(
                                                              child: Text(
                                                                  " キャンセル "),
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right:
                                                                        15.0),
                                                            child:
                                                                ElevatedButton(
                                                              child: Text(
                                                                  "   購入する   "),
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) {
                                                                    return CupertinoAlertDialog(
                                                                      title:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "購入確認",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      content:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "${widget.shortInfo} を購入します。\nよろしいですか？",
                                                                        ),
                                                                      ),
                                                                      actions: <
                                                                          Widget>[
                                                                        // ボタン領域
                                                                        ElevatedButton(
                                                                          child:
                                                                              Text("キャンセル"),
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                        ),
                                                                        ElevatedButton(
                                                                          child:
                                                                              Text(
                                                                            "購入する",
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            final creditCard = CreditCard(
                                                                                number: _cardNumberEditingController.text.toString(),
                                                                                expMonth: int.parse(_expMonthEditingController.text),
                                                                                expYear: int.parse(_expYearEditingController.text),
                                                                                cvc: _cvcNumberEditingController.text.toString());
                                                                            StripeService(price: widget.price + shipsPayment + gValue).payViaExistingCard(creditCard);
                                                                            final ref =
                                                                                EcommerceApp.firestore.collection(EcommerceApp.collectionUser).doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) + DateTime.now().millisecondsSinceEpoch.toString());
                                                                            ref.set(
                                                                              {
                                                                                "id": ref.id,
                                                                                "imageURL": widget.imageURL,
                                                                                EcommerceApp.addressID: snapshot.data.docs[index].id,
                                                                                "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
                                                                                EcommerceApp.productID: widget.shortInfo,
                                                                                EcommerceApp.paymentDetails: "クレジットカード",
                                                                                EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                EcommerceApp.isSuccess: true,
                                                                                "boughtFrom": widget.postBy,
                                                                                "totalPrice": widget.price + shipsPayment + gValue,
                                                                                "isTransactionFinished": "inComplete",
                                                                                "isPayment": "inComplete",
                                                                                "isDelivery": "inComplete",
                                                                                "itemPrice": widget.price,
                                                                              },
                                                                            ).whenComplete(
                                                                              () => {
                                                                                finishedCheckOut(),
                                                                              },
                                                                            );
                                                                            EcommerceApp.firestore.collection(EcommerceApp.collectionUser).doc(widget.postBy).collection("Notify").doc(ref.id).set({
                                                                              "id": ref.id,
                                                                              "imageURL": widget.imageURL,
                                                                              EcommerceApp.addressID: snapshot.data.docs[index].id,
                                                                              "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                                                                              EcommerceApp.productID: widget.shortInfo,
                                                                              EcommerceApp.paymentDetails: "代金引換",
                                                                              EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
                                                                              EcommerceApp.isSuccess: true,
                                                                              "boughtFrom": widget.postBy,
                                                                              "totalPrice": widget.price + shipsPayment + gValue,
                                                                              "NotifyMessage": "${EcommerceApp.sharedPreferences.getString(
                                                                                EcommerceApp.userName,
                                                                              )} さんが${widget.shortInfo}を購入しました。\n取引完了まで少々お待ちください。\nまた、売上金は取引完了後に付与されます。",
                                                                              "isTransactionFinished": "inComplete",
                                                                              "isBuyerPayment": "inComplete",
                                                                              "isBuyerDelivery": "inComplete",
                                                                              "itemPrice": widget.price,
                                                                            });
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
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
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView.separated(
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _buildPayViaNewCardButton(context);
          case 1:
            return _buildPayViaExistingCardButton(context);
          default:
            return Container();
        }
      },
      itemCount: 2,
      separatorBuilder: (
        context,
        index,
      ) =>
          Divider(color: Theme.of(context).primaryColor),
    );
  }

  /// 未登録のカードで決済をするボタン
  Widget _buildPayViaNewCardButton(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('新規のカードで決済する'),
      ),
      onTap: StripeService(price: widget.price + shipsPayment + gValue)
          .payViaNewCard,
    );
  }

  /// 登録済みのカードで決済をするボタン
  Widget _buildPayViaExistingCardButton(BuildContext context) {
    final creditCard = CreditCard(
        number: _cardNumberEditingController.text.trim().toString(),
        expMonth: int.parse(_expMonthEditingController.text.trim().toString()),
        expYear: int.parse(_expYearEditingController.text.trim().toString()),
        cvc: _cvcNumberEditingController.text.trim().toString());
    return InkWell(
      child: ListTile(
        leading: Icon(
          Icons.credit_card_outlined,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('既存のカードで決済する'),
      ),
      onTap: () {
        StripeService(price: widget.price + shipsPayment + gValue)
            .payViaExistingCard(creditCard);

        Fluttertoast.showToast(msg: "注文を承りました");
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      },
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
    print(paymentIntent);
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
    print("完了");

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

// class MySample extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return MySampleState();
//   }
// }
//
// class MySampleState extends State<MySample> {
//   String cardNumber = '';
//   String expiryDate = '';
//   // String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Column(
//         children: <Widget>[
//           // CreditCardWidget(
//           //   cardNumber: cardNumber,
//           //   expiryDate: expiryDate,
//           //   cardHolderName: cardHolderName,
//           //   cvvCode: cvvCode,
//           //   showBackView: isCvvFocused,
//           //   obscureCardNumber: true,
//           //   obscureCardCvv: true,
//           // ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   CreditCardForm(
//                     formKey: formKey,
//                     obscureCvv: false,
//                     obscureNumber: false,
//                     cardNumber: cardNumber,
//                     cvvCode: cvvCode,
//                     // cardHolderName: cardHolderName,
//                     expiryDate: expiryDate,
//                     themeColor: Colors.blue,
//                     cardNumberDecoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'カードナンバー',
//                       hintText: 'XXXX XXXX XXXX XXXX',
//                     ),
//                     expiryDateDecoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'MM/YY',
//                       hintText: 'XX/XX',
//                     ),
//                     cvvCodeDecoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'CVV',
//                       hintText: 'XXX',
//                     ),
//                     // cardHolderDecoration: const InputDecoration(
//                     //   border: OutlineInputBorder(),
//                     //   labelText: 'Card Holder',
//                     // ),
//                     onCreditCardModelChange: onCreditCardModelChange,
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       primary: const Color(0xff1b447b),
//                     ),
//                     child: Container(
//                       margin: const EdgeInsets.all(8),
//                       child: const Text(
//                         'Validate',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'halter',
//                           fontSize: 14,
//                           package: 'flutter_credit_card',
//                         ),
//                       ),
//                     ),
//                     onPressed: () {
//                       if (formKey.currentState.validate()) {
//                         print('valid!');
//                       } else {
//                         print('invalid!');
//                       }
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void onCreditCardModelChange(CreditCardModel creditCardModel) {
//     setState(() {
//       cardNumber = creditCardModel.cardNumber;
//       expiryDate = creditCardModel.expiryDate;
//       // cardHolderName = creditCardModel.cardHolderName;
//       cvvCode = creditCardModel.cvvCode;
//       isCvvFocused = creditCardModel.isCvvFocused;
//     });
//   }
// }
