import 'package:flutter/material.dart';
import 'package:flutterradio/HomePage.dart';

import 'package:loading_indicator/loading_indicator.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                color: Colors.green[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget _getLogo() {
//   return Container(
//     child: Stack(
//       children: <Widget>[
//         Positioned(
//           child: Container(
//             // color: Colors.black,
//             margin: EdgeInsets.only(top: 50),
//             child: Center(
//               child: Image(
//                 image: AssetImage('assets/img/logo-carabaya.png'),
//               ),
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }
