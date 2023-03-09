library chess_clock_companion.global;

import "package:flutter/material.dart";
import "play.dart";
import "dart:convert";
import "dart:async";
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

late BluetoothConnection activeConnection;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Clock white = Clock("White", 300);
Clock black = Clock("Black", 300);
ValueNotifier update = ValueNotifier(false);
TimeOption currentTimeOption = TimeOption("Blitz", 5, 0);
List<TimeOption> time_options = [
  TimeOption("Blitz", 5, 0),
  TimeOption("Rapid", 25, 0),
  TimeOption("Fischer Blitz", 3, 2),
  TimeOption("Fischer Rapid", 25, 10),
];

class Clock {
  String player;
  int currentTime;

  Clock(this.player, this.currentTime);
}

class TimeOption {
  String name;
  int duration;
  int move_bonus_time;

  TimeOption(this.name, this.duration, this.move_bonus_time);
}

void receiveBluetooth() {
  String data = "";
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  activeConnection.input!.listen((_data) {
    update.value = false;
    data += String.fromCharCodes(_data);
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      timer.cancel();

      if (data.isNotEmpty) {
        try {
          if (data.contains("Match Started")) {
            Navigator.of(navigatorKey.currentContext!).push(PageRouteBuilder(
                transitionDuration: Duration(seconds: 1),
                pageBuilder: (context, __, ___) => Play()));
          } else if (data.contains("W")) {
            data = data.trim();
            white.currentTime =
                int.parse(data.split(",")[0].split("W")[1].trim());

            black.currentTime =
                int.parse(data.split(",")[1].split("B")[1].split(";")[0]);

            update.value = true;
          } else {
            data = data.trim();
            data = data.substring(0, data.lastIndexOf("}") + 1);
            final response = jsonDecode(data);
            switch (response["to"].toString().toLowerCase()) {
              case "blitz":
                currentTimeOption = time_options[0];
                break;
              case "fblitz":
                currentTimeOption = time_options[2];
                break;
              case "rapid":
                currentTimeOption = time_options[1];
                break;
              case "frapid":
                currentTimeOption = time_options[3];
                break;
              case "custom match":
                currentTimeOption = TimeOption(
                    response["to"].toString(),
                    int.parse(response["dur"].toString()),
                    int.parse(response["bon"].toString()));
                if (time_options.length <= 5) {
                  time_options.add(currentTimeOption);
                } else {
                  time_options[4] = currentTimeOption;
                }

                break;
            }
            white.currentTime = currentTimeOption.duration * 60;
            black.currentTime = currentTimeOption.duration * 60;
          }
        } catch (e) {
          print(e);
        }
      }
      update.value = true;

      data = "";
    });
  });
}
