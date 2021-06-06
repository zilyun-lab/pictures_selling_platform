import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';

class SearchAddress extends StatefulWidget {
  @override
  _SearchAddressState createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  final zipCodeController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      child: Text(
                        '郵便番号',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      width: 90),
                  Expanded(
                    child: TextFormField(
                      maxLines: 1,
                      controller: zipCodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '郵便番号',
                        suffixIcon: IconButton(
                          highlightColor: Colors.transparent,
                          icon: Container(
                              width: 36.0, child: new Icon(Icons.clear)),
                          onPressed: () {
                            zipCodeController.clear();
                            addressController.clear();
                          },
                          splashColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  OutlineButton(
                    child: Text('検索'),
                    onPressed: () async {
                      var result = await get(Uri.parse(
                          'https://zipcloud.ibsnet.co.jp/api/search?zipcode=${zipCodeController.text}'));
                      Map<String, dynamic> map =
                          jsonDecode(result.body)['results'][0];
                      addressController.text =
                          '${map['address1']}${map['address2']}${map['address3']}';
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              Row(
                children: [
                  Container(
                    child: Text('住所', style: TextStyle(fontSize: 18.0)),
                    width: 90,
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLines: 1,
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: '住所',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
