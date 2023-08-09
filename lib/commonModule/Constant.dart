
import 'dart:io';
import 'package:flutter/material.dart';


class Constant {
  static String stripeSecretKey = "sk_test_51LlAvQFysF0okTxJjCODF1rt79hZpNypYCfAAUaSgy9EGXbg5dL3h9a93rxNCgXMpBJEFETvdWO1y5xyClOxn6D200JgDzWUe5";
  static const String mapkey = "AIzaSyCvlZaKvRSMouyH9pDgGC6pMGADfytOrsA";
  static int page=1;

  static Brightness? deviceBrightness = Platform.isIOS?Brightness.light:Brightness.dark;
  static const String perPage = "10";

  // static const String baseUrl = "http://52.22.227.137/api/";
  static const String baseUrl="https://domez.io/api/";
  // static const String baseUrl="http://192.168.0.114/domez_backend/api/";

  static const String dummyProfileUrl ="https://www.domez.io/storage/app/public/admin/images/profiles/default.png";
  static String fcmToken = "";
  static const String pushNotification = "${baseUrl}pushnotification";

  static const String signUp = "${baseUrl}sign-up";
  static const String verify = "${baseUrl}verify";
  static const String signIn = "${baseUrl}sign-in";
  static const String helpcenter = "${baseUrl}helpcenter";
  static const String editProfile = "${baseUrl}editprofile";
  static const String googleSignIn = "${baseUrl}google-login";
  static const String facebookSignIn = "${baseUrl}facebook-login";
  static const String appleSignIn = "${baseUrl}apple-login";
  static const String ressendOtp = "${baseUrl}resend-otp";
  static const String forgotpass = "${baseUrl}forgot-password";
  static const String changepassword = "${baseUrl}change-password";
  static const String deleteAccount = "${baseUrl}delete-account";
  static const String cancelAccount = "${baseUrl}booking-cancel";

  static const String review = "${baseUrl}review";


  static const String search = "${baseUrl}search?page=";
  static const String filter = "${baseUrl}filter";

  static const String categoryList = "${baseUrl}sportslist";
  static const String favourite = "${baseUrl}favourite";
  static const String favouriteList = "${baseUrl}favourite-list";
  static String bookingList = "${baseUrl}booking-list";
  static const String bookingDetails = "${baseUrl}booking-details-";
  static const String payment = "${baseUrl}payment";
  static const String splitPayment = "${baseUrl}split-payment";
  static const String ratingsList = "${baseUrl}rattinglist-";

  static const String domesList = "${baseUrl}domes-list";
  static const String domesDetails = "${baseUrl}dome-details-";
  static const String getTimeSlots = "${baseUrl}timeslots";
  static const String availableFields = "${baseUrl}available-fields";
  static const String requestDomez = "${baseUrl}dome-request";

  static const String leaguesList = "${baseUrl}leagues-list";
  static const String leagueDetails = "${baseUrl}league-details-";

  static const String getStripeKey = "${baseUrl}stripe-key";

  static const String cmsPages = "https://domez.io/cms-pages";
  static const String termsUrl = "https://domez.io/terms-conditions";
  static const String privacyUrl = "https://domez.io/privacy-policy";
  static const String cancelUrl = "https://domez.io/cancellation-policies";
  static const String refundUrl = "https://domez.io/refund-policies";

  static String kUriPrefix = 'https://domez.page.link';

  static int signUpotp = 0;
  static int totalFavDome = 0;

}
