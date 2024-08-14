import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_gateways/Features/checkout/data/models/amount_model/amount_model.dart';
import 'package:payment_gateways/Features/checkout/data/models/amount_model/details.dart';
import 'package:payment_gateways/Features/checkout/data/models/item_list_model/item.dart';
import 'package:payment_gateways/Features/checkout/data/models/item_list_model/item_list_model.dart';
import 'package:payment_gateways/Features/checkout/data/models/payment_intent_input_model/payment_intent_model.dart';
import 'package:payment_gateways/Features/checkout/presentation/cubit/payment_cubit.dart';
import 'package:payment_gateways/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:payment_gateways/core/utils/api_key.dart';
import 'package:payment_gateways/core/widgets/custom_button.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  const CustomButtonBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ThankYouView(),
              ));
        }
        if (state is PaymentFailure) {
          Navigator.pop(context);
          SnackBar snackBar = SnackBar(content: Text(state.error));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return CustomButton(
          isLoading: state is PaymentLoading ? true : false,
          text: 'Continue',
          onTap: () {
            if (BlocProvider.of<PaymentCubit>(context).isPayPal) {
              // PAYPAL :
              var transactionsData = getTransactionData();
              BlocProvider.of<PaymentCubit>(context).executePayPalPayment(context, transactionsData);
            } else {
              // STRIPE :
              PaymentIntentInputModel paymentIntentInputModel = PaymentIntentInputModel(
                amount: '999',
                currency: 'USD',
                customerId: ApiKey.customerId,
              );
              BlocProvider.of<PaymentCubit>(context).makePayment(paymentIntentInputModel: paymentIntentInputModel);
            }
          },
        );
      },
    );
  }

  ({AmountModel amount, ItemListModel itemList}) getTransactionData() {
    AmountModel amount = AmountModel(
      total: "100",
      currency: "USD",
      details: Details(
        subtotal: "100",
        shipping: "0",
        shippingDiscount: 0,
      ),
    );

    List<Item> items = [
      Item(
        name: "Apple",
        price: "10",
        currency: "USD",
        quantity: 4,
      ),
      Item(
        name: "Pineapple",
        price: "12",
        currency: "USD",
        quantity: 5,
      ),
    ];

    ItemListModel itemList = ItemListModel(items: items);

    return (amount: amount, itemList: itemList);
  }
}
