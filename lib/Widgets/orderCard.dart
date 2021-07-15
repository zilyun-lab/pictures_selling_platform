// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Orders/AdminOrderDetailsPage.dart';
import 'package:selling_pictures_platform/Orders/OrderDetailsPage.dart';
import '../Store/storehome.dart';

int counter = 0;

class OrderCard extends StatelessWidget {
  final int itemCount;
  final int totalPrice;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String speakingToID;
  final String speakingToName;
  final double finalGetProceeds;

  OrderCard(
      {Key key,
      this.data,
      this.itemCount,
      this.orderID,
      this.totalPrice,
      this.speakingToID,
      this.speakingToName,
      this.finalGetProceeds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        if (counter == 0) {
          counter = counter + 1;
          //todo:ここが怪しい
        }
        route = MaterialPageRoute(
            builder: (c) => OrderDetails(
                  finalGetProceeds: finalGetProceeds,
                  orderID: orderID,
                  totalPrice: totalPrice,
                  speakingToName: speakingToName,
                  speakingToID: speakingToID,
                ));
        Navigator.push(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.black,
          height: 90,
          child: ListView.builder(
            itemBuilder: (c, index) {
              ItemModel model = ItemModel.fromJson(data[index].data());
              return sourceOrderInfo(model, context);
            },
            itemCount: itemCount,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }

  Widget sourceOrderInfo(ItemModel model, BuildContext context,
      {Color background}) {
    width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.grey[100],
      height: 90,
      child: Row(
        children: [
          Image.network(
            model.thumbnailUrl,
            height: 100,
            fit: BoxFit.scaleDown,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          model.shortInfo,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          model.longDescription,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1.0),
                          child: Row(
                            children: [
                              Text(
                                "合計金額: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                (totalPrice).toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "円",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AdminOrderCard extends StatelessWidget {
  final int itemCount;
  final int totalPrice;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String speakingToID;
  final String speakingToName;

  AdminOrderCard(
      {Key key,
      this.data,
      this.itemCount,
      this.orderID,
      this.totalPrice,
      this.speakingToID,
      this.speakingToName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        if (counter == 0) {
          counter = counter + 1;
          //todo:ここが怪しい
        }
        route = MaterialPageRoute(
            builder: (c) => AdminOrderDetails(
                  orderID: orderID,
                  totalPrice: totalPrice,
                  speakingToName: speakingToName,
                  speakingToID: speakingToID,
                ));
        Navigator.push(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.black,
          height: 90,
          child: ListView.builder(
            itemBuilder: (c, index) {
              ItemModel model = ItemModel.fromJson(data[index].data());
              return sourceOrderInfo(model, context);
            },
            itemCount: itemCount,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }

  Widget sourceOrderInfo(ItemModel model, BuildContext context,
      {Color background}) {
    width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.grey[100],
      height: 90,
      child: Row(
        children: [
          Image.network(
            model.thumbnailUrl,
            height: 100,
            fit: BoxFit.scaleDown,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          model.shortInfo,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          model.longDescription,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1.0),
                          child: Row(
                            children: [
                              Text(
                                "合計金額: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                (totalPrice).toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "円",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
