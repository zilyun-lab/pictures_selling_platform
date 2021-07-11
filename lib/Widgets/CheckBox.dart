import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/allList.dart';

class CheckBoxDialog extends StatefulWidget {
  CheckBoxDialog(
    this.title,
    this.message,
    this.checkBoxCaption, [
    this.positiveCaption,
    this.onPositive,
    this.negativeCaption,
    this.onNegative,
  ]);

  final String title;
  final String message;
  final String checkBoxCaption;
  final String positiveCaption;
  final Function onPositive;
  final String negativeCaption;
  final Function onNegative;

  @override
  CheckBoxDialogState createState() => CheckBoxDialogState();
}

class CheckBoxDialogState extends State<CheckBoxDialog> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(widget.title),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.message),
            ExpansionTile(
              title: Text("出品時の規約について"),
              children: [
                Text(
                  "著作権　許諾の同意"
                  "\n\n本サービス及び本サービスのコンテンツの著作権及び商標権等の知的財産権（以下、「著作権等」といいます）は、当社又は著作権等を有する第三者に帰属するものとします。会員は、当社の書面による事前の承諾がある場合を除き、本サービスのコンテンツを当社又は著作権等を有する第三者の許諾を得ることなく使用することはできません。"
                  "\n会員は、本サービスサイトにデザイン画像をアップロードし、又は、商品データを入力した場合、当社に対して、当該商品データ等を、本サービスにおいて、以下の各号に掲げる方法のいずれかまたはすべてにより、当該商品データ等の全部または一部を無償で利用することを非独占的に許諾する。なお、許諾地域は日本を含むすべての国と地域とし、許諾期間は本サービスの利用契約の有効期間とします。"
                  "\n（１）インターネット、携帯電話その他情報通信ネットワーク、情報誌等含む任意の媒体を利用して、商品データ等の複製、頒布、自動公衆送信（送信可能化を含む）、修正及び改変を行うこと（本サービスサイトに掲載し閲覧させることを含む。）"
                  "\n（２）デザイン画像を商品素材に印刷、加工し、商品として製造すること、及び、これに付随する一切の行為"
                  "\n（３）前号に基づき製造した商品を、第６条第１項の委託を受けて購入者に販売すること"
                  "\n会員は、当社に対し、前項に定める許諾を、当社と提携若しくは協力関係にある第三者に対し再許諾することを許諾するものとします。"
                  "\n本サービスの利用契約の終了に伴い、本条第２項乃至第３項の許諾が終了する場合においても、当該許諾の終了以前に成立した売買契約に関する商品の製造及び販売を目的とする商品データ等の利用の許諾は有効なものとします。",
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: CheckboxListTile(
                value: _isChecked,
                title: Text(
                  widget.checkBoxCaption,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                // チェックボックスを押下すると以下の処理が実行される
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      child: Text(widget.negativeCaption),
                      onPressed: () {
                        Navigator.pop(context);
                        if (widget.onNegative != null) {
                          widget.onNegative();
                        }
                      }),
                  FlatButton(
                      child: Text(widget.positiveCaption),
                      onPressed: _isChecked
                          ? () {
                              Navigator.pop(context);
                              if (widget.onPositive != null) {
                                widget.onPositive();
                              }
                            }
                          : null),
                ],
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
    );
  }
}

class NormalCheckBoxDialog extends StatefulWidget {
  NormalCheckBoxDialog(
    this.title,
    this.message,
    this.checkBoxCaption,
    this.buyerID,
    this.orderID,
    this.postBy,
    this.postByName,
    this.toName,
    this.whoBought,
  );

  final String title;
  final String message;
  final String checkBoxCaption;
  final String buyerID;
  final String orderID;
  final String postBy;
  final String postByName;
  final String toName;
  final String whoBought;

  @override
  NormalCheckBoxDialogState createState() => NormalCheckBoxDialogState();
}

class NormalCheckBoxDialogState extends State<NormalCheckBoxDialog> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  String cancelWhy = "";
  TextEditingController whyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // backgroundColor: HexColor("e5e2df"),
      title: Center(
        child: Text(widget.title),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RadioButtonGroup(
                    labels: cancelReason,
                    onSelected: (String selected) {
                      setState(() {
                        cancelWhy = selected;
                      });
                      print(cancelWhy);
                    },
                  ),
                ),
              ],
            ),
            cancelWhy == "上記以外の理由"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text("理由の詳細(必須)"),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: whyController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : Container(),
            Text(widget.message),
            Container(
              height: 200,
              width: double.maxFinite,
              child: ListView(children: [
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text("返品が必要な場合は、キャンセル申請前に返品を完了してくだささい。"),
                  value: _isChecked1,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked1 = value;
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text("キャンセル後は取引メッセージが利用できなくなります"),
                  value: _isChecked2,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked2 = value;
                    });
                  },
                )
              ]),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      child: Text("キャンセル"),
                      onPressed: () {
                        // Navigator.pop(context);
                        print(widget.postBy);
                        print(widget.orderID);
                        print(widget.buyerID);
                        print(widget.whoBought);
                      }),
                  FlatButton(
                      child: Text("申請する"),
                      onPressed: _isChecked1 && _isChecked2
                          ? () {
                              final refTime =
                                  DateTime.now().millisecondsSinceEpoch;
                              Navigator.pop(context);
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(widget.postBy)
                                  .collection("Notify")
                                  .doc(widget.orderID)
                                  .collection("cancel")
                                  .add({
                                "why": whyController.text,
                                "reason": cancelWhy,
                                "orderID": widget.orderID,
                                "whoCancelRequest": widget.postBy,
                                "CancelRequestName": widget.postByName,
                                "cancelTo": widget.buyerID,
                                "cancelToID": EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID),
                                "cancelTime": refTime,
                              });
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(widget.buyerID)
                                  .collection("orders")
                                  .doc(widget.orderID)
                                  .update({
                                "CancelRequestTo": true,
                              });
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(widget.postBy)
                                  .collection("Notify")
                                  .doc(widget.orderID)
                                  .update({
                                "CancelRequestTo": true,
                              }).whenComplete(() {
                                Fluttertoast.showToast(
                                  msg: "キャンセル申請を送信しました。",
                                  backgroundColor: HexColor("#E67928"),
                                );
                              });
                              FirebaseFirestore.instance
                                  .collection("cancelReport")
                                  .doc(widget.orderID)
                                  .set({
                                "why": whyController.text,
                                "reason": cancelWhy,
                                "orderID": widget.orderID,
                                "whoCancelRequest": widget.postBy,
                                "CancelRequestName": widget.postByName,
                                "cancelTo": EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userName),
                                "cancelToID": EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID),
                                "cancelTime": refTime,
                              }).whenComplete(() {
                                Fluttertoast.showToast(
                                  msg: "キャンセル申請を送信しました。",
                                  backgroundColor: HexColor("#E67928"),
                                );
                              });
                            }
                          : null),
                ],
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
    );
  }
}

class CommonCheckBoxDialog extends StatefulWidget {
  CommonCheckBoxDialog(
    this.title,
    this.message,
    this.checkBoxCaption, [
    this.positiveCaption,
    this.onPositive,
    this.negativeCaption,
    this.onNegative,
  ]);

  final String title;
  final String message;
  final String checkBoxCaption;
  final String positiveCaption;
  final Function onPositive;
  final String negativeCaption;
  final Function onNegative;

  @override
  CommonCheckBoxDialogState createState() => CommonCheckBoxDialogState();
}

class CommonCheckBoxDialogState extends State<CommonCheckBoxDialog> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(widget.title),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(widget.message),
            Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: CheckboxListTile(
                value: _isChecked,
                title: Text(
                  widget.checkBoxCaption,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                // チェックボックスを押下すると以下の処理が実行される
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      child: Text(widget.negativeCaption),
                      onPressed: () {
                        Navigator.pop(context);
                        if (widget.onNegative != null) {
                          widget.onNegative();
                        }
                      }),
                  FlatButton(
                      child: Text(widget.positiveCaption),
                      onPressed: _isChecked
                          ? () {
                              Navigator.pop(context);
                              if (widget.onPositive != null) {
                                widget.onPositive();
                              }
                            }
                          : null),
                ],
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
    );
  }
}
