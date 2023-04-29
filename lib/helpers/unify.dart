import 'package:hindley_milner/helpers/substitution.dart';
import 'package:hindley_milner/helpers/type_helpers.dart';
import 'package:hindley_milner/models/types.dart';

Substitution unify(MonoType type1, MonoType type2) {
  if (type1 == type2) {
    return Substitution({});
  }

  if (type1 is TypeVariable) {
    if (contains(type2, type1)) {
      throw Exception("Type mismatch: $type1 occurs in $type2");
    }
    return Substitution({type1.a: type2});
  }

  if (type2 is TypeVariable) {
    return unify(type2, type1);
  }

  if (type1 is TypeFunctionApplication && type2 is TypeFunctionApplication) {
    if (type1.c != type2.c) {
      throw Exception("Type mismatch: ${type1.c} != ${type2.c}");
    }

    if (type1.mus.length != type2.mus.length) {
      throw Exception(
        "TypeFunctionApplication argument length mismatch: $type1 != $type2",
      );
    }

    var substitution = Substitution({});

    for (var i = 0; i < type1.mus.length; i++) {
      var s = unify(
        substitution.applyMono(type1.mus[i]),
        substitution.applyMono(type2.mus[i]),
      );
      substitution = substitution.combine(s);
    }

    return substitution;
  }

  throw Exception("Type mismatch: $type1 != $type2");
}
