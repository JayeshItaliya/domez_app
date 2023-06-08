import 'dart:io';
import 'package:domez/screens/menuPage/bookings.dart';
import 'package:domez/screens/menuPage/filters.dart';
import 'package:domez/screens/payment/linkAccess/initialLinkAccess.dart';
import 'package:domez/screens/splashScreen/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'commonModule/Constant.dart';
import 'commonModule/Strings.dart';
import 'commonModule/deepLinkRoute.dart';
import 'commonModule/pay.dart';
import 'controller/network_binding.dart';
import 'controller/stripeController.dart';
import 'main_page.dart';

Future<void> main() async {
  final context = SecurityContext.defaultContext;
  context.allowLegacyUnsafeRenegotiation = true;
  // final httpClient = HttpClient(context: context);

  //TODO uncomment karvanu baaki che
  // StripeController mycontroller = Get.put(StripeController());


  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  await GetStorage.init();

  //TODO uncomment karvanu baaki che
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


  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  if (initialLink != null) {
    final Uri deepLink = initialLink.link;
    if(deepLink.path!=null){
      Get.to(Filters());
      print(deepLink.path);

    }
    else{
      Get.to(Bookings(isBackButton: true));
    }
    // Example of using the dynamic link to push the user to a different screen
  }
  FirebaseDynamicLinks.instance.onLink.listen(
        (pendingDynamicLinkData) {
      // Set up the `onLink` event listener next as it may be received here
      if (pendingDynamicLinkData != null) {
        final Uri deepLink = pendingDynamicLinkData.link;
        // Example of using the dynamic link to push the user to a different screen
        print(deepLink.path);
        Get.to(Filters());
      }
    },
  );


  initDynamicLinks();
  // await mycontroller.getTask().then((value) {
  //   print("LIVE");
  //   print(value);
  //   print(cx.read(Keys.publishableStripeKey));
  //   print(cx.read(Keys.secretStripeKey));
  // });

  Stripe.merchantIdentifier = 'merchant.domez.io.domez';
  // Stripe.publishableKey = value;
  Stripe.publishableKey =
  "pk_live_51LlAvQFysF0okTxJhOBTwVLwJpgRBlURYPJP5qrk0EvXKuivpbCD8wIBqCJMpnxQny54dCghUwUNMNDa35b7WoQb00VV8tfzP1";
  //     Constant.stripePublishableKey;

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
    // home: PaySampleApp(),
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

bool isFlutterLocalNotificationsInitialized = false;

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
