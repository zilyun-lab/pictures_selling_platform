import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/myDrawer.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:http/http.dart' as http;

class StripeCheckOut extends StatelessWidget {
  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final formKey = new GlobalKey<FormState>();
  final card = new StripeCard();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StripeCheckOutPage(),
    );
  }
}

class StripeCheckOutPage extends StatefulWidget {
  //MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _StripeCheckOutPageState createState() => _StripeCheckOutPageState();
}

class _StripeCheckOutPageState extends State<StripeCheckOutPage> {
  final formKey = GlobalKey<FormState>();
  final card = new StripeCard();
  final url = "http://localhost:8888/sample_stripe";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardForm(card: card, formKey: formKey),
                ElevatedButton(
                  child: Text("決済する"),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();

                      final CreditCard _creditCard = CreditCard(
                        number: card.number,
                        expMonth: card.expMonth,
                        expYear: card.expYear,
                      );
                      final token = await StripePayment.createTokenWithCard(
                        _creditCard,
                      );
                      print(token);
                      // final res = await http.post(
                      //     Uri.parse(
                      //       url,
                      //     ),
                      //     body: {
                      //       "stripeToken": token,
                      //     });
                    } else {
                      print('処理が通りませんでした。');
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}