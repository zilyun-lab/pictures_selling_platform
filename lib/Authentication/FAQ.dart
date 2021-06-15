import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/main.dart';

class FAQ extends StatelessWidget {
  const FAQ({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (c) => MainPage(),
              );
              Navigator.pushReplacement(context, route);
            },
          ),
          backgroundColor: Colors.white,
          title: Text(
            "よくある質問",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ExpansionTile(
              title: Text("Q: 売り上げたお金はいつ振り込まれるの？"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                      "A:売上金の振り込みは毎月15日と30日になっております。\n※該当日が土日祝日の場合は直近の平日に振り込まれます"),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Q: 商品は到着までどれくらいかかるの？"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("A:注文確定後、約1週間程度でお届けいたします。"),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Q: 注文キャンセル、返品は出来るの？"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                      "A:注文キャンセルは注文確定後1時間以内は可能です。お客様都合での返品は受け付けておりません。傷などがあった場合は商品到着後速やかにお問い合わせください"),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Q: 額縁はついているの？"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                      "A:コピー商品には額縁は付属しておりません。原画では商品によって異なる為、商品説明をよく読んでご購入お願いいたします。"),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Q: 配送状況は確認できるの？"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("A:発送時に送るメールの伝票番号から確認することが出来ます"),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Q: 領収書は発行できるの？"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("A:決済完了時にメールにて送らせていただきます。"),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("Q: 出品した絵画をSNSで宣伝していいの？"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("A:SNSでの宣伝は問題ありません。SNSなどで公開し宣伝しましょう。"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
