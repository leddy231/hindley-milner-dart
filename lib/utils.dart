extension MapValues<K, V> on Map<K, V> {
  Map<K, V2> mapValues<V2>(V2 Function(V) f) {
    return map((key, value) => MapEntry(key, f(value)));
  }
}
