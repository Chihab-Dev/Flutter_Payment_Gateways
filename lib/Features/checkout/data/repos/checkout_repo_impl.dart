import 'package:dartz/dartz.dart';
import 'package:payment_gateways/Features/checkout/data/models/payment_intent_input_model/payment_intent_model.dart';
import 'package:payment_gateways/Features/checkout/data/repos/checkout_repo.dart';
import 'package:payment_gateways/core/errors/failures.dart';
import 'package:payment_gateways/core/utils/stripe_service.dart';

class CheckoutRepoImpl implements CheckoutRepo {
  StripeService stripeService = StripeService();
  @override
  Future<Either<Failure, void>> makePayment({required PaymentIntentInputModel paymentIntentInputModel}) async {
    try {
      await stripeService.makePayment(paymentIntentInputModel: paymentIntentInputModel);

      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
