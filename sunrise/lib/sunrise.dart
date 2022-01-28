/// Support for doing something awesome.
///
/// More dartdocs go here.
library sunrise;

import 'package:sunrise/src/generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder autoThemeGenerator(BuilderOptions options) =>
    SharedPartBuilder([SunriseThemeGenerator()], 'sunrise_theme_generator');
