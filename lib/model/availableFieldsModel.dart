
class AvailableFieldsModel {
  AvailableFieldsModel({
    required this.id,
    required this.name,
    required this.minPerson,
    required this.maxPerson,
    required this.image,
    required this.sportData,
  });

  int id;
  String name;
  int minPerson;
  int maxPerson;
  String image;
  SportData sportData;

  factory AvailableFieldsModel.fromJson(Map<String, dynamic> json) => AvailableFieldsModel(
    id: json["id"],
    name: json["name"],
    minPerson: json["min_person"],
    maxPerson: json["max_person"],
    image: json["image"],
    sportData: SportData.fromJson(json["sport_data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "min_person": minPerson,
    "max_person": maxPerson,
    "image": image,
    "sport_data": sportData.toJson(),
  };
  static List<AvailableFieldsModel> getListFromJson(List<dynamic> list){
    List<AvailableFieldsModel> fetchedList=[];
    list.forEach((unit) => fetchedList.add(AvailableFieldsModel.fromJson(unit)));
    return fetchedList;

  }
}

class SportData {
  SportData({
    required this.id,
    required this.name,
    required this.image,
  });

  int id;
  String name;
  String image;

  factory SportData.fromJson(Map<String, dynamic> json) => SportData(
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
