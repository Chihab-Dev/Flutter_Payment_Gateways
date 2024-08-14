import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payment_gateways/Features/checkout/presentation/views/payment_details.dart';
import 'package:payment_gateways/core/utils/styles.dart';

AppBar buildAppBar({
  final String? title,
  final bool backArrow = true,
  final bool addNewCard = false,
  required BuildContext context,
}) {
  return AppBar(
    leading: backArrow
        ? InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: SvgPicture.asset(
                'assets/images/arrow.svg',
              ),
            ),
          )
        : null,
    actions: addNewCard
        ? [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentDetailsView(),
                    ));
              },
              child: Image.asset(
                'assets/images/add_new_card.png',
                fit: BoxFit.cover,
                cacheWidth: 75,
              ),
            ),
          ]
        : [],
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    title: Text(
      title ?? '',
      textAlign: TextAlign.center,
      style: Styles.style25,
    ),
  );
}
