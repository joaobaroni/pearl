/// Returns true if [query] is a fuzzy subsequence match against [target].
/// Each character of [query] must appear in [target] in order (case-insensitive).
/// An empty query matches everything.
bool fuzzyMatch(String query, String target) {
  if (query.isEmpty) return true;
  final lowerQuery = query.toLowerCase();
  final lowerTarget = target.toLowerCase();
  int queryIndex = 0;
  for (int i = 0; i < lowerTarget.length && queryIndex < lowerQuery.length; i++) {
    if (lowerTarget[i] == lowerQuery[queryIndex]) {
      queryIndex++;
    }
  }
  return queryIndex == lowerQuery.length;
}
