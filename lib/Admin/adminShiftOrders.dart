// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:selling_pictures_platform/Admin/adminOrderCard.dart';
// import 'package:selling_pictures_platform/Config/config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:selling_pictures_platform/Widgets/myDrawer.dart';
// import '../Widgets/loadingWidget.dart';
// //import '../Widgets/orderCard.dart';
//
// class AdminShiftOrders extends StatefulWidget {
//   @override
//   _MyOrdersState createState() => _MyOrdersState();
// }
//
// class _MyOrdersState extends State<AdminShiftOrders> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         drawer: MyDrawer(),
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: Colors.black),
//           centerTitle: true,
//           title: Text("購入された商品"),
//           actions: [
//             IconButton(
//                 icon: Icon(
//                   Icons.arrow_drop_down_circle,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   SystemNavigator.pop();
//                 })
//           ],
//         ),
//         body: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection("orders").snapshots(),
//           builder: (c, snapshot) {
//             return snapshot.hasData
//                 ? ListView.builder(
//                     itemCount: snapshot.data.docs.length,
//                     itemBuilder: (c, index) {
//                       return FutureBuilder<QuerySnapshot>(
//                         future: FirebaseFirestore.instance
//                             .collection("items")
//                             .where("shortInfo",
//                                 whereIn: snapshot.data.docs[index]
//                                     .data()[EcommerceApp.productID])
//                             .get(),
//                         builder: (c, snap) {
//                           return snap.hasData
//                               ? AdminOrderCard(
//                                   itemCount: snap.data.docs.length,
//                                   data: snap.data.docs,
//                                   orderID: snapshot.data.docs[index].id,
//                                   orderBy: snapshot.data.docs[index]
//                                       .data()["orderBy"],
//                                   addressID: snapshot.data.docs[index]
//                                       .data()["addressID"],
//                                 )
//                               : Center(
//                                   child: circularProgress(),
//                                 );
//                         },
//                       );
//                     },
//                   )
//                 : Center(
//                     child: circularProgress(),
//                   );
//           },
//         ),
//       ),
//     );
//   }
// }
