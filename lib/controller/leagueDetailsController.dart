import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/LeagueDetailsModel.dart';
import '../screens/league/leaguePageDetails.dart';
import '../service/getAPI.dart';

class LeagueDetailsController extends GetxController {

  var myList = List<LeagueDetailsModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;

  ScrollController scrollController = ScrollController();
  StreamSubscription? subscription;
  var isoffline = false.obs;
  // var did=''.obs;
  var leagueId=''.obs;
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
    print("SOHAM");
    print(leagueId.value);

    // TODO: implement onInit
    super.onInit();
    checkNetwork();
  }
  Future<void> setLid(String leagueId,bool isFav) async {
    this.leagueId.value=leagueId;
    print("DIWAKAR");
    print(this.leagueId.value);
    await getTask(isFav);

  }


  Future<void> getTask(bool isFav) async {
    try {
      isDataProcessing.value = true;

      if (isoffline.value == false) {
        print(leagueId.value);
        print("leagueId.valueeeee1");
        await TaskProvider().getLeagueDetails(lid: leagueId.value).then((resp) {
          if(resp!=null) {
            print("leagueId.valueeeee");


            isDataProcessing.value = false;
            myList.clear();
            myList.addAll(resp);
            print("league.images");

            print(myList[0].leagueImages.toList().toString());
            // Get.to(
            //     LeaguePageDetails(
            //       isFav: isFav, leagueId: '',));
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
