# gestalt

Simple Gestalt-style string similarity for Dart and Flutter.

This package implements the basic matching approach used by Python's
`difflib.SequenceMatcher.ratio()`.

It recursively finds the longest contiguous matching parts of two strings
and produces a similarity score between `0.0` and `1.0`.

## Features
It is pure Dart and zero-dependency

## Installation

For Dart:

```bash
dart pub add gestalt
flutter pub add gestalt
```

## Usage

```dart
import 'package:gestalt/gestalt.dart';

void main() {
  final score = gestaltSimilarity(
    'hello world',
    'hello dart',
  );

  print(score);
}
```

The result is a value between 0.0 and 1.0.

```dart
gestaltSimilarity('hello', 'hello');
// 1.0

gestaltSimilarity('abc', 'xyz');
// 0.0

gestaltSimilarity('hello', 'hallo');
// 0.8
```