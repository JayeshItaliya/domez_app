import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../commonModule/Strings.dart';
import '../model/domesListModel.dart';
import '../service/getAPI.dart';
import 'categoryController.dart';
import 'commonController.dart';

class DomesListController extends GetxController {

  var myList1 = List<DomesListModel>.empty(growable: true).obs;
  var myList2 = List<DomesListModel>.empty(growable: true).obs;
  var myList3 = List<DomesListModel>.empty(growable: true).obs;
  var isDataProcessing1 = false.obs;
  var isDataProcessing2 = false.obs;
  var isDataProcessing3 = false.obs;
  ScrollController scrollController = ScrollController();
  StreamSubscription? subscription;
  var isoffline = false.obs;

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
    if (cx.read("id") == null) cx.write('id', 0);

    cx.id.value=cx.read("id");
    print(cx.read("id"));
    print("Soham");

    // TODO: implement onInit
    super.onInit();

    getTask1(sportid.value);
    getTask2(sportid.value);
    getTask3(sportid.value);
    checkNetwork();
  }

  Future<void> getTask1(String sid) async {

    if(cx.read("islogin")??false){
      try {

        print("dome1");
        isDataProcessing1.value = true;

        if (isoffline.value == false) {
          print(cx.read("id"));
          print(sid.toString());
          print(cx.read('id'));


          TaskProvider().getDomesList(
            type: "1",
            uid: cx.read("id").toString(),
            lat:'',
            lng:'',
            sportId: sid.toString(),

          ).then((resp) {
            print("SOMU3");

            if(resp!=null) {
              isDataProcessing1.value = false;
              myList1.clear();
              myList1.addAll(resp);
              print("LOL");
            }
            else{
              print("Oops! Null Response");
              isDataProcessing1.value = false;

            }

          }, onError: (err) {
            isDataProcessing1.value = false;
            showSnackbar("Error", err.toString(), Colors.red);
          });
        }
      } catch (e) {
        isDataProcessing1.value = false;
        showSnackbar("Exception", e.toString(), Colors.red);
      }
    }
    return null;
  }
  Future<void> getTask2(String sid) async {
    try {
      print("dome2");

      isDataProcessing2.value = true;

      if (isoffline.value == false) {
        TaskProvider().getDomesList(
          type: "2",
          uid: cx.read("id").toString(),
          lat:'',
          lng:'',
          sportId:sid.toString(),
        ).then((resp) {
          print("SOMU2");

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
  Future<void> getTask3(String sid) async {
    print("dome3");

  try {
      isDataProcessing3.value = true;

      if (isoffline.value == false) {
        TaskProvider().getDomesList(
          type: "3",
          uid: cx.read("id").toString(),
          lat: cx.read(Keys.lat).toString(),
          lng: cx.read(Keys.lng).toString(),
          sportId:sid.toString(),

        ).then((resp) {
          print("SOMU4");

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
    print("hi");
    sportid.value=cid;
    getTask1(cid);
    getTask2(cid);
    getTask3(cid);

  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}
