import 'package:flutter/material.dart';
import 'package:flutterradio/fondo_color/hex_color.dart';
import 'package:flutterradio/Menu_izquierdo/noticia_WebView.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var url = "https://radiocarabaya.com";
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NoticiaWebView(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(GlobalConfiguration().getString("title")),
        backgroundColor: HexColor(GlobalConfiguration().getString("color")),
      ),
      body: Center(
        child: Container(
          width: 50,
          height: 50,
          child: LoadingIndicator(
            indicatorType: Indicator.ballRotateChase,
            color: Colors.green[500],
          ),
        ),
      ),
    );
  }
}
