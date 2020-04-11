import 'dart:async';

import 'package:eghl_plugin_unofficial/eghl_plugin_unofficial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = 'Awaiting results';

  Future<void> pay() async {
    try {
      String paymentId = await Eghlpluginunofficial.generateId('DEMO');

      String result = await Eghlpluginunofficial.makePayment(
        merchantReturnUrl: 'SDK',
        serviceId: 'SIT',
        password: 'sit12345',
        merchantName: 'GHL ePayment Testing',
        amount: 1.00,
        paymentDescription: 'eGHL Payment testing',
        customerName: 'Somebody',
        customerEmail: 'somebody@somesite.com',
        customerPhone: '60123456789',
        paymentId: paymentId,
        orderNumber: paymentId,
        currencyCode: 'MYR',
        languageCode: 'EN',
        pageTimeout: Duration(
          minutes: 2,
          seconds: 30,
        ),
        transactionType: 'SALE',
        paymentMethod: 'ANY',
        useDebugPaymentUrl: true,
      );

      setState(() {
        _result = 'Result: $result';
      });
    } on PlatformException catch (err) {
      setState(() {
        _result = 'PlatformException: ${err.toString()}';
      });
    } catch (err) {
      setState(() {
        _result = 'Error: ${err.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                onPressed: pay,
                child: Text('Click me to launch payment'),
              ),
              Text(_result),
            ],
          ),
        ),
      ),
    );
  }
}
