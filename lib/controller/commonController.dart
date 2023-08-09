import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;

import '../commonModule/Constant.dart';
import '../commonModule/utils.dart';

class CommonController extends GetxController{
  var isDataProcessing = false.obs;
  var connectionStatus = 0.obs;
  late StreamSubscription<InternetConnectionStatus> listener;



  var index=0.obs;
  final storage = GetStorage();
  StreamSubscription? subscription;
  var isoffline = false.obs;
  var height=Get.height;
  var width=Get.width;
  var curIndex=0.obs;
  var searchDome="".obs;

  var profilePicture="".obs;

  var s4complete=false.obs;


  //calendarPicker Section
  var selDate = DateFormat.d().format(DateTime.now()).obs;
  var selMonth = DateFormat.MMM().format(DateTime.now()).obs;
  var selYear = DateFormat.y().format(DateTime.now()).obs;
  var fullDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;
  var currentDate = DateTime.now().obs;

  //-----------BookSlot Page---------//
  List<int> globalSelectedIndex =  List<int>.empty(growable: true).obs;
  var globalPrice=0.0.obs;


  //-----------Fields Page---------//
  List<int> globalAvailableFieldIndex =  List<int>.empty(growable: true).obs;
  List<String> globalAvailableFieldName =  List<String>.empty(growable: true).obs;


  //-----------Fields Page---------//
  var price=0.0.obs;


  var isSplitAmount=false.obs;

  var isconfirm=true.obs;
  var isprocessing=false.obs;
  var isfailed=false.obs;
  var issuccessful=false.obs;

  var type=1.obs;
  var msg="".obs;

  var id=0.obs;
  var name="".obs;
  var email="".obs;
  var phone="".obs;
  var countrycode="".obs;
  var image="".obs;
  var isLogin=false.obs;
  var isVerified=false.obs;
  var isReset=false.obs;

  var lat="".obs;
  var lng="".obs;
  final GlobalKey<FormState> ChangePassFormKey = GlobalKey<FormState>();

  var totalFavourites = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //
    // listener = InternetConnectionChecker()
    //     .onStatusChange
    //     .listen((InternetConnectionStatus status) {
    //   switch (status) {
    //     case InternetConnectionStatus.connected:
    //       connectionStatus.value = 1;
    //       break;
    //     case InternetConnectionStatus.disconnected:
    //       connectionStatus.value = 0;
    //       break;
    //   }
    // });

    checkNetwork();
    // initMethod();
  }

  // void initMethod(){
  //
  //   index=0.obs;
  //   // subscription;
  //   isoffline = false.obs;
  //   height=Get.height;
  //   width=Get.width;
  //   curIndex=0.obs;
  //   searchDome="".obs;
  //   s4complete=false.obs;
  //   // mePicker Section
  //   totalBookingDuration=01.obs;
  //   totalBookingPrice=35.obs;
  //   initialTime="3pm".obs;
  //   endTime="7pm".obs;
  //   initialIndex=0.obs;
  //   // lendarPicker Section
  //   selDate = DateFormat.d().format(DateTime.now()).obs;
  //   selMonth = DateFormat.MMM().format(DateTime.now()).obs;
  //   fullDate = DateFormat.y().format(DateTime.now()).obs;
  //
  //
  //
  // }
  dynamic read(String key){
    return storage.read('$key');
  }

  void write(String key,var value){
    storage.write('$key',value);
  }

  double responsive(double tabletDevice,double bigMobileDevice,double smallMobileDevice,){
  return Get.width>550?tabletDevice:
         Get.width>400?bigMobileDevice:
         smallMobileDevice;
  }
  checkNetwork() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {

        isoffline.value = true;
      } else if (result == ConnectivityResult.mobile) {
        isoffline.value = false;
      } else if (result == ConnectivityResult.wifi) {
        isoffline.value = false;
      } else {
        Get.snackbar("Network Error", "Failed to get network connection");
        isoffline.value = false;
      }
    });
  }


  Future favourite({String? uid, String? did,String? type,String? lid}) async {
    print("Fav");
    if(type=="1"){
      print(type.toString()+did.toString());
    }
    else{
      print(type.toString()+lid.toString());
    }
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Constant.favourite));

      request.fields.addAll({
        'user_id': uid.toString(),
        'type': type.toString(),
        'dome_id': did.toString(),
        'league_id': lid.toString(),
      });
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {
        print(uid.toString(),);
        print("domeId"+did.toString());
        print("leagueId"+lid.toString());
        print(jsonBody.toString());
      } else {
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }
}