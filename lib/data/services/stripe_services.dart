import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart' as dio;
import 'package:ecommerce_app/utlis/constants/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class StripeServices extends GetxController {
  static StripeServices get to => Get.find();

  // Variables
  final _dio = dio.Dio();

  // Function to create payment intent
  Future<Map<String, dynamic>> createPaymentIntent(
    String currency,
    int amount,
  ) async {
    const String url = 'https://api.stripe.com/v1/payment_intents';

    final response = await _dio.post(
      url,

      // لازم نبعت body كنص URL-Encoded مو Map
      data: 'amount=$amount&currency=$currency&payment_method_types[]=card',

      options: dio.Options(
        headers: {
          'Authorization': 'Bearer ${UKeys.stripeSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        validateStatus: (status) => true,
      ),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    }

    throw 'Stripe error ${response.statusCode}: ${response.data}';
  }

  // Function to init the payment sheet
  Future<void> initPaymentSheet(String currency, int amount) async {
    try {
      // 1. Create payment intent on the server
      final data = await createPaymentIntent(currency, amount);
      if (kDebugMode) dev.log(data.toString(), name: 'StripeServices');

      // 2. Create billing details (optional)
      final billingDetails = BillingDetails(
        name: 'Flutter Stripe',
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: const Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      );

      // 3. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: data['client_secret'],
          merchantDisplayName: 'Shopping App',
          primaryButtonLabel: 'Pay now',
          style: ThemeMode.dark,
          billingDetails: billingDetails,
        ),
      );
    } catch (e) {
      throw 'something went wrong while initializing payment sheet: $e';
    }
  }

  // Function to show the stripe payment sheet
  Future<void> showPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      switch (e.error.code) {
        case FailureCode.Canceled:
          throw 'Payment cancelled';
        case FailureCode.Failed:
          throw 'Payment failed';
        case FailureCode.Timeout:
          throw 'Payment timeout';
        case FailureCode.Unknown:
          throw 'Payment failed due to unknown error';
      }
    } catch (e) {
      throw 'something went wrong while showing payment sheet: $e';
    }
  }
}
