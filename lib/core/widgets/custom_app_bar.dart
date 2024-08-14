import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payment_gateways/core/utils/styles.dart';

AppBar buildAppBar({final String? title, final bool backArrow = true}) {
  return AppBar(
    leading: backArrow
        ? Center(
            child: SvgPicture.asset(
              'assets/images/arrow.svg',
            ),
          )
        : null,
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
