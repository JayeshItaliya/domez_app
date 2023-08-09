import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/getAPI.dart';

var isDataProcessing = false;

StreamSubscription? subscription;
var isOffline = false;

checkNetwork() {
  subscription = Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) {

    if (result == ConnectivityResult.none) {
      isOffline = true;
    } else if (result == ConnectivityResult.mobile) {
      isOffline = false;
    } else if (result == ConnectivityResult.wifi) {
      isOffline = false;
    } else {
      Get.snackbar("Network Error", "Failed to get network connection");
      isOffline = false;
    }
  });
}

showSnackbar(title, message, color) {
  Get.snackbar(title, message,
      colorText: Colors.white, backgroundColor: color);
}

Future<String> getStripeKey() async {
  String publishasbleKey='';
  checkNetwork();
  try {
    isDataProcessing = true;

    if (isOffline == false) {
      await TaskProvider().getStripeKey().then((resp) {
        if(resp!=null) {
          print(resp);
          isDataProcessing = false;
          print(resp.toString());
          publishasbleKey=resp.toString();
          return resp.toString();
        }
      }, onError: (err) {
        isDataProcessing = false;
        showSnackbar("Error", err.toString(), Colors.red);
        return "";
      });
    }
  } catch (e) {
    isDataProcessing = false;
    showSnackbar("Exception", e.toString(), Colors.red);
    return "";
  }
  return publishasbleKey;
}
