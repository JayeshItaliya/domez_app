import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/domesDetailsModel.dart';
import '../screens/bookSteps/DomePage.dart';
import '../service/getAPI.dart';

class DomesDetailsController extends GetxController {

  var myList = List<DomesDetailsModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;
  StreamSubscription? subscription;
  var isoffline = false.obs;
  // var did=''.obs;
  var domeId=''.obs;
  var isFav=false.obs;

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
    print(domeId.value);

    // TODO: implement onInit
    super.onInit();
    checkNetwork();
  }
  Future<void> setDid(String domeid,bool isFav, {bool isFavPage = false})async {
    domeId.value=domeid;
    print(domeId.value);
    await getTask(isFav);

  }


  Future<void> getTask(bool isFav) async {
    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {
        print(domeId.value);
        await TaskProvider().getDomesDetails(did: domeId.value).then((resp) {
          if(resp!=null) {
            isDataProcessing.value = false;
            myList.clear();
            myList.addAll(resp);

            print(myList[0].domeImages.toList().toString());
            // Get.to(
            //     DomePage(
            //     isFav: isFav,
            //       isFavPage: true,
            //
            //     ),
            //     // arguments: false,
            //     transition: Transition.rightToLeft);
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
