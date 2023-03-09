import "package:chess_clock_companion/bluetoothDiscovery.dart";
import "package:chess_clock_companion/chessTimers.dart";
import "package:chess_clock_companion/play.dart";
import "package:chess_clock_companion/timeOption.dart";
import "package:flutter/material.dart";
import "package:chess_clock_companion/global.dart" as global;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text("Home", style: TextStyle(color: Colors.black)),
          actions: [
            Builder(
              builder: (context) => InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      transitionDuration: Duration(seconds: 1),
                      pageBuilder: (context, __, ___) =>
                          const BluetoothDiscovery()));
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("HC-05",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.32),
                      )),
                  Icon(
                    Icons.bluetooth,
                    color: Colors.black,
                  )
                ]),
              ),
            )
          ]),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 0.5])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.27,
                  child: Column(children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              transitionDuration: Duration(seconds: 1),
                              pageBuilder: (context, __, ___) => Play()));
                        },
                        child: CircleAvatar(
                            backgroundColor: Color(0xff00BF08),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ))),
                    ValueListenableBuilder(
                        valueListenable: global.update,
                        builder: (context, value, __) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Hero(
                                  tag: 'WhiteHero',
                                  child: AnimatedContainer(
                                      duration: Duration(seconds: 1),
                                      child: ChessTimers(
                                        clock: global.white,
                                      ))),
                              Hero(
                                  tag: 'BlackHero',
                                  child: AnimatedContainer(
                                      duration: Duration(seconds: 1),
                                      child: ChessTimers(
                                        clock: global.black,
                                      ))),
                            ],
                          );
                        }),
                  ])),
              Expanded(
                  child: Hero(
                      tag: "Menu",
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            color: Color(0xff323232),
                          ),
                          child: ValueListenableBuilder(
                              valueListenable: global.update,
                              builder: (context, value, __) {
                                return SingleChildScrollView(
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
                                              enabled: global.currentTimeOption
                                                          .name ==
                                                      e.name
                                                  ? true
                                                  : false,
                                            )))
                                        .toList(),
                                  ),
                                );
                              }))))
            ],
          )),
    );
  }
}
