import 'dart:convert';
import 'package:code_buffer/code_buffer.dart';
import 'package:symbol_table/symbol_table.dart';
import 'ast/ast.dart';
import 'text/parser.dart';
import 'text/scanner.dart';

/// Parses a Jael document.
Document parseDocument(String text,
    {sourceUrl, void onError(JaelError error)}) {
  var scanner = scan(text, sourceUrl: sourceUrl);

  if (scanner.errors.isNotEmpty && onError != null)
    scanner.errors.forEach(onError);
  else if (scanner.errors.isNotEmpty) throw scanner.errors.first;

  var parser = new Parser(scanner);
  var doc = parser.parseDocument();

  if (parser.errors.isNotEmpty && onError != null)
    parser.errors.forEach(onError);
  else if (parser.errors.isNotEmpty) throw parser.errors.first;

  return doc;
}

class Renderer {
  const Renderer();

  void render(Document document, CodeBuffer buffer, SymbolTable scope) {
    if (document.doctype != null) buffer.writeln(document.doctype.span.text);
    renderElement(
        document.root, buffer, scope, document.doctype?.public == null);
  }

  void renderElement(
      Element element, CodeBuffer buffer, SymbolTable scope, bool html5) {
    if (element.attributes.any((a) => a.name.name == 'for-each')) {
      renderForeach(element, buffer, scope, html5);
      return;
    } else if (element.attributes.any((a) => a.name.name == 'if')) {
      renderIf(element, buffer, scope, html5);
      return;
    }

    buffer..write('<')..write(element.tagName.name);

    for (var attribute in element.attributes) {
      var value = attribute.value?.compute(scope);

      if (value == false || value == null) continue;

      buffer.write(' ${attribute.name.name}');

      if (value == true)
        continue;
      else
        buffer.write('="');

      String msg;

      if (value is Iterable) {
        msg = value.join(' ');
      } else if (value is Map) {
        msg = value.keys.fold<StringBuffer>(new StringBuffer(), (buf, k) {
          var v = value[k];
          if (v == null) return buf;
          return buf..write('$k: $v;');
        }).toString();
      } else {
        msg = value.toString();
      }

      buffer.write(HTML_ESCAPE.convert(msg));
      buffer.write('"');
    }

    if (element is SelfClosingElement) {
      if (html5)
        buffer.writeln('>');
      else
        buffer.writeln('/>');
    } else {
      buffer.writeln('>');
      buffer.indent();

      for (int i = 0; i < element.children.length; i++) {
        var child = element.children.elementAt(i);
        renderElementChild(
            child, buffer, scope, html5, i, element.children.length);
      }

      buffer.writeln();
      buffer.outdent();
      buffer.writeln('</${element.tagName.name}>');
    }
  }

  void renderForeach(
      Element element, CodeBuffer buffer, SymbolTable scope, bool html5) {
    var attribute =
        element.attributes.singleWhere((a) => a.name.name == 'for-each');
    if (attribute.value == null) return;

    var asAttribute = element.attributes
        .firstWhere((a) => a.name.name == 'as', orElse: () => null);
    var alias = asAttribute?.value?.compute(scope) ?? 'item';
    var otherAttributes = element.attributes
        .where((a) => a.name.name != 'for-each' && a.name.name != 'as');
    Element strippedElement;

    if (element is SelfClosingElement)
      strippedElement = new SelfClosingElement(element.lt, element.tagName,
          otherAttributes, element.slash, element.gt);
    else if (element is RegularElement)
      strippedElement = new RegularElement(
          element.lt,
          element.tagName,
          otherAttributes,
          element.gt,
          element.children,
          element.lt2,
          element.slash,
          element.tagName2,
          element.gt2);

    for (var item in attribute.value.compute(scope)) {
      var childScope = scope.createChild(values: {alias: item});
      renderElement(strippedElement, buffer, childScope, html5);
    }
  }

  void renderIf(
      Element element, CodeBuffer buffer, SymbolTable scope, bool html5) {
    var attribute = element.attributes.singleWhere((a) => a.name.name == 'if');

    if (!attribute.value.compute(scope)) return;

    var otherAttributes = element.attributes.where((a) => a.name.name != 'if');
    Element strippedElement;

    if (element is SelfClosingElement)
      strippedElement = new SelfClosingElement(element.lt, element.tagName,
          otherAttributes, element.slash, element.gt);
    else if (element is RegularElement)
      strippedElement = new RegularElement(
          element.lt,
          element.tagName,
          otherAttributes,
          element.gt,
          element.children,
          element.lt2,
          element.slash,
          element.tagName2,
          element.gt2);

    renderElement(strippedElement, buffer, scope, html5);
  }

  void renderElementChild(ElementChild child, CodeBuffer buffer,
      SymbolTable scope, bool html5, int index, int total) {
    if (child is Text) {
      if (index == 0)
        buffer.write(child.span.text.trimLeft());
      else if (index == total - 1)
        buffer.write(child.span.text.trimRight());
      else
        buffer.write(child.span.text);
    } else if (child is Interpolation) {
      var value = child.expression.compute(scope);

      if (value != null) {
        if (child.isRaw)
          buffer.write(value);
        else
          buffer.write(HTML_ESCAPE.convert(value.toString()));
      }
    } else if (child is Element) {
      buffer.writeln();
      renderElement(child, buffer, scope, html5);
    }
  }
}
