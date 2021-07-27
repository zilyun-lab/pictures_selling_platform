// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Counters/changeAddresss.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:selling_pictures_platform/Orders/CheckOutPage.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/WidgetOfFirebase.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';

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
                stream: getSecondStreamSnapshots(
                    EcommerceApp.collectionUser,
                    EcommerceApp.sharedPreferences
                        .getString(EcommerceApp.userUID),
                    EcommerceApp.subCollectionAddress),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Neumorphic(
          style: NeumorphicStyle(
            color: Colors.white,
            shadowLightColor: Colors.black.withOpacity(0.2),
            shadowDarkColor: Colors.black.withOpacity(0.6),
          ),
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
                    activeColor: mainColorOfLEEWAY,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: screenwidth * 0.8,
                        child: Table(
                          children: [
                            TableRow(
                                children: addressText(
                                    "氏名",
                                    widget.model.lastName +
                                        widget.model.firstName)),
                            TableRow(
                                children: addressText(
                                    "郵便番号", widget.model.postalCode)),
                            TableRow(
                                children: addressText(
                                    "住所",
                                    widget.model.prefectures +
                                        widget.model.city +
                                        widget.model.address +
                                        widget.model.secondAddress)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
