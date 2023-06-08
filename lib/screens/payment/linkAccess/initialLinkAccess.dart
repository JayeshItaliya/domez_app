import 'package:domez/commonModule/AppColor.dart';
import 'package:domez/commonModule/Constant.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/bookingDetailsController.dart';

class InitialLinkAccess extends StatefulWidget {
  String? bId;
    InitialLinkAccess({Key? key,this.bId="1"}) : super(key: key);

  @override
  State<InitialLinkAccess> createState() => _InitialLinkAccessState();
}

class _InitialLinkAccessState extends State<InitialLinkAccess> {
  BookingDetailsController mycontroller = Get.put(BookingDetailsController());
  bool isDataProcessing=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().then((value) {
      isDataProcessing=false;
    });
  }
  Future<void> getData()async{


    await mycontroller.setBid(
        // Constant.linkBookingId,
        widget.bId.toString(),
        2,
        false,
        true,
        linkAccess: true,
      // isLinkTimerExpire: true
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: isDataProcessing?
          Center(
            child: CircularProgressIndicator(
              color: AppColor.darkGreen,
            ),
          )
          :Container(

      ),
    );
  }
}
