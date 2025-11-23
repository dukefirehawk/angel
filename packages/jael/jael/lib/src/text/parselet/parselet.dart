library;

import 'package:jael3/jael3.dart';

part 'infix.dart';
part 'prefix.dart';

abstract class PrefixParselet {
  Expression? parse(Parser parser, Token token);
}

abstract class InfixParselet {
  int get precedence;
  Expression? parse(Parser parser, Expression left, Token token);
}
