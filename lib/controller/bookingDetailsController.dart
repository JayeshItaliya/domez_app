import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/bookingDetailsModel.dart';
import '../screens/menuPage/bookinDetailsDomesSplit.dart';
import '../screens/menuPage/bookingDetailsDomesFull.dart';
import '../screens/menuPage/bookingtDetailsleague.dart';
import '../screens/payment/linkAccess/timeExpirePage.dart';
import '../service/getAPI.dart';

class BookingDetailsController extends GetxController {
  var myList = List<BookingDetailsModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;

  StreamSubscription? subscription;
  var isoffline = false.obs;
  var bookId = ''.obs;
  var type = 0.obs;

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
    print(bookId.value);

    // TODO: implement onInit
    super.onInit();
    checkNetwork();
  }

  Future<void> setBid(String bookId, int type,bool isActive,bool isNavigate,{ bool? linkAccess,}) async{
    await getTask(bookId, type,isActive,isNavigate,linkAccess:  linkAccess,);
  }

  Future<void> getTask(String bookId, int type,bool isActive,bool isNavigate,
      {bool? linkAccess,}) async {
    try {
      print(linkAccess);
      isDataProcessing.value = true;

      if (isoffline.value == false) {
        print(bookId);
        TaskProvider().getBookingDetails(bid: bookId).then((resp) {
          if (resp != null) {

            isDataProcessing.value = false;
            myList.clear();
            myList.addAll(resp);
            print(type.toString());
            print("timeExpire");
            print(myList[0].bookingStatus=="cancelled");

            if(isNavigate){
              if(myList[0].bookingStatus=="cancelled"){
                Get.to(TimeExpirePage());
              }
              else{
                if (type == 1) {
                  Get.to(BookingDetailsDomesFull(linkAccess: linkAccess,isActive: isActive,));
                } else if (type == 2) {
                  Get.to(BookingDetailsDomesSplit(isActive: isActive,linkAccess: linkAccess??false,));
                } else {
                  Get.to(BookingDetailsLeague(linkAccess: linkAccess,));
                }
              }
            }

          } else {}
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
