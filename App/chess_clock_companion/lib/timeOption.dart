import "package:flutter/material.dart";
import "global.dart" as global;

class TimeOption extends StatefulWidget {
  @required
  global.TimeOption? timeOption;
  @required
  bool enabled;
  TimeOption({this.timeOption, this.enabled = false, Key? key})
      : super(key: key);

  @override
  _TimeOptionState createState() => _TimeOptionState();
}

class _TimeOptionState extends State<TimeOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: widget.enabled
          ? MediaQuery.of(context).size.height * 0.15
          : MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          color: widget.enabled ? Color(0xff00BF08) : Colors.grey,
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.4,
            alignment: Alignment.centerLeft,
            child: Text(
              widget.enabled ? "Time Option" : widget.timeOption!.name,
              style: TextStyle(
                  color: Colors.white, fontSize: widget.enabled ? 20 : 15),
            )),
        Container(height: 50, width: 3, color: Colors.white),
        Container(
            width: MediaQuery.of(context).size.width * 0.3,
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.enabled
                    ? Text(
                        widget.timeOption!.name,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    : Container(),
                Text(
                  "${widget.timeOption!.duration.toString()}min per player",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(
                  "${widget.timeOption!.move_bonus_time.toString()}sec per Move",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                )
              ],
            )),
      ]),
    );
  }
}
