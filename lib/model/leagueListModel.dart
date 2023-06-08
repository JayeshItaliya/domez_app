
class LeagueListModel {
  LeagueListModel({
    required this.id,
    required this.leagueName,
    required this.domeName,
    required this.image,
    required this.price,
    required this.city,
    required this.state,
    required this.isFav,
    required this.date,
    required this.sportData,
  });

  int id;
  String leagueName;
  String domeName;
  String image;
  int price;
  String city;
  String state;
  bool isFav;
  String date;
  List<SportDatum> sportData;

  factory LeagueListModel.fromJson(Map<String, dynamic> json) => LeagueListModel(
    id: json["id"],
    leagueName: json["league_name"],
    domeName: json["dome_name"],
    image: json["image"],
    price: json["price"],
    city: json["city"],
    state: json["state"],
    isFav: json["is_fav"],
    date: json["date"],
    sportData: List<SportDatum>.from(json["sport_data"].map((x) => SportDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "league_name": leagueName,
    "dome_name": domeName,
    "image": image,
    "price": price,
    "city": city,
    "state": state,
    "is_fav": isFav,
    "date": date,
    "sport_data": List<dynamic>.from(sportData.map((x) => x.toJson())),
  };
  static List<LeagueListModel> getListFromJson(List<dynamic> list){
    List<LeagueListModel> fetchedList=[];
    list.forEach((unit) => fetchedList.add(LeagueListModel.fromJson(unit)));
    return fetchedList;
  }
}

class SportDatum {
  SportDatum({
    required this.id,
    required this.name,
    required this.image,
  });

  int id;
  String name;
  String image;

  factory SportDatum.fromJson(Map<String, dynamic> json) => SportDatum(
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

