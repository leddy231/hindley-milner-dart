import 'package:hindley_milner/helpers/substitution.dart';
import 'package:hindley_milner/helpers/type_helpers.dart';
import 'package:hindley_milner/helpers/unify.dart';
import 'package:hindley_milner/models/context.dart';
import 'package:hindley_milner/models/expression.dart';
import 'package:hindley_milner/models/types.dart';

(Substitution, MonoType) w(Context context, Expression expr) {
  switch (expr) {
    case VariableExpression varExp:
      var type = context[varExp.x];
      if (type == null) {
        throw Exception('Undefined variable ${varExp.x}');
      }
      return (Substitution({}), instantiate(type));
    case AbstractionExpression absExp:
      var beta = TypeVariable.fresh();
      var (s1, t1) = w(
        context.extend({absExp.x: beta}),
        absExp.e,
      );
      return (s1, s1.applyMono(Types.function(beta, t1)));
    case ApplicationExpression appExp:
      var (s1, t1) = w(context, appExp.e1);
      var (s2, t2) = w(s1.applyContext(context), appExp.e2);
      var beta = TypeVariable.fresh();
      var s3 = unify(s2.applyMono(t1), Types.function(t2, beta));
      return (s3.combine(s2.combine(s1)), s3.applyMono(beta));

    case LetExpression letExp:
      var (s1, t1) = w(context, letExp.e1);
      context = s1.applyContext(context);
      var (s2, t2) = w(
        context.extend({letExp.x: generalize(context, s1.applyMono(t1))}),
        letExp.e2,
      );
      return (s2.combine(s1), t2);
  }
}
