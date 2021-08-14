// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_date_picker/dropdown_date_picker.dart';

// Project imports:
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:selling_pictures_platform/main.dart';

String getGender = '';
String getYear = '';
String getMonth = '';
String getDay = '';

class SubmitGender extends StatefulWidget {
  const SubmitGender({Key key}) : super(key: key);

  @override
  State<SubmitGender> createState() => _SubmitGenderState();
}

class _SubmitGenderState extends State<SubmitGender> {
  String selectGender = '未選択';

  void _handleRadioButton(String gender) => setState(() {
        selectGender = gender;
        getGender = gender;
        print(getGender);
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => SubmitBirthDay()));
        },
        label: Text('次へ'),
        backgroundColor: HexColor('#E67928'),
      ),
      body: Material(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        'あなたの性別は：$selectGender',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: <Widget>[
                            Radio(
                              activeColor: Colors.blueAccent,
                              value: '男性',
                              groupValue: selectGender,
                              onChanged: _handleRadioButton,
                            ),
                            const Text('男性'),
                            Row(
                              children: <Widget>[
                                Radio(
                                  activeColor: Colors.blueAccent,
                                  value: '女性',
                                  groupValue: selectGender,
                                  onChanged: _handleRadioButton,
                                ),
                                const Text(
                                  '女性',
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  activeColor: Colors.blueAccent,
                                  value: 'その他',
                                  groupValue: selectGender,
                                  onChanged: _handleRadioButton,
                                ),
                                const Text('その他'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmitBirthDay extends StatefulWidget {
  const SubmitBirthDay({Key key}) : super(key: key);

  @override
  _SubmitState createState() => _SubmitState();
}

class _SubmitState extends State<SubmitBirthDay> {
  String _year = '1940';
  String _month = '1';
  String _day = '1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: 'hero1',
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => const SubmitGender()));
              },
              label: const Text('戻る'),
              backgroundColor: HexColor('#E67928'),
            ),
            getYear != '' && getMonth != '' && getDay != ''
                ? FloatingActionButton.extended(
                    heroTag: 'hero2',
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const SubmitResult()));
                    },
                    label: const Text('次へ'),
                    backgroundColor: HexColor('#E67928'),
                  )
                : FloatingActionButton.extended(
                    heroTag: 'hero3',
                    onPressed: () {},
                    label: const Text('次へ'),
                    backgroundColor: Colors.grey,
                  ),
          ],
        ),
      ),
      body: Material(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('あなたの生年月日は：',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    getYear != ''
                        ? Text('$getYear年',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))
                        : const Text('？年',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                    getMonth != ''
                        ? Text('$getMonth月',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))
                        : const Text('？月',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                    getDay != ''
                        ? Text('$getDay日',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))
                        : const Text('？日',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            isExpanded: true,
                            value: _year,
                            onChanged: (String newValue) {
                              setState(() {
                                _year = newValue;
                                getYear = _year;
                                print(
                                  _year,
                                );
                                print(getYear);
                              });
                            },
                            selectedItemBuilder: (context) {
                              return year.map((String item) {
                                return Text(
                                  item,
                                  style: const TextStyle(color: Colors.black),
                                );
                              }).toList();
                            },
                            items: year.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: item == _year
                                      ? const TextStyle(fontWeight: FontWeight.bold)
                                      : const TextStyle(
                                          fontWeight: FontWeight.normal),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            isExpanded: true,
                            value: _month,
                            onChanged: (String newValue) {
                              setState(() {
                                _month = newValue;
                                getMonth = _month;
                                print(
                                  _month,
                                );
                                print(getMonth);
                              });
                            },
                            selectedItemBuilder: (context) {
                              return month.map((String item) {
                                return Text(
                                  item,
                                  style: const TextStyle(color: Colors.black),
                                );
                              }).toList();
                            },
                            items: month.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: item == _month
                                      ? const TextStyle(fontWeight: FontWeight.bold)
                                      : const TextStyle(
                                          fontWeight: FontWeight.normal),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            isExpanded: true,
                            value: _day,
                            onChanged: (String newValue) {
                              setState(() {
                                _day = newValue;
                                getDay = _day;
                                print(
                                  _day,
                                );
                                print(getDay);
                              });
                            },
                            selectedItemBuilder: (context) {
                              return day.map((String item) {
                                return Text(
                                  item,
                                  style: const TextStyle(color: Colors.black),
                                );
                              }).toList();
                            },
                            items: day.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: item == _day
                                      ? const TextStyle(fontWeight: FontWeight.bold)
                                      : const TextStyle(
                                          fontWeight: FontWeight.normal),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitResult extends StatefulWidget {
  const SubmitResult({Key key}) : super(key: key);

  @override
  State<SubmitResult> createState() => _SubmitResultState();
}

class _SubmitResultState extends State<SubmitResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => const SubmitGender()));
              },
              label: const Text('戻る'),
              heroTag: 'hero1',
              backgroundColor: HexColor('#E67928'),
            ),
            getYear != '' && getMonth != '' && getDay != ''
                ? FloatingActionButton.extended(
                    onPressed: () {
                      SaveToFb();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const ThankYou()));
                      setState(() {
                        getYear = '';
                        getMonth = '';
                        getDay = '';
                      });
                    },
                    label: const Text('完了する'),
                    heroTag: 'hero2',
                    backgroundColor: HexColor('#E67928'),
                  )
                : FloatingActionButton.extended(
                    heroTag: 'hero3',
                    onPressed: () {},
                    label: const Text('完了する'),
                    backgroundColor: Colors.grey,
                  ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '下記の事項でお間違いありませんか？',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                const Text(
                  'お間違い無ければ完了するを押してください。',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    const Text(
                      '性別：',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      getGender,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ],
                ),
                getYear != '' && getMonth != '' && getDay != ''
                    ? Row(
                        children: [
                          const Text(
                            '生年月日：',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            '${'$getYear年'}${'$getMonth月'}${'$getDay日'}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ],
                      )
                    : const Text('生年月日を選択してください。',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ThankYou extends StatefulWidget {
  const ThankYou({Key key}) : super(key: key);

  @override
  State<ThankYou> createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  dynamic displaySplash() {
    //todo:Timerは何秒後に何をするか
    Timer(
      const Duration(
        seconds: 3,
      ),
      () async {
        await Navigator.push(context, MaterialPageRoute(builder: (c) => MainPage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text('ご協力ありがとうございました。\n ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(
                        text: '引き続き ',
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
                        text: ' をお楽しみ下さい',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

dynamic SaveToFb() {
  FirebaseFirestore.instance
      .collection('users')
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update({
    'gender': getGender,
    'Birth': '$getYear年$getMonth月$getDay日'
  });
}
