import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/ratingListModel.dart';
import '../service/getAPI.dart';
import 'domesDetailsController.dart';

class RatingListController extends GetxController {

  var myList = List<RatingListModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;
  StreamSubscription? subscription;
  var isoffline = false.obs;
  var type =1.obs;
  DomesDetailsController mycontroller = Get.put(DomesDetailsController());


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
    print("sriti");

    // TODO: implement onInit
    super.onInit();
    getTask();
    checkNetwork();
  }



  Future<void> getTask() async {
    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {
        print("sriti");

        TaskProvider().getRatingsList(did: mycontroller.domeId.value).then((resp) {
          print("Heyyylooow");
          if(resp!=null) {
            print("Heyyylooow");

            isDataProcessing.value = false;
            myList.clear();
            myList.addAll(resp);

          }
          else{
            isDataProcessing.value = false;

          }

        }, onError: (err) {
          isDataProcessing.value = false;
          showSnackbar("Error", err.toString(), Colors.red);
        });
      }
    } catch (e) {
      isDataProcessing.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
    }
  }

  showSnackbar(title, message, color) {
    Get.snackbar(title, message,
        colorText: Colors.white, backgroundColor: color);
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}
