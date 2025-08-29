import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as fb;
import 'package:playground/playground/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:playground/playground/finance_bloc.dart';

class blocUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return blocUIState();
  }
}

class blocUIState extends State<blocUI> {
  late final StreamSubscription _sub;
  final _controller = StreamController<dynamic>();
  Stream<dynamic> get stream => _controller.stream;

  @override
  Widget build(BuildContext context) {
    final _wBloc = fb.BlocProvider.of<WBloc>(context);
    Future<int> randomWeather() async {
      await Future.delayed(Duration(seconds: 3));
      final random = Random();
      final randomT = random.nextInt(50);
      if (randomT > 40) {
        return 404;
      } else {
        return randomT;
      }
    }

    final bloc = fb.BlocProvider.of<BlocEars>(context);
    _sub = bloc.stream.listen((state) {
      if (state is BlocEarsState) {
        final _data = state.earsState;
        _controller.add(_data);
      }
    });

    return Scaffold(
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                final dataStream = snapshot.data!;
                return Text(dataStream);
              } else {
                return Text('error occured');
              }
            },
          ),

          fb.BlocBuilder<WBloc, BStates>(
            builder: (context, state) {
              if (state is IState) {
                return Column(
                  children: <Widget>[
                    const Text('Bloc now in initial state'),
                    ElevatedButton(
                      onPressed: () async {
                        _wBloc.add(WeatherButton());
                        final int weather = await randomWeather();

                        if (weather == 404) {
                          _wBloc.add(AddError());
                        } else {
                          _wBloc.add(WeatherRecieved(temp: weather));
                        }
                      },
                      child: Text('random weather'),
                    ),
                  ],
                );
              }
              if (state is LState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    const Text('loading random weather!'),
                  ],
                );
              }
              if (state is LdState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Weather loaded : now it is ${state.temperature} degrees',
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _wBloc.add(WeatherButton());
                        final int weather = await randomWeather();

                        if (weather == 404) {
                          _wBloc.add(AddError());
                        } else {
                          _wBloc.add(WeatherRecieved(temp: weather));
                        }
                      },
                      child: Text('reload'),
                    ),
                  ],
                );
              }
              if (state is EState) {
                return const Text(
                  'some error occurred! Please try again later!',
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          SizedBox(height: 40),

          fb.BlocBuilder<PriceBloc, States>(
            builder: (context, state) {
              if (state is InitState) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        fb.BlocProvider.of<PriceBloc>(
                          context,
                        ).add(LoadingEvent());
                      },
                      child: Text('start'),
                    ),
                    Text('Price bloc in init state'),
                  ],
                );
              }
              if (state is LoadState) {
                return CircularProgressIndicator();
              }
              if (state is LoadedState) {
                final int? priceA = state.priceA;
                final int? priceB = state.priceB;
                final String? news = state.news;
                if (state.priceA != null && state.priceB != null) {
                  final averagePrice = (priceA! + priceB!) / 2;
                  return Column(
                    children: <Widget>[
                      Text('average price aviable: $averagePrice'),
                      Text('priceA : $priceA'),
                      Text('priceB : $priceB'),
                      news != null ? Text(news) : Text('no news by API'),
                    ],
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      Text('average price not aviable'),
                      priceA != null
                          ? Text('priceA now : $priceA')
                          : Text('no priceA'),
                      priceB != null
                          ? Text('priceB now : $priceB')
                          : Text('no priceB'),
                      news != null ? Text(news) : Text('no news by API'),
                    ],
                  );
                }
              } else {
                return Text('error!');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    _controller.close();
    super.dispose();
  }
}
