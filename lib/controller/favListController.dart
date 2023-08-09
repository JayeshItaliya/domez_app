import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/favouriteModel.dart';
import '../service/getAPI.dart';

class FavListController extends GetxController {

  var myList = List<FavouriteModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;
  StreamSubscription? subscription;
  var isoffline = false.obs;
  var type =1.obs;
  ScrollController scrollController = ScrollController();
  var reLoadingDataProcessing = false.obs;
  var page = 1;
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
    if(type.value.toString().isNotEmpty){
      getTask(type.value.toString());
    }
    checkNetwork();
    paginateTask(type.value.toString());
  }



  Future<void> getTask(String type) async {
    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {

        TaskProvider().getFavList(type: type,page: 1).then((resp) {
          if(resp!=null) {

            isDataProcessing.value = false;
            myList.clear();
            myList.addAll(resp);
            if(resp.isEmpty){
              reLoadingDataProcessing.value=false;
            }
          }
          else{
            myList.clear();
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
  void paginateTask(String type) {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print("reach End");
        page++;
        print("page==>${page}");
        getMoreTask(type,page);
      }
    });
  }

  void getMoreTask(String type,var page) {
    try {
      reLoadingDataProcessing.value = true;

      if (isoffline.value == false) {

        TaskProvider().getFavList(type: type,page: page).then((resp) {
          if(resp!=null) {
            reLoadingDataProcessing.value = false;
            myList.addAll(resp);
          }
          else{
            myList.clear();
            reLoadingDataProcessing.value = false;
          }
        }, onError: (err) {
          reLoadingDataProcessing.value = false;
          showSnackbar("Error", err.toString(), Colors.red);
        });
      }
    } catch (e) {
      isDataProcessing.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
    }
  }


}
