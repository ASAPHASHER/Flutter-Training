import 'dart:async';
import 'dart:isolate';

void main() async {
  scheduleMicrotask(() => print("Microtask A"));
  Future(() => print("Event Loop Task 1")).then((_) => print("Future Chain 1"));
  Future(() => throw "Error in Future").catchError((e) => print("Caught: $e"));

  runZonedGuarded(() {
    Future(() => throw "Zone Error");
  }, (e, st) => print("Zone Caught: $e"));

  final stream = numberStream().asyncMap((n) async {
    await Future.delayed(Duration(milliseconds: 100));
    return n * 2;
  });

  final controller = StreamController<int>();
  stream.listen(controller.add);

  controller.stream.listen((data) async {
    await Future.delayed(Duration(milliseconds: 150));
    print("Backpressure Processed: $data");
  });

  final receivePort = ReceivePort();
  Isolate.spawn(worker, receivePort.sendPort);
  final sendPort = await receivePort.first;

  final responsePort = ReceivePort();
  sendPort.send(["Hello Isolate", responsePort.sendPort]);
  print(await responsePort.first);

  await Future.delayed(Duration(seconds: 2));
  controller.close();
}

Stream<int> numberStream() async* {
  for (int i = 1; i <= 5; i++) {
    yield i;
  }
}

void worker(SendPort mainPort) {
  final port = ReceivePort();
  mainPort.send(port.sendPort);
  port.listen((msg) {
    final text = msg[0];
    final reply = msg[1] as SendPort;
    reply.send("Worker Received: $text");
  });
}
