import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:domez/controller/commonController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../commonModule/Strings.dart';
import '../model/domesDetailsModel.dart';
import '../screens/bookSteps/DomePage.dart';
import '../service/getAPI.dart';

class StripeController extends GetxController {

  // var myList = List<DomesDetailsModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;

  StreamSubscription? subscription;
  var isoffline = false.obs;
  // var did=''.obs;
  CommonController cx = Get.put(CommonController());

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
    // getTask();

    // TODO: implement onInit
    super.onInit();
    checkNetwork();
  }


  Future<String> getTask() async {
    String publishasbleKey='';

    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {
        print("domeId.valueeeee1");
        await TaskProvider().getStripeKey().then((resp) {
          if(resp!=null) {
            print(resp);
            print("domeId.valueeeee1");

            isDataProcessing.value = false;
            cx.write(Keys.publishableStripeKey,resp);

            // myList.clear();
            // myList.addAll(resp);
            print(resp.toString());
            publishasbleKey=resp.toString();

            return resp.toString();

          }

        }, onError: (err) {
          print("domeId.valueeeee3");

          isDataProcessing.value = false;
          showSnackbar("Error", err.toString(), Colors.red);
          return "ddd";
        });
      }
    } catch (e) {
      print("domeId.valueeeee2");

      isDataProcessing.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
      return "fff";
    }
    return publishasbleKey;
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
