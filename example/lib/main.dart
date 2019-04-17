import 'dart:async';

import 'package:eghl_plugin_unofficial/eghl_plugin_unofficial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _eghlPaymentResult = 'Awaiting payment start.';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await EghlPluginUnofficial.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            Text(this._eghlPaymentResult),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            RaisedButton(
              child: Text('Launch eGHL payment'),
              onPressed: () {
                _makeEghlPayment();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makeEghlPayment() async {
    String result = 'Payment started, waiting for result.';

    int currMillis = new DateTime.now().millisecondsSinceEpoch;
    String paymentId = 'TEST${currMillis}';
    try {
      result = await EghlPluginUnofficial.makePayment({
        'TransactionType': 'SALE',
        'PymtMethod': 'ANY',
        'ServiceID': 'SIT',
        'Password': 'sit12345',
        'PaymentID': paymentId,
        'OrderNumber': paymentId,
        'PaymentDesc': 'eGHL FMX Integration testing',
        'MerchantReturnURL': 'SDK',
        'Amount': '1.00',
        'CurrencyCode': 'MYR',
        'CustIP': '',
        'CustName': 'TestCustomer1',
        'CustEmail': 'testemail@gmail.com',
        'CustPhone': '60102658531',
        'PaymentGateway': 'https://test2pay.ghl.com/IPGSG/Payment.aspx',
      });
    } on PlatformException catch (e) {
      result = 'Unable to start payment. ${e.message}';
    }

    setState(() {
      _eghlPaymentResult = result;
    });
  }
}
