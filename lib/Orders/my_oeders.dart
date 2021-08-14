// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/main.dart';
import '../Widgets/loading_widget.dart';
import '../Widgets/order_card.dart';

class MyOrders extends StatefulWidget {
  final String name;
  final String id;
  final int finalGetProceeds;

  const MyOrders({Key key, this.name, this.id, this.finalGetProceeds})
      : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,
        title: const Text(
          '注文履歴',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: EcommerceApp.firestore
            .collection(EcommerceApp.collectionUser)
            .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
            .collection(EcommerceApp.collectionOrders)
            .orderBy(
              'orderTime',
              descending: true,
            )
            .snapshots(),
        builder: (c, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (c, index) {
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('items')
                          .where('shortInfo',
                              isEqualTo: snapshot.data.docs[index]
                                  ['productIDs'])
                          .get(),
                      builder: (c, snap) {
                        return snap.hasData
                            ? OrderCard(
                                finalGetProceeds: widget.finalGetProceeds,
                                totalPrice: snapshot.data.docs[index]
                                    ['totalPrice'],
                                itemCount: snap.data.docs.length,
                                data: snap.data.docs,
                                orderID: snapshot.data.docs[index].id,
                                speakingToID: widget.id,
                                speakingToName: widget.name,
                              )
                            : Center(
                                child: circular_progress(),
                              );
                      },
                    );
                  },
                )
              : Center(
                  child: circular_progress(),
                );
        },
      ),
    );
  }
}
