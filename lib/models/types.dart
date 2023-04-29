import 'package:collection/collection.dart';

enum TypeFunction {
  function("->", 2),
  bool("Bool", 0),
  integer("Int", 0),
  string("String", 0),
  list("List", 1);

  final String name;
  final int arity;

  const TypeFunction(this.name, this.arity);
}

sealed class PolyType {}

sealed class MonoType extends PolyType {}

class TypeVariable extends MonoType {
  static int currentTypeVar = 0;
  final String a;

  TypeVariable(this.a);

  TypeVariable.fresh() : a = "t${currentTypeVar++}";

  @override
  String toString() => a;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeVariable && runtimeType == other.runtimeType && a == other.a;
}

class TypeFunctionApplication extends MonoType {
  final TypeFunction c;
  final List<MonoType> mus;

  TypeFunctionApplication(this.c, this.mus);

  @override
  String toString() => "${c.name} ${mus.join(' ')}";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeFunctionApplication &&
          runtimeType == other.runtimeType &&
          c == other.c &&
          ListEquality().equals(mus, other.mus);
}

class TypeQuantifier extends PolyType {
  final String a;
  final PolyType sigma;

  TypeQuantifier(this.a, this.sigma);

  @override
  String toString() => '(∀$a. $sigma)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeQuantifier &&
          runtimeType == other.runtimeType &&
          a == other.a &&
          sigma == other.sigma;
}

abstract class Types {
  // Helper functions and variables to make it easier to create types.
  static final bool = TypeFunctionApplication(TypeFunction.bool, []);
  static final int = TypeFunctionApplication(TypeFunction.integer, []);
  static final string = TypeFunctionApplication(TypeFunction.string, []);

  static TypeFunctionApplication function(MonoType from, MonoType to) =>
      TypeFunctionApplication(
        TypeFunction.function,
        [from, to],
      );

  static TypeFunctionApplication list(MonoType of) => TypeFunctionApplication(
        TypeFunction.list,
        [of],
      );
}
