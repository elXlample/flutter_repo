import 'dart:async';
import 'dart:math';
import 'package:latlong2/latlong.dart' as latlng;

class RandomPosition {
  Stream<latlng.LatLng> randomPostionStream() async* {
    double lat = 55.751244;
    double lng = 37.618423;
    final random = Random();

    while (true) {
      await Future.delayed(Duration(seconds: 5));
      lat += (random.nextDouble() - 0.5) / 1000;
      lng += (random.nextDouble() - 0.5) / 1000;
      yield latlng.LatLng(lat, lng);
    }
  }
}

class AsyncStreams {
  Stream<int> bombTicking(int timer) async* {
    for (int t = timer; t >= 0; t--) {
      await Future.delayed(const Duration(seconds: 1));
      yield t;
    }
  }
}

class HomeStream {
  final StreamController<String> _controller = StreamController<String>();
  // final StreamController<String> _controller = StreamController<String>.broadcast();
  //if there is multiple subscribers

  void addEvent(String event) {
    _controller.add(event);
  }

  Stream<String> get stream => _controller.stream;
  void dispose() {
    _controller.close();
  }
}
