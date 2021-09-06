// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

// Verifies that references to deduplicated mixins are properly updated.
// Regression test for https://github.com/flutter/flutter/issues/55345.

class Diagnosticable {}

class SomeClass with Diagnosticable {}

class State<T> with Diagnosticable {}

class StateA extends State {}

class StateB extends State<int> {}

StateA a = StateA();
StateB b = StateB();

List<T> foo<T>(T x) {
  print(T);
  return <T>[x];
}

T Function<S extends T>(T) bar<T>(T x) {
  print(T);

  return <S extends T>(T y) {
    print(S);
    print(y);
    return y;
  };
}

main() {
  State x1 = a ?? b;
  print(x1);

  var x2 = a ?? b;
  var x3 = foo(x2);
  var x4 = bar(x3);
  x4(x3);
  // No compile time or runtime errors.
}
