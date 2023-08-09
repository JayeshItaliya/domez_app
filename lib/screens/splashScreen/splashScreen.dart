
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print("deviceToken==> ${value}");
        Constant.fcmToken = value;
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
    //   if (message?.data['type'] == 'chat') {
    //     Get.to(ManageAccounts());
    //   }
    // }
    //
    // Future<void> setupInteractedMessage() async {
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


    fetchLinkData();
    initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: BoxDecoration(
            color: Colors.black,

            image: DecorationImage(
                image: AssetImage("assets/images/splashPage.png"),
                fit: BoxFit.cover
            )
        ),
      ),
    );
  }
}