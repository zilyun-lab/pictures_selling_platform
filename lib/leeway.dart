// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:selling_pictures_platform/Authentication/login.dart';
import '../main.dart';
import 'Models/HEXCOLOR.dart';

class LEEWAY extends StatelessWidget {
  const LEEWAY({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor('E5E2E0'),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(
                  text: '初めまして ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  )),
              TextSpan(
                text: 'LEEWAY',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: HexColor('E67928')),
              ),
              const TextSpan(
                  text: ' 運営です！',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
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
      backgroundColor: HexColor(
        'e5e2df',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(
                        text: '<',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    TextSpan(
                      text: 'LEEWAY',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: HexColor('E67928')),
                    ),
                    const TextSpan(
                        text: 'って？>',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: '　LEEWAY',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: HexColor('E67928'),
                            ),
                          ),
                          const TextSpan(
                            text: 'とは「絵を販売したいひと」と「購入したいひと」とを繋げる架け橋となる場です。'
                                '\nあなたの作品をより多くの人へ。\n運命の一作をあなたの元へ。',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'images/Photos-bro.png',
                      fit: BoxFit.scaleDown,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(
                        text: '<',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    TextSpan(
                      text: 'アーティスト',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: HexColor('E67928')),
                    ),
                    const TextSpan(
                        text: 'の皆様へ>',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: '　LEEWAY',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: HexColor('E67928'),
                            ),
                          ),
                          const TextSpan(
                            text: 'はアーティストの活動を支援しています。'
                                '\nより多くの作品をより多くの方々へ共に届けましょう。\nそして多くの成果も手に入れましょう。',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'images/Makingart-bro.png',
                      fit: BoxFit.scaleDown,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(
                        text: '<',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    TextSpan(
                      text: '購入者',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: HexColor('E67928')),
                    ),
                    const TextSpan(
                        text: 'の皆様へ>',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(
                            text: '　いつも',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w100),
                          ),
                          TextSpan(
                            text: 'LEEWAY',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: HexColor('E67928'),
                            ),
                          ),
                          const TextSpan(
                            text: 'をご利用いただきありがとうございます。',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w100),
                          ),
                          TextSpan(
                            text: '\nLEEWAY',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: HexColor('E67928'),
                            ),
                          ),
                          const TextSpan(
                            text: 'はそんなあなたの「運命の一作」を見つけるお手伝いをさせていただきます。',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'images/Images-bro.png',
                      fit: BoxFit.scaleDown,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
