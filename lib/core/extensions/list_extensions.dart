extension ListUpsertExtension<T> on List<T> {
  void upsert(T item, {T? existing, required bool Function(T) test}) {
    if (existing == null) {
      add(item);
      return;
    }

    final index = indexWhere(test);
    if (index != -1) this[index] = item;
  }
}
