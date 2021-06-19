import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Orders/CheckOutPage.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';

import 'package:selling_pictures_platform/Models/address.dart';
import 'package:selling_pictures_platform/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Address extends StatefulWidget {
  final double totalAmount;
  const Address({Key key, this.totalAmount})
      : super(
          key: key,
        );
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "お届け先住所を選択してください",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Consumer<AddressChanger>(
          builder: (context, address, c) {
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
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
                          ? noAddressCard()
                          : ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return AddressCard(
                                  currentIndex: address.counter,
                                  value: index,
                                  model: AddressModel.fromJson(
                                      snapshot.data.docs[index].data()),
                                  addressId: snapshot.data.docs[index].id,
                                );
                              },
                            );
                },
              ),
            );
          },
        ),
      ],

      // drawer: MyDrawer(),
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text("お届け先住所を追加する"),
      //   backgroundColor: Colors.black,
      //   icon: Icon(
      //     Icons.add_business,
      //   ),
      //   onPressed: () {
      //     Route route = MaterialPageRoute(
      //       builder: (c) => AddAddress(),
      //     );
      //     Navigator.pushReplacement(
      //       context,
      //       route,
      //     );
      //   },
      // ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.black.withOpacity(0.3),
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_location,
              color: Colors.black,
            ),
            Text("お届け先住所がありません"),
            Text("お届け先住所を設定してください"),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final int currentIndex;
  final int value;
  AddressCard(
      {Key key, this.model, this.addressId, this.currentIndex, this.value})
      : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    CheckOutPage(V: widget.value);
    double screenwidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(
          context,
          listen: false,
        ).displayResult(widget.value);
      },
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: widget.value,
                  groupValue: widget.currentIndex,
                  onChanged: (val) {
                    Provider.of<AddressChanger>(
                      context,
                      listen: false,
                    ).displayResult(val);
                  },
                  activeColor: Colors.black,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: screenwidth * 0.8,
                      child: Table(
                        children: [
                          // TableRow(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(bottom: 3.0),
                          //       child: KeyText(msg: "名字"),
                          //     ),
                          //     Text(widget.model.lastName),
                          //   ],
                          // ),
                          // TableRow(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(bottom: 3.0),
                          //       child: KeyText(msg: "名前"),
                          //     ),
                          //     Text(widget.model.firstName),
                          //   ],
                          // ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: KeyText(msg: "氏名"),
                              ),
                              Text(widget.model.lastName +
                                  widget.model.firstName),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: KeyText(msg: "郵便番号"),
                              ),
                              Text(widget.model.postalCode),
                            ],
                          ),
                          // TableRow(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(bottom: 3.0),
                          //       child: KeyText(msg: "都道府県"),
                          //     ),
                          //     Text(widget.model.prefectures),
                          //   ],
                          // ),
                          // TableRow(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(bottom: 3.0),
                          //       child: KeyText(msg: "市区町村"),
                          //     ),
                          //     Text(widget.model.city),
                          //   ],
                          // ),
                          // TableRow(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(bottom: 3.0),
                          //       child: KeyText(msg: "番地および\n任意の建物名"),
                          //     ),
                          //     Text(widget.model.address),
                          //   ],
                          // ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: KeyText(msg: "住所"),
                              ),
                              Text(widget.model.prefectures +
                                  widget.model.city +
                                  widget.model.address),
                            ],
                          ),
                          // TableRow(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(bottom: 3.0),
                          //       child: KeyText(msg: "電話番号"),
                          //     ),
                          //     Text(widget.model.phoneNumber),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // widget.value == Provider.of<AddressChanger>(context).counter
            //     ? WideButton(
            //         message: "決済ページへ",
            //         onPressed: () {
            //           Route route = MaterialPageRoute(
            //               builder: (c) => PaymentPage(
            //                  addressId: widget.addressId,
            //                     totalAmount: widget.totalAmount,
            //                   ));
            //           Navigator.push(context, route);
            //         },
            //       )
            //     : Container(),
          ],
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;
  KeyText({Key key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
