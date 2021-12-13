// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// https://github.com/dart-lang/sdk/issues/35778

import "dart:async";
import "dart:isolate";

import "package:expect/expect.dart";

void child(replyPort) {
  print("Child start");

  replyPort.send(const <List>[]);
  replyPort.send(const <Map>[]);
  replyPort.send(const <Null>[]);
  replyPort.send(const <Object>[]);
  replyPort.send(const <String>[]);
  replyPort.send(const <bool>[]);
  replyPort.send(const <double>[]);
  replyPort.send(const <int>[]);
  replyPort.send(const <num>[]);

  replyPort.send(const <List, List>{});
  replyPort.send(const <List, Map>{});
  replyPort.send(const <List, Null>{});
  replyPort.send(const <List, Object>{});
  replyPort.send(const <List, String>{});
  replyPort.send(const <List, bool>{});
  replyPort.send(const <List, double>{});
  replyPort.send(const <List, int>{});
  replyPort.send(const <List, num>{});

  replyPort.send(const <Map, List>{});
  replyPort.send(const <Map, Map>{});
  replyPort.send(const <Map, Null>{});
  replyPort.send(const <Map, Object>{});
  replyPort.send(const <Map, String>{});
  replyPort.send(const <Map, bool>{});
  replyPort.send(const <Map, double>{});
  replyPort.send(const <Map, int>{});
  replyPort.send(const <Map, num>{});

  replyPort.send(const <Null, List>{});
  replyPort.send(const <Null, Map>{});
  replyPort.send(const <Null, Null>{});
  replyPort.send(const <Null, Object>{});
  replyPort.send(const <Null, String>{});
  replyPort.send(const <Null, bool>{});
  replyPort.send(const <Null, double>{});
  replyPort.send(const <Null, int>{});
  replyPort.send(const <Null, num>{});

  replyPort.send(const <Object, List>{});
  replyPort.send(const <Object, Map>{});
  replyPort.send(const <Object, Null>{});
  replyPort.send(const <Object, Object>{});
  replyPort.send(const <Object, String>{});
  replyPort.send(const <Object, bool>{});
  replyPort.send(const <Object, double>{});
  replyPort.send(const <Object, int>{});
  replyPort.send(const <Object, num>{});

  replyPort.send(const <String, List>{});
  replyPort.send(const <String, Map>{});
  replyPort.send(const <String, Null>{});
  replyPort.send(const <String, Object>{});
  replyPort.send(const <String, String>{});
  replyPort.send(const <String, bool>{});
  replyPort.send(const <String, double>{});
  replyPort.send(const <String, int>{});
  replyPort.send(const <String, num>{});

  replyPort.send(const <bool, List>{});
  replyPort.send(const <bool, Map>{});
  replyPort.send(const <bool, Null>{});
  replyPort.send(const <bool, Object>{});
  replyPort.send(const <bool, String>{});
  replyPort.send(const <bool, bool>{});
  replyPort.send(const <bool, double>{});
  replyPort.send(const <bool, int>{});
  replyPort.send(const <bool, num>{});

  replyPort.send(const <double, List>{});
  replyPort.send(const <double, Map>{});
  replyPort.send(const <double, Null>{});
  replyPort.send(const <double, Object>{});
  replyPort.send(const <double, String>{});
  replyPort.send(const <double, bool>{});
  replyPort.send(const <double, double>{});
  replyPort.send(const <double, int>{});
  replyPort.send(const <double, num>{});

  replyPort.send(const <int, List>{});
  replyPort.send(const <int, Map>{});
  replyPort.send(const <int, Null>{});
  replyPort.send(const <int, Object>{});
  replyPort.send(const <int, String>{});
  replyPort.send(const <int, bool>{});
  replyPort.send(const <int, double>{});
  replyPort.send(const <int, int>{});
  replyPort.send(const <int, num>{});

  replyPort.send(const <num, List>{});
  replyPort.send(const <num, Map>{});
  replyPort.send(const <num, Null>{});
  replyPort.send(const <num, Object>{});
  replyPort.send(const <num, String>{});
  replyPort.send(const <num, bool>{});
  replyPort.send(const <num, double>{});
  replyPort.send(const <num, int>{});
  replyPort.send(const <num, num>{});

  print("Child done");
}

Future<void> main(List<String> args) async {
  print("Parent start");

  ReceivePort port = new ReceivePort();
  Isolate.spawn(child, port.sendPort);
  StreamIterator<dynamic> incoming = new StreamIterator<dynamic>(port);

  Expect.isTrue(await incoming.moveNext());
  dynamic x = incoming.current;
  Expect.isTrue(x is List<List>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is List<Map>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is List<Null>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is List<Object>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is List<String>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is List<bool>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is List<double>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is List<int>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is List<num>);

  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<List, List>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<List, Map>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<List, Null>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<List, Object>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<List, String>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<List, bool>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<List, double>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<List, int>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<List, num>);

  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Map, List>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Map, Map>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Map, Null>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Map, Object>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Map, String>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Map, bool>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Map, double>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Map, int>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Map, num>);

  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Null, List>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Null, Map>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Null, Null>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Null, Object>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Null, String>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Null, bool>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Null, double>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Null, int>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Null, num>);

  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Object, List>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Object, Map>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Object, Null>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Object, Object>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Object, String>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Object, bool>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Object, double>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Object, int>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<Object, num>);

  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<String, List>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<String, Map>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<String, Null>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<String, Object>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<String, String>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<String, bool>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<String, double>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<String, int>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<String, num>);

  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<bool, List>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<bool, Map>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<bool, Null>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<bool, Object>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<bool, String>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<bool, bool>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<bool, double>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<bool, int>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<bool, num>);

  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<double, List>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<double, Map>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<double, Null>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<double, Object>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<double, String>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<double, bool>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<double, double>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<double, int>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<double, num>);

  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<int, List>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<int, Map>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<int, Null>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<int, Object>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<int, String>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<int, bool>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<int, double>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<int, int>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<int, num>);

  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<num, List>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<num, Map>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<num, Null>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<num, Object>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<num, String>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<num, bool>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<num, double>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<num, int>);
  Expect.isTrue(await incoming.moveNext());
  x = incoming.current;
  Expect.isTrue(x is Map<num, num>);

  port.close();
  print("Parent done");
}
