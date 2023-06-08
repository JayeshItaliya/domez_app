
class FilterModel {
  FilterModel({
    required this.id,
    required this.type,
    required this.leagueName,
    required this.domeId,
    required this.domeName,
    required this.price,
    required this.image,
    required this.city,
    required this.state,
    required this.isFav,
    required this.sportId,
    required this.sportsList,
  });

  int id;
  int type;
  String leagueName;
  String domeId;
  String domeName;
  int price;
  String image;
  String city;
  String state;
  bool isFav;
  String sportId;
  List<SportsList> sportsList;

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
    id: json["id"],
    type: json["type"],
    leagueName: json["league_name"],
    domeId: json["dome_id"],
    domeName: json["dome_name"],
    price: json["price"],
    image: json["image"],
    city: json["city"],
    state: json["state"],
    isFav: json["is_fav"],
    sportId: json["sport_id"],
    sportsList: List<SportsList>.from(json["sports_list"].map((x) => SportsList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "league_name": leagueName,
    "dome_id": domeId,
    "dome_name": domeName,
    "price": price,
    "image": image,
    "city": city,
    "state": state,
    "is_fav": isFav,
    "sport_id": sportId,
    "sports_list": List<dynamic>.from(sportsList.map((x) => x.toJson())),
  };
  static List<FilterModel> getListFromJson(List<dynamic> list){
    List<FilterModel> fetchedList=[];
    list.forEach((unit) => fetchedList.add(FilterModel.fromJson(unit)));
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
