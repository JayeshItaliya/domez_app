
class PaymentDetailsModel {
  PaymentDetailsModel({
    required this.status,
    required this.message,
    required this.transactionId,
    required this.bookingId,
    required this.paymentLink,
  });

  int status;
  String message;
  String transactionId;
  int bookingId;
  String paymentLink;

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) => PaymentDetailsModel(
    status: json["status"],
    message: json["message"],
    transactionId: json["transaction_id"],
    bookingId: json["booking_id"],
    paymentLink: json["payment_link"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "transaction_id": transactionId,
    "booking_id": bookingId,
    "payment_link": paymentLink,
  };
}
