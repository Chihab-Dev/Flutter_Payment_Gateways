import 'package:flutter/material.dart';
import 'package:payment_gateways/Features/checkout/presentation/views/widgets/my_cart_view_body.dart';
import 'package:payment_gateways/core/widgets/custom_app_bar.dart';

class MyCartView extends StatelessWidget {
  const MyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'My Cart', backArrow: false, addNewCard: true,context: context),
      body: const MyCartViewBody(),
    );
  }
}
