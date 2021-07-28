// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Orders/AdminOrderDetailsPage.dart';
import 'package:selling_pictures_platform/Orders/OrderDetailsPage.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import '../Store/storehome.dart';

int counter = 0;

class OrderCard extends StatelessWidget {
  final int itemCount;
  final int totalPrice;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String speakingToID;
  final String speakingToName;
  final int finalGetProceeds;

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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Neumorphic(
        style: NeumorphicStyle(color: bgColor),
        child: ListTile(
          trailing: Icon(
            Icons.arrow_forward_ios_outlined,
            color: mainColorOfLEEWAY,
          ),
          leading: Container(
            child: Image.network(
              model.thumbnailUrl,
              height: 50,
              width: 75,
              fit: BoxFit.scaleDown,
            ),
          ),
          title: Expanded(
            child: Text(
              model.shortInfo,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          subtitle: Row(
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
        ),
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Neumorphic(
        style: NeumorphicStyle(color: bgColor),
        child: ListTile(
          trailing: Icon(
            Icons.arrow_forward_ios_outlined,
            color: mainColorOfLEEWAY,
          ),
          leading: Container(
            child: Image.network(
              model.thumbnailUrl,
              height: 50,
              width: 75,
              fit: BoxFit.scaleDown,
            ),
          ),
          title: Expanded(
            child: Text(
              model.shortInfo,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          subtitle: Row(
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
        ),
      ),
    );
  }
}
