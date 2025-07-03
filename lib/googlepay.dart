// googlepay.dart
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripeinflutter/conts.dart';
import 'package:stripeinflutter/pay.dart';

class GooglePayPay implements Pay {
  @override
  Future<void> pay(double amount, String currency) async {
    try {
      // Initialize Google Pay directly without checking availability
      await Stripe.instance.initGooglePay(GooglePayInitParams(
        testEnv: true,
        merchantName: 'Awais Co.',
        countryCode: 'US',
      ));

      await Stripe.instance.presentGooglePay(
        PresentGooglePayParams(
          clientSecret: await _createPaymentIntent(amount, currency),
          currencyCode: currency,
        ),
      );
    } catch (e) {
      // Check if it's a specific Google Pay error
      if (e.toString().contains('Google Pay is not available')) {
        throw Exception('Google Pay is not supported on this device');
      }
      throw Exception('Google Pay failed: $e');
    }
  }

  Future<String> _createPaymentIntent(double amount, String currency) async {
    // This logic should be the same as your CardPay’s getPaymentIntent
    final Dio dio = Dio();
    try {
      final response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: {
          'amount': (amount * 100).toStringAsFixed(0),
          'currency': currency,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      return response.data['client_secret'];
    } catch (e) {
      throw Exception('Failed to create PaymentIntent: $e');
    }
  }
}
 