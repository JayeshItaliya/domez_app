import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/bookingListModel.dart';
import '../service/getAPI.dart';

class BookListController extends GetxController {

  var myList = List<BookingListModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;

  ScrollController scrollController = ScrollController();
  StreamSubscription? subscription;
  var isoffline = false.obs;
  var type =1.obs;


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
    getTask(type.value.toString());
    checkNetwork();
  }



  Future<void> getTask(String type) async {
    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {
        print("sriti");

        TaskProvider().getBookList(type: type).then((resp) {
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
