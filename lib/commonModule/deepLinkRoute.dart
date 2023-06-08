
import 'dart:async';

import 'package:domez/main_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/menuPage/filters.dart';
import '../screens/payment/linkAccess/initialLinkAccess.dart';
import 'Constant.dart';


String bookingId='';
bool _isCreatingLink = false;
FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;



class RouteServices {


  static Route<dynamic> generateRoute(RouteSettings routeSettings,)  {

    print("Dynamic link calling1");

    initDynamicLinks().then((value) {
      print(value);
      // fetchLinkData();
      print("Dynamic link calling2");
      print(bookingId);
      print("/domeBooking?bookingId=${Constant.linkBookingId}");


      switch ('/domeBooking') {
      // case '/domeBooking':
      // case '/domeBooking?bookingId=33':
        case '/domeBooking':
          return CupertinoPageRoute(builder: (_) {
            return InitialLinkAccess(bId: bookingId,);
          });

        default:
          return _errorRoute();
      }
    });
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
      );
    });
  }
}


void handleLinkData(PendingDynamicLinkData data) {
  final Uri? uri = data?.link;
  if(uri != null) {
    final queryParams = uri.queryParameters;
    if(queryParams.length > 0) {
      String? bookingId = queryParams["bookingId"];
      // verify the username is parsed correctly
      Get.to(Filters());
      print("My users username is: $bookingId");
    }
  }
}
//If app is shutDown
void fetchLinkData() async {
  final PendingDynamicLinkData? data =
  await dynamicLinks.getInitialLink();
  final Uri? deepLink = data?.link;
  print(deepLink);
  if (deepLink != null) {
    try {
      String name = deepLink.queryParameters['bookingId'] ?? "";
      if (deepLink.pathSegments.isNotEmpty) {
        Get.to(InitialLinkAccess(bId: name,));
      }
    } catch (e) {
      debugPrint(e.toString());
    }


    // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    print(link);

    // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
    if (link != null) {
      handleLinkData(link);
    }
    // This will handle incoming links if the application is already opened
    FirebaseDynamicLinks.instance.onLink;
  }
}

//If app is resume in backGround
Future<String> initDynamicLinks() async {
  print("Hey Deep Linking");

  dynamicLinks.onLink.listen((dynamicLinkData) async {
    print("onListen");
    print(dynamicLinkData.link);
    print(dynamicLinkData.android);
    print(dynamicLinkData.ios);
    print(dynamicLinkData.utmParameters);
    print(dynamicLinkData.link.path);

    final Uri uri = dynamicLinkData.link;
    final queryParams = uri.queryParameters;

    print("Variables");
    print(uri);
    print(queryParams['bookingId']);
    bookingId=queryParams['bookingId'].toString();




    if (queryParams.isNotEmpty) {
      print("bookingID=>"+bookingId.toString());
      Get.to(InitialLinkAccess(bId: bookingId,));
    } else {
      Get.offAll(WonderEvents());
    }





    //If app is shutDown
    final PendingDynamicLinkData? data =
        await dynamicLinks.getInitialLink();
    final Uri? deepLink = data?.link;
    print(deepLink);
    if (deepLink != null) {
      try {
        String name = deepLink.queryParameters['bookingId'] ?? "";
        if (deepLink.pathSegments.isNotEmpty) {
          Get.to(InitialLinkAccess(bId: name,));
        }
      } catch (e) {
        debugPrint(e.toString());
      }


      // // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
      // var link = await FirebaseDynamicLinks.instance.getInitialLink();
      // print(link);
      //
      // // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
      // if (link != null) {
      //   handleLinkData(link);
      // }
      // // This will handle incoming links if the application is already opened
      // FirebaseDynamicLinks.instance.onLink;
    }

  }).onError((error) {
    print('onLink error');
    print(error.message);
  });
  return bookingId;
}
