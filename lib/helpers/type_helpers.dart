import 'package:hindley_milner/helpers/free_vars.dart';
import 'package:hindley_milner/models/context.dart';
import 'package:hindley_milner/models/types.dart';

bool contains(MonoType type, TypeVariable type2) {
  switch (type) {
    case TypeVariable typeVar:
      return typeVar == type2;
    case TypeFunctionApplication app:
      return app.mus.any((mu) => contains(mu, type2));
  }
}

MonoType instantiate(
  PolyType type, [
  Map<String, TypeVariable>? mappings,
]) {
  mappings ??= {};
  switch (type) {
    case TypeVariable typeVar:
      return mappings[typeVar.a] ?? typeVar;
    case TypeFunctionApplication app:
      return TypeFunctionApplication(
        app.c,
        app.mus.map((mu) => instantiate(mu, mappings)).toList(),
      );
    case TypeQuantifier quant:
      mappings[quant.a] = TypeVariable.fresh();
      return instantiate(quant.sigma, mappings);
  }
}

PolyType generalize(Context context, MonoType type) {
  Set<String> freeContextVars = freeVarsContext(context);
  Set<String> freeTypeVars = freeVarsType(type);
  var freeVars = freeTypeVars.difference(freeContextVars);

  return freeVars.fold(type, (sigma, a) => TypeQuantifier(a, sigma));
}
