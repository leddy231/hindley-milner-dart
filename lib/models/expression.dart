sealed class Expression {}

class VariableExpression extends Expression {
  final String x;

  VariableExpression(this.x);

  @override
  String toString() => x;
}

class ApplicationExpression extends Expression {
  final Expression e1;
  final Expression e2;

  ApplicationExpression(this.e1, this.e2);

  @override
  String toString() => '($e1 $e2)';
}

class AbstractionExpression extends Expression {
  final String x;
  final Expression e;

  AbstractionExpression(this.x, this.e);

  @override
  String toString() => '(λ$x -> $e)';
}

class LetExpression extends Expression {
  final String x;
  final Expression e1;
  final Expression e2;

  LetExpression(this.x, this.e1, this.e2);

  @override
  String toString() => '(let $x = $e1 in $e2)';
}
