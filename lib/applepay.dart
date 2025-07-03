// // applepay.dart
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:stripeinflutter/pay.dart';
// import 'package:dio/dio.dart';
// import 'package:stripeinflutter/conts.dart';

// class ApplePayPay implements Pay {
//   @override
//   Future<void> pay(double amount, String currency) async {
//     try {
//       await Stripe.instance.initApplePay(ApplePayInitParams(
//         merchantCountryCode: 'US', // Your country code
//         merchantName: 'Awais Co.', // Shown in the Apple Pay sheet
//       ));

//       final clientSecret = await _createPaymentIntent(amount, currency);

//       await Stripe.instance.presentApplePay(
//         PresentApplePayParams(
//           cartItems: [
//             ApplePayCartSummaryItem(
//               label: 'Total',
//               amount: amount.toStringAsFixed(2),
//             ),
//           ],
//           country: 'US', // Same as above
//           currency: currency,
//         ),
//       );

//       await Stripe.instance.confirmApplePayPayment(clientSecret);
//     } catch (e) {
//       throw Exception('Apple Pay failed: $e');
//     }
//   }

//   Future<String> _createPaymentIntent(double amount, String currency) async {
//     final Dio dio = Dio();
//     try {
//       final response = await dio.post(
//         'https://api.stripe.com/v1/payment_intents',
//         data: {
//           'amount': (amount * 100).toStringAsFixed(0),
//           'currency': currency,
//         },
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $stripeSecretKey',
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//         ),
//       );
//       return response.data['client_secret'];
//     } catch (e) {
//       throw Exception('Failed to create PaymentIntent: $e');
//     }
//   }
// }
