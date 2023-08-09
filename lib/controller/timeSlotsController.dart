import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:domez/controller/commonController.dart';
import 'package:domez/controller/domesListController.dart';
import 'package:domez/model/timeSlots.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../commonModule/Strings.dart';
import '../service/getAPI.dart';
import 'domesDetailsController.dart';

class TimeSlotsController extends GetxController {

  var myList = List<TimeSlotsModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;
  StreamSubscription? subscription;
  var isoffline = false.obs;

  CommonController cx=Get.put(CommonController());
  DomesDetailsController domedetailcontroller=Get.put(DomesDetailsController());
  DomesListController domeListController=Get.put(DomesListController());

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
    print("Heyyyy2345");

    getTask();
    checkNetwork();
  }


  Future<void> getTask() async {
    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {

        TaskProvider().getAvailableSlots(cx.read(Keys.domeId).toString(),cx.read(Keys.sportId).toString()).then((resp) {
          if(resp!=null&&resp.length!=0) {
            myList.clear();
            DateTime today =resp[0].currentTime;
            String curDate =
            DateFormat(
                "yyyy-MM-dd")
                .format(today);
            int curHour =today.hour;

            print(curDate);
            print(cx.read(Keys.fullDate));

           
            if(cx.read(Keys.fullDate) ==curDate){
              resp.asMap().forEach((index,element) {
                int startTime =
                int.parse(element.slot
                    .toString()
                    .substring(
                    0, 2));
                // isExpiredSlot = false;

                if (element.slot
                    .toString()
                    .substring(
                    6, 8) ==
                    "PM") {
                  if (element.slot
                      .toString()
                      .substring(
                      0, 2) !=
                      "12") {
                    startTime =
                        startTime + 12;
                  }
                } else {
                  if (element.slot
                      .toString()
                      .substring(
                      0, 2) ==
                      "12") {
                    startTime = 0;
                  }
                }
                print(curDate);
                  if (startTime <=
                      curHour) {
                    print(startTime);
                  }
                  else{
                    myList.add(element);
                  }
                  if(resp.length-1==index){
                    isDataProcessing.value = false;
                  }
              });
            }
            else{
              isDataProcessing.value = false;
              myList.addAll(resp);
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
