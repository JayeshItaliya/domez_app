import 'dart:io';
import 'package:domez/commonModule/utils.dart';
import 'package:domez/screens/authPage/signIn.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../controller/bookingDetailsController.dart';
import '../controller/leagueDetailsController.dart';
import '../screens/league/leaguePageDetails.dart';

class NotificationServices {
  BookingDetailsController bx = Get.put(BookingDetailsController());
  LeagueDetailsController lx = Get.put(LeagueDetailsController());

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance ;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin  = FlutterLocalNotificationsPlugin();

  // function to request notifications permissions
  void requestNotificationPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
        alert: true ,
        announcement: true ,
        badge: true ,
        carPlay:  true ,
        criticalAlert: true ,
        provisional: true ,
        sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('user granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('user granted provisional permission');
    }else {
      // AppSettings.openNotificationSettings();
      print('user denied permission');
    }
  }


  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(BuildContext context, RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings ,
        iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
        onDidReceiveNotificationResponse: (payload){
          // handle interaction when app is active for android
          handleMessage(context, message);
        }
    );
  }

  void firebaseInit(BuildContext context){


    FirebaseMessaging.onMessage.listen((message) {

      RemoteNotification? notification = message.notification ;
      AndroidNotification? android = message.notification!.android ;


      if (kDebugMode) {

        print("notifications title:"+notification!.title.toString());
        print("notifications body:"+notification.body.toString());
        print('count:'+android!.count.toString());

        print("notifications channel id:"+message.notification!.android!.channelId.toString());
        print("notifications click action:"+message.notification!.android!.clickAction.toString());
        print("notifications color:"+message.notification!.android!.color.toString());
        print("notifications count:"+message.notification!.android!.count.toString());
      }


      if(Platform.isAndroid){
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }


  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message)async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString() ,
      importance: Importance.max  ,
      showBadge: true ,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString() ,
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high ,
      ticker: 'ticker' ,
      //  icon: largeIconPath
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
        presentAlert: true ,
        presentBadge: true ,
        presentSound: true
    ) ;

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero , (){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });

  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print(token);
    print("Constant.fcmToken");
    return token!;
  }

  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context)async{
    print("handle tap on notification when app is in background or terminated");
    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }


    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

  }


  void handleMessage(BuildContext context, RemoteMessage message) {
  print("Hello handle message");
  var data=message.data;

  print('A bg message just showed up :  ${message.messageId}');
  print(data['booking_id']);
  print(data['NotificationId']);
  print(data['type']);
  print(data['league_id']);

  if(data['type']=="1"){
    print("Type 1");
    if(cx.read("islogin")){
      bx.setBid(data['booking_id'].toString(),2,true,true);
    }
    else{
      Get.to(SignIn(curIndex: 4,isBackButton: false,));
    }

  }
  else if(data['type']=="2"){
    if(cx.read("islogin")){
      bx.setBid(data['booking_id'].toString(),2,true,true);
    }
    else{
      Get.to(SignIn(curIndex: 4,isBackButton: false,));

    }

  }
  else if(data['type']=="3"){
    if(cx.read("islogin")){
      bx.setBid(data['booking_id'].toString(),2,true,true);
    }
    else{
      Get.to(SignIn(curIndex: 4,isBackButton: false,));

    }
  }
  else if(data['type']=="4"){
    if(cx.read("islogin")){
      Get.to(
          LeaguePageDetails(
            isFav: false,
            leagueId: data['league_id'].toString(),));
    }
    else{
      Get.to(SignIn(curIndex: 4,isBackButton: false,));

    }
    print("Type 4");

  }
  else if(data['type']=="5"){
    if(cx.read("islogin")){
      bx.setBid(data['booking_id'].toString(),2,true,true);
    }
    else{
      Get.to(SignIn(curIndex: 4,isBackButton: false,));

    }
    print("Type 5");
  }
  else if(data['type']=="6"){
    if(cx.read("islogin")){
      bx.setBid(data['booking_id'].toString(),2,true,true);
    }
    else{
      Get.to(SignIn(curIndex: 4,isBackButton: false,));

    }
    print("Type 6");
  }


    // if(message.data['type'] =='msj'){
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => MessageScreen(
    //         id: message.data['id'] ,
    //       )));
    // }
  }


}