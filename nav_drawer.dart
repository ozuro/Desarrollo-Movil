import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterradio/SplashScreen/loading.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';
import 'dart:convert';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  double icono = 0;
  ListTile hola;
  List<dynamic> _posts;
  String telefono = "";
  String telefono1 = "tel:+9510000001";
  bool icono1 = false;
  @override
  void initState() {
    super.initState();
    this._setPosts();
  }

  Future<List<dynamic>> getListFromConfig(String filename) async {
    final contents = await rootBundle.loadString('assets/cfg/' + filename);
    return json.decode(contents);
  }

  void _setPosts() async {
    getListFromConfig('carabaya.json').then((response) {
      setState(() {
        String temp;
        this._posts = response;
        this._posts.map((e) {
          temp = e['telefono'];
        }).toList();
        telefono = temp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/img/' +
                        GlobalConfiguration().getString("background")))),
            child: null,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Sitio Web'),
            onTap: () => {navWebsite(context)},
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Enviar mensaje'),
            onTap: () {
              Navigator.of(context).pop(sms());
            },
          ),
          ListTile(
            leading: Icon(Istos.whatsapp),
            title: Text('Enviar whatsapp'),
            onTap: () {
              // if (FlutterOpenWhatsapp == null) {
              //   print("no tiene whatsapp ");
              // } else {
              Navigator.of(context).pop(FlutterOpenWhatsapp.sendSingleMessage(
                  "+51935721912", "Hola Radio Carabaya,"));
              // }
            },
          ),

          this.llamarRadio(),
          // ListTile(
          //   leading: Icon(Icons.call),
          //   title: Text('Llamar a la radio'),
          //   onTap: () {
          //     Navigator.of(context).pop(llamar());
          //     print("HOLAAAAAA");
          //   },
          // ),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Salir'),
              onTap: () {
                Navigator.of(context).pop(salir());
              }),
        ],
      ),
    );
  }

  void navWebsite(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SplashScreen(),
      ),
    );
  }

  Widget llamarRadio() {
    return ListTile(
      leading: Icon(Icons.call),
      title: Text('Llamar a la radio'),
      onTap: () {
        Navigator.of(context).pop(llamar(telefono));

        print("HOLAAAAAA");
      },
    );
  }

  sms() {
    String mensaje = "sms:9510000001";
    launch(mensaje);
  }

  llamar(String llamar) {
    // String llamar = "tel:+9510000001";
    // String llamar = _datos['telefono'];
    print("===========================");
    print(llamar);
    launch(llamar);
  }

  salir() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    exit(0);
  }
}
