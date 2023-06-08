import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:domez/commonModule/AppColor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:image_compression_flutter/flutter_image_compress.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../controller/commonController.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  CommonController cx = Get.put(CommonController());
  bool iscategories = false;
  bool isdistance = false;
  bool isprice = false;

  double start = 0.0;
  double end = 200.0;
  double minDistance = 0.0;
  double maxDistance = 500.0;

  double start1 = 0.0;
  double end1 = 50.0;
  double minPrice = 0.0;
  double maxPrice = 200.0;
  RangeLabels labels = RangeLabels('1', "500");
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  String twodigitcountryCode = '';

  // String compressedTargetImagePath = '/storage/emulated/0/Download/siraj.jpg';

  int vollyIndex = 0;
  final GlobalKey<FormState> EditProfileFormKey = GlobalKey<FormState>();

  File? image;
  Directory? dir;

  XFile? photo;
  final ImagePicker _picker = ImagePicker();
  bool isImage = false;

  @override
  void initState() {
    super.initState();
    namecontroller.text = cx.read("username");
    emailcontroller.text = cx.read("useremail");
    print(cx.read("phone"));
    print(cx.read("countrycode"));

    if (cx.read("phone").toString().isNotEmpty||cx.read("phone")!=null) {
      phonecontroller.text = cx.read("phone");
    }
    if (cx.read("countrycode") != null||cx.read("countrycode").toString().isNotEmpty) {
      print("HEY Dhrugv");
      twodigitcountryCode = cx.read("countrycode");
    }
    print(twodigitcountryCode);
    print("Phone number controller"+phonecontroller.text);


    if(phonecontroller.text.isEmpty){
      print("phonecontroller.text");
      setState((){
        phonecontroller.text="";
        phonecontroller.value=TextEditingValue(text: "");
      });
    }


    getPath();
  }

  Future<void> getPath() async {
    if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
      print(dir);

      if (!dir!.existsSync()) {
        dir?.createSync();
      }
    } else {
      dir = Directory("/storage/emulated/0/Download");
      if (!dir!.existsSync()) {
        dir?.createSync();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          //color set to transperent or set your own color
          statusBarIconBrightness: Constant.deviceBrightness,
          //set brightness for icons, like dark background light icons
        )
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 18, 30, 18),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: cx.width * 0.09,
                    height: cx.width * 0.09,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFF5F7F9),
                            blurRadius: 8,
                            spreadRadius: 7, //New
                          )
                        ],
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFE8FFF6),
                        )),
                    child: Padding(
                      padding: EdgeInsets.only(left: cx.width * 0.02),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(cx.height / 30),
            Container(
              height: cx.height * 0.8,
              child: Form(
                key: EditProfileFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Container(
                            width: cx.width / 3,
                            height: cx.width / 3,
                            child: Stack(
                              children: [
                                buildImage(),
                                Positioned(
                                  bottom: cx.height * 0.005,
                                  right: 4,
                                  child: InkWell(
                                      onTap: () {
                                        onEditProfile(context: context);
                                      },
                                      child: buildEditIcon(Theme.of(context)
                                          .colorScheme
                                          .primary)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(cx.height / 20),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: namecontroller,
                          maxLength: 30,
                          cursorColor: Color(0xFF628477),
                          keyboardType: TextInputType.text,

                          style: TextStyle(
                            fontSize: cx.height > 800 ? 19 : 17,
                            color: AppColor.darkGreen,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            fillColor: AppColor.bg,
                            hintText: "Cody Fisher",
                            hintStyle: TextStyle(
                                fontSize: cx.height > 800 ? 17 : 15,
                                color: AppColor.darkGreen,
                                fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(cx.height / 6.67),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(cx.height / 6.67),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(cx.height / 6.67),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(cx.height / 6.67),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(
                              cx.height / 26.68,
                              cx.height / 41.69,
                              0,
                              cx.height / 41.69,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Full Name";
                            }
                            return null;
                          },
                        ),
                        Gap(cx.height / 44.47),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: emailcontroller,
                          cursorColor: Color(0xFF628477),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: cx.height > 800 ? 19 : 17,
                            color: AppColor.darkGreen,
                          ),
                          decoration: InputDecoration(
                            fillColor: AppColor.bg,
                            // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                            hintText: "testdomez@gmail.com",
                            hintStyle: TextStyle(
                                fontSize: cx.height > 800 ? 17 : 15,
                                color: AppColor.darkGreen,
                                fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(cx.height / 6.67),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(cx.height / 6.67),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(cx.height / 6.67),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(cx.height / 6.67),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),

                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(
                              cx.height / 26.68,
                              cx.height / 41.69,
                              0,
                              cx.height / 41.69,
                            ),
                          ),
                          validator: (value) {
                            String pattern =
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                            RegExp regex = RegExp(pattern);
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Email Address";
                            } else if (!regex.hasMatch(value)) {
                              return "Please Enter Valid Email";
                            } else {}
                          },
                        ),
                        Gap(cx.height / 44.47),
                        IntlPhoneField(
                          textInputAction: TextInputAction.done,

                          obscureText: false,
                          controller: phonecontroller,
                          flagsButtonPadding: EdgeInsets.all(10),
                          style: TextStyle(
                            fontSize: cx.height > 800 ? 19 : 17,
                            color: AppColor.darkGreen,
                          ),
                          cursorColor: AppColor.darkGreen,
                          dropdownTextStyle: TextStyle(
                            fontSize: cx.height > 800 ? 16 : 14,
                            color: AppColor.darkGreen,
                          ),
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(
                              cx.responsive(36, 30, 26),
                              cx.responsive(22, 18, 16),
                              cx.responsive(36, 30, 26),
                              cx.responsive(22, 18, 16),
                            ),
                            filled: true,
                            fillColor: AppColor.bg,
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                              fontSize: cx.height > 800 ? 17 : 15,
                              color: Color(0xFF628477),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColor.Green,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFD53E3E),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFD53E3E),
                              ),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          invalidNumberMessage: "Please Enter Valid Length",
                          initialCountryCode: twodigitcountryCode.isEmpty?"CA":twodigitcountryCode,
                          // initialValue: '+91',
                          onCountryChanged: (country) {
                            setState(() {
                              twodigitcountryCode = country.code;
                              print(twodigitcountryCode);
                              print("countryCode");
                            });
                          },
                          // onChanged: (phone) {
                          //   setState(() {
                          //     countryCode=phone.countryCode;
                          //     print("countryCode");
                          //     print(countryCode);
                          //   });
                          // },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: cx.responsive(33, 25, 20),
                        right: cx.responsive(26, 20, 18),
                        left: cx.responsive(26, 20, 18),
                      ),
                      child: Container(
                        height: cx.height / 12,
                        width: cx.width / 1.4,
                        child: CustomButton(
                          text: "Save",
                          fun: () {
                            if (!cx.isDataProcessing.value) {
                              if (EditProfileFormKey.currentState!.validate()) {
                                editProfile();
                                // Get.back();
                              }
                            }
                          },
                          color: Colors.black.withOpacity(0.9),
                          radius: cx.height / 44.47,
                          width: cx.width / 4,
                          size: cx.responsive(25, 22, 15),
                          textColor: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onEditProfile({
    required BuildContext context,
  }) {
    Alert(
      style: AlertStyle(
          buttonsDirection: ButtonsDirection.column,
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: Color(0xFF9BD9C1),
              width: 2.5,
            ),
          ),
          alertElevation: 100,
          isButtonVisible: false),
      onWillPopActive: true,

      context: context,
      content: Column(
        children: <Widget>[
          Gap(cx.height / 80),
          Text(
            "Change Profile Image",
            style: TextStyle(
                fontSize: cx.responsive(24, 20, 18),
                fontWeight: FontWeight.w700),
          ),
          Gap(cx.height / 45),
          InkWell(
            onTap: () async {
              var photosStatus = await Permission.storage.status;
              if (!photosStatus.isGranted) {
                await Permission.storage.request();
              }

              else if(photosStatus.isPermanentlyDenied){
                _showOpenAppSettingsDialog(context);
                await Permission.storage.request();
              }
              else if(photosStatus.isDenied){
                _showOpenAppSettingsDialog(context);
                await Permission.storage.request();
              }
              else if (photosStatus.isRestricted) {
                _showOpenAppSettingsDialog(context);
                await Permission.storage.request();

              }
              else{
                photo = await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  image = (File(photo!.path));
                });

                if (image == null) {
                  setState(() {
                    isImage = false;
                  });
                } else {
                  setState(() {
                    isImage = true;
                    compressImage(photo!).then((value) {
                      cx.isDataProcessing.value = false;

                      image = value;
                      print("value.toString()");
                      print(image!.path);
                      print(value.toString());
                      print(value.path.toString());
                    });
                  });
                }
                print(photo!.path);
                print(image!.path);
                Navigator.of(context).pop();
              }

              // Duration du = const Duration(seconds: 2);
              // Timer(du, () {
              //   // Get.offAll(WonderEvents());
              //   Get.back();
              // });
            },
            child: Container(
              // width: widget.width,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(cx.height / 66.7),
              child: Center(
                child: NunitoText(
                  text: "Open Camera",
                  fontWeight: FontWeight.w700,
                  fontSize: cx.responsive(26, 20, 16),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Gap(cx.height / 60),
          InkWell(
            onTap: () async {
              var photosStatus = await Permission.storage.status;
              if (!photosStatus.isGranted) {
                await Permission.storage.request();
              }
              else{
                photo = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  image = (File(photo!.path));
                });
                Navigator.of(context).pop();
                print(photo!.path);
                print(image!.path);

                if (image == null) {
                  setState(() {
                    isImage = false;
                  });
                } else {
                  print("image!.absolute");
                  print(image!.absolute);
                  print(dir.toString());
                  setState(() {
                    isImage = true;

                    compressImage(photo!).then((value) {
                      cx.isDataProcessing.value = false;

                      image = value;
                      print("value.toString()");
                      print(image!.path);
                      print(value.toString());
                      print(value.path.toString());
                    });
                  });
                }
              }


              // Duration du = const Duration(seconds: 2);
              // Timer(du, () {
              //   Get.back();
              // });
            },
            child: Container(
              // width: widget.width,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(cx.height / 66.7),
              child: Center(
                child: NunitoText(
                  text: "Open Gallery",
                  fontWeight: FontWeight.w700,
                  fontSize: cx.responsive(26, 20, 16),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),

      closeIcon: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.cancel,
          color: Colors.red,
        ),
      ),
      // onWillPopActive:true ,
    ).show();
  }

  Widget buildImage() {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: isImage
            ? Obx(
                () => cx.isDataProcessing.value
                    ? Container(
                        width: cx.width / 3,
                        height: cx.width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            border:
                                Border.all(color: Color(0xFfDCE4E1), width: 3)),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: AppColor.darkGreen,
                        )),
                      )
                    : Container(
                        width: cx.width / 3,
                        height: cx.width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            border:
                                Border.all(color: Color(0xFfDCE4E1), width: 3)),
                        child: Ink.image(
                          image: FileImage(File(image!.path)),
                          fit: BoxFit.cover,
                          width: cx.width / 3,
                          height: cx.width / 3,
                          // child: InkWell(
                          // onTap: onEditProfile(context: context),
                          // ),
                        ),
                      ),
              )
            : Container(
                width: cx.width / 3,
                height: cx.width / 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    border: Border.all(color: Color(0xFfDCE4E1), width: 3)),
                child: CachedNetworkImage(
                  imageUrl: cx.read("image"),
                  imageBuilder: (context, imageProvider) => Ink.image(
                    image: NetworkImage(cx.read("image")),
                    fit: BoxFit.cover,
                    width: cx.width / 3,
                    height: cx.width / 3,
                    // child: InkWell(
                    // onTap: onEditProfile(context: context),
                    // ),
                  ),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Ink.image(
                    image: AssetImage(
                      Image1.anime,
                    ),
                    fit: BoxFit.cover,
                    width: cx.width / 3,
                    height: cx.height / 5.6,
                    // child: InkWell(
                    // onTap: onEditProfile(context: context),
                    // ),
                  ),
                  errorWidget: (context, url, error) => Ink.image(
                    image: AssetImage(
                      Image1.anime,
                    ),
                    fit: BoxFit.cover,
                    width: cx.width / 3,
                    height: cx.height / 5.6,
                    // child: InkWell(
                    // onTap: onEditProfile(context: context),
                    // ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 0,
          child: Image.asset(
            'assets/images/profileCamera.png',
            width: 30,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  void editProfile() async {
    onAlert(context: context, type: 1, msg: "Loading...");

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(Constant.editProfile));
      request.fields.addAll({
        'name': namecontroller.text,
        'phone': phonecontroller.text,
        'email': emailcontroller.text,
        'countrycode': twodigitcountryCode.isEmpty?"CA":twodigitcountryCode,
        'user_id': cx.id.value.toString(),
      });
      if (isImage) {
        print(image!.path);
        print("hurry");
        request.files
            .add(await http.MultipartFile.fromPath('image', image!.path));
      }
      print(request.fields);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (jsonBody['status'] == 1) {
        print(jsonBody.toString());
        cx.write('username', jsonBody['userdata']['name']);
        cx.write('useremail', jsonBody['userdata']['email']);
        cx.write('phone', jsonBody['userdata']['phone']);
        cx.write('countrycode', jsonBody['userdata']['countrycode']);
        cx.write('image', jsonBody['userdata']['image']);
        cx.write('id', jsonBody['userdata']['id']);
        cx.write('islogin', true);
        cx.write('isVerified', true);

        print("cx.read(image");
        print(cx.read("image"));

        cx.id.value = cx.read("id");
        cx.email.value = cx.read("useremail");
        cx.phone.value = cx.read("phone");
        cx.countrycode.value = cx.read("countrycode");
        cx.image.value = cx.read("image");
        cx.isLogin.value = cx.read("islogin");
        cx.name.value = cx.read("username");
        cx.isVerified.value = cx.read("isVerified");

        onAlert(context: context, type: 2, msg: jsonBody['message']);
        // Get.back();

      } else {
        print("0");
        onAlert(context: context, type: 3, msg: jsonBody['message']);
        print(jsonBody);
      }
    } catch (e) {
      Get.back();
      showLongToast("Oops! Server Unavailable");
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  // Future<File?> testCompressAndGetFile(File file, String targetPath) async {
  //   print("Hey");
  //   print(file.absolute.path);
  //   print(targetPath);
  //
  //   var result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     targetPath,
  //     quality: 88,
  //     rotate: 180,
  //   );
  //
  //   print(file.lengthSync());
  //   print(result?.lengthSync());
  //
  //   return result;
  // }

  Future<File> compressImage(XFile file) async {
    cx.isDataProcessing.value = true;
    print("File Path");
    print(file.path);
    final ImageFile _input =
        ImageFile(filePath: file.path, rawBytes: await file.readAsBytes());
    final Configuration _config = Configuration(
      outputType: ImageOutputType.webpThenPng,
      useJpgPngNativeCompressor: false,
      quality: (_input.sizeInBytes / 1048576) < 2
          ? 90
          : (_input.sizeInBytes / 1048576) < 5
              ? 50
              : (_input.sizeInBytes / 1048576) < 10
                  ? 10
                  : 1,
    );
    final ImageFile output = await compressor
        .compress(ImageFileConfiguration(input: _input, config: _config));
    if (kDebugMode) {
      print('Input size : ${_input.sizeInBytes / 1048576}');
      print('Output size : ${output.sizeInBytes / 1048576}');
      // print(output.pa);
    }
    File file1 = await _createFileFromString(output.rawBytes);
    return file1;
  }

  Future<File> _createFileFromString(bytes) async {

    // final result = await ImageGallerySaver.saveImage(bytes, name: "signature");
    // Directory dir;
    // if (Platform.isIOS) {
    //   dir = await getApplicationDocumentsDirectory();
    //   print(dir);
    //
    //   if (!dir.existsSync()) {
    //     dir.createSync();
    //   }
    // } else {
    //   dir = Directory("/storage/emulated/0/Download");
    //   if (!dir.existsSync()) {
    //     dir.createSync();
    //   }
    // }

    String dir = (await getApplicationDocumentsDirectory()).path;
    var rng = Random();
    for (var i = 0; i < 10; i++) {
      print(rng.nextInt(100));
    }
    String fullPath =
        '${dir}/domez${DateTime.now().millisecondsSinceEpoch}.png';
    print("local file full path ${fullPath}");
    File file = File(fullPath);
    await file.writeAsBytes(bytes);
    print(file.path);

    final result = await ImageGallerySaver.saveImage(bytes);
    print(result);
    print("local file full path ${result['filePath']}");
    print("local file full path ${result.toString()}");
    return file;
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
