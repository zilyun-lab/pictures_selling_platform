import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:url_launcher/url_launcher.dart';

class ProceedsRequests extends StatefulWidget {
  const ProceedsRequests({Key key}) : super(key: key);

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

  String selectedItem = "みずほ銀行";
  String holder = "";

  void getValue() {
    setState(() {
      holder = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (c) => MyPage(),
              );
              Navigator.pushReplacement(
                context,
                route,
              );
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "戻る",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            )),
        backgroundColor: Colors.white,
        title: Text(
          "売上振り込み申請",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFieldOfHereWithText(lastNameController, 'タナカ', "口座名義(セイ)"),
                textFieldOfHereWithText(firstNameController, 'タロウ', "口座名義(メイ)"),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Expanded(
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
                            style: TextStyle(color: Colors.black),
                          );
                        }).toList();
                      },
                      items: bankList.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: item == selectedItem
                                ? TextStyle(fontWeight: FontWeight.bold)
                                : TextStyle(fontWeight: FontWeight.normal),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                textFieldOfHereWithNumber(
                    shitenController, 3, '支店コード', '支店コード'),
                textFieldOfHereWithNumber(
                    bankAccountController, 7, '口座番号', '口座番号'),
                textFieldOfHereWithNumber(
                    priceController, 8, 'ご希望の申請金額を入力してください', 'ご希望の申請金額'),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, //ボタンの背景色
                  ),
                  child: Text(''
                      '確定する'),
                  onPressed: _openMailApp,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
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
    padding: const EdgeInsets.all(12.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
      ),
    ),
  );
}
