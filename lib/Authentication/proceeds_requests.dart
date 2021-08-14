// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/check_box.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:selling_pictures_platform/Authentication/my_page.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/allList.dart';

class ProceedsRequests extends StatefulWidget {
  const ProceedsRequests({Key key, this.myProceeds}) : super(key: key);
  final int myProceeds;

  @override
  _ProceedsRequestsState createState() => _ProceedsRequestsState();
}

class _ProceedsRequestsState extends State<ProceedsRequests> {
  TextEditingController priceController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController shitenController = TextEditingController();
  TextEditingController bankAccountController = TextEditingController();

  String selectedItem = 'みずほ銀行';
  String holder = '';
  int proceeds;

  Future<Map<String, dynamic>> getProceeds() async {
    final DocumentSnapshot qSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection('MyProceeds')
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .get();

    return qSnapshot.data();

    // proceeds = qSnapshot.data()['Proceeds'].toInt();
    // print(proceeds);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getProceeds();
  }

  void getValue() {
    setState(() {
      holder = selectedItem;
    });
  }

  String requestPrice = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  '戻る',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            )),
        backgroundColor: Colors.white,
        title: const Text(
          '売上振り込み申請',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textFieldOfHereWithText(lastNameController, 'タナカ', '口座名義(セイ)'),
              textFieldOfHereWithText(firstNameController, 'タロウ', '口座名義(メイ)'),
              Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedItem,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedItem = newValue;
                    });
                  },
                  selectedItemBuilder: (context) {
                    return bankList.map((String item) {
                      return Text(
                        item,
                        style: const TextStyle(color: Colors.black),
                      );
                    }).toList();
                  },
                  items: bankList.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: item == selectedItem
                            ? const TextStyle(fontWeight: FontWeight.bold)
                            : const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    );
                  }).toList(),
                ),
              ),
              textFieldOfHereWithNumber(shitenController, 3, '支店コード', '支店コード'),
              textFieldOfHereWithNumber(
                  bankAccountController, 7, '口座番号', '口座番号'),
              FutureBuilder(
                future: getProceeds(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        onChanged: (String v) {
                          setState(() {
                            requestPrice = v;
                          });
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(8),
                        ],
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        decoration: InputDecoration(
                          hintText: 'ご希望の申請金額を入力してください',
                          labelText:
                              'ご希望の申請金額(申請可能金額：${snapshot.data['Proceeds']}円)',
                        ),
                      ),
                    );
                  } else {
                    return const Text('データが存在しません');
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: '振り込み手数料(200円)は申請者負担となります。',
                      ),
                    ],
                  ),
                ),
              ),
              mySizedBox(20),
              requestPrice != '0' &&
                      int.parse(
                            requestPrice ?? '0',
                          ) >=
                          proceeds
                  ? Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey, //ボタンの背景色
                        ),
                        onPressed: () {},
                        child: const Text('確定する'),
                      ),
                    )
                  : Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, //ボタンの背景色
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return CommonCheckBoxDialog(
                                    '最終確認',
                                    '下記の入力情報に\nお間違いありませんか？\n',
                                    '確認しました。',
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '口座名義：${lastNameController.text} ${firstNameController.text}'),
                                            Text('銀行名：　$selectedItem'),
                                            Text(
                                                '支店番号：${shitenController.text}'),
                                            Text(
                                                '口座番号：${bankAccountController.text}'),
                                            Text(
                                                '申請金額：${priceController.text} 円')
                                          ],
                                        ),
                                      ),
                                    ),
                                    'OK',
                                    () {
                                      FirebaseFirestore.instance
                                          .collection('requestProceeds')
                                          .doc(EcommerceApp.sharedPreferences
                                              .getString(EcommerceApp.userUID))
                                          .set({
                                        'email': EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp.userEmail),
                                        'requestProceeds': priceController.text,
                                        'requestUser': EcommerceApp
                                            .sharedPreferences
                                            .getString(EcommerceApp.userName),
                                        'requestUserID': EcommerceApp
                                            .sharedPreferences
                                            .getString(EcommerceApp.userUID),
                                        'userBankName': selectedItem,
                                        'userBankSecondName':
                                            shitenController.text,
                                        'userBankNumber':
                                            bankAccountController.text,
                                        'lastName': lastNameController.text,
                                        'firstName': firstNameController.text,
                                      });
                                      Fluttertoast.showToast(
                                        msg:
                                            '売り上げ申請行いました。売り上げ申請行いました。\n運営からのお知らせをお待ち下さい。',
                                        backgroundColor: Colors.lightBlueAccent,
                                      );
                                      Navigator.pop(context);
                                    },
                                    'キャンセル',
                                    () {
                                      Navigator.pop(context);
                                    });
                              });
                        },
                        child: const Text('確認へ進む'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMailApp() async {
    final title = Uri.encodeComponent(
      '${lastNameController.text} ${firstNameController.text}様より売り上げの振り込み申請が届きました。',
    );
    final body = Uri.encodeComponent(
      '氏名： ${lastNameController.text} ${firstNameController.text}\n銀行名：${selectedItem.trim()}\n支店コード：${shitenController.text}\n口座番号：${bankAccountController.text}\n申請金額：${priceController.text}円\nユーザーID：${EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail)}',
    );
    const mailAddress = 'zilyunya.take@gmail.com';

    return _launchURL(
      'mailto:$mailAddress?subject=$title&body=$body',
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final Error error = ArgumentError('Could not launch $url');
      throw error;
    }
  }
}

Widget textFieldOfHereWithNumber(
  TextEditingController controller,
  int length,
  String hint,
  String label,
) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
      ),
    ),
  );
}

Widget textFieldOfHereWithText(
    TextEditingController controller, String hint, String label) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
      ),
    ),
  );
}
