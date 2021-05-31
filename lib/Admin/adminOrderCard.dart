// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:selling_pictures_platform/Admin/adminOrderDetails.dart';
// import 'package:selling_pictures_platform/Models/item.dart';
// import 'package:flutter/material.dart';
// import 'package:selling_pictures_platform/Widgets/orderCard.dart';
//
// //import '../Store/storehome.dart';
//
// int counter = 0;
//
// class AdminOrderCard extends StatelessWidget {
//   final int itemCount;
//   final List<DocumentSnapshot> data;
//   final String orderID;
//   final String addressID;
//   final String orderBy;
//
//   AdminOrderCard(
//       {Key key,
//       this.itemCount,
//       this.data,
//       this.orderID,
//       this.orderBy,
//       this.addressID})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Route route;
//         if (counter == 0) {
//           counter = counter + 1;
//           //todo:ここが怪しい
//           // route =
//           //     MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID));
//
//         }
//         route = MaterialPageRoute(
//             builder: (c) => AdminOrderDetails(
//                   orderID: orderID,
//                   orderBy: orderBy,
//                   addressID: addressID,
//                 ));
//         Navigator.push(context, route);
//       },
//       child: Container(
//         padding: EdgeInsets.all(10),
//         margin: EdgeInsets.all(10),
//         height: itemCount * 190.0,
//         child: ListView.builder(
//           itemBuilder: (c, index) {
//             ItemModel model = ItemModel.fromJson(data[index].data());
//             return sourceOrderInfo(model, context);
//           },
//           itemCount: itemCount,
//           physics: NeverScrollableScrollPhysics(),
//         ),
//       ),
//     );
//   }
// }
