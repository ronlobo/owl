// Copyright (c) 2016, Agilord. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart' show BuildStep;
// ignore: implementation_imports
import 'package:source_gen/src/annotation.dart' show matchAnnotation;

const _owlVersion = '0.1.0';

/// Whether the AST [element] has an [annotation] on it.
bool hasAnnotation(Element element, Type annotation) =>
    element.metadata.any((ea) => _matchAnnotation(annotation, ea));

/// Return the first [annotation] for the given [element] or null if non exists.
DartObject getAnnotation(Element element, Type annotation) => element.metadata
    .firstWhere((ea) => _matchAnnotation(annotation, ea), orElse: () => null)
    ?.constantValue;

/// Return all [annotation]s for the given [element].
Iterable<DartObject> getAnnotations(Element element, Type annotation) =>
    element.metadata
        .where((ea) => _matchAnnotation(annotation, ea))
        .map((ea) => ea.constantValue);

/// Whether any class exists in the [library] that has the given [annotation].
bool hasAnnotatedClass(LibraryElement library, Type annotation) => library.units
    .any((unit) => unit.types.any((type) => hasAnnotation(type, annotation)));

///
ClassElement getClassRef(LibraryElement library, DartObject obj) {
  for (var unit in library.units) {
    for (var type in unit.types) {
      // TODO: figure out better way to check this
      if (obj.toString() == 'Type (${type.name})') return type;
    }
  }
  return null;
}

///
List<ClassElement> listClasses(LibraryElement library, Type annotation) =>
    library.units
        .map((unit) => unit.types)
        .fold(new List<ClassElement>(), (l1, l2) => l1..addAll(l2))
        .where((type) => hasAnnotation(type, annotation))
        .toList();

/// Probes the [element] and if it is a library, it will create library-level
/// import blocks.
String handleIfLibrary(BuildStep buildStep, Element element, Type annotation,
    {List<String> libraries, Map<String, String> aliasedLibraries}) {
  if (element is LibraryElement && hasAnnotatedClass(element, annotation)) {
    final List<String> blocks = [];
    blocks.addAll([
      '// Generated by owl $_owlVersion',
      '// https://github.com/agilord/owl\n\n'
    ]);
    blocks.add(_library(buildStep.input.id.path.split('/').last));
    libraries?.forEach((lib) {
      blocks.add(_library(lib));
    });
    aliasedLibraries?.forEach((alias, lib) {
      blocks.add(_library(lib, alias));
    });
    return blocks.join('\n');
  }
  return null;
}

///
String stringValue(DartObject object, String field, [String defaultValue]) {
  if (object == null) return defaultValue;
  final value = object.getField(field);
  if (value.isNull) return defaultValue;
  return value.toStringValue();
}

///
bool boolValue(DartObject object, String field, [bool defaultValue]) {
  if (object == null) return defaultValue;
  final value = object.getField(field);
  if (value.isNull) return defaultValue;
  return value.toBoolValue();
}

Set _nativeJsonTypes = new Set.from(['int', 'double', 'bool', 'String', 'num']);

/// Whether a given type is native in JSON-land.
bool isNativeJson(String type) => _nativeJsonTypes.contains(type);

bool _matchAnnotation(Type annotation, ElementAnnotation ea) {
  try {
    return matchAnnotation(annotation, ea);
  } catch (e) {
    return false;
  }
}

String _library(String lib, [String alias]) {
  final String ending = alias == null ? '' : ' as $alias';
  return '// ignore: unused_import, library_prefixes\n'
      'import \'$lib\'$ending;';
}
