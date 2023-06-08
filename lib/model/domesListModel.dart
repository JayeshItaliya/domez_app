
class DomesListModel {
  DomesListModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.hst,
    required this.city,
    required this.state,
    required this.isActive,
    required this.isFav,
    required this.bookingId,
    required this.bookingType,
    required this.bookingPaymentType,
    required this.bookingDate,
    required this.totalFields,
    required this.sportsList,
  });

  int id;
  String name;
  String image;
  int price;
  int hst;
  String city;
  String state;
  int isActive;
  bool isFav;
  int bookingId;
  int bookingType;
  int bookingPaymentType;
  String bookingDate;
  int totalFields;
  List<SportsList> sportsList;

  factory DomesListModel.fromJson(Map<String, dynamic> json) => DomesListModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    price: json["price"],
    hst: json["hst"],
    city: json["city"],
    state: json["state"],
    isActive: json["is_active"],
    isFav: json["is_fav"],
    bookingId: json["booking_id"],
    bookingType: json["booking_type"],
    bookingPaymentType: json["booking_payment_type"],
    bookingDate: json["booking_date"],
    totalFields: json["total_fields"],
    sportsList: List<SportsList>.from(json["sports_list"].map((x) => SportsList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "price": price,
    "hst": hst,
    "city": city,
    "state": state,
    "is_active": isActive,
    "is_fav": isFav,
    "booking_id": bookingId,
    "booking_type": bookingType,
    "booking_payment_type": bookingPaymentType,
    "booking_date": bookingDate,
    "total_fields": totalFields,
    "sports_list": List<dynamic>.from(sportsList.map((x) => x.toJson())),
  };
  static List<DomesListModel> getListFromJson(List<dynamic> list){
    List<DomesListModel> fetchedList=[];
    list.forEach((unit) => fetchedList.add(DomesListModel.fromJson(unit)));
    return fetchedList;
  }
}

class SportsList {
  SportsList({
    required this.id,
    required this.name,
    required this.image,
  });

  int id;
  String name;
  String image;

  factory SportsList.fromJson(Map<String, dynamic> json) => SportsList(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}


