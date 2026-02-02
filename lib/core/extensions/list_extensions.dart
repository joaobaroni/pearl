/// Adds an insert-or-update operation to [List].
extension ListUpsertExtension<T> on List<T> {
  /// Inserts [item] if [existing] is `null`; otherwise replaces the first
  /// element matching [test] in place.
  void upsert(T item, {T? existing, required bool Function(T) test}) {
    if (existing == null) {
      add(item);
      return;
    }

    final index = indexWhere(test);
    if (index != -1) this[index] = item;
  }
}
