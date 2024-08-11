import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_gateways/Features/checkout/data/models/ephemeral_key_model/ephemeral_key_model.dart';
import 'package:payment_gateways/Features/checkout/data/models/payment_intent_input_model/payment_intent_model.dart';
import 'package:payment_gateways/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:payment_gateways/core/utils/api_key.dart';
import 'package:payment_gateways/core/utils/api_service.dart';

class StripeService {
  final ApiService apiService = ApiService();
  Future<PaymentIntentModel> createPaymentIntent(PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await apiService.post(
      body: paymentIntentInputModel.toJson(),
      contentType: Headers.formUrlEncodedContentType,
      url: 'https://api.stripe.com/v1/payment_intents',
      token: ApiKey.secretKey,
    );

    var paymentIntentModel = PaymentIntentModel.fromJson(response.data);

    return paymentIntentModel;
  }

  Future initPaymentSheet(String? paymentIntentClientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Main params
        merchantDisplayName: 'chihab',
        // • to relate the payment sheet with the customer who made the intent ::
        paymentIntentClientSecret: paymentIntentClientSecret,

        // Customer params
        // • to check if the customer have previous CARDs then display it ::
        // customerEphemeralKeySecret: data['ephemeralKey'],
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment({required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
    await initPaymentSheet(paymentIntentModel.clientSecret);
    await displayPaymentSheet();
  }

  Future<String> createCustomer() async {
    var response = await apiService.post(
      body: "",
      contentType: Headers.formUrlEncodedContentType,
      url: 'https://api.stripe.com/v1/customers',
      token: ApiKey.secretKey,
    );

    var customerId = response.data['id'];

    return customerId;
  }

  Future<EphemeralKeyModel> createEphemeralKey({required String customerId}) async {
    var response = await apiService.post(
        body: {
          "customer": customerId,
        },
        contentType: Headers.formUrlEncodedContentType,
        url: 'https://api.stripe.com/v1/ephemeral_keys',
        token: ApiKey.secretKey,
        headers: {
          "Stripe-Version": "2024-06-20",
          'Authorization': "Bearer ${ApiKey.secretKey}",
        });

    var ephemeralKeyModel = EphemeralKeyModel.fromJson(response.data);

    return ephemeralKeyModel;
  }
}
