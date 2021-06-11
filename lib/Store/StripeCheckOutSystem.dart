// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:selling_pictures_platform/Models/GetLikeItemsModel.dart';
// import 'package:selling_pictures_platform/Models/UploadItemModel.dart';
// import 'package:selling_pictures_platform/Store/storehome.dart';
// import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
//
// class TestPage extends StatelessWidget {
//   const TestPage({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: MyAppBar(),
//         body: ChangeNotifierProvider<GetLikeItemsModel>(
//           create: (_) => GetLikeItemsModel()..fetchItems(),
//           child: Consumer<GetLikeItemsModel>(builder: (context, model, child) {
//             final items = model.items;
//             final listTiles = items
//                 .map((item) => ListTile(
//                       leading: Image.network(item.thumbnailUrl),
//                       title: Text(item.shortInfo.toString()),
//                       trailing: IconButton(
//                         color: Colors.black,
//                         icon: Icon(Icons.delete),
//                         onPressed: () =>
//                             removeItemFromLike(item.shortInfo, context),
//                       ),
//                     ))
//                 .toList();
//             return ListView(
//               children: listTiles,
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:selling_pictures_platform/Store/storehome.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:stripe_payment/stripe_payment.dart';

/// 決済の結果
class StripeTransactionResponse {
  StripeTransactionResponse({
    @required this.message,
    @required this.success,
  });

  String message;
  bool success;
}

class StripeService {
  final int price;

  StripeService({this.price});

  /// pay via new card
  Future<StripeTransactionResponse> payViaNewCard() async {
    initialize();
    // create payment method
    final paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    );
    // StripePayment.createSourceWithParams(options);
    final paymentIntent = await createPaymentIntent();
    final confirmResult =
        await confirmPaymentIntent(paymentIntent, paymentMethod);
    return handlePaymentResult(confirmResult);
  }

  /// pay via existing card
  Future<StripeTransactionResponse> payViaExistingCard(
      CreditCard creditCard) async {
    initialize();
    final paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(card: creditCard),
    );
    final paymentIntent = await createPaymentIntent();
    final confirmResult =
        await confirmPaymentIntent(paymentIntent, paymentMethod);
    return handlePaymentResult(confirmResult);
  }

  /// initialize stripe
  void initialize() {
    const publishableKey =
        'pk_test_51IsmpSBqhjcHw6SAXESFpB4deZcO28ciMAhsejnDQU2TLBX8eu3ud6LLIzIaOXFCZqn3BulpEhCgCS8r0f3a4Iqq004HizK3Hh';
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: publishableKey,
        merchantId: 'Test',
        androidPayMode: 'test',
      ),
    );
  }

  /// create payment intent
  Future<dynamic> createPaymentIntent() async {
    final paymentEndpoint = Uri.https('api.stripe.com', 'v1/payment_intents');
    const secretKey =
        'sk_test_51IsmpSBqhjcHw6SABgmvRZtCE8hhxMmR3DpZpK4EwiUbIoRyRKuLqb7L1WLkWKA14u6bcgAH7wdcfEMiln3nu3Ow00Rt8BE0xe';

    final headers = <String, String>{
      'Authorization': 'Bearer $secretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, dynamic>{
      'amount': price.toString(),
      'currency': 'jpy',
      'payment_method_types[]': 'card',
    };

    final response = await http.post(
      paymentEndpoint,
      headers: headers,
      body: body,
    );

    final paymentIntent = jsonDecode(response.body);
    return paymentIntent;
  }

  /// confirm payment intent
  Future<PaymentIntentResult> confirmPaymentIntent(
      dynamic paymentIntent, PaymentMethod paymentMethod) async {
    print(paymentIntent);
    final confirmResult = await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ),
    );
    return confirmResult;
  }

  /// handle payment intent result
  StripeTransactionResponse handlePaymentResult(
      PaymentIntentResult confirmResult) {
    print("完了");

    if (confirmResult.status == 'succeeded') {
      return StripeTransactionResponse(
        message: 'Transaction successful',
        success: true,
      );
    } else {
      return StripeTransactionResponse(
        message: 'Transaction failed',
        success: true,
      );
    }
  }
}

class App extends StatelessWidget {
  final int price;

  const App({Key key, this.price}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (c) => StoreHome(),
            );
            Navigator.pushReplacement(context, route);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          '決済画面',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: _buildContent(),
      ),
    );
  }

  /// コンテンツの描画
  Widget _buildContent() {
    return ListView.separated(
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _buildPayViaNewCardButton(context);
          case 1:
            return _buildPayViaExistingCardButton(context);
          default:
            return Container();
        }
      },
      itemCount: 2,
      separatorBuilder: (
        context,
        index,
      ) =>
          Divider(color: Theme.of(context).primaryColor),
    );
  }

  /// 未登録のカードで決済をするボタン
  Widget _buildPayViaNewCardButton(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('新規のカードで決済する'),
      ),
      onTap: StripeService(price: price).payViaNewCard,
    );
  }

  /// 登録済みのカードで決済をするボタン
  Widget _buildPayViaExistingCardButton(BuildContext context) {
    final creditCard = CreditCard(
        number: '4242424242424242', expMonth: 5, expYear: 24, cvc: '424');
    return InkWell(
      child: ListTile(
        leading: Icon(
          Icons.credit_card_outlined,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('既存のカードで決済する'),
      ),
      onTap: () {
        StripeService(price: price).payViaExistingCard(creditCard);

        Fluttertoast.showToast(msg: "注文を承りました");
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      },
    );
  }
}
