import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  static Future<void> presentPaymentSheet(
      String paymentIntentClientSecret) async {
    try {
      PaymentSheetPaymentOption? paymentSheetPaymentOption =
          await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntentClientSecret));

      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      rethrow;
    }
  }
}
