import 'package:flutter/material.dart';
import 'package:playground/playground/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'async_streams.dart';
import 'dart:math';
import 'package:latlong2/latlong.dart' as latlng;

import 'package:flutter_map/flutter_map.dart';

class asyncUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return asyncUIState();
  }
}

class asyncUIState extends State<asyncUI> {
  AsyncStreams asyncStreams = AsyncStreams();
  RandomPosition _randomPosition = RandomPosition();
  //instance
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/btcusdt@trade'),
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('waiting for connection');
              }
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                final data = snapshot.data!.toString();
                return Column(
                  children: <Widget>[
                    Text('real time crypto-data'),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(data),
                    ),
                  ],
                );
              }

              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          StreamBuilder(
            stream: asyncStreams.bombTicking(20),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('seconds before explosion: ${snapshot.data}');
              }
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                final pos = snapshot.data!;

                return SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: pos, // London
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'com.example.playground',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: pos,
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Text('some error');
              }
            },
            stream: _randomPosition.randomPostionStream(),
          ),
        ],
      ),
    );
  }
}
