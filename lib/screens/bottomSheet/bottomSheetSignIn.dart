import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../controller/commonController.dart';
import '../../main_page.dart';
import '../../service/getAPI.dart';
import '../authPage/forgotPassword.dart';
import '../authPage/signUp.dart';
import '../../commonModule/utils.dart';

import 'package:http/http.dart' as http;


class BottomSheetSignIn extends StatefulWidget {
  final int curIndex;
  int noOfPopTime;

  BottomSheetSignIn({Key? key,this.noOfPopTime=-1,required this.curIndex}) : super(key: key);

  @override
  State<BottomSheetSignIn> createState() => _BottomSheetSignInState();
}

class _BottomSheetSignInState extends State<BottomSheetSignIn> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  String? name;
  bool hidePassword=true;
  Map _userObj = {};
  CommonController cx = Get.put(CommonController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.curIndex);

  }
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height / 3.8,
        ),
        Container(
          // height: size.height*2.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(cx.height / 13.34),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: cx.height / 33.5, right: cx.height / 44.47),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),

              children: [
                Gap(cx.height / 22.23),
                SenticText(
                  textAlign: TextAlign.center,
                  text: 'Sign In',
                  fontSize: cx.height > 800 ? 32 : 28,
                  fontWeight: FontWeight.w500,
                ),
                Gap(cx.height / 95.29),
                NunitoText(
                  textAlign: TextAlign.center,
                  text: "Sign in if your account exists",
                  fontWeight: FontWeight.w400,
                  fontSize: cx.height > 800 ? 19 : 17,
                  color: Color(0xFF6F6B6B),
                ),
                Gap(cx.height / 22.23),
                Form(
                  key: signInFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailcontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.emailAddress,

                        textInputAction: TextInputAction.next,

                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                          hintText: "Enter Email",
                          hintStyle: TextStyle(
                            fontSize: cx.height > 800 ? 17 : 15,
                            color: Color(0xFF628477),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
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
                        validator: (value){
                          String pattern =
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                          RegExp regex = RegExp(pattern);
                          if (value == null || value.isEmpty || !regex.hasMatch(value)) {
                            return "Please Enter Valid Email";
                          }
                          else{
                          }
                          return null;
                        },
                      ),
                      Gap(cx.height / 44.47),
                      TextFormField(
                        controller: passcontroller,
                        textInputAction: TextInputAction.done,
                        obscureText: hidePassword?true:false,

                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                          hintText: "Enter Password",
                          hintStyle: TextStyle(
                            fontSize: cx.height > 800 ? 17 : 15,
                            color: Color(0xFF628477),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          suffixIcon: InkWell(
                            onTap: (){
                              setState((){
                                hidePassword=!hidePassword;
                              });
                            },
                            child: hidePassword?Icon(
                                Icons.visibility_rounded
                            ):Icon(
                                Icons.visibility_off_rounded),
                          ),
                          filled: true,
                          contentPadding: EdgeInsets.fromLTRB(
                            cx.height / 26.68,
                            cx.height / 41.69,
                            0,
                            cx.height / 41.69,
                          ),
                        ),
                        validator: (value){
                          if (value == null ) {
                            return "Please Enter Valid Password";
                          }
                          else if(value.length<8){
                            return "Password must be greater than or equal to 8 char";
                          }
                          else{

                          }
                          return null;
                        },
                        onChanged: (value) {
                          // debugPrint("Searching Domes");
                          // if (value.isNotEmpty) {
                          //   autoCompleteSearch(value);
                          // } else {
                          //   if (predictions.length > 0 && mounted) {
                          //     setState(() {
                          //       predictions = [];
                          //     });
                          //   }
                          // }
                        },
                      ),
                      Gap(cx.height / 44.47),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            child: NunitoText(
                              textAlign: TextAlign.center,
                              text: "Forgot password?",
                              fontWeight: FontWeight.w400,
                              fontSize: cx.height > 800 ? 17 : 15,
                              color: Color(0xFFA8A8A8),
                            ),
                            onTap: (){
                              Get.to(ForgotPassword(),
                                  transition: Transition.rightToLeft);
                            },
                          ),
                        ],
                      ),
                      Gap(cx.height / 15),
                      Padding(
                        padding:  EdgeInsets.only(
                          bottom:cx.responsive(33,25,20),
                          right:cx.responsive(25,20,15),
                          left:cx.responsive(22,15,10),
                        ),
                        child: Container(
                          height: cx.responsive(cx.height/13.8,cx.height/13.8,cx.height/12.13),
                          width: cx.width/1.25,
                          child: CustomButton(
                            text: "Sign In",
                            fun: () {
                              if(signInFormKey.currentState!.validate()){
                                signIn(widget.curIndex);
                              }
                              else{
                                print("no fetch data");

                              }                            },
                            color:AppColor.darkGreen,
                            radius: cx.height / 11.17,
                            width: cx.width / 4,
                            size: cx.responsive(23, 19, 15),
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(cx.height / 66.7),
                Padding(
                  padding:  EdgeInsets.only(
                    left: cx.responsive(12,10, 9),
                    right: cx.responsive(12,10, 9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: DottedLine(
                          dashLength: 10,
                          dashColor: Color(0xFFD6D6D6),
                          lineThickness: 1.7,
                          lineLength: cx.responsive(cx.height/7.2, cx.height/7.2, cx.height/6),
                        ),
                      ),
                      NunitoText(
                        text: "OR",
                        fontWeight: FontWeight.w500,
                        fontSize: cx.height > 800 ? 21 : 18,
                        color: Color(0xFFD6D6D6),
                      ),
                      Flexible(
                        child: DottedLine(
                          dashLength: 10,
                          dashColor: Color(0xFFD6D6D6),
                          lineThickness: 1.7,
                          lineLength: cx.responsive(cx.height/7.2,cx.height/7.2, cx.height/6),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(cx.height / 38),

                NunitoText(
                  textAlign: TextAlign.center,
                  text: "Log in with",
                  fontWeight: FontWeight.w700,
                  fontSize: cx.height > 800 ? 19 : 17,
                  color: Color(0xFF757575),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Image.asset(
                        'assets/images/google.png',
                        scale: 2.1,
                      ),
                      onTap: (){
                        googleSignin();
                      },
                    ),
                    Platform.isIOS?InkWell(
                      child: Image.asset(
                        'assets/images/apple.png',
                        scale: 2.1,

                      ),

                      onTap: () async {
                        final appleIdCredential = await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                          webAuthenticationOptions: WebAuthenticationOptions(
                            // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                            clientId:
                            'de.lunaone.flutter.signinwithappleexample.service',

                            redirectUri:
                            // For web your redirect URI needs to be the host of the "current page",
                            // while for Android you will be using the API server that redirects back into your app via a deep link
                            // kIsWeb
                            //     ? Uri.parse('https://${window.location.host}/')
                            //     :
                            Uri.parse(
                              'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                            ),
                          ),
                          // TODO: Remove these if you have no need for them
                          // nonce: 'example-nonce',
                          // state: 'example-state',
                        );

                        final credential =
                        OAuthProvider('apple.com').credential(
                          idToken: appleIdCredential.identityToken,
                          accessToken: appleIdCredential.authorizationCode,
                          // rawNonce: 'example-nonce'
                        );
                        await FirebaseAuth.instance.signInWithCredential(credential);

                        // ignore: avoid_print
                        print(FirebaseAuth.instance.currentUser);


                        print("credential2");
                        print(appleIdCredential);
                        print(appleIdCredential.identityToken);
                        print(appleIdCredential.email);
                        print(appleIdCredential.authorizationCode);
                        print(appleIdCredential.familyName);
                        print(appleIdCredential.givenName);
                        print(appleIdCredential.userIdentifier);


                        print(credential);


                        final userData=FirebaseAuth.instance.currentUser;
                        print("Sending data to API");
                        print(userData);


                        TaskProvider.appleSignInAPI(
                          email: userData?.providerData[0].email.toString()!=null?userData?.email.toString():"",
                          // name: userData?.displayName.toString()!=null?userData?.displayName.toString():"",
                          name: userData?.providerData[0].displayName.toString()!=null?userData?.providerData[0].displayName.toString():"",
                          phone: userData?.providerData[0].phoneNumber.toString()!=null?userData?.phoneNumber.toString():"",
                          uid: userData?.providerData[0].uid.toString()!=null?userData?.uid.toString():"",
                          context:context,
                            curIndex: widget.curIndex,
                            noOfPopTime: widget.noOfPopTime
                        );

                        // print("credential3");
                        // await FirebaseAuth.instance.signInWithCredential(credential);
                        // print("credential");
                        // print(credential);
                        //

                        // This is the endpoint that will convert an authorization code obtained
                        // via Sign in with Apple into a session in your system
                        final signInWithAppleEndpoint = Uri(
                          scheme: 'https',
                          host: 'flutter-sign-in-with-apple-example.glitch.me',
                          path: '/sign_in_with_apple',
                          queryParameters: <String, String>{
                            'code': appleIdCredential.authorizationCode,
                            if (appleIdCredential.givenName != null)
                              'firstName': appleIdCredential.givenName!,
                            if (appleIdCredential.familyName != null)
                              'lastName': appleIdCredential.familyName!,
                            'useBundleId':
                            !kIsWeb && (Platform.isIOS || Platform.isMacOS)
                                ? 'true'
                                : 'false',
                            if (appleIdCredential.state != null) 'state': appleIdCredential.state!,
                          },
                        );

                        final session = await http.Client().post(
                          signInWithAppleEndpoint,
                        );

                        // If we got this far, a session based on the Apple ID credential has been created in your system,
                        // and you can now set this as the app's session
                        // ignore: avoid_print
                        print("session");
                        print(session);
                        print(session.body);
                        print(session.contentLength);
                        print(session.request);
                        print(session.persistentConnection);
                        print(session.reasonPhrase);
                        print(session.headers);



                      },
                    ):Container(),
                    InkWell(
                      onTap: () async {
                        FacebookAuth.instance.login(
                            permissions: ["public_profile", "email"]).then((value) {
                          FacebookAuth.instance.getUserData().then((userData) async {

                            setState(() {
                              _userObj = userData;
                            });
                            // print(_userObj);
                            // print(_userObj['name']);
                            TaskProvider.facebooSignInAPI(
                              image: _userObj['picture']['data']['url'],
                              name: _userObj['name'],
                              email:_userObj['email'],
                              uid: _userObj['id'],
                              context: context,
                                curIndex: widget.curIndex,
                                noOfPopTime: widget.noOfPopTime

                            );
                          });
                        });

                      },
                      child: Image.asset(
                        'assets/images/facebook.png',
                        scale: 2.1,

                      ),

                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    NunitoText(
                      textAlign: TextAlign.center,
                      text: "Don't have an account? ",
                      fontWeight: FontWeight.w400,
                      fontSize: cx.height > 800 ? 18 : 16,
                      color: Color(0xFFA8A8A8),
                    ),
                    InkWell(
                      onTap: () {
                        Get.off(SignUp(noOfPopTime: widget.noOfPopTime,curIndex: widget.curIndex),
                        transition: Transition.rightToLeft);
                      },
                      child: NunitoText(
                        textAlign: TextAlign.center,
                        text: " Sign Up",
                        fontWeight: FontWeight.bold,
                        fontSize: cx.height > 800 ? 18 : 16,
                        color: AppColor.darkGreen,
                      ),
                    ),
                  ],
                ),
                Gap(cx.height / 9),

              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> googleSignin() async {
    final googleSignIn = GoogleSignIn();
    final signInAccount = await googleSignIn.signIn();

    final googleAccountAuthentication = await signInAccount?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAccountAuthentication?.accessToken,
        idToken: googleAccountAuthentication?.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    if (FirebaseAuth.instance.currentUser != null) {
      onAlert(context: context,type: 1,msg: "Loading...");
      print("Google Account success");
      print("${FirebaseAuth.instance.currentUser?.displayName} signed in");
      print("${FirebaseAuth.instance.currentUser?.toString()}");
      setState(() {
        name = FirebaseAuth.instance.currentUser?.displayName;
        if(FirebaseAuth.instance.currentUser?.photoURL!=null){
          cx.profilePicture.value=FirebaseAuth.instance.currentUser!.photoURL!;
        }

        print(name);
        print(FirebaseAuth.instance.currentUser?.photoURL);

      });

      final userData=FirebaseAuth.instance.currentUser;
      TaskProvider.googleSignInAPI(
        email: userData?.providerData[0].email.toString()??"",
        name: userData?.providerData[0].displayName.toString()??"",
        phone: userData?.providerData[0].phoneNumber??"",
        uid: userData?.providerData[0].uid.toString()??"",
        is_verified: userData?.emailVerified.toString()??"",
        image: userData?.providerData[0].photoURL.toString()??"",
        context: context,
        curIndex: widget.curIndex,
        noOfPopTime: widget.noOfPopTime
      );


    } else {
      onAlert(context: context,type: 3,msg: "Google SignIn Failed");
      print("Unable to sign in");
    }
  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 240,
            child: SizedBox.expand(child: FlutterLogo()),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
  Future signIn(int currentIndex) async {
    print("currentIndex");
    print(currentIndex);
    onAlert(context: context,type: 1,msg: "Loading...");

    try {
      var request = http.MultipartRequest('POST', Uri.parse(Constant.signIn));
      request.fields.addAll({
        'email': emailcontroller.text,
        'password': passcontroller.text,
        'fcm_token': Constant.fcmToken.isEmpty?"test":Constant.fcmToken,
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {
        print("1");
        cx.write('username',jsonBody['userdata']['name']);
        cx.write('useremail',jsonBody['userdata']['email']);
        cx.write('phone',jsonBody['userdata']['phone']);
        cx.write('countrycode',jsonBody['userdata']['countrycode']);
        cx.write('image',jsonBody['userdata']['image']);
        cx.write('id',jsonBody['userdata']['id']);
        cx.write('islogin',true);
        cx.write('isVerified',true);

        cx.id.value=cx.read("id");
        cx.email.value=cx.read("useremail");
        cx.phone.value=cx.read("phone");
        cx.countrycode.value=cx.read("countrycode");
        cx.image.value=cx.read("image");
        cx.isLogin.value=cx.read("islogin");
        cx.name.value=cx.read("username");
        cx.isVerified.value=cx.read("isVerified");
        print(jsonBody.toString());

        onAlert(context: context,type: 2,msg: jsonBody['message']);
        Duration du=Duration(seconds: 2);
        Timer(du, () {

          //Navigation from receipt
          if(widget.noOfPopTime==99){
            widget.noOfPopTime=1;
            Get.back();
            while(widget.noOfPopTime!=0){
              widget.noOfPopTime--;
              Get.back(result: true);
            }
          }
          else if(widget.noOfPopTime!=-1){
            while(widget.noOfPopTime!=0){
             widget.noOfPopTime--;
             Get.back();
            }
          }
          else{
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                WonderEvents(curIndex: widget.curIndex,)),
                  (Route<dynamic> route) => false,);
          }
        });

      } else {
        print("0");
        onAlert(context: context,type: 3,msg: jsonBody['message']);
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
  }

}
