import 'package:flutter/material.dart';
import 'package:stripeinflutter/cardpay.dart';
import 'package:stripeinflutter/googlepay.dart';
import 'package:stripeinflutter/pay.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe in Flutter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to Stripe in Flutter!'),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Pay pay = Cardpay();
                    pay.pay(100.0, 'USD').then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment Successful!')),
                      );
                    }).catchError((error) {
                      String errorMessage = error.toString();
                      
                      // Check if it's a cancellation
                      if (errorMessage.contains('cancelled by user') || 
                          errorMessage.contains('cancel')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment cancelled'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      } else {
                        // Actual error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Payment Failed: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 14,
                    ),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Pay with Card',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      Pay pay = GooglePayPay();
                      await pay.pay(100.0, 'USD');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google Pay Successful!')),
                      );
                    } catch (error) {
                      String errorMessage = 'Google Pay Failed: $error';
                      if (error.toString().contains('MissingPluginException') ||
                          error.toString().contains('not supported')) {
                        errorMessage = 'Google Pay is not available on this device';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 14,
                    ),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Pay with Google Pay',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
