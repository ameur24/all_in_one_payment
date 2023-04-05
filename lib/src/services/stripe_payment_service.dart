import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../payment_service.dart';

class StripePaymentService implements PaymentService {
  final String _publishableKey;
  final String _secretKey;
  final String _merchantid;
  final String _androidPayMode;

  StripePaymentService(this._publishableKey, this._secretKey, this._merchantid,
      this._androidPayMode) {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: _publishableKey,
        merchantId: _merchantid,
        androidPayMode: _androidPayMode,
      ),
    );
  }

  @override
  Future<PaymentStatus> makePayment({
    required String customerId,
    required String paymentToken,
    required double amount,
    String? currency,
    String? description,
    String? statementDescriptor,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(
          card: CreditCard(
            token: paymentToken,
          ),
        ),
      );

      final paymentIntent = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: "",
          paymentMethodId: paymentMethod.id,
        ),
      );

      return PaymentStatus.success;
    } catch (e) {
      return PaymentStatus.failure;
    }
  }

  @override
  Future<PaymentStatus> authorizePayment({
    required String customerId,
    required String paymentToken,
    required double amount,
    String? currency,
    String? description,
    String? statementDescriptor,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      StripePayment.setOptions(StripeOptions(
        publishableKey: 'your_publishable_key',
        merchantId: _merchantid,
        androidPayMode: _androidPayMode,
      ));

      final paymentMethod = PaymentMethod.fromJson(jsonDecode(paymentToken));

      final paymentIntentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
            paymentMethodId: paymentMethod.id,
            paymentMethod: PaymentMethodRequest(
                card: paymentMethod.card,
                billingAddress: paymentMethod.billingDetails,
                token: paymentToken)),
      );

      if (paymentIntentResult.status == 'succeeded') {
        return PaymentStatus.success;
      } else {
        return PaymentStatus.failure;
      }
    } on PlatformException catch (error) {
      // Handle any errors from the platform
      print('Error: ${error.code} - ${error.message}');
      return PaymentStatus.failure;
    } catch (error) {
      print('Error: $error');
      return PaymentStatus.failure;
    }
  }
  // implementation for authorizing payment with Stripe


@override
Future<PaymentStatus> capturePayment({
  required String customerId,
  required String paymentId,
  required double amount,
  String? currency,
  String? description,
  String? statementDescriptor,
  Map<String, dynamic>? metadata,
}) {
  // implementation for capturing payment with Stripe
}

@override
Future<PaymentStatus> voidAuthorization({
  required String customerId,
  required String authorizationId,
  String? description,
  Map<String, dynamic>? metadata,
}) {
  // implementation for voiding authorization with Stripe
}

@override
Future<PaymentStatus> refundPayment({
  required String customerId,
  required String paymentId,
  required double amount,
  String? currency,
  String? description,
  String? statementDescriptor,
  Map<String, dynamic>? metadata,
}) {
  // implementation for refunding payment with Stripe
}
@override
Future<PaymentIntentStatus> getPaymentIntent({
  required String paymentIntentId,
}) async {
  try {
    final paymentIntentResponse = await StripePayment.re(paymentIntentId);

    switch (paymentIntentResponse.status) {
      case PaymentIntentStatus.succeeded:
        return PaymentIntentStatus.succeeded;
      case PaymentIntentStatus.requiresAction:
        return PaymentIntentStatus.requiresAction;
      case PaymentIntentStatus.requiresConfirmation:
        return PaymentIntentStatus.requiresConfirmation;
      case PaymentIntentStatus.canceled:
        return PaymentIntentStatus.canceled;
      case PaymentIntentStatus.processing:
        return PaymentIntentStatus.processing;
      default:
        return PaymentIntentStatus.canceled;
    }
  } catch (e) {
    throw PaymentException(e.toString());
  }
}
