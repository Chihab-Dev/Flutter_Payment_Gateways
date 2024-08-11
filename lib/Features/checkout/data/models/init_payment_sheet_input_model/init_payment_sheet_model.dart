// ignore_for_file: public_member_api_docs, sort_constructors_first
class InitPaymentSheetInputModel {
  String paymentIntentClientSecret;
  String ephemeralKeySecret;
  String customerId;
  InitPaymentSheetInputModel({
    required this.paymentIntentClientSecret,
    required this.ephemeralKeySecret,
    required this.customerId,
  });
}
