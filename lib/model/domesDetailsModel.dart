class DomesDetailsModel {
  DomesDetailsModel({
    required this.id,
    required this.totalFields,
    required this.name,
    required this.price,
    required this.hst,
    required this.city,
    required this.state,
    required this.address,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.lat,
    required this.lng,
    required this.benefitsDescription,
    required this.rattingData,
    required this.benefits,
    required this.sportsList,
    required this.domeImages,
    this.closedDays,
    this.currentTime,

  });

  int id;
  int totalFields;
  String name;
  double price;
  double hst;
  String city;
  String state;
  String address;
  String startTime;
  String endTime;
  String description;
  String lat;
  String lng;
  String benefitsDescription;
  RattingData rattingData;
  List<Benefit> benefits;
  List<SportsList> sportsList;
  List<DomeImage> domeImages;
  List<int>? closedDays;
  DateTime? currentTime;

  factory DomesDetailsModel.fromJson(Map<String, dynamic> json) => DomesDetailsModel(
    id: json["id"],
    totalFields: json["total_fields"],
    name: json["name"],
    price: json["price"]?.toDouble(),
    hst: json["hst"]?.toDouble(),
    city: json["city"],
    state: json["state"],
    address: json["address"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    description: json["description"],
    lat: json["lat"],
    lng: json["lng"],
    benefitsDescription: json["benefits_description"]??"hey test",
    rattingData: RattingData.fromJson(json["ratting_data"]),
    benefits: List<Benefit>.from(json["benefits"].map((x) => Benefit.fromJson(x))),
    sportsList: List<SportsList>.from(json["sports_list"].map((x) => SportsList.fromJson(x))),
    domeImages: List<DomeImage>.from(json["dome_images"].map((x) => DomeImage.fromJson(x))),
    closedDays: json["closed_days"] == null ? [] : List<int>.from(json["closed_days"]!.map((x) => x)),
    currentTime: json["current_time"] == null ? null : DateTime.parse(json["current_time"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total_fields": totalFields,
    "name": name,
    "price": price,
    "hst": hst,
    "address": address,
    "city": city,
    "state": state,
    "start_time": startTime,
    "end_time": endTime,
    "description": description,
    "lat": lat,
    "lng": lng,
    "benefits_description": benefitsDescription,
    "ratting_data": rattingData.toJson(),
    "benefits": List<dynamic>.from(benefits.map((x) => x.toJson())),
    "sports_list": List<dynamic>.from(sportsList.map((x) => x.toJson())),
    "dome_images": List<dynamic>.from(domeImages.map((x) => x.toJson())),
    "closed_days": closedDays == null ? [] : List<dynamic>.from(closedDays!.map((x) => x)),
    "current_time": currentTime?.toIso8601String(),

  };
}

class Benefit {
  Benefit({
    required this.benefit,
    required this.benefitImage,
  });

  String benefit;
  String benefitImage;

  factory Benefit.fromJson(Map<String, dynamic> json) => Benefit(
    benefit: json["benefit"],
    benefitImage: json["benefit_image"],
  );

  Map<String, dynamic> toJson() => {
    "benefit": benefit,
    "benefit_image": benefitImage,
  };
}

class DomeImage {
  DomeImage({
    required this.id,
    required this.domeId,
    required this.image,
  });

  int id;
  int domeId;
  String image;

  factory DomeImage.fromJson(Map<String, dynamic> json) => DomeImage(
    id: json["id"],
    domeId: json["dome_id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dome_id": domeId,
    "image": image,
  };
}

class RattingData {
  RattingData({
    required this.avgRating,
    required this.totalReview,
    required this.images,
  });

  String avgRating;
  int totalReview;
  List<String> images;

  factory RattingData.fromJson(Map<String, dynamic> json) => RattingData(
    avgRating: json["avg_rating"],
    totalReview: json["total_review"],
    images: List<String>.from(json["images"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "avg_rating": avgRating,
    "total_review": totalReview,
    "images": List<dynamic>.from(images.map((x) => x)),
  };
}

class SportsList {
  SportsList({
    required this.sportId,
    required this.sportName,
    required this.sportImage,
  });

  int sportId;
  String sportName;
  String sportImage;

  factory SportsList.fromJson(Map<String, dynamic> json) => SportsList(
    sportId: json["id"],
    sportName: json["name"],
    sportImage: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "sport_id": sportId,
    "sport_name": sportName,
    "sport_image": sportImage,
  };
}

class WorkingHour {
  String? day;
  int? isClosed;

  WorkingHour({
    this.day,
    this.isClosed,
  });

  factory WorkingHour.fromJson(Map<String, dynamic> json) => WorkingHour(
    day: json["day"],
    isClosed: json["is_closed"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "is_closed": isClosed,
  };
}
