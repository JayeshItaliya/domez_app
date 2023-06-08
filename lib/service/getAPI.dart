import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import '../commonModule/Constant.dart';
import 'package:http/http.dart'as http;
import '../commonModule/Strings.dart';
import '../model/FilterModel.dart';
import '../model/LeagueDetailsModel.dart';
import '../model/availableFieldsModel.dart';
import '../model/bookingDetailsModel.dart';
import '../model/bookingListModel.dart';
import '../model/ratingListModel.dart';
import '../model/timeSlots.dart';
import '../model/categoryModel.dart';
import '../model/domesDetailsModel.dart';
import '../model/domesListModel.dart';
import '../model/favouriteModel.dart';
import '../model/leagueListModel.dart';


class TaskProvider extends GetConnect {
  Future<String?> getStripeKey() async {
    try {

      print("Stripe API CAlling1");
      var request = http.MultipartRequest('GET', Uri.parse(Constant.getStripeKey));

      print(request.fields.toString());


      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {
        print("Stripe API CAlling2");

        print(jsonBody.toString());

        String jsonBody1 = jsonBody['data']['public_key'];
        String jsonBody2 = jsonBody['data']['secret_key'];
        print("Stripe Publishable Key");

        cx.write(Keys.publishableStripeKey,jsonBody1);
        cx.write(Keys.secretStripeKey,jsonBody2);


        print(jsonBody1);
        // List <FavouriteModel>? data=FavouriteModel.getListFromJson(jsonBody1);

        return jsonBody1;
      } else {
        print("Stripe API CAlling3");

        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }

  Future<List<CategoryModel>?> getCategoryList() async {
    try {
      var request = http.MultipartRequest('GET', Uri.parse(Constant.categoryList));


      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      print(jsonBody.toString());

      if (jsonBody['status'] == 1) {
        print("SUCCESS");
        print(jsonBody.toString());
        List<dynamic> jsonBody1 = jsonBody['sportslist'];
        List <CategoryModel>? dataList=CategoryModel.getListFromJson(jsonBody1);
        return dataList;
      } else {
        print("FAILURE");

        print(jsonBody);
      }
    } catch (e) {
      print("Category List");
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;
  } // Fetch Data


  Future<List<DomesListModel>?> getDomesList({String? type,String? uid,String? lat,String? lng,String? sportId}) async {
    try {
      print("lat lng");
      print(lat.toString());
      print(lng.toString());
      print(cx.lat.value);
      print(cx.lng.value);
      print(cx.read(Keys.lat).toString());
      print(cx.read(Keys.lng).toString());

      var request = http.MultipartRequest('POST', Uri.parse(Constant.domesList));
      request.fields.addAll({
        'type': type.toString(),
        'user_id': uid.toString()=="0"?"":uid.toString(),
        'lat': lat.toString(),
        'lng': lng.toString(),
        'sport_id':sportId.toString()

      });

      print(request.fields.toString());

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {

        print(jsonBody.toString());
        List<dynamic> jsonBody1 = jsonBody['domes_list'];
        List <DomesListModel>? data=DomesListModel.getListFromJson(jsonBody1);
        print("SOLVED1");

        return data;
      } else {
        print(jsonBody);
      }
    } catch (e) {
      print("SOMU1");
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;
  }

  Future<List<DomesDetailsModel>?> getDomesDetails({String? did}) async {
    print("ABHI");
    print(did.toString());
    if(did.toString().isEmpty)
      {
        print("DID IS EMPTY");
      }
    try {
      var request = http.MultipartRequest('GET', Uri.parse(Constant.domesDetails+did.toString()));
      print(Constant.domesDetails+did.toString());
      print(Uri.parse(Constant.domesDetails+did.toString()));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      // print(jsonBody.toString());

      if (jsonBody['status'] == 1) {
        print(jsonBody.toString());
        var jsonBody1 = jsonBody['dome_details'];

        List <DomesDetailsModel> data=[];
        DomesDetailsModel? data1=DomesDetailsModel.fromJson(jsonBody1);

        data.add(data1);
        cx.write(Keys.domeId,data1.id);
        cx.write(Keys.domeName,data1.name);
        cx.write(Keys.hstPercent,data1.hst/100);
        cx.write(Keys.address,data1.address);
        cx.write(Keys.city,data1.city);
        cx.write(Keys.state,data1.state);

        return data;
      } else {
        print(jsonBody.toString());
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }

  Future<List<LeagueListModel>?> getLeagueList({String? type,String? uid,String? lat,String? lng,String? sportId}) async {
    try {


      var request = http.MultipartRequest('POST', Uri.parse(Constant.leaguesList));
      request.fields.addAll({
        'type': type.toString(),
        'user_id': uid.toString()=="0"?"":uid.toString(),
        'lat': lat.toString(),
        'lng': lng.toString(),
        'sport_id':sportId.toString()

      });
      print(request.fields.toString());

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {

        print(jsonBody.toString());
        List<dynamic> jsonBody1 = jsonBody['leagues_list'];
        List <LeagueListModel>? data=LeagueListModel.getListFromJson(jsonBody1);

        return data;
      } else {
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }

  Future<List<LeagueDetailsModel>?> getLeagueDetails({String? lid}) async {
    print("ABHI");
    print(lid.toString());
    if(lid.toString().isEmpty)
      {
        print("LID IS EMPTY");
      }
    try {
      var request = http.MultipartRequest('GET', Uri.parse(Constant.leagueDetails+lid.toString()));
      print(Constant.leagueDetails+lid.toString());
      print(Uri.parse(Constant.leagueDetails+lid.toString()));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {
        print(jsonBody.toString());
        var jsonBody1 = jsonBody['league_details'];

        List <LeagueDetailsModel> data=[];
        LeagueDetailsModel? data1=LeagueDetailsModel.fromJson(jsonBody1);
        data.add(data1);

        cx.write(LKeys.leagueName,data1.leagueName);
        cx.write(LKeys.domeName,data1.domeName);
        cx.write(LKeys.leagueId,data1.id);
        cx.write(LKeys.address,data1.address);
        cx.write(LKeys.hstPercent,data1.hst/100);
        cx.write(LKeys.city,data1.city);
        cx.write(LKeys.state,data1.state);
        cx.write(LKeys.fieldName,data1.fields);
        cx.write(LKeys.time,data1.time);
        cx.write(LKeys.date,data1.date);
        cx.write(LKeys.days,data1.days);
        cx.write(LKeys.totalGames,data1.totalGames);
        cx.write(LKeys.price,data1.price);
        cx.write(LKeys.leagueDeadline,data1.bookingDeadline);


        print(data);

        return data;
      } else {
        print(jsonBody.toString());
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }

  Future<List<LeagueDetailsModel>?> getPushNotifcation() async {
    try {
      var request = http.MultipartRequest('GET', Uri.parse(Constant.pushNotification));


      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      print(jsonBody.toString());

      if (jsonBody['status'] == 1) {
        print(jsonBody.toString());
        var jsonBody1 = jsonBody['league_details'];

        List <LeagueDetailsModel> data=[];
        LeagueDetailsModel? data1=LeagueDetailsModel.fromJson(jsonBody1);
        data.add(data1);
        print(data);

        return data;
      } else {
        print(jsonBody.toString());
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  } // Fetch Data
// Fetch Data
  Future<List<TimeSlotsModel>?> getAvailableSlots(String? did,String? sid) async {
    try {



      print("Heyyyy2343d");
      print(cx.read(Keys.fullDate));
      print(did.toString(),);
      print(sid.toString());


      var request = http.MultipartRequest('POST', Uri.parse(Constant.getTimeSlots));
      request.fields.addAll({
        // 'date': '23-02-2023',
        // 'dome_id': '35',
        // 'sport_id': '6'
      'date':cx.read(Keys.fullDate),
      'dome_id': did.toString(),
      'sport_id': sid.toString()
      });

      print(request.fields.toString());

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {

        print(jsonBody.toString());
        List<dynamic> jsonBody1 = jsonBody['data'];

        List <TimeSlotsModel>? data=TimeSlotsModel.getListFromJson(jsonBody1);

        return data;
      } else {
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }


  Future<List<FavouriteModel>?> getFavList({String? type}) async {
    try {


      var request = http.MultipartRequest('POST', Uri.parse(Constant.favouriteList));
      request.fields.addAll({
        'user_id': cx.read("id").toString(),
        'type': type.toString()
      });

      print(request.fields.toString());


      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {

        print(jsonBody.toString());

        List<dynamic> jsonBody1 = jsonBody['data_list'];
        List <FavouriteModel>? data=FavouriteModel.getListFromJson(jsonBody1);

        return data;
      } else {
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }
  Future<List<BookingListModel>?> getBookList({String? type}) async  {
    try {

      print("type");
      print(type.toString());

      var request = http.MultipartRequest('POST', Uri.parse(Constant.bookingList));
      request.fields.addAll({
        'user_id': cx.read("id").toString(),
        'is_active': type.toString()
      });
      print(request.fields.toString());

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {

        print(jsonBody.toString());

        List<dynamic> jsonBody1 = jsonBody['bookings_list'];
        List <BookingListModel>? data=BookingListModel.getListFromJson(jsonBody1);

        return data;
      } else {
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }
  Future<List<BookingDetailsModel>?> getBookingDetails({String? bid}) async {
    print(bid.toString());
    if(bid.toString().isEmpty)
    {
      print("DID IS EMPTY");
    }
    try {
      var request = http.MultipartRequest('GET', Uri.parse(Constant.bookingDetails+bid.toString()));
      print(Constant.bookingDetails+bid.toString());
      print(Uri.parse(Constant.bookingDetails+bid.toString()));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      print("booking_details3");
      print(jsonBody.toString());

      if (jsonBody['status'] == 1) {
        print(jsonBody.toString());
        var jsonBody1 = jsonBody['booking_details'];

        List <BookingDetailsModel> data=[];
        BookingDetailsModel? data1=BookingDetailsModel.fromJson(jsonBody1);
        data.add(data1);
        print(data);

        return data;
      } else {
        print(jsonBody.toString());
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  } //

  Future<List<RatingListModel>?> getRatingsList({String? did}) async {
    try {


      print("type");

      var request = http.MultipartRequest('GET', Uri.parse(Constant.ratingsList+did.toString()));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {

        print(jsonBody.toString());

        List<dynamic> jsonBody1 = jsonBody['rattinglist']['data'];

        List <RatingListModel>? data=RatingListModel.getListFromJson(jsonBody1);

        return data;
      } else {
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }
  Future<List<AvailableFieldsModel>?> getAvailableFields() async {
    try {

      var request = http.MultipartRequest('POST', Uri.parse(Constant.availableFields));
      request.fields.addAll({
        'dome_id':cx.read(Keys.domeId).toString(),
        'sport_id':cx.read(Keys.sportId).toString(),
        'date':cx.read(Keys.fullDate).toString(),
        'start_time' :cx.read(Keys.startTime).toString().substring(0,8),
        'end_time':cx.read(Keys.endTime).toString().substring(11,19),
        'players':   cx.read(Keys.players).toString(),
        'slots':   cx.read(Keys.slotsList).toString(),
      });

      print(request.toString());
      print(request.fields.toString());


      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      print("SOLVED1");

      if (jsonBody['status'] == 1) {

        print(jsonBody.toString());
        List<dynamic> jsonBody1 = jsonBody['fields'];
        List <AvailableFieldsModel>? data=AvailableFieldsModel.getListFromJson(jsonBody1);

        return data;
      } else {
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }

  Future<List<FavouriteModel>?> getSearchList(String type,name) async {
    try {

      print("Searching...");
      print(type);
      print(name);
      var request = http.MultipartRequest('POST', Uri.parse(Constant.search));
      request.fields.addAll({
        'name': name,
        'type': type
      });
      print(request.toString());
      print(request.fields.toString());


      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {
        print("Search Successful");

        print(jsonBody.toString());
        List<dynamic> jsonBody1 = jsonBody['data'];
        List <FavouriteModel>? data=FavouriteModel.getListFromJson(jsonBody1);

        return data;
      } else {
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }

  Future<List<FilterModel>?> getFilterList({
    String? type,
    String? sportId,
    String? minPrice,
    String? maxPrice,
    String? distance,
    String? userId,
    String? lat,
    String? lng,
    String? page,
  }) async {
    try {

      print("Filtering...");


      var request = http.MultipartRequest('POST', Uri.parse(Constant.filter+"?page="+page.toString()));
      request.fields.addAll({
        'type': type.toString(),
        'sport_id': sportId.toString(),
        'min_price': minPrice.toString(),
        'max_price': maxPrice.toString(),
        'lat': lat.toString(),
        'lng': lng.toString(),
        'user_id': userId.toString(),
        'kilometers': distance.toString(),
      });

      print("Filtered List");
      print(request.fields.toString());


      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {
        print("Filter Successful");

        print(jsonBody.toString());
        List<dynamic> jsonBody1 = jsonBody['data'];
        List <FilterModel>? data=FilterModel.getListFromJson(jsonBody1);

        return data;
      } else {
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
    return null;

  }

  static void postRatings(BuildContext context,int domeId) async {
    onAlert(context: context, type: 1, msg: "Loading...");

    try {
      print("Ratings");
      print(
        cx.read("id").toString(),
      );
      print(
        domeId.toString(),
      );
      print(
        starsValue.toString(),
      );
      print(msgpasscontroller.text);
      var request = http.MultipartRequest('POST', Uri.parse(Constant.review));
      request.fields.addAll({
        'user_id': cx.read("id").toString(),
        'dome_id': domeId.toString(),
        'ratting': starsValue.toString(),
        'comment': msgpasscontroller.text
      });
      print(request.fields);

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {
        print(jsonBody.toString());
        onAlert(context: context, type: 2, msg: jsonBody['message']);
        // Get.back();

      } else {
        print("Error");
        // Get.back();
        onAlert(context: context, type: 3, msg: jsonBody['message']);
        print(jsonBody);
      }
    } catch (e) {
      showLongToast("Oops! Server Unavailable");
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }


}
