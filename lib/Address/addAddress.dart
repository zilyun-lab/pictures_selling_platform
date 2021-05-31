import 'package:flutter/services.dart';
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Store/cart.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Widgets/myDrawer.dart';

class AddAddress extends StatefulWidget {
  final String val;
  AddAddress({this.val});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  List<String> items = [
    "北海道",
    "青森県",
    "岩手県",
    "宮城県",
    "秋田県",
    "山形県",
    "福島県",
    "茨城県",
    "栃木県",
    "群馬県",
    "埼玉県",
    "千葉県",
    "東京都",
    "神奈川県",
    "新潟県",
    "富山県",
    "石川県",
    "福井県",
    "山梨県",
    "長野県",
    "岐阜県",
    "静岡県",
    "愛知県",
    "三重県",
    "滋賀県",
    "京都府",
    "大阪府",
    "兵庫県",
    "奈良県",
    "和歌山県",
    "鳥取県",
    "島根県",
    "岡山県",
    "広島県",
    "山口県",
    "徳島県",
    "香川県",
    "愛媛県",
    "高知県",
    "福岡県",
    "佐賀県",
    "長崎県",
    "熊本県",
    "大分県",
    "宮崎県",
    "鹿児島県",
    "沖縄県",
  ];
  String selectedItem = "北海道";
  String holder = "";
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cLastName = TextEditingController();
  final cFirstName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cAddress = TextEditingController();
  final cCity = TextEditingController();
  final cPrefectures = TextEditingController();
  final cPostalCode = TextEditingController();
  void getValue() {
    setState(() {
      holder = selectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("e5e2df"),
        key: scaffoldKey,
        appBar: MyAppBar(),
        //drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //print(selectedItem);
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                lastName: cLastName.text.trim(),
                firstName: cFirstName.text.trim(),
                postalCode: cPostalCode.text,
                prefectures: selectedItem.trim(),
                //prefectures: cPrefectures.text.trim(),
                city: cCity.text.trim(),
                address: cAddress.text,
                phoneNumber: cPhoneNumber.text,
              ).toJson();
              // todo: firestoreに追加
              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .doc(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .doc(DateTime.now().millisecondsSinceEpoch.toString())
                  .set(model)
                  .then((value) {
                final snack = SnackBar(content: Text("新規お届け先を追加しました"));
                scaffoldKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });

              Route route = MaterialPageRoute(builder: (c) => Address());
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text("追加する"),
          backgroundColor: Colors.black,
          icon: Icon(
            Icons.check,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(
                    8.0,
                  ),
                  child: Text(
                    "新しいお届け先を追加する",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      label: "名字",
                      hint: "例) 田中",
                      controller: cLastName,
                    ),
                    MyTextField(
                      label: "名前",
                      hint: "例) 太郎",
                      controller: cFirstName,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(7),
                        ],
                        keyboardType: TextInputType.number,
                        controller: cPostalCode,
                        decoration: InputDecoration(
                          labelText: "郵便番号",
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: "例) 1234567",
                        ),
                        validator: (val) => val.isEmpty ? "未記入の項目があります" : null,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedItem,
                          onChanged: (String newValue) {
                            setState(() {
                              selectedItem = newValue;
                            });
                          },
                          selectedItemBuilder: (context) {
                            return items.map((String item) {
                              return Text(
                                item,
                                style: TextStyle(color: Colors.black),
                              );
                            }).toList();
                          },
                          items: items.map((String item) {
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
                        )),
                    // MyTextField(
                    //   label: "都道府県",
                    //   hint: "例) 北海道",
                    //   controller: cPrefectures,
                    // ),
                    MyTextField(
                      label: "市区町村",
                      hint: "例) 札幌市中央区",
                      controller: cCity,
                    ),
                    MyTextField(
                      label: "番地および任意の建物名",
                      hint: "例) 北１条西2丁目　Leewayビル２階１２３号室",
                      controller: cAddress,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(11),
                        ],
                        keyboardType: TextInputType.number,
                        controller: cPhoneNumber,
                        decoration: InputDecoration(
                          labelText: "電話番号",
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: "例) 09012345678",
                        ),
                        validator: (val) => val.isEmpty ? "未記入の項目があります" : null,
                      ),
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

class MyTextField extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  MyTextField({Key key, this.hint, this.label, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        8,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(
            0.6,
          )),
        ),
        validator: (val) => val.isEmpty ? "未記入の項目があります" : null,
      ),
    );
  }
}

// class SelectBox extends StatefulWidget {
//   const SelectBox({Key key}) : super(key: key);
//
//   @override
//   _SelectBoxState createState() => _SelectBoxState();
// }

// class _SelectBoxState extends State<SelectBox> {
//   List<String> items = [
//     "北海道",
//     "青森県",
//     "岩手県",
//     "宮城県",
//     "秋田県",
//     "山形県",
//     "福島県",
//     "茨城県",
//     "栃木県",
//     "群馬県",
//     "埼玉県",
//     "千葉県",
//     "東京都",
//     "神奈川県",
//     "新潟県",
//     "富山県",
//     "石川県",
//     "福井県",
//     "山梨県",
//     "長野県",
//     "岐阜県",
//     "静岡県",
//     "愛知県",
//     "三重県",
//     "滋賀県",
//     "京都府",
//     "大阪府",
//     "兵庫県",
//     "奈良県",
//     "和歌山県",
//     "鳥取県",
//     "島根県",
//     "岡山県",
//     "広島県",
//     "山口県",
//     "徳島県",
//     "香川県",
//     "愛媛県",
//     "高知県",
//     "福岡県",
//     "佐賀県",
//     "長崎県",
//     "熊本県",
//     "大分県",
//     "宮崎県",
//     "鹿児島県",
//     "沖縄県"
//   ];
//   String selectedItem = "北海道";
//   String holder = "";
//   void getValue() {
//     setState(() {
//       holder = selectedItem;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AddAddress(val: selectedItem);
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DropdownButtonFormField<String>(
//         value: selectedItem,
//         onChanged: (String newValue) {
//           setState(() {
//             selectedItem = newValue;
//             holder = selectedItem;
//           });
//         },
//         selectedItemBuilder: (context) {
//           return items.map((String item) {
//             return Text(
//               item,
//               style: TextStyle(color: Colors.pink),
//             );
//           }).toList();
//         },
//         items: items.map((String item) {
//           return DropdownMenuItem(
//             value: item,
//             child: Text(
//               item,
//               style: item == selectedItem
//                   ? TextStyle(fontWeight: FontWeight.bold)
//                   : TextStyle(fontWeight: FontWeight.normal),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//     // return DropdownButton<String>(
//     //   value: _selectedItem,
//     //   onChanged: (String newValue) {
//     //     setState(() {
//     //       _selectedItem = newValue;
//     //     });
//     //   },
//     //   selectedItemBuilder: (context) {
//     //     return _items.map((String item) {
//     //       return Text(
//     //         item,
//     //         style: TextStyle(color: Colors.pink),
//     //       );
//     //     }).toList();
//     //   },
//     //   items: _items.map((String item) {
//     //     return DropdownMenuItem(
//     //       value: item,
//     //       child: Text(
//     //         item,
//     //         style: item == _selectedItem
//     //             ? TextStyle(fontWeight: FontWeight.bold)
//     //             : TextStyle(fontWeight: FontWeight.normal),
//     //       ),
//     //     );
//     //   }).toList(),
//     // );
//   }
// }
