import 'package:hindley_milner/models/types.dart';
import 'package:hindley_milner/utils.dart';

class Context {
  final Map<String, PolyType> raw;

  Context(this.raw);

  operator [](String key) => raw[key];

  Context extend(Map<String, PolyType> raw) => Context({...this.raw, ...raw});

  Context map(PolyType Function(PolyType) f) => Context(raw.mapValues(f));
}
