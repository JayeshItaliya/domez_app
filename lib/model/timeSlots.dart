class TimeSlotsModel {
  TimeSlotsModel({
    required this.slot,
    required this.price,
    required this.status,
    required this.currentTime,
  });

  String slot;
  int price;
  int status;
  DateTime currentTime;

  factory TimeSlotsModel.fromJson(Map<String, dynamic> json) => TimeSlotsModel(
    slot: json["slot"],
    price: json["price"],
    status: json["status"],
    currentTime: DateTime.parse(json["current_time"]),
  );

  Map<String, dynamic> toJson() => {
    "slot": slot,
    "price": price,
    "status": status,
    "current_time": currentTime.toIso8601String(),
  };
  static List<TimeSlotsModel> getListFromJson(List<dynamic> list){
    List<TimeSlotsModel> fetchedList=[];
    list.forEach((unit) => fetchedList.add(TimeSlotsModel.fromJson(unit)));
    return fetchedList;
  }
}
