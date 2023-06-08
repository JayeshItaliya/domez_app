class TimeSlotsModel {
  TimeSlotsModel({
    required this.slot,
    required this.price,
    required this.status,
  });

  String slot;
  int price;
  int status;

  factory TimeSlotsModel.fromJson(Map<String, dynamic> json) => TimeSlotsModel(
    slot: json["slot"],
    price: json["price"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "slot": slot,
    "price": price,
    "status": status,
  };
  static List<TimeSlotsModel> getListFromJson(List<dynamic> list){
    List<TimeSlotsModel> fetchedList=[];
    list.forEach((unit) => fetchedList.add(TimeSlotsModel.fromJson(unit)));
    return fetchedList;
  }
}
