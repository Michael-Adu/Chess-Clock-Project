import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import "global.dart" as global;
import "dart:math";

class ChessTimers extends StatefulWidget {
  bool full;
  global.Clock? clock;
  ChessTimers({this.full = false, this.clock, Key? key}) : super(key: key);

  @override
  _ChessTimersState createState() => _ChessTimersState();
}

class _ChessTimersState extends State<ChessTimers> {
  late Duration time;
  List<Widget> children = List<Widget>.empty(growable: true);
  List<Widget> chessNameIcon = List<Widget>.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    time = Duration(seconds: widget.clock!.currentTime);
    chessNameIcon = [
      widget.clock!.player == "White"
          ? WhitePawn()
          : BlackPawn(
              strokeColor: Colors.white,
            ),
      Column(
        children: [
          Container(
              alignment: widget.clock!.player == "White"
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Text(
                widget.clock!.player,
                style: TextStyle(
                    color: widget.clock!.player == "White"
                        ? Colors.black
                        : Colors.white,
                    fontSize: widget.full ? 30 : 10),
              )),
          Container(
              alignment: widget.clock!.player == "White"
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    alignment: widget.clock!.player == "White"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Text(
                      "${DateFormat('mm').format(DateTime.fromMillisecondsSinceEpoch(widget.clock!.currentTime * 1000))}:",
                      style: TextStyle(
                          fontSize: widget.full ? 40 : 20,
                          color: widget.clock!.player == "White"
                              ? Colors.red
                              : Color(0xff00BF08)),
                    )),
                Text(
                  "${DateFormat('ss').format(DateTime.fromMillisecondsSinceEpoch(widget.clock!.currentTime * 1000))}",
                  style: TextStyle(
                      fontSize: widget.full ? 40 : 20,
                      color: widget.clock!.player == "White"
                          ? Colors.black
                          : Colors.white),
                )
              ]))
        ],
      )
    ];
    children = [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.clock!.player == "White"
              ? chessNameIcon
              : chessNameIcon.reversed.toList(),
        ),
      ]),
      Container(
          width: MediaQuery.of(context).size.width * 0.1,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              color: widget.clock!.player == "White"
                  ? const Color(0xff323232)
                  : Colors.white,
              width: 3,
            ),
            Container(
              color: widget.clock!.player == "White"
                  ? const Color(0xff323232)
                  : Colors.white,
              width: 3,
            )
          ]))
    ];
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: widget.full
            ? MediaQuery.of(context).size.width * 0.9
            : MediaQuery.of(context).size.width * 0.4,
        height: widget.full
            ? MediaQuery.of(context).size.height * 0.3
            : MediaQuery.of(context).size.height * 0.137,
        alignment: widget.clock!.player == "White"
            ? Alignment.centerLeft
            : Alignment.centerRight,
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        decoration: BoxDecoration(
            borderRadius: widget.full
                ? BorderRadius.circular(20)
                : widget.clock!.player == "White"
                    ? const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
            color: widget.clock!.player == "White"
                ? Colors.white
                : const Color(0xff323232),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 7),
                  blurRadius: 11,
                  color: Colors.black.withOpacity(0.32),
                  spreadRadius: 3)
            ]),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.clock!.player == "White"
                ? children
                : children.reversed.toList()));
  }
}
