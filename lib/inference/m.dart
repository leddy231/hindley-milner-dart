import 'package:hindley_milner/helpers/substitution.dart';
import 'package:hindley_milner/helpers/type_helpers.dart';
import 'package:hindley_milner/helpers/unify.dart';
import 'package:hindley_milner/models/context.dart';
import 'package:hindley_milner/models/expression.dart';
import 'package:hindley_milner/models/types.dart';

Substitution m(Context context, Expression expr, MonoType type) {
  switch (expr) {
    case VariableExpression varExpr:
      var value = context[varExpr.x];
      if (value == null) {
        throw Exception('Undefined variable ${varExpr.x}');
      }
      return unify(type, instantiate(value));
    case AbstractionExpression absExpr:
      var beta1 = TypeVariable.fresh();
      var beta2 = TypeVariable.fresh();
      var s1 = unify(
        type,
        Types.function(beta1, beta2),
      );
      var s2 = m(
        s1.applyContext(context).extend({absExpr.x: s1.applyMono(beta1)}),
        absExpr.e,
        s1.applyMono(beta2),
      );
      return s2.combine(s1);
    case ApplicationExpression appExpr:
      var beta = TypeVariable.fresh();
      var s1 = m(context, appExpr.e1, Types.function(beta, type));
      var s2 = m(s1.applyContext(context), appExpr.e2, s1.applyMono(beta));
      return s2.combine(s1);

    case LetExpression letExpr:
      var beta = TypeVariable.fresh();
      var s1 = m(context, letExpr.e1, beta);
      var s2 = m(
        s1.applyContext(context).extend(
          {letExpr.x: generalize(context, s1.applyMono(beta))},
        ),
        letExpr.e2,
        s1.applyMono(type),
      );
      return s2.combine(s1);
  }
}
