import 'dart:io';
import 'package:domez/screens/splashScreen/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'commonModule/Constant.dart';
import 'commonModule/deepLinkRoute.dart';
import 'commonModule/getStripeKey.dart';
import 'controller/network_binding.dart';


Future<void> main() async {
  final context = SecurityContext.defaultContext;
  context.allowLegacyUnsafeRenegotiation = true;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  await GetStorage.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await getStripeKey().then((value) {
    print("LIVE");
    print(value);
    Stripe.merchantIdentifier = 'merchant.domez.io.domez';
    //TODO NOT DONE
    // Stripe.publishableKey = "pk_test_51LlAvQFysF0okTxJcqvqe5FuA6eGnvPGx09mjkD9XamI1ZY3JDyRZyfI0yMohFkUmYfrYaQVkTqqqXwLtcu5DL4q00sg52wJEO";
    Stripe.publishableKey = value;
  });


  await Stripe.instance.applySettings();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      // statusBarColor: Colors.blue, // Change this to your desired color
      statusBarIconBrightness:
          Constant.deviceBrightness // Set the status bar icon color to light
      ));
  runApp(GetMaterialApp(
    title: 'DOMEZ',
    onGenerateRoute: RouteServices.generateRoute,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: MaterialColor(0xFF468F73, color),

    ),
    // home: InitialLinkAccess(),
    home: SplashScreen(),
    initialBinding: NetworkBinding(),
  ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description

  importance: Importance.high,
  playSound: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
  print(message.toMap());
}

Map<int, Color> color = {
  50: Color.fromRGBO(70, 143, 115, 1),
  100: Color.fromRGBO(70, 143, 115, 1),
  200: Color.fromRGBO(70, 143, 115, 1),
  300: Color.fromRGBO(70, 143, 115, 1),
  400: Color.fromRGBO(70, 143, 115, 1),
  500: Color.fromRGBO(70, 143, 115, 1),
  600: Color.fromRGBO(70, 143, 115, 1),
  700: Color.fromRGBO(70, 143, 115, 1),
  800: Color.fromRGBO(70, 143, 115, 1),
  900: Color.fromRGBO(70, 143, 115, 1)
};
