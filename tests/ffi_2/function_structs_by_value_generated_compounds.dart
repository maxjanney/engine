// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// This file has been automatically generated. Please do not edit it manually.
// Generated by tests/ffi/generator/structs_by_value_tests_generator.dart.

// @dart = 2.9

import 'dart:ffi';

// Reuse the AbiSpecificInts.
import 'abi_specific_ints.dart';

class Struct1ByteBool extends Struct {
  @Bool()
  bool a0;

  String toString() => "(${a0})";
}

class Struct1ByteInt extends Struct {
  @Int8()
  int a0;

  String toString() => "(${a0})";
}

class Struct3BytesHomogeneousUint8 extends Struct {
  @Uint8()
  int a0;

  @Uint8()
  int a1;

  @Uint8()
  int a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

class Struct3BytesInt2ByteAligned extends Struct {
  @Int16()
  int a0;

  @Int8()
  int a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct4BytesHomogeneousInt16 extends Struct {
  @Int16()
  int a0;

  @Int16()
  int a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct4BytesFloat extends Struct {
  @Float()
  double a0;

  String toString() => "(${a0})";
}

class Struct7BytesHomogeneousUint8 extends Struct {
  @Uint8()
  int a0;

  @Uint8()
  int a1;

  @Uint8()
  int a2;

  @Uint8()
  int a3;

  @Uint8()
  int a4;

  @Uint8()
  int a5;

  @Uint8()
  int a6;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3}, ${a4}, ${a5}, ${a6})";
}

class Struct7BytesInt4ByteAligned extends Struct {
  @Int32()
  int a0;

  @Int16()
  int a1;

  @Int8()
  int a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

class Struct8BytesInt extends Struct {
  @Int16()
  int a0;

  @Int16()
  int a1;

  @Int32()
  int a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

class Struct8BytesHomogeneousFloat extends Struct {
  @Float()
  double a0;

  @Float()
  double a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct8BytesFloat extends Struct {
  @Double()
  double a0;

  String toString() => "(${a0})";
}

class Struct8BytesMixed extends Struct {
  @Float()
  double a0;

  @Int16()
  int a1;

  @Int16()
  int a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

class Struct9BytesHomogeneousUint8 extends Struct {
  @Uint8()
  int a0;

  @Uint8()
  int a1;

  @Uint8()
  int a2;

  @Uint8()
  int a3;

  @Uint8()
  int a4;

  @Uint8()
  int a5;

  @Uint8()
  int a6;

  @Uint8()
  int a7;

  @Uint8()
  int a8;

  String toString() =>
      "(${a0}, ${a1}, ${a2}, ${a3}, ${a4}, ${a5}, ${a6}, ${a7}, ${a8})";
}

class Struct9BytesInt4Or8ByteAligned extends Struct {
  @Int64()
  int a0;

  @Int8()
  int a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct10BytesHomogeneousBool extends Struct {
  @Bool()
  bool a0;

  @Bool()
  bool a1;

  @Bool()
  bool a2;

  @Bool()
  bool a3;

  @Bool()
  bool a4;

  @Bool()
  bool a5;

  @Bool()
  bool a6;

  @Bool()
  bool a7;

  @Bool()
  bool a8;

  @Bool()
  bool a9;

  String toString() =>
      "(${a0}, ${a1}, ${a2}, ${a3}, ${a4}, ${a5}, ${a6}, ${a7}, ${a8}, ${a9})";
}

class Struct12BytesHomogeneousFloat extends Struct {
  @Float()
  double a0;

  @Float()
  double a1;

  @Float()
  double a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

class Struct16BytesHomogeneousFloat extends Struct {
  @Float()
  double a0;

  @Float()
  double a1;

  @Float()
  double a2;

  @Float()
  double a3;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3})";
}

class Struct16BytesMixed extends Struct {
  @Double()
  double a0;

  @Int64()
  int a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct16BytesMixed2 extends Struct {
  @Float()
  double a0;

  @Float()
  double a1;

  @Float()
  double a2;

  @Int32()
  int a3;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3})";
}

class Struct17BytesInt extends Struct {
  @Int64()
  int a0;

  @Int64()
  int a1;

  @Int8()
  int a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

class Struct19BytesHomogeneousUint8 extends Struct {
  @Uint8()
  int a0;

  @Uint8()
  int a1;

  @Uint8()
  int a2;

  @Uint8()
  int a3;

  @Uint8()
  int a4;

  @Uint8()
  int a5;

  @Uint8()
  int a6;

  @Uint8()
  int a7;

  @Uint8()
  int a8;

  @Uint8()
  int a9;

  @Uint8()
  int a10;

  @Uint8()
  int a11;

  @Uint8()
  int a12;

  @Uint8()
  int a13;

  @Uint8()
  int a14;

  @Uint8()
  int a15;

  @Uint8()
  int a16;

  @Uint8()
  int a17;

  @Uint8()
  int a18;

  String toString() =>
      "(${a0}, ${a1}, ${a2}, ${a3}, ${a4}, ${a5}, ${a6}, ${a7}, ${a8}, ${a9}, ${a10}, ${a11}, ${a12}, ${a13}, ${a14}, ${a15}, ${a16}, ${a17}, ${a18})";
}

class Struct20BytesHomogeneousInt32 extends Struct {
  @Int32()
  int a0;

  @Int32()
  int a1;

  @Int32()
  int a2;

  @Int32()
  int a3;

  @Int32()
  int a4;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3}, ${a4})";
}

class Struct20BytesHomogeneousFloat extends Struct {
  @Float()
  double a0;

  @Float()
  double a1;

  @Float()
  double a2;

  @Float()
  double a3;

  @Float()
  double a4;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3}, ${a4})";
}

class Struct32BytesHomogeneousDouble extends Struct {
  @Double()
  double a0;

  @Double()
  double a1;

  @Double()
  double a2;

  @Double()
  double a3;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3})";
}

class Struct40BytesHomogeneousDouble extends Struct {
  @Double()
  double a0;

  @Double()
  double a1;

  @Double()
  double a2;

  @Double()
  double a3;

  @Double()
  double a4;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3}, ${a4})";
}

class Struct1024BytesHomogeneousUint64 extends Struct {
  @Uint64()
  int a0;

  @Uint64()
  int a1;

  @Uint64()
  int a2;

  @Uint64()
  int a3;

  @Uint64()
  int a4;

  @Uint64()
  int a5;

  @Uint64()
  int a6;

  @Uint64()
  int a7;

  @Uint64()
  int a8;

  @Uint64()
  int a9;

  @Uint64()
  int a10;

  @Uint64()
  int a11;

  @Uint64()
  int a12;

  @Uint64()
  int a13;

  @Uint64()
  int a14;

  @Uint64()
  int a15;

  @Uint64()
  int a16;

  @Uint64()
  int a17;

  @Uint64()
  int a18;

  @Uint64()
  int a19;

  @Uint64()
  int a20;

  @Uint64()
  int a21;

  @Uint64()
  int a22;

  @Uint64()
  int a23;

  @Uint64()
  int a24;

  @Uint64()
  int a25;

  @Uint64()
  int a26;

  @Uint64()
  int a27;

  @Uint64()
  int a28;

  @Uint64()
  int a29;

  @Uint64()
  int a30;

  @Uint64()
  int a31;

  @Uint64()
  int a32;

  @Uint64()
  int a33;

  @Uint64()
  int a34;

  @Uint64()
  int a35;

  @Uint64()
  int a36;

  @Uint64()
  int a37;

  @Uint64()
  int a38;

  @Uint64()
  int a39;

  @Uint64()
  int a40;

  @Uint64()
  int a41;

  @Uint64()
  int a42;

  @Uint64()
  int a43;

  @Uint64()
  int a44;

  @Uint64()
  int a45;

  @Uint64()
  int a46;

  @Uint64()
  int a47;

  @Uint64()
  int a48;

  @Uint64()
  int a49;

  @Uint64()
  int a50;

  @Uint64()
  int a51;

  @Uint64()
  int a52;

  @Uint64()
  int a53;

  @Uint64()
  int a54;

  @Uint64()
  int a55;

  @Uint64()
  int a56;

  @Uint64()
  int a57;

  @Uint64()
  int a58;

  @Uint64()
  int a59;

  @Uint64()
  int a60;

  @Uint64()
  int a61;

  @Uint64()
  int a62;

  @Uint64()
  int a63;

  @Uint64()
  int a64;

  @Uint64()
  int a65;

  @Uint64()
  int a66;

  @Uint64()
  int a67;

  @Uint64()
  int a68;

  @Uint64()
  int a69;

  @Uint64()
  int a70;

  @Uint64()
  int a71;

  @Uint64()
  int a72;

  @Uint64()
  int a73;

  @Uint64()
  int a74;

  @Uint64()
  int a75;

  @Uint64()
  int a76;

  @Uint64()
  int a77;

  @Uint64()
  int a78;

  @Uint64()
  int a79;

  @Uint64()
  int a80;

  @Uint64()
  int a81;

  @Uint64()
  int a82;

  @Uint64()
  int a83;

  @Uint64()
  int a84;

  @Uint64()
  int a85;

  @Uint64()
  int a86;

  @Uint64()
  int a87;

  @Uint64()
  int a88;

  @Uint64()
  int a89;

  @Uint64()
  int a90;

  @Uint64()
  int a91;

  @Uint64()
  int a92;

  @Uint64()
  int a93;

  @Uint64()
  int a94;

  @Uint64()
  int a95;

  @Uint64()
  int a96;

  @Uint64()
  int a97;

  @Uint64()
  int a98;

  @Uint64()
  int a99;

  @Uint64()
  int a100;

  @Uint64()
  int a101;

  @Uint64()
  int a102;

  @Uint64()
  int a103;

  @Uint64()
  int a104;

  @Uint64()
  int a105;

  @Uint64()
  int a106;

  @Uint64()
  int a107;

  @Uint64()
  int a108;

  @Uint64()
  int a109;

  @Uint64()
  int a110;

  @Uint64()
  int a111;

  @Uint64()
  int a112;

  @Uint64()
  int a113;

  @Uint64()
  int a114;

  @Uint64()
  int a115;

  @Uint64()
  int a116;

  @Uint64()
  int a117;

  @Uint64()
  int a118;

  @Uint64()
  int a119;

  @Uint64()
  int a120;

  @Uint64()
  int a121;

  @Uint64()
  int a122;

  @Uint64()
  int a123;

  @Uint64()
  int a124;

  @Uint64()
  int a125;

  @Uint64()
  int a126;

  @Uint64()
  int a127;

  String toString() =>
      "(${a0}, ${a1}, ${a2}, ${a3}, ${a4}, ${a5}, ${a6}, ${a7}, ${a8}, ${a9}, ${a10}, ${a11}, ${a12}, ${a13}, ${a14}, ${a15}, ${a16}, ${a17}, ${a18}, ${a19}, ${a20}, ${a21}, ${a22}, ${a23}, ${a24}, ${a25}, ${a26}, ${a27}, ${a28}, ${a29}, ${a30}, ${a31}, ${a32}, ${a33}, ${a34}, ${a35}, ${a36}, ${a37}, ${a38}, ${a39}, ${a40}, ${a41}, ${a42}, ${a43}, ${a44}, ${a45}, ${a46}, ${a47}, ${a48}, ${a49}, ${a50}, ${a51}, ${a52}, ${a53}, ${a54}, ${a55}, ${a56}, ${a57}, ${a58}, ${a59}, ${a60}, ${a61}, ${a62}, ${a63}, ${a64}, ${a65}, ${a66}, ${a67}, ${a68}, ${a69}, ${a70}, ${a71}, ${a72}, ${a73}, ${a74}, ${a75}, ${a76}, ${a77}, ${a78}, ${a79}, ${a80}, ${a81}, ${a82}, ${a83}, ${a84}, ${a85}, ${a86}, ${a87}, ${a88}, ${a89}, ${a90}, ${a91}, ${a92}, ${a93}, ${a94}, ${a95}, ${a96}, ${a97}, ${a98}, ${a99}, ${a100}, ${a101}, ${a102}, ${a103}, ${a104}, ${a105}, ${a106}, ${a107}, ${a108}, ${a109}, ${a110}, ${a111}, ${a112}, ${a113}, ${a114}, ${a115}, ${a116}, ${a117}, ${a118}, ${a119}, ${a120}, ${a121}, ${a122}, ${a123}, ${a124}, ${a125}, ${a126}, ${a127})";
}

class StructAlignmentInt16 extends Struct {
  @Int8()
  int a0;

  @Int16()
  int a1;

  @Int8()
  int a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

class StructAlignmentInt32 extends Struct {
  @Int8()
  int a0;

  @Int32()
  int a1;

  @Int8()
  int a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

class StructAlignmentInt64 extends Struct {
  @Int8()
  int a0;

  @Int64()
  int a1;

  @Int8()
  int a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

class Struct8BytesNestedInt extends Struct {
  Struct4BytesHomogeneousInt16 a0;

  Struct4BytesHomogeneousInt16 a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct8BytesNestedFloat extends Struct {
  Struct4BytesFloat a0;

  Struct4BytesFloat a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct8BytesNestedFloat2 extends Struct {
  Struct4BytesFloat a0;

  @Float()
  double a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct8BytesNestedMixed extends Struct {
  Struct4BytesHomogeneousInt16 a0;

  Struct4BytesFloat a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct16BytesNestedInt extends Struct {
  Struct8BytesNestedInt a0;

  Struct8BytesNestedInt a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct32BytesNestedInt extends Struct {
  Struct16BytesNestedInt a0;

  Struct16BytesNestedInt a1;

  String toString() => "(${a0}, ${a1})";
}

class StructNestedIntStructAlignmentInt16 extends Struct {
  StructAlignmentInt16 a0;

  StructAlignmentInt16 a1;

  String toString() => "(${a0}, ${a1})";
}

class StructNestedIntStructAlignmentInt32 extends Struct {
  StructAlignmentInt32 a0;

  StructAlignmentInt32 a1;

  String toString() => "(${a0}, ${a1})";
}

class StructNestedIntStructAlignmentInt64 extends Struct {
  StructAlignmentInt64 a0;

  StructAlignmentInt64 a1;

  String toString() => "(${a0}, ${a1})";
}

class StructNestedIrregularBig extends Struct {
  @Uint16()
  int a0;

  Struct8BytesNestedMixed a1;

  @Uint16()
  int a2;

  Struct8BytesNestedFloat2 a3;

  @Uint16()
  int a4;

  Struct8BytesNestedFloat a5;

  @Uint16()
  int a6;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3}, ${a4}, ${a5}, ${a6})";
}

class StructNestedIrregularBigger extends Struct {
  StructNestedIrregularBig a0;

  Struct8BytesNestedMixed a1;

  @Float()
  double a2;

  @Double()
  double a3;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3})";
}

class StructNestedIrregularEvenBigger extends Struct {
  @Uint64()
  int a0;

  StructNestedIrregularBigger a1;

  StructNestedIrregularBigger a2;

  @Double()
  double a3;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3})";
}

class Struct8BytesInlineArrayInt extends Struct {
  @Array(8)
  Array<Uint8> a0;

  String toString() => "(${[for (var i0 = 0; i0 < 8; i0 += 1) a0[i0]]})";
}

class Struct10BytesInlineArrayBool extends Struct {
  @Array(10)
  Array<Bool> a0;

  String toString() => "(${[for (var i0 = 0; i0 < 10; i0 += 1) a0[i0]]})";
}

class StructInlineArrayIrregular extends Struct {
  @Array(2)
  Array<Struct3BytesInt2ByteAligned> a0;

  @Uint8()
  int a1;

  String toString() => "(${[for (var i0 = 0; i0 < 2; i0 += 1) a0[i0]]}, ${a1})";
}

class StructInlineArray100Bytes extends Struct {
  @Array(100)
  Array<Uint8> a0;

  String toString() => "(${[for (var i0 = 0; i0 < 100; i0 += 1) a0[i0]]})";
}

class StructInlineArrayBig extends Struct {
  @Uint32()
  int a0;

  @Uint32()
  int a1;

  @Array(4000)
  Array<Uint8> a2;

  String toString() =>
      "(${a0}, ${a1}, ${[for (var i0 = 0; i0 < 4000; i0 += 1) a2[i0]]})";
}

class StructStruct16BytesHomogeneousFloat2 extends Struct {
  Struct4BytesFloat a0;

  @Array(2)
  Array<Struct4BytesFloat> a1;

  @Float()
  double a2;

  String toString() =>
      "(${a0}, ${[for (var i0 = 0; i0 < 2; i0 += 1) a1[i0]]}, ${a2})";
}

class StructStruct32BytesHomogeneousDouble2 extends Struct {
  Struct8BytesFloat a0;

  @Array(2)
  Array<Struct8BytesFloat> a1;

  @Double()
  double a2;

  String toString() =>
      "(${a0}, ${[for (var i0 = 0; i0 < 2; i0 += 1) a1[i0]]}, ${a2})";
}

class StructStruct16BytesMixed3 extends Struct {
  Struct4BytesFloat a0;

  @Array(1)
  Array<Struct8BytesMixed> a1;

  @Array(2)
  Array<Int16> a2;

  String toString() => "(${a0}, ${[
        for (var i0 = 0; i0 < 1; i0 += 1) a1[i0]
      ]}, ${[for (var i0 = 0; i0 < 2; i0 += 1) a2[i0]]})";
}

class Struct8BytesInlineArrayMultiDimensionalInt extends Struct {
  @Array(2, 2, 2)
  Array<Array<Array<Uint8>>> a0;

  String toString() => "(${[
        for (var i0 = 0; i0 < 2; i0 += 1)
          [
            for (var i1 = 0; i1 < 2; i1 += 1)
              [for (var i2 = 0; i2 < 2; i2 += 1) a0[i0][i1][i2]]
          ]
      ]})";
}

class Struct32BytesInlineArrayMultiDimensionalInt extends Struct {
  @Array(2, 2, 2, 2, 2)
  Array<Array<Array<Array<Array<Uint8>>>>> a0;

  String toString() => "(${[
        for (var i0 = 0; i0 < 2; i0 += 1)
          [
            for (var i1 = 0; i1 < 2; i1 += 1)
              [
                for (var i2 = 0; i2 < 2; i2 += 1)
                  [
                    for (var i3 = 0; i3 < 2; i3 += 1)
                      [for (var i4 = 0; i4 < 2; i4 += 1) a0[i0][i1][i2][i3][i4]]
                  ]
              ]
          ]
      ]})";
}

class Struct64BytesInlineArrayMultiDimensionalInt extends Struct {
  @Array.multi([2, 2, 2, 2, 2, 2])
  Array<Array<Array<Array<Array<Array<Uint8>>>>>> a0;

  String toString() => "(${[
        for (var i0 = 0; i0 < 2; i0 += 1)
          [
            for (var i1 = 0; i1 < 2; i1 += 1)
              [
                for (var i2 = 0; i2 < 2; i2 += 1)
                  [
                    for (var i3 = 0; i3 < 2; i3 += 1)
                      [
                        for (var i4 = 0; i4 < 2; i4 += 1)
                          [
                            for (var i5 = 0; i5 < 2; i5 += 1)
                              a0[i0][i1][i2][i3][i4][i5]
                          ]
                      ]
                  ]
              ]
          ]
      ]})";
}

class Struct4BytesInlineArrayMultiDimensionalInt extends Struct {
  @Array(2, 2)
  Array<Array<Struct1ByteInt>> a0;

  String toString() => "(${[
        for (var i0 = 0; i0 < 2; i0 += 1)
          [for (var i1 = 0; i1 < 2; i1 += 1) a0[i0][i1]]
      ]})";
}

@Packed(1)
class Struct3BytesPackedInt extends Struct {
  @Int8()
  int a0;

  @Int16()
  int a1;

  String toString() => "(${a0}, ${a1})";
}

@Packed(1)
class Struct3BytesPackedIntMembersAligned extends Struct {
  @Int8()
  int a0;

  @Int16()
  int a1;

  String toString() => "(${a0}, ${a1})";
}

@Packed(1)
class Struct5BytesPackedMixed extends Struct {
  @Float()
  double a0;

  @Uint8()
  int a1;

  String toString() => "(${a0}, ${a1})";
}

class StructNestedAlignmentStruct5BytesPackedMixed extends Struct {
  @Uint8()
  int a0;

  Struct5BytesPackedMixed a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct6BytesInlineArrayInt extends Struct {
  @Array(2)
  Array<Struct3BytesPackedIntMembersAligned> a0;

  String toString() => "(${[for (var i0 = 0; i0 < 2; i0 += 1) a0[i0]]})";
}

@Packed(1)
class Struct8BytesPackedInt extends Struct {
  @Uint8()
  int a0;

  @Uint32()
  int a1;

  @Uint8()
  int a2;

  @Uint8()
  int a3;

  @Uint8()
  int a4;

  String toString() => "(${a0}, ${a1}, ${a2}, ${a3}, ${a4})";
}

@Packed(1)
class Struct9BytesPackedMixed extends Struct {
  @Uint8()
  int a0;

  @Double()
  double a1;

  String toString() => "(${a0}, ${a1})";
}

class Struct15BytesInlineArrayMixed extends Struct {
  @Array(3)
  Array<Struct5BytesPackedMixed> a0;

  String toString() => "(${[for (var i0 = 0; i0 < 3; i0 += 1) a0[i0]]})";
}

class Union4BytesMixed extends Union {
  @Uint32()
  int a0;

  @Float()
  double a1;

  String toString() => "(${a0}, ${a1})";
}

class Union8BytesNestedFloat extends Union {
  @Double()
  double a0;

  Struct8BytesHomogeneousFloat a1;

  String toString() => "(${a0}, ${a1})";
}

class Union9BytesNestedInt extends Union {
  Struct8BytesInt a0;

  Struct9BytesHomogeneousUint8 a1;

  String toString() => "(${a0}, ${a1})";
}

class Union16BytesNestedInlineArrayFloat extends Union {
  @Array(4)
  Array<Float> a0;

  Struct16BytesHomogeneousFloat a1;

  String toString() => "(${[for (var i0 = 0; i0 < 4; i0 += 1) a0[i0]]}, ${a1})";
}

class Union16BytesNestedFloat extends Union {
  Struct8BytesHomogeneousFloat a0;

  Struct12BytesHomogeneousFloat a1;

  Struct16BytesHomogeneousFloat a2;

  String toString() => "(${a0}, ${a1}, ${a2})";
}

class StructInlineArrayInt extends Struct {
  @Array(10)
  Array<WChar> a0;

  String toString() => "(${[for (var i0 = 0; i0 < 10; i0 += 1) a0[i0]]})";
}
