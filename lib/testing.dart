import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<dynamic, dynamic>? paymentIntentData;

  Future<void> processPayment(
      double totalPrice, String pId, BuildContext context) async {
    try {
      // Convert the total price to cents and then to a string
      String amountInCents = (totalPrice * 100).toInt().toString();
      var paymentIntentData = await createPaymentIntent(amountInCents, "USD");

      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData['client_secret'],
            googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US'),
            merchantDisplayName: 'Nod2Job',
          ),
        );
        await displayPaymentSheet();
        Fluttertoast.showToast(msg: "Payment successfull");

        await updateCredits(pId, totalPrice);
        print("Payment done done");
      } else {
        Fluttertoast.showToast(msg: "Failed to create payment intent");
      }
    } catch (e) {
      debugPrint("Payment processing error: $e");
      Fluttertoast.showToast(msg: "Payment failed: $e");
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) => {
            // setState(() {
            // }),
            paymentIntentData = null,
            // print("Payment done done done")

            // placeOrder(),
          });
    } on StripeException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      Fluttertoast.showToast(msg: "Payment Cancelled");
      Fluttertoast.showToast(msg: "Couldn't place the order");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, String> body = {
        'amount': amount, // Ensure this is a string
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return jsonDecode(response.body.toString());
    } catch (e) {
      debugPrint("exception$e");
    }
  }

  int calculateAmount(String amount) {
    final double price = double.parse(amount); // Parse to double
    final int convertedPrice = (price * 100).toInt(); // Convert to cents
    return convertedPrice;
  }

  /// Update product's credits in Firebase
  Future<void> updateCredits(String productId, double amountPaid) async {
    try {
      final docRef = _firestore.collection('posts').doc(productId);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          final existingCredits = snapshot.data()?['credits'] ?? 0;
          final newCredits = existingCredits + (amountPaid * 100).toInt();

          transaction.update(docRef, {'credits': newCredits});
        } else {
          transaction.set(docRef, {'credits': (amountPaid * 100).toInt()});
        }
      });
    } catch (e) {
      debugPrint("Failed to update credits: $e");
      rethrow;
    }
  }
}

class StartAdvertisementScreen extends StatelessWidget {
  StartAdvertisementScreen({
    super.key,
  });
  PaymentService _paymentService = PaymentService();
  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Advertise ',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,

        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              "Promote Your post",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 24),

            // Info Section
            // Card(
            //   color: Colors.white,
            //   elevation: 3,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: const Padding(
            //     padding: EdgeInsets.all(16.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Why Advertise?",
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         SizedBox(height: 12),
            //         Text(
            //           "• Reach a larger audience.\n"
            //           "• Increase your product's visibility.\n"
            //           "• Cost-effective at just \$0.01 per click.",
            //           style: TextStyle(fontSize: 16, height: 1.5),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 24),

            // // Cost Section
            // Card(
            //   elevation: 3,
            //   color: Colors.white,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Padding(
            //     padding: EdgeInsets.all(16.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           "Cost per Click:",
            //           style:
            //               TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            //         ),
            //         Text(
            //           "\$0.01",
            //           style: TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold,
            //             color: appColor,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 24),

            // Input Field
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Amount to Spend (USD)",
                hintText: "e.g. 100",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.monetization_on_outlined,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final enteredAmount = amountController.text;
                  if (enteredAmount.isNotEmpty) {
                    final amount = double.tryParse(enteredAmount);
                    if (amount != null && amount > 0) {
                      _paymentService.processPayment(
                        amount,
                        "",
                        context,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a valid amount.')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Amount cannot be empty.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                ),
                child: const Text(
                  "Pay",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
