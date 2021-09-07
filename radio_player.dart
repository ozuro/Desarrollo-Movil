import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutterradio/radio/audio_services.dart';
import 'package:flutterradio/radio/radio_cons.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutterradio/fondo_color/hex_color.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

class RadioPlayer extends StatefulWidget {
  @override
  _RadioPlayerState createState() => _RadioPlayerState();
}

class _RadioPlayerState extends State<RadioPlayer> {
  IconData iconplayer = FontAwesomeIcons.play;
  double safrono = 30;
  double opacityGif = 0;
  double loader = 0;
  int colornum = 4293322470;
  List<dynamic> _posts;
  String colorjson = "";
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
        this._posts = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = 10;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      screenHeight = MediaQuery.of(context).size.height * 0.20;
    } else {
      screenHeight = MediaQuery.of(context).size.height * 0.10;
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Opacity(
            opacity: loader,
            child: Container(
              width: 50,
              height: 50,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                color: Colors.yellow[700],
              ),
            ),
          ),
          Opacity(
            opacity: opacityGif,
            child: Image.asset("assets/img/voz.gif", gaplessPlayback: true),
          ),
          Container(
            height: screenHeight,
            decoration: BoxDecoration(
              color: HexColor(GlobalConfiguration().getString("color"))
                  .withOpacity(0.7),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 5.0),
                ),
              ],
            ),
            child: Row(
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Center(
                      child: StreamBuilder<PlaybackState>(
                        stream: AudioService.playbackStateStream,
                        builder: (context, snapshot) {
                          final playing = snapshot.data?.playing ?? true;
                          return Column(
                            children: [
                              if (playing) ...{
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.stop),
                                  iconSize: 30,
                                  color: Colors.white,
                                  onPressed: pause,
                                ),
                              } else ...{
                                IconButton(
                                  icon: Icon(iconplayer),
                                  iconSize: safrono,
                                  color: Colors.white,
                                  onPressed: play,
                                ),
                              },
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: this._posts == null
                      ? [CircularProgressIndicator()]
                      : this._posts.map((e) {
                          return Column(
                            children: [
                              ColorizeAnimatedTextKit(
                                onTap: () {
                                  print("Tap Event");
                                },
                                text: [
                                  // "RADIO CARABAYA",
                                  e['title']
                                ],
                                isRepeatingAnimation: false,
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Horizon",
                                ),
                                colors: [
                                  myColor[e['fontColor2']],
                                  myColor[e['fontColor3']],
                                  myColor[e['fontColor4']],
                                  // Colors.yellow,
                                  // Colors.red[900],
                                  // Colors.green,
                                  // Colors.white54,
                                ],
                                textAlign: TextAlign.start,
                              ),
                              TypewriterAnimatedTextKit(
                                speed: Duration(milliseconds: 50),
                                text: [
                                  // "8:30 AM",
                                  // "Señal que une los pueblos",
                                  e['subtitle']
                                ],
                                textStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Agne",
                                  color: myColor[e['fontColor1']],
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          );
                        }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  empezar() {
    AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationColor: 4281942016,
      androidNotificationIcon: 'mipmap/logo_radio',
      androidEnableQueue: true,
      androidResumeOnClick: true,
    );
  }

  play() {
    if (AudioService.running) {
      AudioService.play();
      setState(() {
        opacityGif = 1;
        loader = 0;
        iconplayer = FontAwesomeIcons.play;
      });
    } else {
      empezar();
      setState(() {
        opacityGif = 0;
        loader = 1;
        iconplayer = FontAwesomeIcons.broadcastTower;
        safrono = 25;
      });
      Future.delayed(
        Duration(seconds: 4),
        () => setState(
          () {
            opacityGif = 1;
            loader = 0;
            // iconplayer = Icons.play_arrow;
          },
        ),
      );
    }
  }

  pause() {
    AudioService.pause();
    setState(() {
      opacityGif = 0;
      loader = 0;
      iconplayer = FontAwesomeIcons.play;
      safrono = 30;
    });
  }

  stop() => AudioService.stop();

  // Widget _getcolores() {
  //   if (this._posts == null) {
  //     return CircularProgressIndicator();
  //   } else {
  //     return   Column(
  //       children: this._posts.map<Widget>((e) {
  //         return Container(
  //           margin: EdgeInsets.only(bottom: 15),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //             e['titulo'],
  //             colorjson= e['titulo'],
  //             colornum = colorjson.toI
  //             ],
  //           ),
  //         );
  //       }).toList(),
  //     );
  //   }
  // }
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}
