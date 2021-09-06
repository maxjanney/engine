// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

import "package:expect/expect.dart";

main() {
  Expect.throwsNoSuchMethodError(() => -(null as dynamic));
  // Make sure we have an untyped call to operator-.
  print(-array[0]);
}

var array = <dynamic>[1];
