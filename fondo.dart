import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/" +
                      GlobalConfiguration().getString("background")),
                  fit: BoxFit.cover)),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
          child: Center(
            child: Image.asset(
              "assets/img/" + GlobalConfiguration().getString("logo"),
              height: 250,
            ),
          ),
        )
      ],
    ));
  }
}
