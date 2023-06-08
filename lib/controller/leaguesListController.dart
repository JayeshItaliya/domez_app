import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../commonModule/Strings.dart';
import '../model/leagueListModel.dart';
import '../service/getAPI.dart';
import 'categoryController.dart';
import 'commonController.dart';

class LeagueListController extends GetxController {

  // var myList1 = List<DomesListModel>.empty(growable: true).obs;
  var myList2 = List<LeagueListModel>.empty(growable: true).obs;
  var myList3 = List<LeagueListModel>.empty(growable: true).obs;
  var isDataProcessing2 = false.obs;
  var isDataProcessing3 = false.obs;
  ScrollController scrollController = ScrollController();
  StreamSubscription? subscription;
  var isoffline = false.obs;
  var lat="".obs;
  var lng="".obs;
  var sportid="6".obs;
  CommonController cx = Get.put(CommonController());
  CategoryController mycontroller = Get.put(CategoryController());


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

  @override
  void onInit() {
    cx.id.value=cx.read("id");
    print(cx.read("id"));
    print("Soham");

    // TODO: implement onInit
    super.onInit();

    // getTask1(sportid);
    getTask2(sportid.value);
    getTask3(sportid.value);
    checkNetwork();
  }

  // Future<void> getTask1(sportid) async {
  //   try {
  //     isDataProcessing.value = true;
  //
  //     if (isoffline.value == false) {
  //       print(cx.read("id"));
  //       print(mycontroller.sportId.toString());
  //       print(cx.read('id'));
  //
  //
  //       TaskProvider().getDomesList(
  //         type: "1",
  //         uid: "9",
  //         // uid: cx.read("id"),
  //         sportId: sportid.toString(),
  //
  //       ).then((resp) {
  //         if(resp!=null) {
  //           isDataProcessing.value = false;
  //           myList1.clear();
  //           myList1.addAll(resp!);
  //         }
  //         else{
  //           print("Oops! Null Response");
  //
  //         }
  //
  //       }, onError: (err) {
  //         isDataProcessing.value = false;
  //         showSnackbar("Error", err.toString(), Colors.red);
  //       });
  //     }
  //   } catch (e) {
  //     isDataProcessing.value = false;
  //     showSnackbar("Exception", e.toString(), Colors.red);
  //   }
  // }

  Future<void> getTask2(String sportid) async {
    try {
      isDataProcessing2.value = true;
      print("Get ID");
      print(cx.read("id").toString());

      if (isoffline.value == false) {
        TaskProvider().getLeagueList(
          type: "2",
          uid: cx.read("id").toString(),
          lat:'',
          lng: '',
          sportId:sportid.toString(),
        ).then((resp) {
          if(resp!=null){
            isDataProcessing2.value = false;
            myList2.clear();
            myList2.addAll(resp);
          }
          else{
            isDataProcessing2.value = false;

            print("Oops! Null Response");
          }

        }, onError: (err) {
          isDataProcessing2.value = false;
          showSnackbar("Error", err.toString(), Colors.red);
        });
      }
    } catch (e) {
      isDataProcessing2.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
    }
  }
  Future<void> getTask3(String sportid) async {
    try {
      isDataProcessing3.value = true;

      if (isoffline.value == false) {
        TaskProvider().getLeagueList(
          type: "3",
          uid: cx.read("id").toString(),
          lat: cx.read(Keys.lat),
          lng: cx.read(Keys.lng),
          sportId:sportid.toString(),

        ).then((resp) {
          if(resp!=null) {
            isDataProcessing3.value = false;
            myList3.clear();
            myList3.addAll(resp);
          }
          else{
            isDataProcessing3.value = false;

            print("Oops! Null Response");

          }
        }, onError: (err) {
          isDataProcessing3.value = false;
          showSnackbar("Error", err.toString(), Colors.red);
        });
      }
    } catch (e) {
      isDataProcessing3.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
    }
  }

  showSnackbar(title, message, color) {
    Get.snackbar(title, message,
        colorText: Colors.white, backgroundColor: color);
  }
  sportsUpdate(cid){

    sportid.value=cid;
    // getTask1(cid);
    getTask2(cid);
    getTask3(cid);

  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}
