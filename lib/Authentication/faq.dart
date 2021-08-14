// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';

// Project imports:
import 'package:selling_pictures_platform/main.dart';

class FAQ extends StatelessWidget {
  const FAQ({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
        ),
        backgroundColor: bgColor,
        title: const Text(
          'よくある質問',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            myET(
              const Text('Q: 売り上げたお金はいつ振り込まれるの？'),
              const Text(
                  'A:売上金の振り込みは毎月15日と30日になっております。\n※該当日が土日祝日の場合は直近の平日に振り込まれます　　　　　　　'),
            ),
            myET(
              const Text('Q: 商品は到着までどれくらいかかるの？'),
              const Text('A:注文確定後、約1週間程度でお届けいたします。　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　'),
            ),
            myET(
              const Text('Q: 注文キャンセル、返品は出来るの？'),
              const Text(
                  'A:注文キャンセルは注文確定後1時間以内は可能です。お客様都合での返品は受け付けておりません。傷などがあった場合は商品到着後速やかにお問い合わせください'),
            ),
            myET(
              const Text('Q: 額縁はついているの？'),
              const Text(
                  'A:コピー商品には額縁は付属しておりません。原画では商品によって異なる為、商品説明をよく読んでご購入お願いいたします。'),
            ),
            myET(
              const Text('Q: 配送状況は確認できるの？'),
              const Text('A:発送時に送るメールの伝票番号から確認することが出来ます。'),
            ),
            myET(
              const Text('Q: 領収書は発行できるの？'),
              const Text('A:決済完了時にメールにて送らせていただきます。　　　　　　　　'),
            ),
            myET(
              const Text('Q: 出品した絵画をSNSで宣伝していいの？'),
              const Text('A:SNSでの宣伝は問題ありません。SNSなどで公開し宣伝しましょう。'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Padding myET(Widget q, Widget a) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Neumorphic(
        style: NeumorphicStyle(color: bgColor),
        child: ExpansionTile(
          textColor: Colors.black87,
          title: q,
          children: [
            Padding(padding: const EdgeInsets.all(15), child: a),
          ],
        ),
      ),
    );
  }
}
