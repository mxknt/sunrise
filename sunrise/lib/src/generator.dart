import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sunrise_annotation/sunrise_annotation.dart';

class ThemeGenerator extends GeneratorForAnnotation<SunriseTheme> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);

    final generatedClassName = visitor.className.toString().substring(1);
    final items = annotation.read('themeItems').listValue.map((e) => e.toStringValue()).toList();
    final buff = StringBuffer();

    // buff.writeln('/*');

    buff.writeln('class $generatedClassName {');
    for (var item in items) {
      buff.writeln('final Color $item;');
    }
    buff.writeln('  const $generatedClassName({');
    for (var item in items) {
      buff.writeln('required this.$item,');
    }
    buff.writeln('\t});');
    buff.writeln('}');

    buff.writeln('');
    buff.writeln('class ${generatedClassName}Tween extends Tween<$generatedClassName> {');
    // buff.writeln('\tdouble t = 0;');
    for (var item in items) {
      buff.writeln('final ColorTween _$item;');
    }
    buff.writeln('');
    buff.writeln(
        '  const ${generatedClassName}Tween({required $generatedClassName begin, required $generatedClassName end}): ');
    for (var item in items) {
      buff.writeln('_$item = ColorTween(begin: begin.$item, end: end.$item),');
    }
    buff.writeln('super(begin: begin, end: end);');
    // buff.writeln('\t}');

    buff.writeln('');
    // for (var item in items) {
    //   buff.writeln('\tColor get $item => _$item.lerp(t)!;');
    // }
    // buff.writeln('}');

    buff.writeln('@override');
    buff.writeln('$generatedClassName lerp(double t) {');
    buff.writeln('assert(t >= 0 && t <= 1);');
    buff.writeln('return $generatedClassName(');
    for (var item in items) {
      buff.writeln('$item: _$item.lerp(t)!,');
    }
    buff.writeln(');');
    buff.writeln('}');
    buff.writeln('}');

    // buff.writeln('*/');

    return buff.toString();
  }
}

class ModelVisitor extends SimpleElementVisitor {
  DartType? className;
  Map<String, DartType> fields = {};

  @override
  visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType;
    // return super.visitConstructorElement(element);
  }

  @override
  visitFieldElement(FieldElement element) {
    print('visiting element ${element.toString()}');
    fields[element.name] = element.type;
    // return super.visitFieldElement(element);
  }
}
