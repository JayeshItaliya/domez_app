
class LeagueDetailsModel {
  LeagueDetailsModel({
    required this.id,
    required this.leagueName,
    required this.domeName,
    required this.fields,
    required this.days,
    required this.totalGames,
    required this.time,
    required this.date,
    required this.gender,
    required this.age,
    required this.sport,
    required this.teamLimit,
    required this.minPlayer,
    required this.maxPlayer,
    required this.price,
    required this.hst,
    required this.address,
    required this.city,
    required this.state,
    required this.lat,
    required this.lng,
    required this.amenitiesDescription,
    required this.leagueImages,
    required this.amenities,
    required this.bookingDeadline,
    required this.isFav,
    required this.currentTime,


  });

  int id;
  String leagueName;
  String domeName;
  String fields;
  String days;
  String totalGames;
  String time;
  String date;
  String gender;
  String age;
  String sport;
  String teamLimit;
  String minPlayer;
  String maxPlayer;
  int price;
  int hst;
  String address;
  String city;
  String state;
  String lat;
  String lng;
  String amenitiesDescription;
  List<LeagueImage> leagueImages;
  List<Amenity> amenities;
  DateTime bookingDeadline;
  bool isFav;
  DateTime currentTime;

  factory LeagueDetailsModel.fromJson(Map<String, dynamic> json) => LeagueDetailsModel(
    id: json["id"],
    leagueName: json["league_name"],
    domeName: json["dome_name"],
    fields: json["fields"],
    days: json["days"],
    totalGames: json["total_games"],
    time: json["time"],
    date: json["date"],
    gender: json["gender"],
    age: json["age"],
    sport: json["sport"],
    teamLimit: json["team_limit"],
    minPlayer: json["min_player"],
    maxPlayer: json["max_player"],
    price: json["price"],
    hst: json["hst"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    lat: json["lat"],
    lng: json["lng"],
    amenitiesDescription: json["amenities_description"]??"No Description Available",
    leagueImages: List<LeagueImage>.from(json["league_images"].map((x) => LeagueImage.fromJson(x))),
    amenities: List<Amenity>.from(json["amenities"].map((x) => Amenity.fromJson(x))),
    bookingDeadline: DateTime.parse(json["booking_deadline"]),
    isFav: json["is_fav"],
    currentTime: DateTime.parse(json["current_time"]),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "league_name": leagueName,
    "dome_name": domeName,
    "fields": fields,
    "days": days,
    "total_games": totalGames,
    "time": time,
    "date": date,
    "gender": gender,
    "age": age,
    "sport": sport,
    "team_limit": teamLimit,
    "min_player": minPlayer,
    "max_player": maxPlayer,
    "price": price,
    "hst": hst,
    "address": address,
    "city": city,
    "state": state,
    "lat": lat,
    "lng": lng,
    "amenities_description": amenitiesDescription,
    "league_images": List<dynamic>.from(leagueImages.map((x) => x.toJson())),
    "amenities": List<dynamic>.from(amenities.map((x) => x.toJson())),
    "booking_deadline": "${bookingDeadline.year.toString().padLeft(4, '0')}-${bookingDeadline.month.toString().padLeft(2, '0')}-${bookingDeadline.day.toString().padLeft(2, '0')}",
    "is_fav": isFav,
    "current_time": currentTime.toIso8601String(),
  };
}

class Amenity {
  Amenity({
    required this.benefit,
    required this.benefitImage,
  });

  String benefit;
  String benefitImage;

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
    benefit: json["benefit"],
    benefitImage: json["benefit_image"],
  );

  Map<String, dynamic> toJson() => {
    "benefit": benefit,
    "benefit_image": benefitImage,
  };
}

class LeagueImage {
  LeagueImage({
    required this.id,
    required this.leagueId,
    required this.image,
  });

  int id;
  int leagueId;
  String image;

  factory LeagueImage.fromJson(Map<String, dynamic> json) => LeagueImage(
    id: json["id"],
    leagueId: json["league_id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "league_id": leagueId,
    "image": image,
  };
}
