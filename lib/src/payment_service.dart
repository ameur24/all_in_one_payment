enum PaymentStatus { success, failure, pending }

enum PaymentIntentStatus {
  succeeded,
  requiresAction,
  requiresConfirmation,
  canceled,
  processing,
}

class PaymentException implements Exception {
  final String message;
  PaymentException(this.message);
}

abstract class PaymentService {
  Future<PaymentStatus> makePayment({
    required String customerId,
    required String paymentToken,
    required double amount,
    String? currency,
    String? description,
    String? statementDescriptor,
    Map<String, dynamic>? metadata,
  });

  Future<PaymentStatus> authorizePayment({
    required String customerId,
    required String paymentToken,
    required double amount,
    String? currency,
    String? description,
    String? statementDescriptor,
    Map<String, dynamic>? metadata,
  });

  Future<PaymentStatus> capturePayment({
    required String customerId,
    required String paymentId,
    required double amount,
    String? currency,
    String? description,
    String? statementDescriptor,
    Map<String, dynamic>? metadata,
  });

  Future<PaymentStatus> voidAuthorization({
    required String customerId,
    required String authorizationId,
    String? description,
    Map<String, dynamic>? metadata,
  });

  Future<PaymentStatus> refundPayment({
    required String customerId,
    required String paymentId,
    required double amount,
    String? currency,
    String? description,
    String? statementDescriptor,
    Map<String, dynamic>? metadata,
  });
  Future<PaymentIntentStatus> getPaymentIntent({
    required String paymentIntentId,
  });
}
