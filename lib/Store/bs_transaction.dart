// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import '../main.dart';

class BSTransaction extends StatelessWidget {
  const BSTransaction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor('E5E2E0'),
        title: const Text(
          '取引の流れ',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            final Route route = MaterialPageRoute(
              builder: (c) => MainPage(),
            );
            Navigator.pushReplacement(
              context,
              route,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                const Text(
                  '出品(出品者)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  'images/Listing.png',
                  height: 250,
                ),
                const Text(
                  'スマホで作品の写真を撮り\n出品してみよう！',
                  //style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: HexColor('E5E2E0'),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Text(
                      '購入(購入者)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Image.asset(
                      'images/Credit_card-cuate.png',
                      height: 250,
                    ),
                    const Text(
                      'とってもいい作品を見つけた！\n購入してみよう！',
                      //style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                const Text(
                  'お届け',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  'images/Delivery-amico.png',
                  height: 250,
                ),
                const Text(
                  '弊社が責任を持って\n最速でお届けいたします。',
                  //style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: HexColor('E5E2E0'),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Text(
                      '受け取り/取引完了(購入者)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Image.asset(
                      'images/Delivery-rafiki.png',
                      height: 250,
                    ),
                    const Text(
                      'お届け目安としては\n一週間ほどでお届けいたします。\n受け取りましたら\n受け取り完了の手続きを\nお願いします。\n受け取り確認を終えると取引完了です',
                      //style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Column(
                children: [
                  const Text(
                    '取引完了(出品者)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    'images/Revenue-cuate.png',
                    height: 250,
                  ),
                  const Text(
                    'お客様が受け取り確認を終えますと\n取引完了です。\n出品者の方には販売価格の６割が\n売り上げとして付与されます。',
                    //style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
