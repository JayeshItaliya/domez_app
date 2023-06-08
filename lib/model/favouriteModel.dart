
class FavouriteModel {
  FavouriteModel({
    required this.id,
    required this.leagueName,
    required this.domeName,
    required this.isFav,
    required this.image,
    required this.price,
    required this.city,
    required this.state,
    required this.sportsList,
  });

  int id;
  String leagueName;
  String domeName;
  bool isFav;
  String image;
  int price;
  String city;
  String state;
  List<SportsList> sportsList;

  factory FavouriteModel.fromJson(Map<String, dynamic> json) => FavouriteModel(
    id: json["id"],
    leagueName: json["league_name"],
    domeName: json["dome_name"],
    isFav: true,
    image: json["image"],
    price: json["price"],
    city: json["city"],
    state: json["state"],
    sportsList: List<SportsList>.from(json["sports_list"].map((x) => SportsList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "league_name": leagueName,
    "dome_name": domeName,
    "isFav": isFav,
    "image": image,
    "price": price,
    "city": city,
    "state": state,
    "sports_list": List<dynamic>.from(sportsList.map((x) => x.toJson())),
  };
  static List<FavouriteModel> getListFromJson(List<dynamic> list){
    List<FavouriteModel> fetchedList=[];
    list.forEach((unit) => fetchedList.add(FavouriteModel.fromJson(unit)));
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
