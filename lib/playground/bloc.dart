import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:math';

class ApiChannel {
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws/btcusdt@trade'),
  );
}

abstract class BlocEvents {}

class BlocEventDataRecieved extends BlocEvents {
  dynamic data;
  BlocEventDataRecieved(this.data);
}

abstract class BlocStates {}

class InitialState extends BlocStates {}

class RecievedState extends BlocStates {
  dynamic recievedData;
  RecievedState(this.recievedData);
}

class BlocAPIlistener extends Bloc<BlocEvents, BlocStates> {
  late final StreamSubscription subscription;
  BlocAPIlistener() : super(InitialState()) {
    final ApiChannel apiChannel = ApiChannel();

    subscription = apiChannel.channel.stream.listen((event) {
      add(BlocEventDataRecieved(event));
    });

    on<BlocEventDataRecieved>((event, emit) {
      emit(RecievedState(event.data));
    });
  }
  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}

abstract class BlocEarsEvents {}

class BlocEarsEventRecieved extends BlocEarsEvents {
  dynamic earsData;
  BlocEarsEventRecieved(this.earsData);
}

abstract class BlocEarsStates {}

class BlocEarsInitialState extends BlocEarsStates {}

class BlocEarsState extends BlocEarsStates {
  dynamic earsState;
  BlocEarsState(this.earsState);
}

class BlocEars extends Bloc<BlocEarsEvents, BlocEarsStates> {
  late final StreamSubscription _subscription;

  BlocEars(BlocAPIlistener blocAPI) : super(BlocEarsInitialState()) {
    _subscription = blocAPI.stream.listen((state) {
      if (state is RecievedState) {
        final rawData = state.recievedData;
        add(BlocEarsEventRecieved(rawData));
      }
    });
    on<BlocEarsEventRecieved>((event, emit) {
      emit(BlocEarsState(event.earsData));
    });
  }
  @override
  Future<void> close() {
    _subscription.cancel(); // обязательно отписываемся
    return super.close();
  }
}

abstract class BStates {}

abstract class BEvents {}

class IState extends BStates {}

class LState extends BStates {}

class LdState extends BStates {
  int temperature;
  LdState({required this.temperature});
}

class EState extends BStates {}

class WeatherButton extends BEvents {}

class AddError extends BEvents {}

class WeatherRecieved extends BEvents {
  int temp;
  WeatherRecieved({required this.temp});
}

class WBloc extends Bloc<BEvents, BStates> {
  WBloc() : super(IState()) {
    on<WeatherButton>((event, emit) {
      emit(LState());
    });
    on<WeatherRecieved>((event, emit) {
      emit(LdState(temperature: event.temp));
    });
    on<AddError>((event, emit) {
      emit(EState());
    });
  }
}

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

final measureTemp = randomWeather();
