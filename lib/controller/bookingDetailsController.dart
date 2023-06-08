import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/bookingDetailsModel.dart';
import '../model/domesDetailsModel.dart';
import '../screens/bookSteps/DomePage.dart';
import '../screens/menuPage/bookinDetailsDomesSplit.dart';
import '../screens/menuPage/bookingDetailsDomesFull.dart';
import '../screens/menuPage/bookingtDetailsleague.dart';
import '../screens/payment/linkAccess/timeExpirePage.dart';
import '../service/getAPI.dart';

class BookingDetailsController extends GetxController {
  var myList = List<BookingDetailsModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;

  ScrollController scrollController = ScrollController();
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
    print("SOHAM");
    print(bookId.value);

    // TODO: implement onInit
    super.onInit();
    checkNetwork();
  }

  Future<void> setBid(String bookId, int type,bool isActive,bool isNavigate,{ bool? linkAccess,bool? isLinkTimerExpire}) async{
    print("DIWAKAR");
    await getTask(bookId, type,isActive,isNavigate,linkAccess:  linkAccess,isLinkTimerExpire: isLinkTimerExpire);
  }

  Future<void> getTask(String bookId, int type,bool isActive,bool isNavigate,
      {bool? linkAccess,bool? isLinkTimerExpire}) async {
    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {
        print(bookId);
        print("bookId.valueeeee1");
        TaskProvider().getBookingDetails(bid: bookId).then((resp) {
          if (resp != null) {
            print("bookId.valueeeee");

            isDataProcessing.value = false;
            myList.clear();
            myList.addAll(resp);
            print(type.toString());
            print("type.toString()");
            if(isNavigate){


              if(isLinkTimerExpire??false){
                print("Hey Hey Hey");
                Get.to(TimeExpirePage());
              }
              else{
                if (type == 1) {
                  Get.to(BookingDetailsDomesFull(linkAccess: linkAccess,));
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
