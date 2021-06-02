import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Orders/OrderDetailsPage.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';

String getnotifyID = "";

class TransactionDetailsPage extends StatelessWidget {
  final String notifyID;
  final String imageURL;

  const TransactionDetailsPage({Key key, this.notifyID, this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShippingDetails(notifyID: getnotifyID);
    getnotifyID = notifyID;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Container(
          child: Column(
            children: [
              ListTile(leading: Image.network(imageURL)),
            ],
          ),
        ),
      ),
    );
  }
}
