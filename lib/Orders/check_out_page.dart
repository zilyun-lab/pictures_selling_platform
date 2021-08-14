// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

// Project imports:
import 'package:selling_pictures_platform/Address/addAddress.dart';
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Counters/change_address.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:selling_pictures_platform/Orders/my_oeders.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/widget_of_firebase.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import '../main.dart';
import 'transaction_page.dart';

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
  int gValue = 0;
  final shipsPayment = 1200;
  final TextEditingController _cardNumberEditingController = TextEditingController();
  final TextEditingController _expMonthEditingController = TextEditingController();
  final TextEditingController _expYearEditingController = TextEditingController();
  final TextEditingController _cvcNumberEditingController = TextEditingController();

  String _email;

  @override
  void initState() {
    fetchUserData();
  }

  void fetchUserData() async {
    final snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(widget.il['postBy'])
        .get();
    _email = snapshot.data()['email'];
  }

  String cvc = '';
  String month = '';
  String year = '';
  String cNumber = '';
  bool cNumberbool = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.27,
        centerTitle: true,
        backgroundColor: bgColor,
        title: InkWell(
          onTap: () {
            print(widget.il['postName']);
            print(widget.il['finalGetProceeds']);
          },
          child: const Text(
            '購入画面',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Neumorphic(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 2, bottom: 1),
                        style: NeumorphicStyle(
                          shadowLightColor: Colors.white,
                          shadowDarkColor: Colors.black.withOpacity(0.8),
                          color: Colors.white38,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.network(
                            widget.il['thumbnailUrl'],
                            //width: 100,
                            height: 150,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ),
                  mySizedBox(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                              '作品名：' + widget.il['shortInfo'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(
                                  'users',
                                )
                                .where('uid', isEqualTo: widget.il['postBy'])
                                .snapshots(),
                            builder: (context, dataSnapshot) {
                              return dataSnapshot.data == null
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 0, 8, 8),
                                      child: Text(
                                        '作者名：${dataSnapshot.data.docs[0]['name']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Neumorphic(
                style: NeumorphicStyle(
                  color: Colors.white,
                  shadowLightColor: Colors.black.withOpacity(0.4),
                  shadowDarkColor: Colors.black.withOpacity(0.6),
                ),
                child: const ListTile(
                  leading: Text(
                    '支払い方法',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  trailing: Text('クレジットカード'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Neumorphic(
                style: NeumorphicStyle(
                  color: Colors.white,
                  shadowLightColor: Colors.black.withOpacity(0.4),
                  shadowDarkColor: Colors.black.withOpacity(0.6),
                ),
                child: ListTile(
                  leading: const Text(
                    '送料',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  trailing: Text(widget.il['shipsPayment']),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Neumorphic(
                style: NeumorphicStyle(
                  color: Colors.white,
                  shadowLightColor: Colors.black.withOpacity(0.4),
                  shadowDarkColor: Colors.black.withOpacity(0.6),
                ),
                child: ListTile(
                  leading: const Text(
                    '支払い金額',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  trailing: Text(
                    '¥ ' + '${widget.il['price']}',
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Neumorphic(
                style: NeumorphicStyle(
                  color: Colors.white,
                  shadowLightColor: Colors.black.withOpacity(0.4),
                  shadowDarkColor: Colors.black.withOpacity(0.6),
                ),
                child: ListTile(
                  onTap: () {
                    final Route route =
                        MaterialPageRoute(builder: (c) => AddAddress());
                    Navigator.push(context, route);
                  },
                  leading: Icon(
                    Icons.add,
                    color: mainColorOfLEEWAY,
                  ),
                  title: const Text('新規お届け先を追加'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                ),
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
                            child: circular_progress(),
                          )
                        : snapshot.data.docs.isEmpty
                            ? Container()
                            // ? noAddressCard()
                            : Padding(
                                padding: const EdgeInsets.all(8),
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                    color: Colors.white,
                                    shadowLightColor:
                                        Colors.black.withOpacity(0.4),
                                    shadowDarkColor:
                                        Colors.black.withOpacity(0.6),
                                  ),
                                  child: ExpansionTile(
                                    initiallyExpanded: true,
                                    collapsedBackgroundColor: Colors.white,
                                    leading: Icon(
                                      Icons.location_on_outlined,
                                      color: mainColorOfLEEWAY,
                                    ),
                                    title: const Text(
                                      'マイアドレス',
                                      style: TextStyle(color: Colors.black),
                                    ),
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
                                            addressId:
                                                snapshot.data.docs[index].id,
                                          );
                                          return AddressCard(
                                            currentIndex: address.counter,
                                            value: index,
                                            model: AddressModel.fromJson(
                                              snapshot.data.docs[index].data(),
                                            ),
                                            addressId:
                                                snapshot.data.docs[index].id,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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
                            child: circular_progress(),
                          )
                        : snapshot.data.docs.isEmpty
                            ? Container()
                            // ? noAddressCard()
                            : ListView.builder(
                                itemCount: 1,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: NeumorphicButton(
                                            style: NeumorphicStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.6)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Center(
                                              child: Text(
                                                'キャンセル',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: 45,
                                            child: NeumorphicButton(
                                              style: NeumorphicStyle(
                                                  color: mainColorOfLEEWAY
                                                      .withOpacity(0.6)),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: const Center(
                                                        child: Text(
                                                          '決済画面',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Expanded(
                                                            child: Form(
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5),
                                                                child:
                                                                    TextFormField(
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      cNumber =
                                                                          value;
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
                                                                      (String
                                                                          value) {
                                                                    return value.isEmpty ||
                                                                            value.length >=
                                                                                16
                                                                        ? '正しいカードナンバーを入力して下さい'
                                                                        : null;
                                                                  },
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    labelText:
                                                                        'カードナンバー',
                                                                    icon: Icon(Icons
                                                                        .credit_card),
                                                                    hintText:
                                                                        'カードナンバー',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  controller:
                                                                      _cardNumberEditingController,
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5),
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
                                                                          return value.isEmpty
                                                                              ? '正しいカード有効期限を入力して下さい'
                                                                              : null;
                                                                        },
                                                                        inputFormatters: [
                                                                          LengthLimitingTextInputFormatter(
                                                                              2),
                                                                        ],
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          labelText:
                                                                              'MM',
                                                                          hintText:
                                                                              'MM',
                                                                          hintStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                        controller:
                                                                            _expMonthEditingController,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5),
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
                                                                          return value.isEmpty
                                                                              ? '正しいカード有効期限を入力して下さい'
                                                                              : null;
                                                                        },
                                                                        inputFormatters: [
                                                                          LengthLimitingTextInputFormatter(
                                                                              2),
                                                                        ],
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              'YY',
                                                                          hintText:
                                                                              'YY',
                                                                          hintStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey,
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
                                                                            .all(
                                                                        5),
                                                                child:
                                                                    TextFormField(
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      cvc =
                                                                          value;
                                                                    });
                                                                  },
                                                                  validator:
                                                                      (String
                                                                          value) {
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
                                                                      const InputDecoration(
                                                                    labelText:
                                                                        'セキュリティーコード',
                                                                    hintText:
                                                                        'CVC',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
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
                                                                        left:
                                                                            15),
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child: Text(
                                                                      ' キャンセル '),
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          15),
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (_) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const Center(
                                                                              child: Text(
                                                                                '購入確認',
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            content:
                                                                                Container(
                                                                              child: Text(
                                                                                '${widget.il['shortInfo']} を購入します。\nよろしいですか？',
                                                                              ),
                                                                            ),
                                                                            actions: <Widget>[
                                                                              // ボタン領域
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8),
                                                                                      child: ElevatedButton(
                                                                                        child: Text('キャンセル'),
                                                                                        onPressed: () => Navigator.pop(context),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8),
                                                                                      child: ElevatedButton(
                                                                                        child: Text(
                                                                                          '購入する',
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          final creditCard = CreditCard(number: _cardNumberEditingController.text.toString(), expMonth: int.parse(_expMonthEditingController.text), expYear: int.parse(_expYearEditingController.text), cvc: _cvcNumberEditingController.text.toString());
                                                                                          StripeService(price: widget.il['price']).payViaExistingCard(creditCard);
                                                                                          widget.il['attribute'] == 'Original'
                                                                                              ? FirebaseFirestore.instance.collection('items').doc(widget.id).update({
                                                                                                  'Stock': 0,
                                                                                                })
                                                                                              : FirebaseFirestore.instance.collection('items').doc(widget.id).update({
                                                                                                  // 'Stock': widget.stock - 1,
                                                                                                  'Stock': FieldValue.increment(-1),
                                                                                                });
                                                                                          final ref = EcommerceApp.firestore.collection(EcommerceApp.collectionUser).doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionOrders).doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) + DateTime.now().millisecondsSinceEpoch.toString());
                                                                                          ref.set(
                                                                                            {
                                                                                              'id': ref.id,
                                                                                              'imageURL': widget.il['thumbnailUrl'],
                                                                                              EcommerceApp.addressID: snapshot.data.docs[index].id,
                                                                                              'orderBy': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
                                                                                              'orderByName': EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                                                                                              EcommerceApp.productID: widget.il['shortInfo'],
                                                                                              EcommerceApp.paymentDetails: 'クレジットカード',
                                                                                              EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                              EcommerceApp.isSuccess: true,
                                                                                              'boughtFrom': widget.il['postBy'],
                                                                                              'totalPrice': widget.il['price'],
                                                                                              'isTransactionFinished': 'inComplete',
                                                                                              'isDelivery': 'inComplete',
                                                                                              'itemPrice': widget.il['price'],
                                                                                              'postName': widget.il['postName'],
                                                                                              'email': EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail),
                                                                                              'CancelRequest': false,
                                                                                              'CancelRequestTo': false,
                                                                                              'cancelTransactionFinished': false,
                                                                                              'itemID': widget.id,
                                                                                              'firstCancelRequest': false,
                                                                                              'secondCancelRequest': false,
                                                                                              'hold': false,
                                                                                            },
                                                                                          ).whenComplete(
                                                                                            () => {
                                                                                              finishedCheckOut(),
                                                                                            },
                                                                                          );
                                                                                          EcommerceApp.firestore.collection(EcommerceApp.collectionUser).doc(widget.il['postBy']).collection('Notify').doc(ref.id).set({
                                                                                            'id': ref.id,
                                                                                            'imageURL': widget.il['thumbnailUrl'],
                                                                                            EcommerceApp.addressID: snapshot.data.docs[index].id,
                                                                                            'orderBy': EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                                                                                            'orderByName': EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                                                                                            EcommerceApp.productID: widget.il['shortInfo'],
                                                                                            EcommerceApp.paymentDetails: '代金引換',
                                                                                            EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                            EcommerceApp.isSuccess: true,
                                                                                            'boughtFrom': widget.il['postName'],
                                                                                            'totalPrice': widget.il['price'],
                                                                                            'isTransactionFinished': 'inComplete',
                                                                                            'isBuyerDelivery': 'inComplete',
                                                                                            'itemPrice': widget.il['price'],
                                                                                            'buyerID': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
                                                                                            'email': _email,
                                                                                            'finalGetProceeds': widget.il['finalGetProceeds'],
                                                                                            'CancelRequest': false,
                                                                                            'CancelRequestTo': false,
                                                                                            'cancelTransactionFinished': false,
                                                                                            'itemID': widget.id,
                                                                                            'firstCancelRequest': false,
                                                                                            'secondCancelRequest': false,
                                                                                            'hold': false,
                                                                                          });
                                                                                          FirebaseFirestore.instance.collection('orders').doc(ref.id).set(
                                                                                            {
                                                                                              'sellerID': widget.il['postBy'],
                                                                                              'id': ref.id,
                                                                                              'imageURL': widget.il['thumbnailUrl'],
                                                                                              EcommerceApp.addressID: snapshot.data.docs[index].id,
                                                                                              'orderBy': EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                                                                                              'orderByName': EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                                                                                              EcommerceApp.productID: widget.il['shortInfo'],
                                                                                              EcommerceApp.paymentDetails: '代金引換',
                                                                                              EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                              EcommerceApp.isSuccess: true,
                                                                                              'boughtFrom': widget.il['postName'],
                                                                                              'totalPrice': widget.il['price'],
                                                                                              'isTransactionFinished': 'inComplete',
                                                                                              'isBuyerDelivery': 'inComplete',
                                                                                              'itemPrice': widget.il['price'],
                                                                                              'buyerID': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
                                                                                              'email': _email,
                                                                                              'finalGetProceeds': widget.il['finalGetProceeds'],
                                                                                              'CancelRequest': false,
                                                                                              'CancelRequestTo': false,
                                                                                              'cancelTransactionFinished': false,
                                                                                              'itemID': widget.id,
                                                                                              'firstCancelRequest': false,
                                                                                              'secondCancelRequest': false,
                                                                                              'hold': false,
                                                                                            },
                                                                                          );
                                                                                          FirebaseFirestore.instance
                                                                                              .collection('users')
                                                                                              .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                                                                                              .collection('AllNotify')
                                                                                              .doc(
                                                                                                EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
                                                                                              )
                                                                                              .collection('Guide')
                                                                                              .doc(ref.id)
                                                                                              .set(
                                                                                            {
                                                                                              'Tag': 'Buyer',
                                                                                              'orderID': ref.id,
                                                                                              'CancelRequest': false,
                                                                                              'CancelRequestTo': false,
                                                                                              'cancelTransactionFinished': false,
                                                                                              'isTransactionFinished': false,
                                                                                              'isBuyerDelivery': false,
                                                                                            },
                                                                                          );
                                                                                          FirebaseFirestore.instance
                                                                                              .collection('users')
                                                                                              .doc(
                                                                                                widget.il['postBy'],
                                                                                              )
                                                                                              .collection('AllNotify')
                                                                                              .doc(widget.il['postBy'])
                                                                                              .collection('Guide')
                                                                                              .doc(ref.id)
                                                                                              .set(
                                                                                            {
                                                                                              'Tag': 'Seller',
                                                                                              'orderID': ref.id,
                                                                                              'CancelRequest': false,
                                                                                              'CancelRequestTo': false,
                                                                                              'cancelTransactionFinished': false,
                                                                                              'isTransactionFinished': false,
                                                                                              'isBuyerDelivery': false,
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                        '   購入する   '),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Center(
                                                child: Text(
                                                  '決済する',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
        .doc(widget.il['postBy'])
        .collection('Notify')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime'])
        .set(data);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    final ref = EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime']);
    await ref.set(data).whenComplete(
          () => {
            finishedCheckOut(),
          },
        );
  }

  finishedCheckOut() {
    TransactionPage(
      name: widget.il['postName'],
      id: widget.il['postBy'],
    );

    Fluttertoast.showToast(msg: '注文を承りました');
    Route route = MaterialPageRoute(
        builder: (c) => MyOrders(
              finalGetProceeds: widget.il['finalGetProceeds'],
              name: widget.il['postName'],
              id: widget.il['postBy'],
            ));
    Navigator.pushReplacement(context, route);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Center(
            child: Text(
              '注文を承りました。',
            ),
          ),
          content: Text(
              'よろしければ「${widget.il['shortInfo']}」の作者である\n「${widget.il['postName']}」さんをフォローして応援しませんか？'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: Text('フォローしない'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: Text('フォローする'),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.il['postBy'])
                            .collection('Followers')
                            .doc(EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userUID))
                            .set({'isFollow': true});
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
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
          child: const Text(
            '購入する',
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
      'description': 'ユーザーID：${EcommerceApp.sharedPreferences.getString(
        EcommerceApp.userUID,
      )}',
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
    //print('完了');

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
