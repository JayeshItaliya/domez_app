
class BookingListModel {
  BookingListModel({
    required this.bookingId,
    required this.type,
    required this.field,
    required this.domeName,
    required this.leagueName,
    required this.date,
    required this.price,
    required this.image,
    required this.paymentType,
  });

  int bookingId;
  int type;
  String field;
  String domeName;
  String leagueName;
  String date;
  double price;
  String image;
  int paymentType;

  factory BookingListModel.fromJson(Map<String, dynamic> json) => BookingListModel(
    bookingId: json["booking_id"],
    type: json["type"],
    field: json["field"],
    domeName: json["dome_name"],
    leagueName: json["league_name"],
    date: json["date"],
    price: double.parse(json["price"].toString()),
    image: json["image"],
    paymentType: json["payment_type"],
  );

  Map<String, dynamic> toJson() => {
    "booking_id": bookingId,
    "type": type,
    "field": field,
    "dome_name": domeName,
    "league_name": leagueName,
    "date": date,
    "price": price,
    "image": image,
    "payment_type": paymentType,
  };
  static List<BookingListModel> getListFromJson(List<dynamic> list){
    List<BookingListModel> fetchedList=[];
    list.forEach((unit) => fetchedList.add(BookingListModel.fromJson(unit)));
    return fetchedList;
  }
}
