import "package:flutter/material.dart";
import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_blue/flutter_blue.dart' as blue;
import "package:chess_clock_companion/global.dart" as global;

class BluetoothDiscovery extends StatefulWidget {
  const BluetoothDiscovery({Key? key}) : super(key: key);

  @override
  _BluetoothDiscoveryState createState() => _BluetoothDiscoveryState();
}

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability {
  BluetoothDevice device;
  _DeviceAvailability availability;
  String type;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, this.type, this.rssi);
}

class _BluetoothDiscoveryState extends State<BluetoothDiscovery> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  List<_DeviceWithAvailability> allDevices =
      List<_DeviceWithAvailability>.empty(growable: true);
  List<_DeviceWithAvailability> _searchResults =
      List<_DeviceWithAvailability>.empty(growable: true);
  TextEditingController controller = TextEditingController();
  bool isDiscovering = false;
  int _focusedIndex = 0;
  double _cardSize = 250;

  @override
  void initState() {
    super.initState();
    isDiscovering = true;
    _startDiscovery();
  }

  void _restartDiscovery() {
    setState(() {
      allDevices.clear();
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) async {
      print(bondedDevices.length);
      var device;
      for (int i = 0; i < bondedDevices.length; i++) {
        if (bondedDevices[i].isConnected == true) {
          var deviceType;
          print("${bondedDevices[i].name} is connected");

          try {
            await BluetoothConnection.toAddress(bondedDevices[i].address)
                .catchError((onError) async {
              global.activeConnection.finish();
              setState(() {
                allDevices[i] = _DeviceWithAvailability(
                    BluetoothDevice(
                      name: bondedDevices[i].name ?? '',
                      address: bondedDevices[i].address,
                      type: bondedDevices[i].type,
                      isConnected: false,
                      bondState: BluetoothBondState.bonded,
                    ),
                    _DeviceAvailability.no,
                    deviceType,
                    0);
              });
            });
          } catch (ex) {}
        } else {
          print("${bondedDevices[i].name} ${bondedDevices[i].bondState}");
        }
      }
      setState(() {
        for (int i = 0; i < bondedDevices.length; i++) {
          allDevices.add(_DeviceWithAvailability(
              bondedDevices[i], _DeviceAvailability.maybe, "Arduino", 0));
        }
        isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          toolbarOpacity: 1,
          title: isDiscovering
              ? const Text(
                  'Retrieving Devices',
                  style: TextStyle(color: Colors.black),
                )
              : const Text('Bluetooth Devices',
                  style: TextStyle(color: Colors.black)),
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
            isDiscovering
                ? FittedBox(
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.replay, color: Colors.black),
                    onPressed: _restartDiscovery,
                  )
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: allDevices.map((e) {
                          return InkWell(
                              onTap: () async {
                                try {
                                  if (e.device.isBonded) {
                                    await BluetoothConnection.toAddress(
                                            e.device.address)
                                        .then(
                                      (value) {
                                        global.activeConnection = value;
                                        setState(() {
                                          allDevices[allDevices.indexOf(e)] =
                                              _DeviceWithAvailability(
                                                  BluetoothDevice(
                                                    name: e.device.name ?? '',
                                                    address: e.device.address,
                                                    type: e.device.type,
                                                    isConnected: true,
                                                    bondState: e.device.isBonded
                                                        ? BluetoothBondState
                                                            .bonded
                                                        : BluetoothBondState
                                                            .none,
                                                  ),
                                                  e.availability,
                                                  e.type,
                                                  e.rssi);
                                          print(e.device.isBonded
                                              ? BluetoothBondState.bonded
                                              : BluetoothBondState.none);
                                        });
                                        global.receiveBluetooth();
                                        return value;
                                      },
                                    );
                                  } else {
                                    var bonded = (await FlutterBluetoothSerial
                                        .instance
                                        .bondDeviceAtAddress(
                                            e.device.address))!;
                                    global.activeConnection =
                                        await BluetoothConnection.toAddress(
                                                e.device.address)
                                            .whenComplete(() => setState(() {
                                                  allDevices[allDevices
                                                          .indexOf(e)] =
                                                      _DeviceWithAvailability(
                                                          BluetoothDevice(
                                                            name:
                                                                e.device.name ??
                                                                    '',
                                                            address: e
                                                                .device.address,
                                                            type: e.device.type,
                                                            bondState:
                                                                BluetoothBondState
                                                                    .bonded,
                                                          ),
                                                          e.availability,
                                                          e.type,
                                                          e.rssi);
                                                  print(bonded
                                                      ? BluetoothBondState
                                                          .bonded
                                                      : BluetoothBondState
                                                          .none);
                                                }));
                                    global.receiveBluetooth();
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              onLongPress: () async {
                                try {
                                  bool bonded = false;
                                  if (e.device.isBonded) {
                                    print(
                                        'Unbonding from ${e.device.address}...');
                                    await FlutterBluetoothSerial.instance
                                        .removeDeviceBondWithAddress(
                                            e.device.address);
                                    print(
                                        'Unbonding from ${e.device.address} has succed');
                                  } else {
                                    print(
                                        'Bonding with ${e.device.address}...');
                                    bonded = (await FlutterBluetoothSerial
                                        .instance
                                        .bondDeviceAtAddress(
                                            e.device.address))!;
                                    print(
                                        'Bonding with ${e.device.address} has ${bonded ? 'succed' : 'failed'}.');
                                  }
                                  setState(() {
                                    allDevices[allDevices.indexOf(e)] =
                                        _DeviceWithAvailability(
                                            BluetoothDevice(
                                              name: e.device.name ?? '',
                                              address: e.device.address,
                                              type: e.device.type,
                                              bondState: bonded
                                                  ? BluetoothBondState.bonded
                                                  : BluetoothBondState.none,
                                            ),
                                            e.availability,
                                            e.type,
                                            e.rssi);
                                    global.receiveBluetooth();
                                  });
                                } catch (ex) {}
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(3, 10),
                                            blurRadius: 2,
                                            color:
                                                Colors.black.withOpacity(0.32))
                                      ]),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        e.device.name!,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      )),
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        e.rssi.toString(),
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      )),
                                                ])),
                                        Icon(Icons.bluetooth,
                                            color: e.availability ==
                                                    _DeviceAvailability.yes
                                                ? Colors.red
                                                : Colors.grey)
                                      ])));
                        }).toList())))));
  }
}
