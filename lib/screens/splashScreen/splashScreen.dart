import 'dart:io';
import 'package:domez/main_page.dart';
import 'package:domez/screens/menuPage/manageAccounts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/notificationService.dart';
import '../../main.dart';
import '../../service/permissionPage.dart';
import '../menuPage/filters.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _notificationsEnabled = false;
  NotificationServices notificationServices = NotificationServices();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();
    print("Hey Token");
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      print('device token');
      print(value);
      if (kDebugMode) {
        print('device token');
        print("deviceToken==> ${value}");
        Constant.fcmToken=value;
      }
    });

    // FirebaseMessaging.instance.getToken().then((value) {
    //   String? token = value;
    //   Constant.fcmToken=token.toString();
    //   print("messageToken=>>${token.toString()}");
    //   print("fcmToken=>>${Constant.fcmToken}");
    // });
    // String? initialMessage;
    // bool _resolved = false;
    //
    // FirebaseMessaging.instance.getInitialMessage().then(
    //       (value) => setState(
    //         () {
    //       _resolved = true;
    //       initialMessage = value?.data.toString();
    //     },
    //   ),
    // );
    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //
    //   // print(message.data);
    //   var data=message.data;
    //   print(data['booking_id']);
    //   print(data['NotificationId']);
    //   print(data['type']);
    //   print(data['league_id']);
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             channelDescription: channel.description,
    //             color: AppColor.darkGreen,
    //             playSound: true,
    //             icon: '@mipmap/ic_launcher',
    //           ),
    //
    //         ));
    //   }
    //   // cx.curIndex.value=4;
    // });
    // @pragma('vm:entry-point')
    // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    //   // If you're going to use other Firebase services in the background, such as Firestore,
    //   // make sure you call `initializeApp` before using other Firebase services.
    //   await Firebase.initializeApp();
    //   // var data=message.data;
    //   // print(data['booking_id']);
    //   // print(data['NotificationId']);
    //   // print(data['type']);
    //   // print(data['league_id']);
    //   print('Handling a background message ${message.toString()}');
    // }
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //
    //
    //   if (notification != null && android != null) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //             title: Text(notification.title!),
    //             content: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [Text(
    //                     notification.body!)],
    //               ),
    //             ),
    //           );
    //         });
    //   }
    // });

    // void handleMessage(RemoteMessage? message) {
    //   print("Hello");
    //   if (message?.data['type'] == 'chat') {
    //     Get.to(ManageAccounts());
    //   }
    // }
    //
    // Future<void> setupInteractedMessage() async {
    //   print("Hello1");
    //
    //   // Get any messages which caused the application to open from
    //   // a terminated state.
    //   RemoteMessage? initialMessage =
    //   await FirebaseMessaging.instance.getInitialMessage();
    //
    //   // If the message also contains a data property with a "type" of "chat",
    //   // navigate to a chat screen
    //   if (initialMessage != null) {
    //     handleMessage(initialMessage);
    //   }
    //
    //   // Also handle any interaction when the app is in the background via a
    //   // Stream listener
    //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    // }
    // setupInteractedMessage();

    _requestPermissions();
    navigateToScreen();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      extendBody: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color:Colors.black,

            image:DecorationImage(
            image: AssetImage("assets/images/splashPage.png"),
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }
  navigateToScreen() async {
    await Future.delayed(Duration(seconds: 2), (){
      // Get.offAll(DemoPush());
      Get.offAll(WonderEvents());
    });
  }
  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      setState(() {
        _notificationsEnabled = granted ?? false;
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

    Get.to(Filters());

    // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    print(link);

    // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
    if(link!=null){
      handleLinkData(link);
    }

    // This will handle incoming links if the application is already opened
    FirebaseDynamicLinks.instance.onLink;
  }

}
