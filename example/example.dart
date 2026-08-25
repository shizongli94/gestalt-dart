import 'package:gestalt/gestalt.dart';

void main() {
  const original = 'The quick brown fox jumps over the lazy dog.';
  const modified = 'The quick brown fox jumped over the lazy dog.';

  final similarity = gestaltSimilarity(original, modified);

  print('Original: $original');
  print('Modified: $modified');
  print('Similarity: $similarity');

  const completelyDifferent = 'I like pineapple pizza.';

  final secondSimilarity = gestaltSimilarity(original, completelyDifferent);

  print('\nAnother comparison:');
  print('Similarity: $secondSimilarity');
}
