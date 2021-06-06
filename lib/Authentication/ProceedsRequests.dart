import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Config/config.dart';
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
  List<String> bankList = [
    "みずほ銀行",
    "三菱UFJ銀行",
    "三井住友銀行",
    "りそな銀行",
    "埼玉りそな銀行",
    "セブン銀行",
    "北海道銀行",
    "青森銀行",
    "みちのく銀行",
    "秋田銀行",
    "北都銀行",
    "荘内銀行",
    "山形銀行",
    "岩手銀行",
    "東北銀行",
    "七十七銀行",
    "東邦銀行",
    "群馬銀行",
    "足利銀行",
    "常陽銀行",
    "筑波銀行",
    "武蔵野銀行",
    "千葉銀行",
    "千葉興業銀行",
    "きらぼし銀行",
    "横浜銀行",
    "第四北越銀行",
    "山梨中央銀行",
    "八十二銀行",
    "北陸銀行",
    "富山銀行",
    "北國銀行",
    "福井銀行",
    "静岡銀行",
    "スルガ銀行",
    "清水銀行",
    "大垣共立銀行",
    "十六銀行",
    "三十三銀行",
    "百五銀行",
    "滋賀銀行",
    "京都銀行",
    "関西みらい銀行",
    "池田泉州銀行",
    "南都銀行",
    "紀陽銀行",
    "但馬銀行",
    "鳥取銀行",
    "山陰合同銀行",
    "中国銀行",
    "広島銀行",
    "山口銀行",
    "阿波銀行",
    "百十四銀行",
    "伊予銀行",
    "四国銀行",
    "福岡銀行",
    "筑邦銀行",
    "佐賀銀行",
    "十八親和銀行",
    "肥後銀行",
    "大分銀行",
    "宮崎銀行",
    "鹿児島銀行",
    "琉球銀行",
    "沖縄銀行",
    "西日本シティ銀行",
    "北九州銀行",
    "三菱ＵＦＪ信託銀行",
    "みずほ信託銀行",
    "三井住友信託銀行",
    "野村信託銀行",
    "新生銀行",
    "あおぞら銀行",
    "シティバンク、エヌ・エイ",
    "ジェー・ピー・モルガン・チェース・バンク・ナショナル・アソシエーション",
    "北洋銀行",
    "きらやか銀行",
    "北日本銀行",
    "仙台銀行",
    "福島銀行",
    "大東銀行",
    "東和銀行",
    "栃木銀行",
    "京葉銀行",
    "東日本銀行",
    "東京スター銀行",
    "神奈川銀行",
    "大光銀行",
    "長野銀行",
    "富山第一銀行",
    "福邦銀行",
    "静岡中央銀行",
    "愛知銀行",
    "名古屋銀行",
    "中京銀行",
    "みなと銀行",
    "島根銀行",
    "トマト銀行",
    "もみじ銀行",
    "西京銀行",
    "徳島大正銀行",
    "香川銀行",
    "愛媛銀行",
    "高知銀行",
    "福岡中央銀行",
    "佐賀共栄銀行",
    "長崎銀行",
    "熊本銀行",
    "豊和銀行",
    "宮崎太陽銀行",
    "南日本銀行",
    "沖縄海邦銀行",
    "農林中央金庫",
    "イオン銀行",
    "ローソン銀行",
    "SMBC信託銀行",
    "ハナ銀行",
    "ブラジル銀行",
    "ユバフーアラブ・フランス連合銀行",
    "SBJ銀行",
    "中国工商銀行",
  ];
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
              child: Text(
                "戻る",
                style: TextStyle(color: Colors.black, fontSize: 20),
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
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      hintText: 'タナカ',
                      labelText: "口座名義(セイ)",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      hintText: 'タロウ',
                      labelText: "口座名義(メイ)",
                    ),
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    keyboardType: TextInputType.number,
                    controller: shitenController,
                    decoration: InputDecoration(
                      hintText: '支店コード',
                      labelText: "支店コード",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(7),
                    ],
                    keyboardType: TextInputType.number,
                    controller: bankAccountController,
                    decoration: InputDecoration(
                      hintText: '口座番号',
                      labelText: "口座番号",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                    ],
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration: InputDecoration(
                      hintText: 'ご希望の申請金額を入力してください。',
                      labelText: 'ご希望の申請金額',
                    ),
                  ),
                ),
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
