import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../commonModule/Strings.dart';
import '../commonModule/utils.dart';
import '../model/domesListModel.dart';
import '../service/getAPI.dart';
import 'commonController.dart';

class DomesListController extends GetxController {

  var myList1 = List<DomesListModel>.empty(growable: true).obs;
  var myList2 = List<DomesListModel>.empty(growable: true).obs;
  var myList3 = List<DomesListModel>.empty(growable: true).obs;

  var isDataProcessing1 = false.obs;
  var isDataProcessing2 = false.obs;
  var isDataProcessing3 = false.obs;

  StreamSubscription? subscription;
  var isoffline = false.obs;
  CommonController cx = Get.put(CommonController());

  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();


  var reLoadingData2=false.obs;
  var reLoadingData3=false.obs;

  var page2=1;
  var page3=1;

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
    if (cx.read("id") == null) cx.write('id', 0);

    cx.id.value=cx.read("id");
    print(cx.read("id"));

    // TODO: implement onInit
    super.onInit();

    checkNetwork();
    paginateTask2(cx.read(Keys.paginationDomeSportId)??"");
    paginateTask3(cx.read(Keys.paginationDomeSportId)??"");
  }

  Future<void> getTask1(String sid) async {

    if(cx.read("islogin")??false){
      try {

        isDataProcessing1.value = true;

        if (isoffline.value == false) {
          print(cx.read("id"));
          print(sid.toString());
          print(cx.read('id'));


          TaskProvider().getDomesList(
            type: "1",
            uid: cx.read("id").toString(),
            lat: "36.8516437",
            lng: "-75.97921939999999",
            page: 1,
            sportId: sid.toString(),

          ).then((resp) {

            if(resp!=null) {
              isDataProcessing1.value = false;
              myList1.clear();
              myList1.addAll(resp);
            }
            else{
              print("Oops! Null Response");
              isDataProcessing1.value = false;

            }

          }, onError: (err) {
            isDataProcessing1.value = false;
            showSnackbar("Error", err.toString(), Colors.red);
          });
        }
      } catch (e) {
        isDataProcessing1.value = false;
        showSnackbar("Exception", e.toString(), Colors.red);
      }
    }
    return null;
  }
  Future<void> getTask2(String sid) async {
    try {
      print("dome2");

      isDataProcessing2.value = true;

      if (isoffline.value == false) {
        TaskProvider().getDomesList(
          type: "2",
          uid: cx.read("id").toString(),
          // lat: "",
          // lng: "-75.97921939999999",
          page: 1,
          sportId:sid.toString(),
        ).then((resp) {

          if(resp!=null){
            isDataProcessing2.value = false;
            myList2.clear();
            myList2.addAll(resp);
          }
          else{
            isDataProcessing2.value = false;

            print("Oops! Null Response");
          }

        }, onError: (err) {
          isDataProcessing2.value = false;
          showSnackbar("Error", err.toString(), Colors.red);
        });
      }
    } catch (e) {
      isDataProcessing2.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
    }
  }
  Future<void> getTask3(String sid) async {
    print("dome3");

  try {
      isDataProcessing3.value = true;

      if (isoffline.value == false) {
        TaskProvider().getDomesList(
          type: "3",
          page: 1,
          uid: cx.read("id").toString(),
          lat: cx.read(Keys.lat).toString(),
          lng: cx.read(Keys.lng).toString(),
          sportId:sid.toString(),

        ).then((resp) {

          if(resp!=null) {
            isDataProcessing3.value = false;
            myList3.clear();
            myList3.addAll(resp);
          }
          else{
            isDataProcessing3.value = false;

            print("Oops! Null Response");

          }
        }, onError: (err) {
          isDataProcessing3.value = false;
          showSnackbar("Error", err.toString(), Colors.red);
        });
      }
    } catch (e) {
      isDataProcessing3.value = false;
      showSnackbar("Exception", e.toString(), Colors.red);
    }
  }

  showSnackbar(title, message, color) {
    Get.snackbar(title, message,
        colorText: Colors.white, backgroundColor: color);
  }
  sportsUpdate(cid){
    // print("hi");
    // sportid.value=cid;
    sportIdUpdate(cid);

    getTask1(cid);
    getTask2(cid);
    getTask3(cid);

  }


 void getMoreTask2(String sid){
   try {
     print("dome2");
     reLoadingData2.value = true;

     if (isoffline.value == false) {
       TaskProvider().getDomesList(
         type: "2",
         uid: cx.read("id").toString(),
         // lat: "36.8516437",
         // lng: "-75.97921939999999",
         page: page2,
         sportId:sid.toString(),
       ).then((resp) {

         if(resp!=null){
           reLoadingData2.value = false;
           //myList2.clear();
           myList2.addAll(resp);
           if(resp.isEmpty){
             reLoadingData2.value=false;
           }
         }
         else{
           reLoadingData2.value = false;

           print("Oops! Null Response");
         }

       }, onError: (err) {
         reLoadingData2.value = false;
         showSnackbar("Error", err.toString(), Colors.red);
       });
     }
   } catch (e) {
     isDataProcessing2.value = false;
     showSnackbar("Exception", e.toString(), Colors.red);
   }
 }
 void getMoreTask3(String sid){
   try {
     reLoadingData2.value = true;

     if (isoffline.value == false) {
       TaskProvider().getDomesList(
         type: "3",
         page: page3,
         uid: cx.read("id").toString(),
         lat: cx.read(Keys.lat).toString(),
         lng: cx.read(Keys.lng).toString(),
         sportId:sid.toString(),

       ).then((resp) {

         if(resp!=null) {
           reLoadingData2.value = false;
           //myList3.clear();
           myList3.addAll(resp);
           if(resp.isEmpty){
             reLoadingData2.value=false;
           }
         }
         else{
           reLoadingData2.value = false;

           print("Oops! Null Response");

         }
       }, onError: (err) {
         reLoadingData2.value = false;
         showSnackbar("Error", err.toString(), Colors.red);
       });
     }
   } catch (e) {
     reLoadingData2.value = false;
     showSnackbar("Exception", e.toString(), Colors.red);
   }
 }

  void paginateTask2(String sportid){
    scrollController2.addListener(() {
      if(scrollController2.position.pixels == scrollController2.position.maxScrollExtent){
        page2++;
        print("page===>${page2}");
        getMoreTask2(sportid);
      }
    });
  }
  void paginateTask3(String sportid){
    scrollController3.addListener(() {
      if(scrollController3.position.pixels == scrollController3.position.maxScrollExtent){
        page3++;
        print("page===>${page3}");
        getMoreTask3(sportid);
      }
    });
  }
}
