#!/usr/bin/env python3
#
# Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.
"""Generates CSSStyleDeclaration template file from css property definitions
defined in WebKit."""

import tempfile, os, re

COMMENT_LINE_PREFIX = '   * '
# TODO(efortuna): Pull from DEPS so that we have latest css *in sync* with our
# Dartium. Then remove the checked in CSSPropertyNames.in.
SOURCE_PATH = 'CSSPropertyNames.in'
#SOURCE_PATH = 'Source/WebCore/css/CSSPropertyNames.in'
TEMPLATE_FILE = '../templates/html/impl/impl_CSSStyleDeclaration.darttemplate'

# These are the properties that are supported on all Dart project supported
# browsers as camelCased names on the CssStyleDeclaration.
# Note that we do not use the MDN for compatibility info here.
BROWSER_PATHS = [
    'cssProperties.CSS21.txt',  # Remove when we have samples from all browsers.
    'cssProperties.ie9.txt',
    'cssProperties.ie10.txt',
    'cssProperties.ie11.txt',
    'cssProperties.ff36.txt',
    'cssProperties.chrome40.txt',
    'cssProperties.safari-7.1.3.txt',
    'cssProperties.mobileSafari-8.2.txt',
    'cssProperties.iPad4Air.onGoogleSites.txt',
]

# Supported annotations for any specific CSS properties.
annotated = {
    'transition':
    '''@SupportedBrowser(SupportedBrowser.CHROME)
  @SupportedBrowser(SupportedBrowser.FIREFOX)
  @SupportedBrowser(SupportedBrowser.IE, '10')
  @SupportedBrowser(SupportedBrowser.SAFARI)'''
}


class Error:

    def __init__(self, message):
        self.message = message

    def __repr__(self):
        return self.message


def camelCaseName(name):
    """Convert a CSS property name to a lowerCamelCase name."""
    name = name.replace('-webkit-', '')
    words = []
    for word in name.split('-'):
        if words:
            words.append(word.title())
        else:
            words.append(word)
    return ''.join(words)


def dashifyName(camelName):

    def fix(match):
        return '-' + match.group(0).lower()

    return re.sub(r'[A-Z]', fix, camelName)


def isCommentLine(line):
    return line.strip() == '' or line.startswith('#') or line.startswith('//')


def readCssProperties(filename):
    data = open(filename).readlines()
    data = sorted([d.strip() for d in set(data) if not isCommentLine(d)])
    return data


def GenerateCssTemplateFile():
    data = open(SOURCE_PATH).readlines()

    # filter CSSPropertyNames.in to only the properties
    # TODO(efortuna): do we also want CSSPropertyNames.in?
    data = [d.strip() for d in data if not isCommentLine(d) and not '=' in d]

    browser_props = [readCssProperties(file) for file in BROWSER_PATHS]
    universal_properties = reduce(lambda a, b: set(a).intersection(b),
                                  browser_props)
    universal_properties = universal_properties.difference(['cssText'])
    universal_properties = universal_properties.intersection(
        map(camelCaseName, data))

    class_file = open(TEMPLATE_FILE, 'w')

    class_file.write("""
// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// WARNING: DO NOT EDIT THIS TEMPLATE FILE.
// The template file was generated by scripts/css_code_generator.py

// Source of CSS properties:
//   %s

part of $LIBRARYNAME;
""" % SOURCE_PATH)

    class_file.write("""
$(ANNOTATIONS)$(NATIVESPEC)$(CLASS_MODIFIERS)class $CLASSNAME $EXTENDS with
    $(CLASSNAME)Base $IMPLEMENTS {
  factory $CLASSNAME() => new CssStyleDeclaration.css('');

  factory $CLASSNAME.css(String css) {
    final style = new DivElement().style;
    style.cssText = css;
    return style;
  }

  /// Returns the value of the property if the provided *CSS* property
  /// name is supported on this element and if the value is set. Otherwise
  /// returns an empty string.
  ///
  /// Please note the property name uses camelCase, not-hyphens.
  String getPropertyValue(String propertyName) {
    return _getPropertyValueHelper(propertyName);
  }

  String _getPropertyValueHelper(String propertyName) {
    return _getPropertyValue(_browserPropertyName(propertyName));
  }

  /**
   * Returns true if the provided *CSS* property name is supported on this
   * element.
   *
   * Please note the property name camelCase, not-hyphens. This
   * method returns true if the property is accessible via an unprefixed _or_
   * prefixed property.
   */
  bool supportsProperty(String propertyName) {
    return _supportsProperty(propertyName) ||
        _supportsProperty(_camelCase("${Device.cssPrefix}$propertyName"));
  }

  bool _supportsProperty(String propertyName) {
    return JS('bool', '# in #', propertyName, this);
  }


  void setProperty(String propertyName, String$NULLABLE value,
      [String$NULLABLE priority]) {
    return _setPropertyHelper(_browserPropertyName(propertyName),
      value, priority);
  }

  String _browserPropertyName(String propertyName) {
    String$NULLABLE name = _readCache(propertyName);
    if (name is String) return name;
    name = _supportedBrowserPropertyName(propertyName);
    _writeCache(propertyName, name);
    return name;
  }

  String _supportedBrowserPropertyName(String propertyName) {
    if (_supportsProperty(_camelCase(propertyName))) {
      return propertyName;
    }
    var prefixed = "${Device.cssPrefix}$propertyName";
    if (_supportsProperty(prefixed)) {
      return prefixed;
    }
    // May be a CSS variable, just use it as provided.
    return propertyName;
  }

  static final _propertyCache = JS('', '{}');
  static String$NULLABLE _readCache(String key) =>
    JS('String|Null', '#[#]', _propertyCache, key);
  static void _writeCache(String key, String value) {
    JS('void', '#[#] = #', _propertyCache, key, value);
  }

  static String _camelCase(String hyphenated) {
    var replacedMs = JS('String', r'#.replace(/^-ms-/, "ms-")', hyphenated);
    return JS(
        'String',
        r'#.replace(/-([\da-z])/ig,'
            r'function(_, letter) { return letter.toUpperCase();})',
        replacedMs);
  }

  void _setPropertyHelper(String propertyName, String$NULLABLE value,
                          [String$NULLABLE priority]) {
    if (value == null) value = '';
    if (priority == null) priority = '';
    JS('void', '#.setProperty(#, #, #)', this, propertyName, value, priority);
  }

  /**
   * Checks to see if CSS Transitions are supported.
   */
  static bool get supportsTransitions {
    return document.body$NULLASSERT.style.supportsProperty('transition');
  }
$!MEMBERS
""")

    for camelName in sorted(universal_properties):
        property = dashifyName(camelName)
        class_file.write("""
  /** Gets the value of "%s" */
  String get %s => this._%s;

  /** Sets the value of "%s" */
  set %s(String$NULLABLE value) {
    _%s = value == null ? '' : value;
  }
  @Returns('String')
  @JSName('%s')
  String get _%s native;

  @JSName('%s')
  set _%s(String value) native;
    """ % (property, camelName, camelName, property, camelName, camelName,
           camelName, camelName, camelName, camelName))

    class_file.write("""
}

class _CssStyleDeclarationSet extends Object with CssStyleDeclarationBase {
  final Iterable<Element> _elementIterable;
  Iterable<CssStyleDeclaration>$NULLABLE _elementCssStyleDeclarationSetIterable;

  _CssStyleDeclarationSet(this._elementIterable) {
    _elementCssStyleDeclarationSetIterable = new List.from(
        _elementIterable).map((e) => e.style);
  }

  String getPropertyValue(String propertyName) =>
      _elementCssStyleDeclarationSetIterable$NULLASSERT.first.getPropertyValue(
          propertyName);

  void setProperty(String propertyName, String$NULLABLE value,
      [String$NULLABLE priority]) {
    _elementCssStyleDeclarationSetIterable$NULLASSERT.forEach((e) =>
        e.setProperty(propertyName, value, priority));
  }

""")

    class_file.write("""
  void _setAll(String propertyName, String$NULLABLE value) {
    value = value == null ? '' : value;
    for (Element element in _elementIterable) {
      JS('void', '#.style[#] = #', element, propertyName, value);
    }
  }
""")

    for camelName in sorted(universal_properties):
        property = dashifyName(camelName)
        class_file.write("""
  /** Sets the value of "%s" */
  set %s(String value) {
    _setAll('%s', value);
  }
    """ % (property, camelName, camelName))

    class_file.write("""

  // Important note: CssStyleDeclarationSet does NOT implement every method
  // available in CssStyleDeclaration. Some of the methods don't make so much
  // sense in terms of having a resonable value to return when you're
  // considering a list of Elements. You will need to manually add any of the
  // items in the MEMBERS set if you want that functionality.
}

abstract class CssStyleDeclarationBase {
  String getPropertyValue(String propertyName);
  void setProperty(String propertyName, String$NULLABLE value,
      [String$NULLABLE priority]);
""")

    class_lines = []

    seen = set()
    for prop in sorted(data, key=camelCaseName):
        camel_case_name = camelCaseName(prop)
        upper_camel_case_name = camel_case_name[0].upper() + camel_case_name[1:]
        css_name = prop.replace('-webkit-', '')
        base_css_name = prop.replace('-webkit-', '')

        if base_css_name in seen or base_css_name.startswith('-internal'):
            continue
        seen.add(base_css_name)

        comment = '  /** %s the value of "' + base_css_name + '" */'
        class_lines.append('\n')
        class_lines.append(comment % 'Gets')
        if base_css_name in annotated:
            class_lines.append(annotated[base_css_name])
        class_lines.append("""
  String get %s =>
    getPropertyValue('%s');

""" % (camel_case_name, css_name))

        class_lines.append(comment % 'Sets')
        if base_css_name in annotated:
            class_lines.append(annotated[base_css_name])
        class_lines.append("""
  set %s(String value) {
    setProperty('%s', value, '');
  }
""" % (camel_case_name, css_name))

    class_file.write(''.join(class_lines))
    class_file.write('}\n')
    class_file.close()
