import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterradio/Menu_izquierdo/nav_drawer.dart';
import 'package:flutterradio/fondo_color/fondo.dart';
import 'package:flutterradio/menu_derecho/slider_dialog.dart';
import 'package:flutterradio/radio/radio_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io' show Platform;
import 'package:global_configuration/global_configuration.dart';
import 'package:flutterradio/fondo_color/hex_color.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:launch_review/launch_review.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String msg = 'hola, mensaje a enviar!';
  AnimationController _animationController;
  TimeOfDay _tiempo = TimeOfDay.now();

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _tiempo = newTime;
    });
  }

  void startServiceInPlatform(DateTime _dateTime) async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel(
        "com.flutter.background_services",
      );

      DateTime time = new DateTime(
        _dateTime.year,
        _dateTime.month,
        _dateTime.day,
        _dateTime.hour,
        _dateTime.minute,
        0,
        0,
        0,
      );

      await methodChannel.invokeMethod(
          "setRadioAlarma", {"time": time.millisecondsSinceEpoch});
    }
  }

  PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {},
      children: <Widget>[Principal()],
    );
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await rateMyApp.init();
        if (mounted && rateMyApp.shouldOpenDialog) {
          rateMyApp.showStarRateDialog(
            context,
            title: 'Radio Carabaya',
            message: 'Te gusta esta aplicacion? brindenos su valoracion:',
            actionsBuilder: (context, stars) {
              return [
                FlatButton(
                  child: Text('Enviar'),
                  onPressed: () async {
                    debugPrint('Gracias por ' +
                        (stars == null ? '0' : stars.round().toString()) +
                        ' estrellas !');
                    await rateMyApp
                        .callEvent(RateMyAppEventType.rateButtonPressed);
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.rate);
                  },
                ),
              ];
            },
            ignoreNativeDialog: Platform.isAndroid,
            dialogStyle: DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions: StarRatingOptions(),
            onDismissed: () =>
                rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
          );
        }
      },
    );
  }

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 1,
    minLaunches: 1,
    remindDays: 1,
    remindLaunches: 1,
    googlePlayIdentifier: 'com.iyaffle.kural',
    //appStoreIdentifier: '1491556149',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(GlobalConfiguration().getString("title")),
        backgroundColor: HexColor(GlobalConfiguration().getString("color")),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (value) {
              if (value == 1) {
                showDialog(
                  context: context,
                  builder: (context) => TimePickerDialog(initialtime: 12),
                );
              } else {
                Navigator.of(context).push(
                  showPicker(
                    context: context,
                    unselectedColor: Colors.green,
                    accentColor: Colors.green,
                    value: _tiempo,
                    onChange: onTimeChanged,
                    minuteInterval: MinuteInterval.ONE,
                    disableHour: false,
                    disableMinute: false,
                    cancelText: "Cancelar",
                    okText: "Guardar",
                    minMinute: 0,
                    maxMinute: 59,
                    onChangeDateTime: (DateTime _dateTime) {
                      startServiceInPlatform(_dateTime);
                      double horas = 0;
                      double minutos = 0;
                      DateTime hola = DateTime.now();
                      double minutoactual = hola.minute.toDouble();
                      setState(() {
                        minutos = _dateTime.minute.toDouble();
                      });
                      minutos = minutos - minutoactual;
                      //   minutos = minutos + 10;
                      Timer(
                          Duration(
                              hours: horas.toInt(),
                              minutes: minutos.toInt()), () async {
                        SystemChannels.platform
                            .invokeListMethod('SystemNavigator.push');
                        await AudioService.play();
                      });
                    },
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 1,
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.stopwatch,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5),
                      Text("Temporizador"),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.alarm_add_sharp,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5),
                      Text("Alarma de radio"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: new Stack(
          children: <Widget>[
            buildPageView(),
            Positioned(
              child: new Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: AudioServiceWidget(child: RadioPlayer())),
            ),
            CircularMenu(
              toggleButtonAnimatedIconData: AnimatedIcons.add_event,
              alignment: Alignment.bottomRight,
              toggleButtonSize: 18,
              toggleButtonColor: Colors.amber,
              items: [
                CircularMenuItem(
                    icon: Icons.star_outline,
                    color: HexColor(GlobalConfiguration().getString("color")),
                    onTap: () {
                      Navigator.of(context).pop(calificar());
                      _animationController.reverse();
                    }),
                CircularMenuItem(
                    icon: Icons.share_outlined,
                    color: HexColor(GlobalConfiguration().getString("color")),
                    onTap: () async {
                      var response =
                          await FlutterShareMe().shareToSystem(msg: msg);
                      if (response == 'success') {
                        print('navigate success');
                        _animationController.reverse();
                      } else {
                        print("no tiene whatsapp");
                      }
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

calificar() {
  LaunchReview.launch(androidAppId: "com.iyaffle.kural", iOSAppId: "585027354");
}
