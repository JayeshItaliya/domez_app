import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../commonModule/Constant.dart';
import '../../model/paymentDetailModel.dart';


class StripeService {

  static Future<PaymentDetailsModel?> paymentSuccessfulAPI({
  String? customerEmail,
  String? customerPhone,
  String? customerName,
  String? user_id,
  String? booking_type,
  String? payment_type,
  String? payment_method,
  String? dome_id,
  String? league_id,
  String? sport_id,
  String? field_id,
  String? date,
  String? players,
  String? slots,
  String? start_time,
  String? end_time,
  String? total_amount,
  String? paid_amount,
  String? minSplitAmount,
  String? sub_total,
  String? service_fee,
  String? hst,
  String? due_amount,
  String? transaction_id,
  String? team_name,
  String? createdAt,
  required BuildContext context
}) async {
    try {

      print("API CALLING...");
      var request = http.MultipartRequest('POST', Uri.parse(Constant.payment));

      request.fields.addAll({
        'customer_email': customerEmail.toString(),
        'user_id': user_id.toString(),
        'booking_type': booking_type.toString(),
        'payment_type': payment_type.toString(),
        'payment_method': payment_method.toString(),
        'dome_id': dome_id.toString(),
        'league_id': league_id.toString(),
        'sport_id': sport_id.toString(),
        'field_id': field_id.toString(),
        'date': date.toString(),
        'players': players.toString(),
        'slots': slots.toString(),
        'start_time': start_time.toString(),
        'end_time': end_time.toString(),
        'total_amount': total_amount.toString(),
        'paid_amount': paid_amount.toString(),
        'min_split_amount': minSplitAmount.toString(),
        'sub_total': sub_total.toString(),
        'service_fee': service_fee.toString(),
        'hst': hst.toString(),
        'due_amount': due_amount.toString(),
        'transaction_id': transaction_id.toString(),
        'team_name': team_name.toString(),
        'customer_phone': customerPhone.toString(),
        'customer_name': customerName.toString(),
        'created_at': createdAt.toString(),
        'fcm_token': Constant.fcmToken.isEmpty?"test":Constant.fcmToken,
      });

      print(request.toString());
      print(request.fields.toString());

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {

        print(jsonBody.toString());
        PaymentDetailsModel jsonBody1 = PaymentDetailsModel.fromJson(jsonBody);


        return jsonBody1;
      } else {
        onAlert(context: context,type: 3,msg: jsonBody['message']);

        print(jsonBody);
        return null;
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }

  }



}