// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

/// Test to ensure that desugaring APIs used by clients like dart2js are
/// always up to date.
///
/// Desugaring APIs are methods that inspect the kernel output to find
/// structures that are assumed to always be generated by the CFE. If the CFE
/// changes its invariants, the desugaring APIs will change together to hide
/// these changes from clients.

import 'dart:io';

import 'package:async_helper/async_helper.dart';
import 'package:expect/expect.dart';
import 'package:front_end/src/api_unstable/dart2js.dart' as api;
import 'package:front_end/src/compute_platform_binaries_location.dart';
import 'package:front_end/src/fasta/kernel/utils.dart' show serializeComponent;
import 'package:front_end/src/testing/compiler_common.dart';
import 'package:kernel/ast.dart' as ir;
import 'package:kernel/binary/ast_from_binary.dart' show BinaryBuilder;

Future<void> main() async {
  await asyncTest(() async {
    await testRedirectingFactoryDirect();
    await testRedirectingFactorySerialized();
    await testRedirectingFactoryPatchFile();
    await testExtensionMemberKind();
  });
}

Future<void> testRedirectingFactoryDirect() async {
  var component = await compileUnit(['a.dart'], {'a.dart': aSource});
  checkIsRedirectingFactory(component, 'a.dart', 'A', 'foo');
  checkIsRedirectingFactory(component, 'core', 'Uri', 'file');
}

Future<void> testRedirectingFactorySerialized() async {
  var component = await compileUnit(['a.dart'], {'a.dart': aSource});
  var bytes = serializeComponent(component);
  component = new ir.Component();
  new BinaryBuilder(bytes).readComponent(component);
  checkIsRedirectingFactory(component, 'a.dart', 'A', 'foo');
  checkIsRedirectingFactory(component, 'core', 'Uri', 'file');
}

// regression test: redirecting factories from patch files don't have the
// redirecting-factory flag stored in kernel.
Future<void> testRedirectingFactoryPatchFile() async {
  var componentUri =
      computePlatformBinariesLocation().resolve('dart2js_platform.dill');
  var component = new ir.Component();
  new BinaryBuilder(new File.fromUri(componentUri).readAsBytesSync())
      .readComponent(component);
  checkIsRedirectingFactory(component, 'collection', 'HashMap', 'identity');
}

void checkIsRedirectingFactory(ir.Component component, String uriPath,
    String className, String constructorName) {
  var lib =
      component.libraries.firstWhere((l) => l.importUri.path.endsWith(uriPath));
  var cls = lib.classes.firstWhere((c) => c.name == className);
  ir.Procedure member =
      cls.members.firstWhere((m) => m.name.text == constructorName);
  Expect.isTrue(
      member.kind == ir.ProcedureKind.Factory, "$member is not a factory");
  Expect.isTrue(api.isRedirectingFactory(member));
  Expect.isTrue(member.isRedirectingFactory);
}

const aSource = '''
class A {
  factory A.foo(int x) = _B;
}

class _B implements A {
  _B(int x);
}
''';

Future<void> testExtensionMemberKind() async {
  var component = await compileUnit(['e.dart'], {'e.dart': extensionSource});
  var library = component.libraries
      .firstWhere((l) => l.importUri.path.endsWith('e.dart'));
  var descriptors =
      library.extensions.expand((extension) => extension.members).toList();

  // Check generated getters and setters for fields.
  var fieldGetter =
      findExtensionField(descriptors, 'field', ir.ExtensionMemberKind.Getter);
  Expect.equals(
      api.getExtensionMemberKind(fieldGetter), ir.ProcedureKind.Getter);
  var fieldSetter =
      findExtensionField(descriptors, 'field', ir.ExtensionMemberKind.Setter);
  Expect.equals(
      api.getExtensionMemberKind(fieldSetter), ir.ProcedureKind.Setter);
  var staticFieldGetter = findExtensionField(
      descriptors, 'staticField', ir.ExtensionMemberKind.Getter);
  Expect.equals(
      api.getExtensionMemberKind(staticFieldGetter), ir.ProcedureKind.Getter);
  var staticFieldSetter = findExtensionField(
      descriptors, 'staticField', ir.ExtensionMemberKind.Setter);
  Expect.equals(
      api.getExtensionMemberKind(staticFieldSetter), ir.ProcedureKind.Setter);

  // Check getters and setters.
  var getter = findExtensionMember(descriptors, 'getter');
  Expect.equals(api.getExtensionMemberKind(getter), ir.ProcedureKind.Getter);
  var setter = findExtensionMember(descriptors, 'setter');
  Expect.equals(api.getExtensionMemberKind(setter), ir.ProcedureKind.Setter);
  var staticGetter = findExtensionMember(descriptors, 'staticGetter');
  Expect.equals(
      api.getExtensionMemberKind(staticGetter), ir.ProcedureKind.Getter);
  var staticSetter = findExtensionMember(descriptors, 'staticSetter');
  Expect.equals(
      api.getExtensionMemberKind(staticSetter), ir.ProcedureKind.Setter);

  // Check methods.
  var method = findExtensionMember(descriptors, 'method');
  Expect.equals(api.getExtensionMemberKind(method), ir.ProcedureKind.Method);
  var methodTearoff = findExtensionTearoff(descriptors, 'get#method');
  Expect.equals(
      api.getExtensionMemberKind(methodTearoff), ir.ProcedureKind.Getter);
  var staticMethod = findExtensionMember(descriptors, 'staticMethod');
  Expect.equals(
      api.getExtensionMemberKind(staticMethod), ir.ProcedureKind.Method);

  // Check operators.
  var operator = findExtensionMember(descriptors, '+');
  Expect.equals(api.getExtensionMemberKind(operator), ir.ProcedureKind.Method);
}

ir.Member findExtensionMember(
    List<ir.ExtensionMemberDescriptor> descriptors, String memberName) {
  return descriptors
      .firstWhere((d) => d.name.text == memberName)
      .member
      .asMember;
}

ir.Member findExtensionField(List<ir.ExtensionMemberDescriptor> descriptors,
    String fieldName, ir.ExtensionMemberKind kind) {
  return descriptors
      .firstWhere((d) => d.name.text == fieldName && d.kind == kind)
      .member
      .asMember;
}

ir.Member findExtensionTearoff(
    List<ir.ExtensionMemberDescriptor> descriptors, String memberName) {
  return descriptors
      .map((d) => d.member.asMember)
      .firstWhere((m) => m.name.text.contains(memberName));
}

const extensionSource = '''
class Foo {}

extension Ext on Foo {
  external int field;
  external static int staticField;

  external get getter;
  external set setter(_);
  external static get staticGetter;
  external static set staticSetter(_);

  external int method();
  external static int staticMethod();

  external operator +(_);
}
''';
