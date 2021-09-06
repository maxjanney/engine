// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.


import 'dart:async';

// Introduce an aliased type.

class A<X> {
  A();
  A.named();
  static void staticMethod<Y>() {}
}

typedef T<X> = A<X>;

// Use the aliased type.

abstract class C {}

abstract class D2 extends C with T<int> {}
//             ^
// [analyzer] unspecified
// [cfe] unspecified

abstract class D4 = C with T<void>;
//             ^
// [analyzer] unspecified
// [cfe] unspecified

main() {
  T<List<List<List<List>>>>.staticMethod<T<int>>();
  //                        ^
  // [analyzer] unspecified
  // [cfe] unspecified
}
