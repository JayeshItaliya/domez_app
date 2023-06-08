import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:domez/model/FilterModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../commonModule/Constant.dart';
import '../commonModule/Strings.dart';
import '../service/getAPI.dart';

class FilterListController extends GetxController {

  var myList = List<FilterModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;

  ScrollController scrollController = ScrollController();
  StreamSubscription? subscription;
  var isoffline = false.obs;
  var isFilterPage = false.obs;
  var type ="1".obs;
  var sportId ="".obs;
  var minPrice ="".obs;
  var maxPrice ="".obs;
  var distance ="".obs;
  var page = 1;
  var isMoreDataAvailable = false.obs;


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
    // getTask(isFilterPage.value);
    paginateTask();
    checkNetwork();
  }

  void updateData() {

    page = 1;
    getTask(false);
  }

  Future<void> getTask(bool isFilterPage) async {
    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {
        print("cx.lat");
        print(cx.read(Keys.lat));
        print(cx.read(Keys.lng));

        TaskProvider().getFilterList(type: type.value,sportId: sportId.value,lat: cx.read(Keys.lat),lng: cx.read(Keys.lng),userId: cx.read("id").toString(),
            distance: distance.value,maxPrice: maxPrice.value,minPrice: minPrice.value,page: page.toString()).then((resp) {
          if(resp!=null) {
            print("Filteringggg");

            if(isFilterPage){
              Get.back();
            }

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


  void paginateTask() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reach End");
        page++;
        getMoreTask(page);
      }
    });
  }

  void getMoreTask(int page) {
    try {
      isMoreDataAvailable.value = true;
      TaskProvider().getFilterList(
          type: type.value,sportId: sportId.value,lat: cx.read(Keys.lat),lng: cx.read(Keys.lng),userId: cx.read("id").toString(),
          distance: distance.value,maxPrice: maxPrice.value,minPrice: minPrice.value,page: page.toString()
      )
          .then((resp) {
        if (resp!.length > 0) {
          isMoreDataAvailable.value = true;
          myList.addAll(resp);

        } else {
          isMoreDataAvailable.value = false;
          showLongToast("No more data");
        }
      }, onError: (err) {
        isDataProcessing.value = false;
        showSnackbar("Error", err.toString(), Colors.red);
      });
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
