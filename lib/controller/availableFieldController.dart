import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/availableFieldsModel.dart';
import '../service/getAPI.dart';

class AvailableFieldController extends GetxController {

  var myList = List<AvailableFieldsModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;
  StreamSubscription? subscription;
  var isoffline = false.obs;


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
    // TODO: implement onInit
    super.onInit();

    getTask();
    checkNetwork();
  }

  Future<void> getTask() async {
    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {
        TaskProvider().getAvailableFields().then((resp) {
          if(resp!=null){
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
