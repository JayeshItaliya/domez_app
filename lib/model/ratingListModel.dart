
class RatingListModel {
  RatingListModel({
    required this.userId,
    required this.userName,
    required this.ratting,
    required this.createdAt,
    required this.domeName,
    required this.domeOwnerName,
    required this.comment,
    required this.replyMessage,
    required this.repliedAt,
    required this.userImage,
  });

  int userId;
  String userName;
  int ratting;
  String createdAt;
  String domeName;
  String domeOwnerName;
  String comment;
  String replyMessage;
  String repliedAt;
  String userImage;

  factory RatingListModel.fromJson(Map<String, dynamic> json) => RatingListModel(
    userId: json["user_id"],
    userName: json["user_name"],
    ratting: json["ratting"],
    createdAt: json["created_at"],
    domeName: json["dome_name"],
    domeOwnerName: json["dome_owner_name"],
    comment: json["comment"],
    replyMessage: json["reply_message"],
    repliedAt: json["replied_at"],
    userImage: json["user_image"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_name": userName,
    "ratting": ratting,
    "created_at": createdAt,
    "dome_name": domeName,
    "dome_owner_name": domeOwnerName,
    "comment": comment,
    "reply_message": replyMessage,
    "replied_at": repliedAt,
    "user_image": userImage,
  };
  static List<RatingListModel> getListFromJson(List<dynamic> list){
    List<RatingListModel> fetchedList=[];
    list.forEach((unit) => fetchedList.add(RatingListModel.fromJson(unit)));
    return fetchedList;
  }
}
