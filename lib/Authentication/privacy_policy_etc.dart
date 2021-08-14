// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// Project imports:
import 'package:selling_pictures_platform/Authentication/my_page.dart';
import 'package:selling_pictures_platform/Models/privacy_policy_and_terms_text.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
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
        title: const Text(
          '規約等',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w100),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Neumorphic(
                style: NeumorphicStyle(color: bgColor),
                child: const ExpansionTile(
                  textColor: Colors.black87,
                  title: Text('利用規約'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(termsText),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Neumorphic(
                style: NeumorphicStyle(color: bgColor),
                child: const ExpansionTile(
                  textColor: Colors.black87,
                  title: Text('特定商取引法に基づく表記'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(specifiedCommercialTransactionLaw),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Neumorphic(
                style: NeumorphicStyle(color: bgColor),
                child: const ExpansionTile(
                  textColor: Colors.black87,
                  title: Text('個人情報保護方針（個人情報保護ポリシー）'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(personalInformationProtectionLaw),
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
