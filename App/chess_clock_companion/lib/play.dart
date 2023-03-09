import "package:flutter/material.dart";
import "package:chess_clock_companion/chessTimers.dart";
import "package:chess_clock_companion/bluetoothDiscovery.dart";
import "package:chess_clock_companion/timeOption.dart";
import "package:chess_clock_companion/global.dart" as global;

class Play extends StatefulWidget {
  const Play({Key? key}) : super(key: key);

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text("Play", style: TextStyle(color: Colors.black)),
            //toolbarOpacity: 0,
            leading: Builder(
                builder: (context) => InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_left_rounded,
                        color: Colors.black,
                        size: 50,
                      ),
                    )),
            actions: [
              Builder(
                builder: (context) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("HC-05",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.32),
                        )),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BluetoothDiscovery()));
                        },
                        child: Icon(
                          Icons.bluetooth,
                          color: Colors.black,
                        ))
                  ],
                ),
              )
            ]),
        body: Container(
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ValueListenableBuilder(
                          valueListenable: global.update,
                          builder: (context, value, __) {
                            return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      child: Hero(
                                          tag: 'WhiteHero',
                                          child: ChessTimers(
                                            clock: global.white,
                                            full: true,
                                          ))),
                                  Container(
                                    child: Hero(
                                        tag: 'BlackHero',
                                        child: ChessTimers(
                                          full: true,
                                          clock: global.black,
                                        )),
                                  )
                                ]);
                          })),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 2,
                      child: Hero(
                          tag: "Menu",
                          child: Expanded(
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10)),
                                    color: Color(0xff323232),
                                  ),
                                  child: SingleChildScrollView(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: global.time_options
                                          .map((e) => Container(
                                              padding: EdgeInsets.all(5),
                                              child: TimeOption(
                                                timeOption: global.TimeOption(
                                                    e.name,
                                                    e.duration,
                                                    e.move_bonus_time),
                                                enabled:
                                                    global.currentTimeOption ==
                                                            e
                                                        ? true
                                                        : false,
                                              )))
                                          .toList(),
                                    ),
                                  )))))
                ])));
  }
}
