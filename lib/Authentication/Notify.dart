import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';

class Notify extends StatefulWidget {
  const Notify({Key key}) : super(key: key);

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
            .collection("Notify")
            .snapshots(),
        builder: (context, snap) {
          return ListView.builder(
              itemCount: snap.data.docs.length,
              itemBuilder: (cotext, index) {
                return Card(
                  color: HexColor("#E67928"),
                  elevation: 0,
                  child: ListTile(
                    title: Text(snap.data.docs[index]["NotifyMessage"]),
                  ),
                );
              });
        },
      ),
    );
  }
}
