import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimePickerDialog extends StatefulWidget {
  final double initialtime;
  const TimePickerDialog({Key key, this.initialtime}) : super(key: key);
  @override
  _TimePickerDialogState createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  double horas = 0;
  double minutos = 0;
  String text = "nothing";

  void temporizador() async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("canal_temporizador");
      int time = minutos.toInt();
      time = time * 59000;
      await methodChannel.invokeMethod("temp_nativo", {"time": time});
    }
  }

  @override
  Widget build(BuildContext context) {
    var horasInt = horas.toInt();
    var minutosInt = minutos.toInt();
    return AlertDialog(
      title: Text("$horasInt horas y $minutosInt minutos restantes"),
      content: Container(
          height: 200,
          child: Column(
            children: <Widget>[
              Slider(
                activeColor: Colors.green,
                value: horas,
                min: 0,
                max: 12,
                divisions: 12,
                onChanged: (value) {
                  setState(() {
                    horas = value;
                  });
                },
              ),
              Text("Hora"),
              Slider(
                autofocus: true,
                activeColor: Colors.green,
                value: minutos,
                min: 0,
                max: 59,
                divisions: 59,
                onChanged: (value) {
                  setState(() {
                    minutos = value;
                  });
                },
              ),
              Text("Minuto"),
            ],
          )),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
          color: Colors.green[250],
        ),
        FlatButton(
          onPressed: () {
            temporizador();
            Navigator.pop(context);
          },
          child: Text("Guardar"),
        )
      ],
    );
  }
}
