// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

library regress;

import 'dart:isolate';

abstract class N<T> {}

class J extends N<String> {
  final String s;
  J(this.s);
}

class K extends N<int> {
  final int i;
  K(this.i);
}

void isolate(Object portObj) {
  SendPort port = portObj;
  port.send(new J("8" * 4));
  for (int i = 0; i < 80000; i++) {
    port.send(new K(i));
  }
  port.send('done');
}

main() async {
  var recv = new RawReceivePort();
  recv.handler = (k) {
    if (k is J) print(k.s.length);
    if (k is String) {
      print(k);
      recv.close();
    }
  };
  var iso = await Isolate.spawn(isolate, recv.sendPort);
}
