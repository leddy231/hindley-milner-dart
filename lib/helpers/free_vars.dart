import 'package:hindley_milner/models/context.dart';
import 'package:hindley_milner/models/types.dart';

Set<String> freeVarsType(PolyType type) {
  switch (type) {
    case TypeVariable typeVar:
      return {typeVar.a};
    case TypeFunctionApplication app:
      return app.mus.map(freeVarsType).fold({}, (a, b) => a.union(b));
    case TypeQuantifier quant:
      return freeVarsType(quant.sigma).difference({quant.a});
  }
}

Set<String> freeVarsContext(Context context) {
  return context.raw.values.map(freeVarsType).fold({}, (a, b) => a.union(b));
}
