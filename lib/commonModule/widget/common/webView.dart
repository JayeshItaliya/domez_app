import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '../../AppColor.dart';
import '../../Constant.dart';

class WebViewClass extends StatefulWidget {
  final String title;
  final String url;

  WebViewClass(this.title, this.url);

  @override
  _WebViewClassState createState() => _WebViewClassState();
}
class _WebViewClassState extends State<WebViewClass> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    print(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColor.darkGreen,
          //color set to transperent or set your own color
          statusBarIconBrightness: Constant.deviceBrightness,
          //set brightness for icons, like dark background light icons
        )
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.darkGreen,
        leading: Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: InkWell(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white,
            fontSize: 20,),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);

            },
            onPageFinished: (finish) {
              print(finish.toString());
              setState(() {
                isLoading = false;
              });
            },
            onPageStarted: (url){
              print(url.toString());
              setState(() {
                isLoading = false;
              });

            },

          ),
          isLoading
              ?  Center(
            child: CircularProgressIndicator(
              color: AppColor.darkGreen,
            ),)
              : Stack(),
        ],
      ),
    );
  }
}
