/// Calculates the similarity between [a] and [b].
///
/// The algorithm is based on the same basic approach used by Python's
/// `difflib.SequenceMatcher`: recursively find the longest contiguous
/// matching subsequences and calculate
///
/// ```text
/// 2 * M / (length(a) + length(b))
/// ```
///
/// where `M` is the total number of matched UTF-16 code units.
///
/// The result is between `0.0` and `1.0`.
///
/// This implementation intentionally operates on Dart UTF-16 code units.
/// It does not perform Unicode normalization or grapheme-cluster handling.
///
/// Examples:
///
/// ```dart
/// gestaltSimilarity('hello', 'hello'); // 1.0
/// gestaltSimilarity('hello', 'hallo'); // 0.8
/// gestaltSimilarity('', 'hello');      // 0.0
/// gestaltSimilarity('', '');            // 1.0
/// ```
double gestaltSimilarity(String a, String b) {
  if (a.isEmpty && b.isEmpty) {
    return 1.0;
  }

  if (a.isEmpty || b.isEmpty) {
    return 0.0;
  }

  final matches = _countMatches(a, 0, a.length, b, 0, b.length);

  return 2.0 * matches / (a.length + b.length);
}

int _countMatches(String a, int aStart, int aEnd, String b, int bStart, int bEnd) {
  final match = _findLongestMatch(a, aStart, aEnd, b, bStart, bEnd);

  if (match.length == 0) {
    return 0;
  }

  return match.length +
      _countMatches(a, aStart, match.aStart, b, bStart, match.bStart) +
      _countMatches(a, match.aStart + match.length, aEnd, b, match.bStart + match.length, bEnd);
}

_Match _findLongestMatch(String a, int aStart, int aEnd, String b, int bStart, int bEnd) {
  var bestLength = 0;
  var bestAStart = aStart;
  var bestBStart = bStart;

  for (var i = aStart; i < aEnd; i++) {
    for (var j = bStart; j < bEnd; j++) {
      var length = 0;

      while (i + length < aEnd && j + length < bEnd && a.codeUnitAt(i + length) == b.codeUnitAt(j + length)) {
        length++;
      }

      if (length > bestLength) {
        bestLength = length;
        bestAStart = i;
        bestBStart = j;
      }
    }
  }

  return _Match(aStart: bestAStart, bStart: bestBStart, length: bestLength);
}

class _Match {
  const _Match({required this.aStart, required this.bStart, required this.length});

  final int aStart;
  final int bStart;
  final int length;
}
