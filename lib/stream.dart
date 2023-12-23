import 'dart:async';
import 'dart:developer';

class NumberGenrator {
  NumberGenrator(Duration duration, {required int endOnTick}) {
    //timer seems to be skipping calling callback for some ticks when duraiton is very small
    //and hence the stream is not getting all the values
    Timer.periodic(duration, (timer) {
      log("adding to stream from timer: ${timer.tick} at ${DateTime.now().millisecondsSinceEpoch}");
      _controller.add(timer.tick);
      if (endOnTick <= timer.tick) {
        timer.cancel();
        _controller.close();
      }
    });
  }

  final _controller = StreamController<int>();

  Stream<int> get getStream => _controller.stream;
}
