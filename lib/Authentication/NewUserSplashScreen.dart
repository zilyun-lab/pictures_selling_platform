// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'SubmitBirthDay.dart';

class NewUserSplashScreen extends StatelessWidget {
  const NewUserSplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Route route = MaterialPageRoute(builder: (c) => SubmitGender());
          Navigator.pushReplacement(context, route);
        },
        label: Text("次へ"),
        backgroundColor: HexColor("#E67928"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/isColor_Vertical.png",
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "ご登録いただきありがとうございます！",
              style: TextStyle(
                  color: HexColor("#E67928"),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "これより簡単なアンケートにお答えいただきます。",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
