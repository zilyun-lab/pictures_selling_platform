import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
