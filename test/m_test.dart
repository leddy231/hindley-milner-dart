import 'package:test/test.dart';

import 'package:hindley_milner/inference/m.dart';
import 'package:hindley_milner/inference/w.dart';
import 'package:hindley_milner/models/context.dart';
import 'package:hindley_milner/models/expression.dart';
import 'package:hindley_milner/models/types.dart';
import 'package:hindley_milner/parser/parser.dart';

void main() {
  final defaultContext = Context({
    "not": Types.function(Types.bool, Types.bool),
    "odd": Types.function(Types.int, Types.bool),
    "append": TypeQuantifier(
      "a",
      Types.function(
        Types.list(TypeVariable("a")),
        Types.function(
          TypeVariable("a"),
          Types.list(TypeVariable("a")),
        ),
      ),
    ),
  });
  test("any to any", () {
    Context context = Context({});
    Expression expr = parse("\\x -> x").value;
    MonoType t = TypeVariable.fresh();
    var s = m(context, expr, t);
    t = s.applyMono(t);
    var result = Types.function(TypeVariable("t1"), TypeVariable("t1"));
    expect(s.applyMono(t), result);
  });

  test("undefined variable", () {
    Context context = Context({});

    Expression expr = parse("x").value;
    expect(() => w(context, expr), throwsException);
  });

  test("not", () {
    Expression expr = parse("\\x -> not x").value;
    MonoType t = TypeVariable.fresh();
    var s = m(defaultContext, expr, t);
    t = s.applyMono(t);
    expect(s.applyMono(t), Types.function(Types.bool, Types.bool));
  });

  test("odd", () {
    Expression expr = parse("\\x -> odd x").value;
    MonoType t = TypeVariable.fresh();
    var s = m(defaultContext, expr, t);
    t = s.applyMono(t);
    expect(s.applyMono(t), Types.function(Types.int, Types.bool));
  });

  test("append", () {
    Expression expr = parse("\\x -> \\y -> append x (odd y)").value;
    MonoType t = TypeVariable.fresh();
    var s = m(defaultContext, expr, t);
    t = s.applyMono(t);
    expect(
      s.applyMono(t),
      Types.function(
        Types.list(Types.bool),
        Types.function(
          Types.int,
          Types.list(Types.bool),
        ),
      ),
    );
  });
}
