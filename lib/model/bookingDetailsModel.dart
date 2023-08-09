
class BookingDetailsModel {
  BookingDetailsModel({
    required this.id,
    required this.type,
    required this.field,
    required this.domeName,
    required this.leagueName,
    required this.days,
    required this.totalGames,
    required this.date,
    required this.time,
    required this.players,
    required this.address,
    required this.city,
    required this.state,
    required this.subTotal,
    required this.serviceFee,
    required this.hst,
    required this.paidAmount,
    required this.dueAmount,
    required this.totalAmount,
    required this.image,
    required this.paymentStatus,
    required this.bookingStatus,
    required this.bookingCreatedAt,
    required this.currentTime,
    required this.userInfo,
    required this.paymentLink,
    required this.otherContributors,
    required this.startDate,
    required this.endDate,
    required this.domeId,
    required this.isRattingExist,
    required this.isActive,
  });

  int id;
  int type;
  String field;
  String domeName;
  String leagueName;
  String days;
  String totalGames;
  String date;
  String time;
  int players;
  String address;
  String city;
  String state;
  double subTotal;
  double serviceFee;
  double hst;
  double paidAmount;
  double dueAmount;
  double totalAmount;
  String image;
  String paymentStatus;
  String bookingStatus;
  DateTime bookingCreatedAt;
  DateTime currentTime;
  UserInfo userInfo;
  String paymentLink;
  List<OtherContributor> otherContributors;
  String startDate;
  String endDate;
  int domeId;
  int isRattingExist;
  int isActive;
  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) => BookingDetailsModel(
    id: json["id"],
    type: json["type"],
    field: json["field"],
    domeName: json["dome_name"],
    leagueName: json["league_name"],
    days: json["days"],
    totalGames: json["total_games"],
    date: json["date"],
    time: json["time"],
    players: json["players"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    subTotal: double.parse(json["sub_total"].toString()),
    serviceFee: double.parse(json["service_fee"].toString())==null?0.0:double.parse(json["service_fee"].toString()),
    hst: double.parse(json["hst"].toString())==null?0.0:double.parse(json["hst"].toString()),
    paidAmount: double.parse(json["paid_amount"].toString()),
    dueAmount: double.parse(json["due_amount"].toString()),
    totalAmount: double.parse(json["total_amount"].toString()),
    image: json["image"],
    paymentStatus: json["payment_status"],
    bookingStatus: json["booking_status"],
    bookingCreatedAt: DateTime.parse(json["booking_created_at"]),
    currentTime: DateTime.parse(json["current_time"]),
    userInfo: UserInfo.fromJson(json["user_info"]),
    paymentLink: json["payment_link"],
    otherContributors: List<OtherContributor>.from(json["other_contributors"].map((x) => OtherContributor.fromJson(x))),
    startDate: json["start_date"],
    endDate: json["end_date"],
    domeId: json["dome_id"],
    isRattingExist: json["is_ratting_exist"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "field": field,
    "dome_name": domeName,
    "league_name": leagueName,
    "days": days,
    "total_games": totalGames,
    "date": date,
    "time": time,
    "players": players,
    "address": address,
    "city": city,
    "state": state,
    "sub_total": subTotal,
    "service_fee": serviceFee,
    "hst": hst,
    "paid_amount": paidAmount,
    "due_amount": dueAmount,
    "total_amount": totalAmount,
    "image": image,
    "payment_status": paymentStatus,
    "booking_status": bookingStatus,
    "booking_created_at": bookingCreatedAt.toIso8601String(),
    "current_time": currentTime.toIso8601String(),
    "user_info": userInfo.toJson(),
    "payment_link": paymentLink,
    "other_contributors": List<dynamic>.from(otherContributors.map((x) => x.toJson())),
    "start_date": startDate,
    "end_date": endDate,
    "dome_id": domeId,
    "is_ratting_exist": isRattingExist,
    "is_active": isActive,
  };
}

class OtherContributor {
  OtherContributor({
    required this.userId,
    required this.contributorName,
    required this.amount,
    required this.contributorImageUrl,
    required this.userImage,
  });

  int userId;
  String contributorName;
  double amount;
  String contributorImageUrl;
  String userImage;

  factory OtherContributor.fromJson(Map<String, dynamic> json) => OtherContributor(
    userId: json["user_id"],
    contributorName: json["contributor_name"],
    amount: json["amount"]?.toDouble(),
    contributorImageUrl: json["contributor_image_url"],
    userImage: json["user_image"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "contributor_name": contributorName,
    "amount": amount,
    "contributor_image_url": contributorImageUrl,
    "user_image": userImage,
  };
}

class UserInfo {
  UserInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.userImage,
  });

  int id;
  String name;
  String phone;
  String email;
  String userImage;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"]??0,
    name: json["name"]??"",
    phone: json["phone"]??"",
    email: json["email"]??"",
    userImage: json["user_image"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "email": email,
    "user_image": userImage,
  };
}
