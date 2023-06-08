import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main_page.dart';


class PermissionPage extends StatefulWidget {
  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<PermissionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(8),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: _centerImageWithText(
                        image: 'assets/images/msg.png',
                        text: "Contact Access",
                        text1:"This app requires contacts access to connect your friend on this app to make more fun."),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  //This is our get started button
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, top: 0, bottom: 10),
                      child: TextButton(

                        child: Text(
                          "Allow",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1,
                              fontSize: 18),
                        ),
                        onPressed: () => {
                          getPermissions()

                        },
                      ),
                    ),
                ],
              ),
              Positioned(
                top: 8,
                left: 10,
                child: TextButton(
                    onPressed: () {
                        Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
  getPermissions() async {
    final PermissionStatus? permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Get.to(WonderEvents());
    } else if (permissionStatus == PermissionStatus.denied) {
      _onAddcontactsClicked(context);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _onAddcontactsClicked(context);
    }
  }

  Future<PermissionStatus?> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else if (permission == PermissionStatus.permanentlyDenied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else {
      return permission;
    }
  }

  _onAddcontactsClicked(context) async {
    Permission permission;

    if (Platform.isIOS) {
      // permission = Permission.photos;
      permission = Permission.contacts;
    } else {
      // permission = Permission.storage;
      permission = Permission.contacts;
    }

    PermissionStatus permissionStatus = await permission.status;
    if (!permissionStatus.isGranted) {
      await Permission.contacts.request();
    }
    if (await Permission.contacts.request().isGranted) {
      return;
    } else {
      print("permission");
      await Permission.contacts.request();
    }


    print(permissionStatus);
    if (permissionStatus == PermissionStatus.restricted) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted

        return;
      }
    }

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted

        return;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context);
      } else {
        permissionStatus = await permission.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted

        return;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      print('Permission granted');
      Get.to(WonderEvents());
    }

  }

  _showOpenAppSettingsDialog(context) async {
    print('Permission denied');
    await openAppSettings();
    // return CustomDialog.show(
    //   context,
    //   'Permission needed',
    //   'Photos permission is needed to select photos',
    //   'Open settings',
    //   openAppSettings,
    // );
  }



  checkpermission_opencamera() async {
    var photosStatus = await Permission.contacts.status;

    if (!photosStatus.isGranted) {
      await Permission.contacts.request();
    }
    if (await Permission.contacts.request().isGranted) {
      Get.offAll(WonderEvents());

    } else {
      print("permission");
      await Permission.contacts.request();
    }
    // Get.offAll(SignIn());

  }

  // Method for showing image and it's description

  Column _centerImageWithText(
      {required String text, required String text1, required String image}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: Image.asset(image)),
        Expanded(
          flex: 0,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 24),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              text1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
