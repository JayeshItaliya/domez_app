import 'package:domez/controller/SearchController.dart';
import 'package:domez/controller/favListController.dart';
import 'package:domez/controller/filterListController.dart';
import 'package:domez/controller/leagueDetailsController.dart';
import 'package:domez/controller/leaguesListController.dart';
import 'package:domez/controller/ratingListController.dart';
import 'package:domez/controller/timeSlotsController.dart';
import 'package:get/get.dart';
import 'availableFieldController.dart';
import 'bookListController.dart';
import 'categoryController.dart';
import 'commonController.dart';
import 'domesDetailsController.dart';
import 'domesListController.dart';



class NetworkBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<CommonController>(() => CommonController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<DomesListController>(() => DomesListController());
    Get.lazyPut<AvailableFieldController>(() => AvailableFieldController());
    Get.lazyPut<BookListController>(() => BookListController());
    Get.lazyPut<DomesDetailsController>(() => DomesDetailsController());
    Get.lazyPut<FavListController>(() => FavListController());
    Get.lazyPut<FilterListController>(() => FilterListController());
    Get.lazyPut<LeagueDetailsController>(() => LeagueDetailsController());
    Get.lazyPut<LeagueListController>(() => LeagueListController());
    Get.lazyPut<RatingListController>(() => RatingListController());
    Get.lazyPut<SearchListController>(() => SearchListController());
    Get.lazyPut<TimeSlotsController>(() => TimeSlotsController());
  }
}