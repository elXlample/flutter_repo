import 'dart:math';

import 'package:async/async.dart';
import 'package:playground/playground/finance_bloc.dart';

class Streams {
  Stream<Map<String, dynamic>> randomPriceA() async* {
    //initial loading
    await Future.delayed(Duration(seconds: 3));

    final _random = Random();

    while (true) {
      final operationTime = _random.nextInt(10);

      final randomPrice = _random.nextDouble() * 1000;

      if (operationTime > 3) {
        yield {'source:': null, 'data': null};
      } else {
        yield {'source': 'A', 'data': randomPrice};
      }
    }
  }

  Stream<Map<String, dynamic>> randomPriceB() async* {
    //initial loading
    await Future.delayed(Duration(seconds: 3));

    final _random = Random();

    while (true) {
      final operationTime = _random.nextInt(10);

      final randomPrice = _random.nextDouble() * 1000;

      if (operationTime > 3) {
        yield {'source:': null, 'data': null};
      } else {
        yield {'source': 'B', 'data': randomPrice};
      }
    }
  }

  Stream<Map<String, dynamic>> randomNews() async* {
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
        yield {'source:': null, 'data': null};
      } else {
        yield {'source': 'news', 'data': news[randomNewsIndex]};
      }
    }
  }

  Stream<Map<String, dynamic>> mergeStreams() {
    Stream<Map<String, dynamic>> globalStream = StreamGroup.merge([
      randomPriceA(),
      randomPriceB(),
      randomNews(),
    ]);
    return globalStream;
  }
}
