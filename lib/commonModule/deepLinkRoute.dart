
import 'dart:async';

import 'package:domez/commonModule/utils.dart';
import 'package:domez/main_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/menuPage/filters.dart';
import '../screens/payment/linkAccess/initialLinkAccess.dart';
import 'Constant.dart';

class RouteServices {


  static Route<dynamic> generateRoute(RouteSettings routeSettings,)  {

    fetchLinkData();
    initDynamicLinks().then((value) {

      print("Dynamic link calling");
      print(bookingId);

      switch ('/domeBooking') {
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