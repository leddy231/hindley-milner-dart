import 'package:petitparser/petitparser.dart';

import 'package:hindley_milner/models/expression.dart';

//  e :: = x
//     | e1 e2
//     | \x -> e
//     | let x = e1 in e2

final parse = ExpressionDefinition().build<Expression>().parse;

class ExpressionDefinition extends GrammarDefinition<Expression> {
  static const String letToken = "let";
  static const String inToken = "in";
  static const keywords = [letToken, inToken];

  @override
  Parser<Expression> start() => ref0(expression).end();

  Parser<Expression> expression() => ref0(singleExpression)
      .plusSeparated(whitespace())
      .map((list) => list.elements.reduce(ApplicationExpression.new));

  Parser<Expression> singleExpression() => [
        ref0(parenthesizedExpression),
        ref0(abstraction),
        ref0(let),
        ref0(variable),
      ].toChoiceParser();

  Parser<Expression> parenthesizedExpression() => seq3(
        char('(').trim(),
        ref0(expression),
        char(')').trim(),
      ).map3((_, expression, __) => expression);

  Parser<VariableExpression> variable() =>
      ref0(identifier).map(VariableExpression.new);

  Parser<AbstractionExpression> abstraction() => seq4(
        char('\\').trim(),
        ref0(identifier),
        string('->').trim(),
        ref0(expression),
      ).map4(
        (_, variable, __, expression) =>
            AbstractionExpression(variable, expression),
      );

  Parser<LetExpression> let() => seq6(
        string(letToken).trim(),
        ref0(identifier),
        char('=').trim(),
        ref0(expression),
        string(inToken).trim(),
        ref0(expression),
      ).map6(
        (_, variable, __, expression1, ___, expression2) =>
            LetExpression(variable, expression1, expression2),
      );

  Parser<String> identifier() =>
      (letter() & (letter() | digit() | char('_')).star())
          .flatten()
          .where((value) => !keywords.contains(value));
}
