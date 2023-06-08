import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pay/pay.dart';



const _paymentItems = [
  PaymentItem(
    label: 'Total Amount',
    amount: '35.35',
    status: PaymentItemStatus.final_price,
    type: PaymentItemType.item,
  ),
  PaymentItem(
    label: 'Total Amount',
    amount: '50.70',
    status: PaymentItemStatus.final_price,
    type: PaymentItemType.total,
  ),
];


class PaySampleApp extends StatefulWidget {
  PaySampleApp({Key? key}) : super(key: key);

  @override
  _PaySampleAppState createState() => _PaySampleAppState();
}

class _PaySampleAppState extends State<PaySampleApp> {
  Future<PaymentConfiguration>? _applePayConfigFuture;
  Future<PaymentConfiguration>? gPayConfigFuture;

  @override
  void initState() {
    super.initState();
    _applePayConfigFuture = PaymentConfiguration.fromAsset('applePay.json');
    gPayConfigFuture = PaymentConfiguration.fromAsset('default_google_pay_config.json');

    // PaymentConfiguration.fromAsset('default_apple_pay_config.json');
  }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
    debugPrint(" payment response ------------ ${paymentResult.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T-shirt Shop'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 20),
          //   child: const Image(
          //     image: AssetImage('assets/images/product.png'),
          //     height: 350,
          //   ),
          // ),

          Gap(22),

          const Text(
            'Bella Vita Luxury ',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '\$48',
            style: TextStyle(
              color: Color(0xff777777),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Looking for a long lasting perfume for men',
            style: TextStyle(
              color: Color(0xff777777),
              fontSize: 15,
            ),
          ),

          FutureBuilder<PaymentConfiguration>(
              future: _applePayConfigFuture,
              builder: (context, snapshot) => snapshot.hasData
                  ? ApplePayButton(

                      paymentConfiguration: snapshot.data!,
                      paymentItems: _paymentItems,
                      style: ApplePayButtonStyle.black,
                      type: ApplePayButtonType.book,
                      width: 200,
                      height: 50,
                      margin: const EdgeInsets.only(top: 15.0),
                      onPaymentResult: onApplePayResult,
                      onError: (error) {
                        print(error);
                      },
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink()),

          // Example pay button configured using an asset
          FutureBuilder<PaymentConfiguration>(
              future: gPayConfigFuture,
              builder: (context, snapshot) => snapshot.hasData
                  ? GooglePayButton(
                      paymentConfiguration: snapshot.data!,
                      paymentItems: _paymentItems,
                      type: GooglePayButtonType.buy,
                      margin: const EdgeInsets.only(top: 15.0),
                      onPaymentResult: onGooglePayResult,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink()),
          // Example pay button configured using a string

          const SizedBox(height: 15)
        ],
      ),
    );
  }
}
