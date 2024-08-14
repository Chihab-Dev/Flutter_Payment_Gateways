import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:payment_gateways/Features/checkout/data/models/amount_model/amount_model.dart';
import 'package:payment_gateways/Features/checkout/data/models/item_list_model/item_list_model.dart';
import 'package:payment_gateways/Features/checkout/data/models/payment_intent_input_model/payment_intent_model.dart';
import 'package:payment_gateways/Features/checkout/data/repos/checkout_repo.dart';
import 'package:payment_gateways/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:payment_gateways/core/utils/api_key.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit({required this.checkoutRepo}) : super(PaymentInitial());

  final CheckoutRepo checkoutRepo;

  bool isPayPal = false;

  Future makePayment({required PaymentIntentInputModel paymentIntentInputModel}) async {
    emit(PaymentLoading());
    var data = await checkoutRepo.makePayment(paymentIntentInputModel: paymentIntentInputModel);

    data.fold(
      (failure) => emit(PaymentFailure(error: failure.message)),
      (_) => emit(PaymentSuccess()),
    );
  }

  void executePayPalPayment(BuildContext context, ({AmountModel amount, ItemListModel itemList}) transactionsData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: ApiKey.payPalClientId,
          secretKey: ApiKey.payPalSecretKey,
          transactions: [
            {
              "amount": transactionsData.amount.toJson(),
              "description": "The payment transaction description.",
              "item_list": transactionsData.itemList.toJson(),
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            log("onSuccess: $params");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ThankYouView(),
              ),
            );
          },
          onError: (error) {
            log("onError: $error");
            Navigator.pop(context);
          },
          onCancel: () {
            print('cancelled:');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  void onChange(Change<PaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
