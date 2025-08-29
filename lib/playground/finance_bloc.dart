import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:async/async.dart';

Stream<dynamic> randomPriceA() async* {
  //initial loading
  await Future.delayed(Duration(seconds: 3));

  final _random = Random();

  while (true) {
    final operationTime = _random.nextInt(10);

    final randomPrice = _random.nextDouble() * 1000;

    if (operationTime > 3) {
      yield null;
    } else {
      Future.delayed(Duration(seconds: operationTime));
      yield randomPrice;
    }
  }
}

Stream<dynamic> randomPriceB() async* {
  //initial loading
  await Future.delayed(Duration(seconds: 3));

  final _random = Random();
  while (true) {
    final operationTime = _random.nextInt(10);

    final randomPrice = _random.nextDouble() * 1000;

    if (operationTime > 3) {
      yield null;
    } else {
      Future.delayed(Duration(seconds: operationTime));
      yield randomPrice;
    }
  }
}

Stream<dynamic> randomNews() async* {
  //initial loading
  await Future.delayed(Duration(seconds: 3));

  final _random = Random();
  while (true) {
    final operationTime = _random.nextInt(10);

    final randomNewsIndex = _random.nextInt(5);
    final news = [
      'Bob married Sidney',
      'Milk price decreased by 1%',
      'Today is Monday',
      'Good news!',
      'Bad news!',
    ];

    if (operationTime > 3) {
      yield null;
    } else {
      await Future.delayed(Duration(seconds: operationTime));
      yield news[randomNewsIndex];
    }
  }
}

abstract class States {}

abstract class Events {}

class InitState extends States {}

class LoadState extends States {}

class LoadedState extends States {
  final int? priceA;
  final int? priceB;
  final String? news;
  LoadedState({this.priceA, this.priceB, this.news});

  LoadedState copyWith({int? priceA, int? priceB, String? news}) {
    return LoadedState(
      priceA: priceA ?? this.priceA,
      priceB: priceB ?? this.priceB,
      news: news ?? this.news,
    );
  }
}

class ErrorState extends States {}

class LoadingEvent extends Events {}

class LoadedEventA extends Events {
  int? priceA;

  LoadedEventA(this.priceA);
}

class LoadedEventB extends Events {
  int? priceB;

  LoadedEventB(this.priceB);
}

class LoadedEventNews extends Events {
  String? news;

  LoadedEventNews(this.news);
}

class PriceBloc extends Bloc<Events, States> {
  late final StreamSubscription globalStreamSub;

  PriceBloc(Stream<Map<String, dynamic>> globalStream) : super(InitState()) {
    globalStreamSub = globalStream.listen((event) {
      if (event['source'] == 'A') {
        add(LoadedEventA(event['data']));
      }
      if (event['source'] == 'B') {
        add(LoadedEventB(event['data']));
      }
      if (event['source'] == 'news') {
        add(LoadedEventNews(event['data']));
      }
    });

    on<LoadingEvent>((event, emit) {
      emit(LoadState());
    });
    on<LoadedEventA>((event, emit) {
      emit((state as LoadedState).copyWith(priceA: event.priceA));
    });
    on<LoadedEventB>((event, emit) {
      emit((state as LoadedState).copyWith(priceB: event.priceB));
    });
    on<LoadedEventNews>((event, emit) {
      emit((state as LoadedState).copyWith(news: event.news));
    });
  }
  @override
  Future<void> close() {
    globalStreamSub.cancel(); // обязательно закрыть!
    return super.close();
  }
}
