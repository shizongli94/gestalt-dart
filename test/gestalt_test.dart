import 'package:gestalt/gestalt.dart';
import 'package:test/test.dart';

void main() {
  group('gestaltSimilarity', () {
    test('identical strings return 1', () {
      expect(gestaltSimilarity('hello', 'hello'), equals(1.0));
    });

    test('two empty strings return 1', () {
      expect(gestaltSimilarity('', ''), equals(1.0));
    });

    test('empty and non-empty strings return 0', () {
      expect(gestaltSimilarity('', 'hello'), equals(0.0));

      expect(gestaltSimilarity('hello', ''), equals(0.0));
    });

    test('completely different strings return 0', () {
      expect(gestaltSimilarity('abc', 'xyz'), equals(0.0));
    });

    test('hello and hallo', () {
      expect(gestaltSimilarity('hello', 'hallo'), closeTo(0.8, 1e-12));
    });

    test('common prefix', () {
      expect(
        gestaltSimilarity('hello', 'hello world'),
        closeTo(10 / 16, 1e-12),
      );
    });

    test('common suffix', () {
      expect(
        gestaltSimilarity('hello world', 'world'),
        closeTo(10 / 16, 1e-12),
      );
    });

    test('multiple matching regions', () {
      expect(
        gestaltSimilarity('abc123xyz', 'abc456xyz'),
        closeTo(12 / 18, 1e-12),
      );
    });

    test('reordered strings', () {
      expect(gestaltSimilarity('abc', 'cba'), closeTo(1 / 3, 1e-12));
    });

    test('comparison is case-sensitive', () {
      expect(gestaltSimilarity('hello', 'Hello'), closeTo(0.8, 1e-12));
    });

    test('Chinese text works', () {
      expect(gestaltSimilarity('你好世界', '你好朋友'), closeTo(0.5, 1e-12));
    });

    test('ipa symbols work', () {
      final ja1 = 'konojijeniwanaːnigaanunpreskakinomiseniitekatosasutemoratta';
      final ja2 = 'konoijenivananigarəndeskakinomiseɲittekataosastemoratta';
      expect(gestaltSimilarity(ja1, ja2), closeTo(0.8421052631578947, 1e-12));

      final cn1 = 'ʈʂɤkɤfɑŋtɕjɛnnimjɛnyoʊijɑŋtswɔtsatswɔtsɤsanmjɛnyoʊipeɪʂweɪ';
      final cn2 = 'ʈʂɤkɤfɑŋtɕjɛnlimjɛnyoʊiʈʂɑŋtswɔtsɯtswɔtsɯʂɑŋyoʊipeɪʃweɪ';
      expect(gestaltSimilarity(cn1, cn2), closeTo(0.8141592920353983, 1e-12));

      final fr1 = 'ʒənəsɥipanefidyɑ̃dəʃinəʒəsɥisʒapɔne';
      final fr2 = 'ʒənəsɥispasynetydjɑ̃tdəʃinʒəsɥisʒapɔnɛ';
      expect(gestaltSimilarity(fr1, fr2), closeTo(0.821917808219178, 1e-12));

      final wrongOne1 =
          'konojijeniwanaːnigaanunpreskakinomiseniitekatosasutemoratta';
      final wrongOne2 = 'ʒənəsɥispasynetydjɑ̃tdəʃinʒəsɥisʒapɔnɛ';
      expect(
        gestaltSimilarity(wrongOne1, wrongOne2),
        closeTo(0.14432989690721648, 1e-12),
      );

      final wrongTwo1 =
          'ʈʂɤkɤfɑŋtɕjɛnnimjɛnyoʊijɑŋtswɔtsatswɔtsɤsanmjɛnyoʊipeɪʂweɪ';
      final wrongTwo2 = 'ʒənəsɥispasynetydjɑ̃tdəʃinʒəsɥisʒapɔnɛ';
      expect(gestaltSimilarity(wrongTwo1, wrongTwo2), closeTo(0.1875, 1e-12));
    });

    test('similarity is symmetric', () {
      const pairs = [
        ('hello', 'hallo'),
        ('abcdef', 'abxyz'),
        ('abc', 'cba'),
        ('你好世界', '你好朋友'),
      ];

      for (final (a, b) in pairs) {
        expect(gestaltSimilarity(a, b), equals(gestaltSimilarity(b, a)));
      }
    });

    test('result is between 0 and 1', () {
      const pairs = [
        ('hello', 'world'),
        ('abc', 'abcdef'),
        ('foo bar', 'bar foo'),
        ('你好', '世界'),
        ('', ''),
      ];

      for (final (a, b) in pairs) {
        final result = gestaltSimilarity(a, b);

        expect(result, greaterThanOrEqualTo(0.0));
        expect(result, lessThanOrEqualTo(1.0));
      }
    });

    test('long identical strings return 1', () {
      final value = 'hello world ' * 100;

      expect(gestaltSimilarity(value, value), equals(1.0));
    });
  });
}
