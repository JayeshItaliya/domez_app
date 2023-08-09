import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:domez/controller/commonController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../commonModule/Strings.dart';
import '../model/categoryModel.dart';
import '../service/getAPI.dart';
import 'domesListController.dart';
import 'leaguesListController.dart';

class CategoryController extends GetxController {

  var myList = List<CategoryModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;
  StreamSubscription? subscription;
  var isoffline = false.obs;
  DomesListController mycontroller = Get.put(DomesListController());
  LeagueListController leagueListController = Get.put(LeagueListController());
  CommonController cx =Get.put(CommonController());
  var sportid="1".obs;
  var initialCategoryId = 0.obs;
  var currentCategoryId = 0.obs;

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
        TaskProvider().getCategoryList().then((resp) {

          isDataProcessing.value = false;
          if(resp!=null){
            myList.clear();
            myList.addAll(resp);
            initialCategoryId.value=myList[0].id;
            currentCategoryId.value=myList[0].id;

            if(cx.curIndex==0){
              print("Hey Soham League sporty Id");
              print(myList[0].id.toString());

              cx.write(Keys.paginationDomeSportId,myList[0].id.toString());
              mycontroller.getTask1(myList[0].id.toString());
              mycontroller.getTask2(myList[0].id.toString());
              mycontroller.getTask3(myList[0].id.toString());
            }
            else if(cx.curIndex==2){
              print("Hey Soham League sporty Id");
              print(myList[0].id.toString());
              cx.write(LKeys.paginationLeagueSportId,myList[0].id.toString());

              leagueListController.getTask2(myList[0].id.toString());
              leagueListController.getTask3(myList[0].id.toString());
            }
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
