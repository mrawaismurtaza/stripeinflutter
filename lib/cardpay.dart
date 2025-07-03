import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:stripeinflutter/conts.dart';
import 'package:stripeinflutter/pay.dart';

class Cardpay implements Pay{
  final Dio _dio = Dio();

  @override
  Future<void> pay(double amount, String currency) async {
    try {
      Map<String, dynamic>? paymentIntent = await getPaymentIntent(
        (amount * 100).toStringAsFixed(0), // Convert to cents
        currency,
      );
      if (paymentIntent == null) {
        throw Exception('Failed to create payment intent');
      }
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent['client_secret'],
        merchantDisplayName: 'Awais Co.',
      ));
      
      await confirmPayment();
    } catch (e) {
      throw Exception('Payment failed: $e');
    }
  }

  Future<Map<String, dynamic>?> getPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      return response.data;
      
    } catch (e) {
      throw Exception('Failed to get payment intent: $e');
    }
  }


  Future<void> confirmPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw Exception('Payment confirmation failed: $e');
    }
  }
}

