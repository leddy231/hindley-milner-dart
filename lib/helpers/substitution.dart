import 'package:hindley_milner/models/context.dart';
import 'package:hindley_milner/models/types.dart';
import 'package:hindley_milner/utils.dart';

class Substitution {
  final Map<String, MonoType> raw;

  Substitution(this.raw);

  Substitution combine(Substitution s2) {
    var s1 = this;
    return Substitution({
      ...s1.raw,
      ...s2.raw.mapValues(s1.applyMono),
    });
  }

  Context applyContext(Context context) => context.map(applyPoly);

  PolyType applyPoly(PolyType poly) {
    switch (poly) {
      case MonoType m:
        return applyMono(m);
      case TypeQuantifier quant:
        return TypeQuantifier(
          quant.a,
          applyPoly(quant.sigma),
        );
    }
  }

  MonoType applyMono(MonoType mono) {
    switch (mono) {
      case TypeVariable typeVariable:
        return raw[typeVariable.a] ?? typeVariable;
      case TypeFunctionApplication app:
        return TypeFunctionApplication(
          app.c,
          app.mus.map(applyMono).toList(),
        );
    }
  }

  @override
  String toString() {
    return raw.entries.map((e) => "${e.key} |-> ${e.value}").join(', ');
  }
}
