import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Models/PrivacyPolicyAndTermsText.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key key}) : super(key: key);

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
              builder: (c) => MyPage(),
            );
            Navigator.pushReplacement(context, route);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "規約等",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: Text("利用規約"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(termsText),
                )
              ],
            ),
            ExpansionTile(
              title: Text("特定商取引法に基づく表記"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(specifiedCommercialTransactionLaw),
                )
              ],
            ),
            ExpansionTile(
              title: Text("個人情報保護方針（個人情報保護ポリシー）"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(personalInformationProtectionLaw),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
