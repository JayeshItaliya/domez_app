
class PaymentDetailsModel {
  PaymentDetailsModel({
    required this.status,
    required this.message,
    required this.transactionId,
    required this.bookingId,
    required this.paymentLink,
    required this.bookingCreatedAt,
    required this.currentTime,

  });

  int status;
  String message;
  String transactionId;
  int bookingId;
  String paymentLink;
  DateTime bookingCreatedAt;
  DateTime currentTime;

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) => PaymentDetailsModel(
    status: json["status"],
    message: json["message"],
    transactionId: json["transaction_id"],
    bookingId: json["booking_id"],
    paymentLink: json["payment_link"],
    bookingCreatedAt: DateTime.parse(json["booking_created_at"]),
    currentTime: DateTime.parse(json["current_time"]),

  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "transaction_id": transactionId,
    "booking_id": bookingId,
    "payment_link": paymentLink,
    "booking_created_at": bookingCreatedAt.toIso8601String(),
    "current_time": currentTime.toIso8601String(),
  };
}
