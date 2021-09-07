import 'package:flutter/material.dart';
import 'package:flutterradio/fondo_color/hex_color.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoticiaWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var link = "https://radiocarabaya.com";
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(GlobalConfiguration().getString("title")),
          backgroundColor: HexColor(GlobalConfiguration().getString("color")),
        ),
        body: WebView(initialUrl: link));
  }
}
