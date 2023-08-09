import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/bookingListModel.dart';
import '../service/getAPI.dart';

class BookListController extends GetxController {

  var myList = List<BookingListModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;
  var reLoadingDataProcessing = false.obs;
  var page = 1;
  StreamSubscription? subscription;
  var isoffline = false.obs;
  var type =1.obs;
  ScrollController scrollController = ScrollController();

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
    getTask(type.value.toString());
    paginateTask(type.value.toString());
    checkNetwork();
  }


  Future<void> getTask(String type, ) async {
    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {

        TaskProvider().getBookList(type: type,page: 1).then((resp) {
          if(resp!=null) {
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

  void paginateTask(String type) {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print("reach End");
        page++;
        print("page==>${page}");
        if(myList.length==0){
          print("list empty");
          reLoadingDataProcessing.value=false;
        }
        getMoreTask(type,page);
      }

    });
  }

  void getMoreTask(String type,var page) {
    try {
      reLoadingDataProcessing.value = true;
      if (isoffline.value == false) {
        TaskProvider().getBookList(type:type,page: page).then((resp) {
          if(resp!=null) {
            isDataProcessing.value = false;
            //myList.clear();
            myList.addAll(resp);
            print(resp);
            if(resp.isEmpty){
              reLoadingDataProcessing.value = false;
            }
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
}
