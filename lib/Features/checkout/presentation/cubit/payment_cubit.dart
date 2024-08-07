import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:payment_gateways/Features/checkout/data/models/payment_intent_input_model/payment_intent_model.dart';
import 'package:payment_gateways/Features/checkout/data/repos/checkout_repo.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit({required this.checkoutRepo}) : super(PaymentInitial());

  final CheckoutRepo checkoutRepo;

  Future makePayment({required PaymentIntentInputModel paymentIntentInputModel}) async {
    emit(PaymentLoading());
    var data = await checkoutRepo.makePayment(paymentIntentInputModel: paymentIntentInputModel);

    data.fold(
      (failure) => emit(PaymentFailure(error: failure.message)),
      (_) => emit(PaymentSuccess()),
    );
  }

  @override
  void onChange(Change<PaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
