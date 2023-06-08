
class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  int id;
  String name;
  String image;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
  static List<CategoryModel> getListFromJson(List<dynamic> list){
    List<CategoryModel> fetchedList=[];

    list.forEach((unit) {

      fetchedList.add(CategoryModel.fromJson(unit));
    });
    return fetchedList;
  }
}
